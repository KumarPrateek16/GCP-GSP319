# GSP319 - Build a Website on Google Cloud: Challenge Lab

## Overview

This project demonstrates how to take a monolithic e-commerce web application (FancyStore) and break it down into microservices deployed on Google Kubernetes Engine (GKE).

The app is containerized using Cloud Build, pushed to Artifact Registry, and deployed on GKE with each microservice exposed via a LoadBalancer.

---

## Architecture

```
FancyStore Monolith
│
├── Orders Microservice   (port 8081)
├── Products Microservice (port 8082)
└── Frontend Microservice (port 8080)
```

All microservices are deployed on GKE and exposed on port 80 externally.

---

## Technologies Used

- Google Kubernetes Engine (GKE)
- Google Cloud Build
- Google Artifact Registry (gcr.io)
- Docker
- Node.js / React
- kubectl

---

## Setup & Deployment

### Prerequisites
- Google Cloud account
- Cloud Shell or gcloud CLI installed
- kubectl installed

### Step 1 - Clone the Repository
```bash
git clone https://github.com/googlecodelabs/monolith-to-microservices.git
cd monolith-to-microservices
./setup.sh
nvm install --lts
```

### Step 2 - Build the Monolith Container
```bash
cd ~/monolith-to-microservices/monolith
gcloud builds submit --tag gcr.io/${GOOGLE_CLOUD_PROJECT}/<monolith-image-name>:1.0.0 .
```
> Expected output: `DONE` and `SUCCESS`

### Step 3 - Create GKE Cluster
```bash
gcloud container clusters create <cluster-name> \
  --num-nodes 3 \
  --machine-type e2-medium \
  --region <region>
```
> Expected output: Cluster created and showing in `RUNNING` state

### Step 4 - Deploy & Expose Monolith
```bash
gcloud container clusters get-credentials <cluster-name> --region <region>

kubectl create deployment <monolith-image-name> \
  --image=gcr.io/${GOOGLE_CLOUD_PROJECT}/<monolith-image-name>:1.0.0

kubectl expose deployment <monolith-image-name> \
  --type=LoadBalancer \
  --port 80 \
  --target-port 8080
```
> Expected output: Service shows `EXTERNAL-IP` assigned — visit `http://<MONOLITH_IP>` and Fancy Store homepage loads successfully

![Homepage](GCP-GSP319\readme_images\Homepage.png"HomePage of the site")


### Step 5 - Build Microservice Containers
```bash
# Orders
cd ~/monolith-to-microservices/microservices/src/orders
gcloud builds submit --tag gcr.io/${GOOGLE_CLOUD_PROJECT}/<orders-image-name>:1.0.0 .

# Products
cd ~/monolith-to-microservices/microservices/src/products
gcloud builds submit --tag gcr.io/${GOOGLE_CLOUD_PROJECT}/<products-image-name>:1.0.0 .
```
> Expected output: `DONE` and `SUCCESS` for both builds

### Step 6 - Deploy & Expose Microservices
```bash
# Orders
kubectl create deployment <orders-image-name> \
  --image=gcr.io/${GOOGLE_CLOUD_PROJECT}/<orders-image-name>:1.0.0
kubectl expose deployment <orders-image-name> \
  --type=LoadBalancer --port 80 --target-port 8081

# Products
kubectl create deployment <products-image-name> \
  --image=gcr.io/${GOOGLE_CLOUD_PROJECT}/<products-image-name>:1.0.0
kubectl expose deployment <products-image-name> \
  --type=LoadBalancer --port 80 --target-port 8082
```
> Expected output: Both services show `EXTERNAL-IP` — visiting `http://<ORDERS_IP>/api/orders` and `http://<PRODUCTS_IP>/api/products` returns JSON responses

![Orders-json](GCP-GSP319\readme_images\Orders-json.png"Orders JSON responses")
![Products-json](GCP-GSP319\readme_images\Orders-json.png"Products JSON responses")

### Step 7 - Configure Frontend
```bash
cd ~/monolith-to-microservices/react-app
nano .env
```
Update with your microservice IPs:
```
REACT_APP_ORDERS_URL=http://<ORDERS_EXTERNAL_IP>/api/orders
REACT_APP_PRODUCTS_URL=http://<PRODUCTS_EXTERNAL_IP>/api/products
```
Then rebuild:
```bash
npm run build
```
> Expected output: `Compiled successfully`

### Step 8 - Build & Deploy Frontend
```bash
cd ~/monolith-to-microservices/microservices/src/frontend
gcloud builds submit --tag gcr.io/${GOOGLE_CLOUD_PROJECT}/<frontend-image-name>:1.0.0 .

kubectl create deployment <frontend-image-name> \
  --image=gcr.io/${GOOGLE_CLOUD_PROJECT}/<frontend-image-name>:1.0.0
kubectl expose deployment <frontend-image-name> \
  --type=LoadBalancer --port 80 --target-port 8080
```
> Expected output: `DONE` and `SUCCESS` — visiting `http://<FRONTEND_IP>` loads Fancy Store homepage with working Orders and Products pages

![Homepage](GCP-GSP319\readme_images\Homepage.png"HomePage of the site")
![Products](GCP-GSP319\readme_images\Products.png"Products Page of the site")
![Orders](GCP-GSP319\readme_images\Orders.png"Orders Page of the site")

---

## Verification

| Service  | URL |
|----------|-----|
| Monolith | `http://<MONOLITH_IP>` |
| Orders   | `http://<ORDERS_IP>/api/orders` |
| Products | `http://<PRODUCTS_IP>/api/products` |
| Frontend | `http://<FRONTEND_IP>` |

---

## Lab Reference

- Lab: GSP319 - Build a Website on Google Cloud: Challenge Lab
- Platform: Google Cloud Skills Boost (Qwiklabs)
- Course: Build a Website on Google Cloud

## AUTHOR

- Prateek Kumar [Github](https://github.com/KumarPrateek16)
