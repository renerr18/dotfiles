
# List Aliases
alias ll="ls -al"
alias ls="ls -AGlph"


# DNS Cache Flusher
alias fdns="sudo dscacheutil -flushcache"

# Less 
export LESS="-R -M --shift 5"
export LESSCOLOR=1

# Desperation Button
function fuckit() {
  sudo networksetup -setdnsservers Wi-Fi empty
}
