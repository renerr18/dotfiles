
alias pss="ps aux | grep -wv defunct | grep -wv vscode-remote"
alias check="ps ax | grep -wv 'grep' | grep -E 'puma|sidekiq' "
function puma(){
    local pid="/workspaces/groups/tmp/pids/puma.pid"
    case $1 in 
        "start") bundle exec bin/rails server -d  -P $pid; ;;
        "stop") kill -HUP $(pgrep -d' ' -f puma);;
        *) ;;
    esac
}

function kiq(){
    local pid="/workspaces/groups/tmp/pids/sidekiq.pid"
    case $1 in 
        "start") bundle exec sidekiq -d -L log/sidekiq.log -P $pid;;
        "stop") bundle exec sidekiqctl stop $pid;;
        "kill") kill -HUP $(pgrep -d' ' -f sidekiq);;
        *);;
    esac
}

function gof(){
    case $1 in 
        "start") puma start;  kiq start;;
        "stop") puma stop; kiq stop;;
        "restart") gof stop; gof start;;
        *);;
    esac    
}

