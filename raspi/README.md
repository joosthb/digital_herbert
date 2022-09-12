# Alpine herbert
workstation is laptop
server is k3s target.

## workstation prereqs
```brew install argocd kubectl```

## Digital herbert bootstrap

```
# activate sshd
vi /etc/ssh/sshd.config

#change motd
vi /etc/motd
apk update
apk upgrade
apk add git curl

curl -sfL https://get.k3s.io | sh -
```
## fix kubectl remote (workstation)
```
scp alpine:/etc/rancher/k3s/k3s.yaml ~/.kube/config
```
And change ip to server ip.

## install argocd

```
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

locally expose argocd api

```
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'
```

## Time sync


Since raspi doesn't have a RTC it depends on GPS for timesync. Home-assistant depends on a synced datetime so:

To enable wait for timesync;
```
sudo systemctl enable systemd-time-wait-sync
```

manual timesync - 

```
sudo chronyc waitsync
```

Confirm syncing
```
sudo timedatectl status
```