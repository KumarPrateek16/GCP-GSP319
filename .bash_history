cd ~
git clone https://github.com/googlecodelabs/monolith-to-microservices.git
cd ~/monolith-to-microservices
./setup.sh
nvm install --lts
cd ~/monolith-to-microservices/monolith
gcloud builds submit --tag gcr.io/${GOOGLE_CLOUD_PROJECT}/fancy-monolith-161:1.0.0 .
gcloud container clusters get-credentials fancy-production-771 --region us-east1
kubectl create deployment fancy-monolith-161   --image=gcr.io/${GOOGLE_CLOUD_PROJECT}/fancy-monolith-161:1.0.0
kubectl expose deployment fancy-monolith-161   --type=LoadBalancer   --port 80   --target-port 8080
kubectl get services
gcloud container clusters get-credentials fancy-production-771 --zone us-east1-c
kubectl create deployment fancy-monolith-161   --image=gcr.io/${GOOGLE_CLOUD_PROJECT}/fancy-monolith-161:1.0.0
kubectl expose deployment fancy-monolith-161   --type=LoadBalancer   --port 80   --target-port 8080
kubectl get services
cd ~/monolith-to-microservices/microservices/src/orders
gcloud builds submit --tag gcr.io/${GOOGLE_CLOUD_PROJECT}/fancy-orders-858:1.0.0 .
cd ~/monolith-to-microservices/microservices/src/products
gcloud builds submit --tag gcr.io/${GOOGLE_CLOUD_PROJECT}/fancy-products-862:1.0.0 .
d0ce566c385b: Preparing
kubectl create deployment fancy-orders-858   --image=gcr.io/${GOOGLE_CLOUD_PROJECT}/fancy-orders-858:1.0.0
kubectl expose deployment fancy-orders-858   --type=LoadBalancer   --port 80   --target-port 8081
kubectl create deployment fancy-products-862   --image=gcr.io/${GOOGLE_CLOUD_PROJECT}/fancy-products-862:1.0.0
kubectl expose deployment fancy-products-862   --type=LoadBalancer   --port 80   --target-port 8082
kubectl get services
cd ~/monolith-to-microservices/react-app
nano .env
npm run build
cd ~/monolith-to-microservices/microservices/src/frontend
gcloud builds submit --tag gcr.io/${GOOGLE_CLOUD_PROJECT}/fancy-frontend-792:1.0.0 .
kubectl create deployment fancy-frontend-792   --image=gcr.io/${GOOGLE_CLOUD_PROJECT}/fancy-frontend-792:1.0.0
kubectl expose deployment fancy-frontend-792   --type=LoadBalancer   --port 80   --target-port 8080
kubectl get services
