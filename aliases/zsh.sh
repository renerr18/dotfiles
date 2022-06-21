
if [ "$ZSH" = "$HOME/.oh-my-zsh" ]; then
  setopt prompt_subst
  fg_purple=$'%{\e[0;35m%}'
  PROMPT=$'%{$reset_color%}(%B%{$fg[green]%}%n%b) - (%{$fg[cyan]%}%~%{$reset_color%})`ruby-env-prompt``git-prompt`\n%{$fg[red]%}> %{$reset_color%}'
fi

function title() {
  # escape '%' chars in $1, make nonprintables visible
  a=${(V)1//\%/\%\%}

  # Truncate command, and join lines.
  a=$(print -Pn "%40>...>$a" | tr -d "\n")

  s="%39>...>$a:$3"

  case $TERM in
  screen)
    print -Pn "\ek$s\e\\"      # screen title (in ^H")
    ;;
  xterm*|rxvt)
    print -Pn "\e]2;$2 | $a:$3\a" # plain xterm title
    ;;
  esac
}

# precmd is called just before the prompt is printed
function precmd()  { 
  title "zsh" "$USER@%m" "%35<...<%~"
}

# preexec is called just before any command line is executed
function preexec() { 
  title "$1"  "$USER@%m" "%55<...<%~"
}
