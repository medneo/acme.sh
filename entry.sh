#!/usr/bin/env sh
if [ "$1" = "daemon" ];  then
 #trap \"echo stop && killall crond && exit 0\" SIGTERM SIGINT \n \
 #crond && while true; do sleep 1; done;\n \
 if [ ! -s /tls/fullchain.cer ]; then
  --issue --dns dns_aws -d "$2"
  --install-cert -d "$2" --fullchain-file /tls/fullchain.cer --cert-file /tl/cert.cer --key-file /tls/key.key --ca-file /tls/ca.cer
 fi
 exec crond -f
else
 exec -- "$@"
fi
