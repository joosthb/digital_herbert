# Alpine herbert
workstation is laptop
server is k3s target.

## workstation prereqs
```brew install argocd kubectl```

## Digital herbert bootstrap

# install alpine
download aarch64 image at [alpine](https://alpinelinux.org/downloads/)
download headless overlay [headless overlay](https://github.com/macmpi/alpine-linux-headless-bootstrap)

extract both to bootable fat32 formatted sdcard
tar xzvf alpine-rpi-3.16.2-aarch64.tar.gz -C /Volumes/UNTITLED

add network to etc/wpa_supplicant.conf

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