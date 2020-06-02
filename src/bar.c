#include <time.h>
#include <stdbool.h>
#include <stdlib.h>
#include <stdatomic.h>
#include <memory.h>
#include <stdio.h>
#include <unistd.h>
#include <signal.h>
#include <wordexp.h>

#include <sys/time.h>
#include <sys/resource.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <dirent.h>

#include <X11/Xlib.h>
#include <X11/Xutil.h>
#include <X11/Xatom.h>

// Error Codes
#define STAT_GOOD 0
#define STAT_BADFLAG -1
#define STAT_BADTIME -2
#define STAT_BADEXEC -3
#define STAT_BADWAIT -4
#define STAT_OVERMEM -5
#define STAT_BADMATCH -6
#define STAT_BADSTREAM -7

#define STAT_NOLOCKDIR 1
#define STAT_LOCKNOTDIR 2
#define STAT_LOCKEXISTS 3
#define STAT_NOLOGDIR 4
#define STAT_LOGNOTDIR 5
#define STAT_BADRLIMIT 6
#define STAT_BADFIRSTFORK 7
#define STAT_BADSECONDFORK 8
#define STAT_BADSID 9
#define STAT_BADOPEN 10
#define STAT_BADCREATE 11
#define STAT_BADDUP 12
#define STAT_NOPROP 13
#define STAT_NULLXDATA 14
#define STAT_BADINTACT 15
#define STAT_BADADDSET 16
#define STAT_BADEMPTYSET 17
#define STAT_BADPROC 18
#define STAT_BADQUITACT 19
#define STAT_BADTERMACT 20
#define STAT_BADABRTACT 21
#define STAT_BADPCLOSE 22
#define STAT_NULLPIPE 23
#define STAT_BADFSCANF 24
#define STAT_BADLENGTH 25
#define STAT_NULLDISP 26
#define STAT_NULLBUF 27
#define STAT_BADSCRIPT 28
#define STAT_BADCLOSE 29

#define LEN(x) (sizeof(x) / sizeof(x[0]))

// Customization
const char *SEPERATOR = " | ";

const char *TIMEFMT = "%a %d %b %y, %H:%M";

const char *CMDS[] = {
  "@TIME@",
  "$HOME/.local/bin/getvol.sh"
};

const char *PREFIXES[] = {
  " ",
  "Vol: "
};

const char *SUFFIXES[] = {
  "",
  ""
};

const char *LOCKDIR = "$HOME/.cache/dwmbar";
const char *LOCKFILE = "bar.pid";
const char *FDDIR = "/proc/self/fd/";
const char *LOGDIR = "$HOME/.cache/dwmbar";
const char *LOGFILE = "bar.log";

// Structs
struct XData {
  Display *disp;
  Window root;
};

// Global Variables
int logfd = -1;
atomic_bool run = true;
sigset_t sset;

// Prototypes
int close_fds(); // Close all active fds above 2
int connect_X(struct XData *xd); // Connect to the X session
int daemonize(); // Turn the process into a daemon
void disconnect_X(struct XData *xd); // Disconnect from the X session
int get_script(FILE *f, size_t pos); // Get output of a script
int get_time(FILE *f, size_t pos); // Get the current time according to TIMEFMT, return seconds to next minute
int main(int argc, char **argv);
int make_signals(); // Create signal handlers and block on SIGALRM
void reset_sigs(); // Clear all signal blocking and set all handlers to SIG_DFL
int set_text(char *txt); // Set the root window name
void sighandler(int num); // Handle exit signals

// Functions

