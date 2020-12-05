#!/bin/bash

#build docker images
docker build -t damilare77/multi-client-travis:latest -t damilare77/multi-client-travis:"$SHA" -f ./client/Dockerfile ./client
docker build -t damilare77/multi-server-travis:latest -t damilare77/multi-server-travis:"$SHA" -f ./server/Dockerfile ./server
docker build -t damilare77/multi-worker-travis:latest -t damilare77/multi-worker-travis:"$SHA" -f ./worker/Dockerfile ./worker

#Take those images and push them to docker hub
docker push damilare77/multi-client-travis:latest
docker push damilare77/multi-server-travis:latest
docker push damilare77/multi-worker-travis:latest

docker push damilare77/multi-client-travis:"$SHA"
docker push damilare77/multi-server-travis:"$SHA"
docker push damilare77/multi-worker-travis:"$SHA"

#apply all configs in k8s folder
kubectl apply -f k8s

#imperatively set image
kubectl set image deployment/client-deployment client=damilare77/multi-client-travis:"$SHA"
kubectl set image deployment/server-deployment server=damilare77/multi-server-travis:"$SHA"
kubectl set image deployment/worker-deployment worker=damilare77/multi-worker-travis:"$SHA"