helm repo add prometheus-community https://prometheus-community.github.io/helm-charts

curl https://prometheus-community.github.io/helm-charts/pubkey.gpg | gpg --import

helm install kube-prometheus-stack prometheus-community/kube-prometheus-stack --namespace prometheus -f values.yaml

helm upgrade kube-prometheus-stack prometheus-community/kube-prometheus-stack --namespace prometheus -f values.yaml