int close_fds()
{
  wordexp_t p;
  if (wordexp(LOCKDIR, &p, 0)) {
    return STAT_NOLOCKDIR;
  }

  struct stat st_info;
  if (stat(p.we_wordv[0], &st_info) == -1) {
    if (mkdir(p.we_wordv[0], 0755)) {
      return STAT_NOLOCKDIR;
    }
  }
  wordfree(&p);

  if (!S_ISDIR(st_info.st_mode)) {
    return STAT_LOCKNOTDIR;
  }

  if (wordexp(LOGDIR, &p, 0)) {
    return STAT_NOLOGDIR;
  }

  if (stat(p.we_wordv[0], &st_info) == -1) {
    if (mkdir(p.we_wordv[0], 0755)) {
      return STAT_NOLOGDIR;
    }
  }
  wordfree(&p);

  if (!S_ISDIR(st_info.st_mode)) {
    return STAT_LOGNOTDIR;
  }

  char buffer[1024];

  const size_t lockdirlen = strlen(LOCKDIR);
  const size_t lockfilelen = strlen(LOCKFILE);
  size_t locklen = lockdirlen + lockfilelen + 2;
  if (locklen > LEN(buffer)) {
    return STAT_NOLOGDIR;
  }
  strcpy(&buffer[0], LOCKDIR);
  strcpy(&buffer[lockdirlen], "/");
  strcpy(&buffer[lockdirlen + 1], LOCKFILE);
  if (wordexp(buffer, &p, 0)) {
    return STAT_NOLOGDIR;
  }

  if (stat(p.we_wordv[0], &st_info) == 0) {
    return STAT_LOCKEXISTS;
  }
  wordfree(&p);

  // Try to iterate over files in FDDIR (/proc/self/fd) and close open fds
  DIR *d = NULL;
  if (wordexp(FDDIR, &p, 0)) {
    return STAT_GOOD;
  }
  if (stat(p.we_wordv[0], &st_info) == 0) {
    d = opendir(FDDIR);
  }
  wordfree(&p);

  if (d != NULL) {
    struct dirent *entry = NULL;
    while ((entry = readdir(d)) != NULL) {
      if (strcmp(entry->d_name, ".") == 0 || strcmp(entry->d_name, "..") == 0) {
        continue;
      }
      int fd = atoi(entry->d_name);
      if (fd > 2) {
        close(fd);
      }
    }

    closedir(d);
    return STAT_GOOD;
  }

  // Fallback to closing all fds from 3 to the limit
  struct rlimit lim;
  int status = getrlimit(RLIMIT_NOFILE, &lim);
  if (status != 0) {
    return STAT_BADRLIMIT;
  }

  for (rlim_t i=3; i < lim.rlim_cur; ++i) {
    close(i);
  }

  return STAT_GOOD;
}

int connect_X(struct XData *xd)
{
  if (xd == NULL) {
    return STAT_NULLXDATA;
  }

  xd->disp = XOpenDisplay(NULL);
  if (xd->disp == NULL) {
    return STAT_NULLDISP;
  }

  xd->root = XDefaultRootWindow(xd->disp);

  return STAT_GOOD;
}

// SysV non-conformant by:
//    - Not keeping parent process open until daemonization is done
//    - Not dropping permissions
//    - Not atomically checking lockfile
//  Doesn't really matter for this small thing in dwm autostart
int daemonize()
{
  int status = close_fds();
  if (status != 0) {
    return status;
  }
  reset_sigs();

  pid_t fres = fork();

  if (fres == (pid_t)-1) {
    return STAT_BADFIRSTFORK;
  }

  if (fres > 0) {
    exit(0);
  }

  fres = setsid();
  if (fres == (pid_t)-1) {
    return STAT_BADSID;
  }

  fres = fork();
  if (fres == (pid_t)-1) {
    return STAT_BADSECONDFORK;
  }

  if (fres != 0) {
    exit(0);
  }

  umask(0);

  close(STDIN_FILENO);

  char buffer[1024];
  const size_t lockdirlen = strlen(LOCKDIR);
  const size_t lockfilelen = strlen(LOCKFILE);
  const size_t locklen = lockdirlen + lockfilelen + 2;
  if (locklen > LEN(buffer)) {
    return STAT_BADCREATE;
  }
  strcpy(&buffer[0], LOCKDIR);
  strcpy(&buffer[lockdirlen], "/");
  strcpy(&buffer[lockdirlen + 1], LOCKFILE);
  wordexp_t p;
  if (wordexp(buffer, &p, 0)) {
    return STAT_BADCREATE;
  }

  FILE *lockfile = fopen(p.we_wordv[0], "w");
  if (lockfile == NULL) {
    return STAT_BADCREATE;
  }

  fprintf(lockfile, "%d", getpid());
  fclose(lockfile);
  wordfree(&p);

  const size_t logdirlen = strlen(LOGDIR);
  const size_t logfilelen = strlen(LOGFILE);
  const size_t loglen = lockdirlen + lockfilelen + 2;
  if (loglen > LEN(buffer)) {
    return STAT_BADOPEN;
  }
  strcpy(&buffer[0], LOGDIR);
  strcpy(&buffer[logdirlen], "/");
  strcpy(&buffer[logdirlen + 1], LOGFILE);
  if (wordexp(buffer, &p, 0)) {
    return STAT_BADOPEN;
  }

  struct stat st_info;
  if (stat(p.we_wordv[0], &st_info) == -1) {
    creat(p.we_wordv[0], 0755);
  }

  logfd = open(p.we_wordv[0], O_WRONLY|O_TRUNC);
  if (logfd == -1) {
    perror("open log");
    return STAT_BADOPEN;
  }
  wordfree(&p);

  int mydup = dup2(logfd, STDOUT_FILENO);
  if (mydup == -1) {
    return STAT_BADDUP;
  }

  mydup = dup2(logfd, STDERR_FILENO);
  if (mydup == -1) {
    return STAT_BADDUP;
  }

  printf("Starting daemon...\n");
  printf("PID: %d\nUID: %d\nGID: %d\n", getpid(), getuid(), getgid());
  printf("EUID: %d\nEGID: %d\n", geteuid(), getegid());

  printf("Changing to /\n");
  chdir("/");
  fflush(stdout);
  return STAT_GOOD;
}

