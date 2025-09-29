set -e

NAME="kubernetes-demo-api"
USERNAME="shubhrajitpallob47"
IMAGE="$USERNAME/$NAME:latest"

echo "Building Docker image..."
docker build -t $IMAGE .

echo "Pushing Docker image to Docker Hub..."
docker push $IMAGE

echo "Applying Kubernetes configurations..."
kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml

echo "Deployment complete."

echo "Getting pod name..."
kubectl get pods

echo "Getting service details..."
kubectl get services

echo "Fetching the main service..."
kubectl get service $NAME-service

