'PureLb is installed using Helm as recommended in https://purelb.gitlab.io/purelb/install/install/.
helm repo add purelb https://gitlab.com/api/v4/projects/20400619/packages/helm/stable
helm repo update
helm install --create-namespace --namespace=purelb purelb purelb/purelb
kubectl apply -f ./extra-objects.yaml
