
    # when invoking commands from the gh cli client, env
    # variables aren't reliably loaded. Source the VPN values
    # needed to remotely bootstrap a service with 
    # gh codespace ssh -c <container> bootstrap-script.sh
    function get-vpn-creds(){
        export $(grep VPN_USERNAME /workspaces/.codespaces/shared/.env)
        export $(grep VPN_PASSWORD /workspaces/.codespaces/shared/.env)
    }

    # If you've set configured VPN_USERNAME and VPN_PASSWORD
    # in your codespace secrets, this will pass those to the
    # vpn auth and should trigger a 2FA push notification. 
    function auto-connect {
        get-vpn-creds
        vpn-kill
        { printf "$VPN_PASSWORD\n"; sleep 1; printf "push\n"; } | name-connect
        sleep 5
    }

    # Called by the autoconnect func, couldn't 
    # get it to work all in one function
    function name-connect {
        get-vpn-creds
        sudo openconnect \
            --csd-wrapper=/usr/libexec/openconnect/csd-post.sh \
            --authgroup="Technology MFA" \
            --pid-file=/var/run/ci.vpn.pid \
            --local-hostname="stub-service.customink.office" \
            --user="$VPN_USERNAME" \
            --passwd-on-stdin --background vpn.out.customink.com
    }
    

    # Make sure it's really dead
    vpn-kill(){
        vpn-disconnect
        kill -HUP $(pgrep -f Openconnect | xargs)
        if [[ -e "/var/run/ci.vpn.pid"  ]]; then 
            sudo rm /var/run/ci.vpn.pid
        fi
        kill -9 $(pgrep -f Openconnect | xargs)
    }

