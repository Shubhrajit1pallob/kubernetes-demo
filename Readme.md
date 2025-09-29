# Kubernetes Demo Project

A simple Node.js application demonstrating Kubernetes deployment with Docker containers using Minikube for local development.

## 📋 Project Overview

This project showcases:

- **Node.js Express API** with health check endpoints
- **Docker containerization** with multi-stage builds
- **Kubernetes deployment** with 2 replica pods
- **Local development** using Minikube
- **Service exposure** via NodePort
- **Health checks** (readiness and liveness probes)
- **Resource management** with CPU and memory limits

## 🏗️ Architecture

```text
┌─────────────────┐    ┌──────────────────────┐    ┌─────────────────┐
│   minikube      │    │    Kubernetes        │    │   Docker Hub    │
│   (Local K8s)   │    │    Service           │    │   Registry      │
│                 │    │  NodePort: 32614     │    │                 │
│                 │    │                      │    │                 │
│  ┌───────────┐  │    │  ┌─────────────────┐ │    │  Image:         │
│  │   Pod 1   │  │◄───┤  │   Load          │ │    │  shubhrajit-    │
│  │   :3000   │  │    │  │   Balancer      │ │    │  pallob47/      │
│  └───────────┘  │    │  │                 │ │    │  kubernetes-    │
│                 │    │  └─────────────────┘ │    │  demo-api:      │
│  ┌───────────┐  │    │                      │    │  latest         │
│  │   Pod 2   │  │    │                      │    │                 │
│  │   :3000   │  │    │                      │    │                 │
│  └───────────┘  │    │                      │    │                 │
└─────────────────┘    └──────────────────────┘    └─────────────────┘
```

## 🚀 Quick Start

### Prerequisites

- [Docker Desktop](https://www.docker.com/products/docker-desktop)
- [kubectl](https://kubernetes.io/docs/tasks/tools/)
- [Minikube](https://minikube.sigs.k8s.io/docs/start/)
- Node.js 18+ (for local development)

### 1. Clone the Repository

```bash
git clone https://github.com/Shubhrajit1pallob/kubernetes-demo.git
cd kubernetes-demo
```

### 2. Start Minikube

```bash
minikube start
```

### 3. Deploy to Kubernetes

```bash
# Option 1: Use the deploy script
npm run deploy

# Option 2: Manual deployment
kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml
```

### 4. Access the Application

```bash
# Get the service URL
minikube service kubernetes-demo-api-service --url

# Or use port forwarding
kubectl port-forward service/kubernetes-demo-api-service 3000:3000
```

Visit `http://localhost:3000` in your browser.

## 📁 Project Structure

```text
kubernetes-demo/
├── k8s/
│   ├── deployment.yaml      # Kubernetes Deployment manifest
│   └── service.yaml         # Kubernetes Service manifest
├── Dockerfile               # Container build instructions
├── docker-compose.yaml      # Docker Compose for local dev
├── deploy.sh                # Automated deployment script
├── index.js                 # Express.js application
├── package.json             # Node.js dependencies
└── README.md                # The Readme File
```

## 🐳 Docker Configuration

The application is containerized using a lightweight Docker image:

```dockerfile
FROM node:18-alpine AS base
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
USER node
EXPOSE 3000
ENV NODE_ENV=production
CMD ["node", "index.js"]
```

**Image**: `shubhrajitpallob47/kubernetes-demo-api:latest`

## ☸️ Kubernetes Resources

### Deployment Configuration

- **Replicas**: 2 pods for high availability
- **Image**: `shubhrajitpallob47/kubernetes-demo-api:latest`
- **Port**: 3000
- **Environment Variables**:
  - `NODE_ENV=production`
  - `PODNAME` (dynamically injected)

### Resource Limits

```yaml
resources:
  requests:
    cpu: "100m"
    memory: "128Mi"
  limits:
    cpu: "500m"
    memory: "512Mi"
```

### Health Checks

- **Readiness Probe**: `GET /readyz` (5s delay, 10s interval)
- **Liveness Probe**: `GET /healthz` (10s delay, 20s interval)

### Service Configuration

- **Type**: NodePort
- **Port**: 3000 → 3000
- **Selector**: `app: kubernetes-demo-api`

## 🛠️ Development

### Local Development (without Kubernetes)

```bash
# Install dependencies
npm install

# Start development server
npm run dev
```

### Local Development (with Docker Compose)

```bash
# Build and run with Docker Compose
docker-compose up --build

# Access at http://localhost:3000
```

## 📊 API Endpoints

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/` | GET | Main API endpoint with pod info |
| `/readyz` | GET | Readiness probe endpoint |
| `/healthz` | GET | Liveness probe endpoint |

### Sample Response

```json
{
  "message": "Hello, from a container!",
  "service": "hello-node",
  "pod": "kubernetes-demo-api-5db7f574d9-2llgc",
  "time": "2025-09-29T03:15:42.123Z"
}
```

## 🔧 Useful Commands

### Kubernetes Management

```bash
# View pods
kubectl get pods

# View services
kubectl get services

# View pod logs
kubectl logs -f deployment/kubernetes-demo-api

# Scale deployment
kubectl scale deployment kubernetes-demo-api --replicas=3

# Delete resources
kubectl delete -f k8s/
```

### Minikube Management

```bash
# Start minikube
minikube start

# Stop minikube
minikube stop

# View minikube dashboard
minikube dashboard

# SSH into minikube
minikube ssh
```

### Docker Commands

```bash
# Build image
docker build -t shubhrajitpallob47/kubernetes-demo-api:latest .

# Push to registry
docker push shubhrajitpallob47/kubernetes-demo-api:latest

# Run locally
docker run -p 3000:3000 shubhrajitpallob47/kubernetes-demo-api:latest
```

## 🚨 Troubleshooting

### Common Issues

1. **Service Unreachable**: Check if pod labels match service selector
2. **Image Pull Errors**: Ensure Docker image exists and is accessible
3. **Pod Not Ready**: Check readiness probe endpoint `/readyz`
4. **Resource Limits**: Monitor pod resource usage with `kubectl top pods`

### Debugging Commands

```bash
# Describe pod for detailed info
kubectl describe pod <pod-name>

# Check pod logs
kubectl logs <pod-name>

# Get cluster info
kubectl cluster-info

# Check minikube status
minikube status
```

## 📈 Monitoring

View real-time metrics:

```bash
# Pod resource usage
kubectl top pods

# Node resource usage
kubectl top nodes

# Watch pod status
kubectl get pods -w
```

## 🎯 Next Steps

- [ ] Add Ingress for external access
- [ ] Implement ConfigMaps for configuration
- [ ] Add Secrets for sensitive data
- [ ] Set up Horizontal Pod Autoscaler (HPA)
- [ ] Add monitoring with Prometheus/Grafana
- [ ] Implement CI/CD pipeline
- [ ] Add namespace isolation
- [ ] Security hardening with RBAC

## 📝 License

This project is licensed under the ISC License.

## 👤 Author

### Shubhrajit Pallob

- GitHub: [@Shubhrajit1pallob](https://github.com/Shubhrajit1pallob)

---

⭐ **Star this repo** if you found it helpful!
