hostname davidcraddockmbp
setenv PATH '/Users/david/.rbenv/shims' $PATH
setenv RBENV_SHELL fish
. '/usr/local/Cellar/rbenv/1.0.0/libexec/../completions/rbenv.fish'
command rbenv rehash 2>/dev/null
function rbenv
  set command $argv[1]
  set -e argv[1]

  switch "$command"
  case rehash shell
    . (rbenv "sh-$command" $argv|psub)
  case '*'
    command rbenv "$command" $argv
  end
end

set fish_greeting (fortune)
function fish_user_key_bindings
  fish_vi_key_bindings
end

function chrome
  /usr/bin/open -a '/Applications/Google Chrome.app' $argv[1..-1]
end
function google
  /usr/bin/open -a '/Applications/Google Chrome.app' "https://www.google.co.uk/search?q=$argv[1..-1]"
end
