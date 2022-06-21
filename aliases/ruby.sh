
# Ruby Versioning With Rbenv

function rbenv-version() {
  echo $(rbenv version | cut -d " " -f1)
}

function ruby-env-prompt() {
  if [[ "$CODESPACES" = "true" ]]; then
    echo ''
  else
    color=$fg[green]
    rbenvprompt=''
    if [ -d "/Users/kencollins/.rbenv" ]; then
      rbenvprompt=$(rbenv-version)
    fi
    if [[ $rbenvprompt == '' ]]; then
      rbenvprompt=$(rbenv global)
    fi
    if [[ $rbenvprompt != '' ]]; then
      if [[ $rbenvprompt != 'system' ]]; then
        color=$fg[yellow]
      fi
      echo " 💎 %{$color%}$rbenvprompt$reset_color%}"
    fi
  fi
}


# Ruby/Rails Core

alias irb="irb -rubygems --prompt simple --readline -r irb/completion"

function rc () {
  bundle exec rails console $*
}

# Bundler

alias b="bundle"
alias bi="b install"
alias bo="b open"

function be() {
  if [[ -a Gemfile ]]; then
    bundle exec $*
  else
    command $*
  fi
}

function t() {
  ruby -I "lib:test" $*
}
