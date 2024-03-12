# requires a parse_bmarks function and a bfile variable to be set
use str
use path
use re
use os

var bfile = (path:join $E:XDG_CONFIG_HOME bookmarks)
fn parse_bmarks {
  put [(each {
    |line|
    var line = (re:replace '#.*$' '' $line | str:trim-space (all))
    if (!=s $line '') {
      put [(each {
        |match|
        if (>= $match[start] 0) {
          put $match[text]
        }
      } [(re:find "[^\\s\"']+|\"([^\"]*)\"|'([ ^']*)'" $line)])]
    }
  } [(all)])]
}

var bookmarks = (from-lines < $bfile | parse_bmarks)

fn sanitize_location {
  |location|
   echo $location | tr -d '\n' |^
   str:replace $E:XDG_CONFIG_HOME "$XDG_CONFIG_HOME" (slurp) |^
   str:replace $E:XDG_RUNTIME_DIR "$XDG_RUNTIME_DIR" (all) |^
   str:replace $E:XDG_DATA_HOME "$XDG_DATA_HOME" (all) |^
   str:replace $E:XDG_CACHE_HOME "$XDG_CACHE_HOME" (all) |^
   str:replace $E:HOME "$HOME" (all)
}

fn add_bookmark {
  |name @rest|
  var conflicting_name = (each {
    |bmark|
    if (str:equal-fold $bmark[0] $name) {
      put $true
    }
  } $bookmarks | has-value [(all)] $true)
  if $conflicting_name {
    print 'Overwrite bookmark for '$name'? (Y/N) '
    var override_choice = (read-line)
    if (not (re:match '((?i)^y(es)?$)' $override_choice)) {
      echo 'Not overwriting'
      return
    }
  }

  var location = (sanitize_location (pwd))
  
  set bookmarks = [(each {
    |bmark|
    if (not (str:equal-fold $bmark[0] $name)) {
      put $bmark
    }
  } $bookmarks) [$name $location (print $@rest)]]

  each {
    |bmark|
    echo $@bmark
  } $bookmarks > $bfile
}

fn remove_bookmark {
  |name|

  set bookmarks = [(each {
    |bmark|
    if (not (str:equal-fold $bmark[0] $name)) {
      put $bmark
    }
  } $bookmarks)]

  each {
    |bmark|
    echo $@bmark
  } $bookmarks > $bfile
}

fn complete {
  |command @rest|

  if ( or (!=s $command remove_bookmark) (> (count $rest) 1) ) {
    return
  } 

  for candidate $bookmarks {
    if (== (count $candidate) 2) {
      edit:complex-candidate &code-suffix='' &display=$candidate[0]' - '$candidate[1] $candidate[0]
    } elif (== (count $candidate) 3) {
      edit:complex-candidate &code-suffix='' &display=$candidate[0]' - '$candidate[1]' ('$candidate[2]')' $candidate[0]
    }
  }
}

set edit:completion:arg-completer[remove_bookmark] = $complete~

if (has-external fzf) {
  set edit:insert:binding[Alt-x] = {
    var selection = ''
    try {
      set selection = (each {
          |item|
          echo $item | re:replace "['\\[\\]\\n]" '' (slurp) | echo (all)
        } $bookmarks | fzf -i -n 1,3.. 2> $os:dev-tty | awk '{print $1}')
    } catch e {
      if (!= $e[reason][exit-status] 130) {
        fail $e
      }
    }

    each {
      |bmark|
      if (==s $bmark[0] $selection) {
        cd (eval 'echo '(str:replace '$' '$E:' $bmark[1]))
      }
    } $bookmarks
  }

  set edit:insert:binding[Alt-X] = {
    var selection = (each {
        |item|
        echo $item | re:replace "['\\[\\]\\n]" '' (slurp) | echo (all)
      } $bookmarks | fzf -i -n 1,3.. 2> $os:dev-tty | awk '{print $1}')

    each {
      |bmark|
      if (==s $bmark[0] $selection) {
        edit:insert-at-dot (eval 'echo '(str:replace '$' '$E:' $bmark[1]))
      }
    } $bookmarks
  }
}
