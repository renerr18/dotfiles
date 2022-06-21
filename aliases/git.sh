
if [[ -x `which git` ]]; then

  # Promt Work

  function git-branch-name () {
    git branch 2> /dev/null | grep "^\*" | sed "s/^\*\ //"
  }

  function git-dirty () {
    git status | grep "nothing to commit"
    echo $?
  }

  function git-prompt() {
    branch=$(git-branch-name)
    if [[ "x$branch" != x ]]; then
      if [[ $branch = "(no branch)" ]]; then
        dirty_color=$fg[yellow]
        echo " %{$dirty_color%}$branch%{$reset_color%}"
      else
        dirty_color=$fg[green]
        gd=$(git-dirty)
        if [[ "$gd" = "1" ]]; then
          dirty_color=$fg[red]
        fi
        [ "x$branch" != x ] && echo " 🔄 %{$dirty_color%}$branch $(git-stash-count)%{$reset_color%}"
      fi
    fi
  }

  function git-stash-count() {
    branch=$(git-branch-name)
    count=$(git stash list | grep "${branch}" | wc -l | awk '{print $1}')
    [ $count != 0 ] && echo "($count)"
  }

  # Other Macros

  function gbd() {
    grb delete $1 && git branch -D $1
  }

  function gmbn() {
    local mbn=master
    local bmr=$(git config --local --get-regexp branch.master.remote)
    if [[ $bmr == '' ]]; then
      mbn=main
    fi
    echo $mbn
  }

  function grbbc () {
    local mybranch=$(git-branch-name)
    local branch=$(echo $mybranch | rev | cut -c 4- | rev)
    git checkout $branch
    git pull --rebase origin $branch
    git checkout $mybranch
    git rebase $branch
    git checkout $branch
    git merge $mybranch
    git push origin $branch
    git checkout $mybranch
  }

  function grbm () {
    local mbn=$(gmbn)
    local branch=$(git-branch-name)
    git checkout $mbn
    git pull origin $mbn
    git checkout "${branch}"
    git rebase $mbn
  }

  function grbmc () {
    local mbn=$(gmbn)
    local branch=$(git-branch-name)
    grbm
    git checkout $mbn
    git merge "${branch}"
    git push origin $mbn
    if [[ -f .git/hooks/post-push ]]; then
      .git/hooks/post-push
    fi
    git checkout "${branch}"
  }

  function gtag () {
    local mbn=$(gmbn)
    git tag -a -m "Tagging Version ${1}" $1
    git push origin $mbn
    git push --tags
  }

  function grbc () {
    branch=$(git-branch-name)
    grb create "${branch}"
  }

  function grbd () {
    local mbn=$(gmbn)
    if [ $1 ]; then
      branch=$1
    else
      branch=$(git-branch-name)
    fi
    if [[ $branch != $mbn ]]; then
      git checkout $mbn
      grb delete $branch
      git branch -D $branch
    fi
  }

  function gsp () {
    if [ $1 ]; then
      v=$1
    else
      v=0
    fi
    git stash pop "stash@{$v}"
  }

  function goops() {
    git add -A && git commit --amend --no-edit && git push -f
  }

fi

alias glog="git log --pretty=format:'%h %ad | %s%d [%an]' --graph --date=short -w"
alias glog_p="git log -p -w"

alias grc='git rebase --continue'
alias grs='git rebase --skip'
alias gra='git rebase --abort'

alias gd='git diff -w'
alias gde='git diff | code -'

alias gst='git status -sb'
alias gr='git remote'
alias ga='git add -i'
alias gco='git checkout'
alias gc='git commit -v'
alias gca='git commit -v -a'
alias gb='git branch'
alias gba='git branch -a'

function gitio () {
  local url=$(curl -s -i https://git.io -F "url=$1" | grep "Location: " | cut -d" " -f2)
  echo -n $url | tr -d '\n' | pbcopy
  echo $url
}
