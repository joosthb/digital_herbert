Alpine herbert
Digital herbert bootstrap

/etc/ssh/sshd.config
/etc/motd
apk update
apk upgrade

apk add git curl


curl -sfL https://get.k3s.io | sh -


# fix kubectl remote
scp alpine:/etc/rancher/k3s/k3s.yaml ~/.kube/config
