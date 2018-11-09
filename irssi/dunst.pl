use strict;
use warnings;
use Irssi qw(signal_add);
use vars qw($VERSION %IRSSI);

$VERSION = '1.0';
%IRSSI = (
    authors => 'aftix',
    contact => 'gameraftexploision@gmail.com',
    name => 'irssi-dunst',
    description => 'Sends highlights to lib notify',
    license => 'MIT',
    changed => '2018-10-30',
);


sub cmd_run {
    if ((my $pid = fork())) { Irssi::pidwait_add($pid) }
    elsif (($pid == 0)) {exec(@_)}
    else {Irssi::print('Error running command')}
}

sub hilight {
    my ($dest, $text, $stripped) = @_;

    $stripped =~ s/"/\\"/g;

    my @message = split / » /, $stripped, 2;
    my $sender = $message[0];
    my $msg = $message[1];

    $sender =~ s/ //g;
    
    cmd_run("exec notify-send -a 'Irssi' \"$sender\" \"$msg\"");
}

sub check_hilight {
    my ($dest, $text, $stripped) = @_;

    hilight($dest, $text, $stripped) if (
	($dest->{level} & (MSGLEVEL_HILIGHT|MSGLEVEL_MSGS)) &&
	($dest->{level} & MSGLEVEL_NOHILIGHT) == 0
    );
}


signal_add('print text', 'check_hilight');
