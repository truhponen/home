helm repo add headlamp https://kubernetes-sigs.github.io/headlamp/
helm repo update
helm install my-headlamp headlamp/headlamp --namespace kube-system -f values.yaml
kubectl apply -f ./extra-objects.yaml