void disconnect_X(struct XData *xd)
{
  if (xd == NULL) {
    return;
  }

  if (xd->disp == NULL) {
    return;
  }

  XCloseDisplay(xd->disp);
  xd->disp = NULL;
}

int get_script(FILE *f, size_t pos)
{
  if (f == NULL) {
    return STAT_NULLBUF;
  }

  if (pos >= LEN(CMDS)) {
    return STAT_BADSCRIPT;
  }

  FILE *scr = popen(CMDS[pos], "r"); // Run script with pipe
  if (scr == NULL) {
    return STAT_NULLPIPE;
  }

  fprintf(f, "%s", PREFIXES[pos]);

  char buffer[30];
  memset(buffer, 0, 30);

  // Keep getting output until script terminates
  while (!feof(scr)) {
    int status = fread(&buffer[0], 1, LEN(buffer), scr);
    if (status != LEN(buffer)) {
      if (ferror(scr)) {
        return STAT_BADFSCANF;
      }
    }

    fprintf(f, "%s", &buffer[0]);
    memset(buffer, 0, 30);
  }

  fprintf(f, "%s", SUFFIXES[pos]);

  int status = pclose(scr);
  if (status == -1) {
    return STAT_BADPCLOSE;
  }

  return STAT_GOOD;
}

int get_time(FILE *f, size_t pos)
{
  if (f == NULL) {
    return STAT_BADFLAG;
  }

  if (pos >= LEN(CMDS)) {
    return STAT_BADTIME;
  }

  char buf[30];

  time_t curtime = time(NULL);
  struct tm *now = localtime(&curtime);
  size_t ret = strftime(&buf[0], LEN(buf), TIMEFMT, now);

  fprintf(f, "%s", PREFIXES[pos]);
  fprintf(f, "%s", &buf[0]);
  fprintf(f, "%s", SUFFIXES[pos]);

  if (ret == 0) {
    return 60;
  }

  return 60 - now->tm_sec;
}

