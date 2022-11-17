kubectl apply -f redis-cart.yaml -n microservices-development
helmfile sync -n microservices-development
#kubectl apply -f loadgenerator.yaml -n microservices-development
