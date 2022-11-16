helmfile destroy -n microservices-development
#kubectl delete -f loadgenerator.yaml -n microservices-development
kubectl delete -f redis-cart.yaml -n microservices-development