int main(int argc, char **argv)
{
  if (LEN(CMDS) != LEN(PREFIXES) || LEN(CMDS) != LEN(SUFFIXES)) {
    fprintf(stderr, "CMD arrays not all the same size! Recompile after fixing.\n");
    return STAT_BADMATCH;
  }

  int status = daemonize();
  if (status == STAT_NOLOCKDIR) {
    fprintf(stderr, "Unable to access %s. Exiting.\n", LOCKDIR);
    return STAT_NOLOCKDIR;
  } else if (status == STAT_LOCKNOTDIR) {
    fprintf(stderr, "%s is not a directory. Exiting.\n", LOCKDIR);
    return STAT_LOCKNOTDIR;
  } else if (status == STAT_LOCKEXISTS) {
    fprintf(stderr, "Lock file %s already exists. Exiting.\n", LOCKFILE);
    return STAT_LOCKEXISTS;
  } else if (status == STAT_NOLOGDIR) {
    fprintf(stderr, "Unable to access %s. Exiting.\n", LOGDIR);
    return STAT_NOLOGDIR;
  } else if (status == STAT_LOGNOTDIR) {
    fprintf(stderr, "%s is not a directory. Exiting.\n", LOGDIR);
    return STAT_LOGNOTDIR;
  } else if (status != STAT_GOOD) {
    fprintf(stderr, "Error daemonizing. %d. Exiting.\n", status);
    return status;
  }

  if (logfd == -1) {
    return STAT_GOOD;
  }

  printf("Making signals\n");
  status = make_signals();
  if (status != 0) {
    perror("Error making signal handlers. Exiting.");
    return status;
  }

  int sig;
  char timebuf[100];

  char *buffer = NULL;
  size_t bufsize = 0;

  int retstatus = STAT_GOOD;

  while (run) {
    buffer = NULL;
    bufsize = 0;
    FILE *stream = open_memstream(&buffer, &bufsize);
    if (stream == NULL) {
      printf("Error making memstream. Exiting.\n");
      retstatus = STAT_BADSTREAM;
      goto quit;
    }

    int towait = -1;

    for (unsigned int pos = 0; pos < LEN(CMDS); ++pos) {
      if (pos != 0) {
        fprintf(stream, "%s", SEPERATOR);
      }
      if (strcmp(CMDS[pos], "@TIME@") != 0) {
        status = get_script(stream, pos);
        if (status != 0) {
          retstatus = STAT_BADEXEC;
          printf("Error getting script %s, %d. Exiting.\n", CMDS[pos], status);
          goto quit;
        }
      } else {
        towait = get_time(stream, pos);
        if (towait < 0) {
          printf("Error getting time. Exiting.\n");
          retstatus = STAT_BADTIME;
          goto quit;
        }
      }
    }

    if (fclose(stream)) {
      retstatus = STAT_BADCLOSE;
    }

    printf("%s\n", buffer);
    set_text(buffer);
    free(buffer);

    fflush(stdout);
    alarm(towait); // At the very least, wake up when the minute changes to update
    status = sigwait(&sset, &sig); // Wait for SIGALRM
    if (status != 0) {
      retstatus = STAT_BADWAIT;
      perror("Error in sigwait. Exiting.");
      goto quit;
    }

    fflush(stdout);
  }

quit:
  printf("Exiting with status %d.\n", retstatus);
  fflush(stdout);
  close(logfd);
  unlink(LOCKFILE);
  return retstatus;
}

int make_signals()
{
  int status = 0;
  struct sigaction sa;

  sa.sa_handler = sighandler;
  sigemptyset(&sa.sa_mask);

  if (sigaction(SIGINT, &sa, NULL) == -1) {
    return STAT_BADINTACT;
  }

  if (sigaction(SIGTERM, &sa, NULL) == -1) {
    return STAT_BADTERMACT;
  }

  if (sigaction(SIGQUIT, &sa, NULL) == -1) {
    return STAT_BADQUITACT;
  }

  if (sigaction(SIGABRT, &sa, NULL) == -1) {
    return STAT_BADABRTACT;
  }

  status = sigemptyset(&sset);
  if (status == -1) {
    return STAT_BADEMPTYSET;
  }
  status = sigaddset(&sset, SIGALRM);
  if (status == -1) {
    return STAT_BADADDSET;
  }
  status = sigprocmask(SIG_BLOCK, &sset, NULL);
  if (status == -1) {
    return STAT_BADPROC;
  }

  return STAT_GOOD;
}

void reset_sigs()
{
  struct sigaction handler;
  handler.sa_handler = SIG_DFL;
  sigemptyset(&handler.sa_mask);

  for (int sig=0; sig < _NSIG; ++sig) {
    sigaction(sig, &handler, NULL);
  }

  sigset_t mask;
  sigemptyset(&mask);
  sigprocmask(SIG_SETMASK, &mask, NULL);
}

int set_text(char *t)
{
  struct XData xd;

  int status = connect_X(&xd);
  if (status != STAT_GOOD) {
    return status;
  }

  XTextProperty xprop;
  Status stat = XStringListToTextProperty(&t, 1, &xprop);
  if (stat == 0) {
    return STAT_NOPROP;
  }

  XSetWMName(xd.disp, xd.root, &xprop);

  XFree(xprop.value);

  disconnect_X(&xd);


  return STAT_GOOD;
}

void sighandler(int num)
{
  switch (num) {
    case SIGINT:
    case SIGTERM:
    case SIGQUIT:
    case SIGABRT:
      run = false;
      raise(SIGALRM);
      break;
    default:
      break;
  }
}
