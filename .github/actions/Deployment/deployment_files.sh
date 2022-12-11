#!/bin/bash
IMAGE=$1
PROJECTID=$2
cat <<EOF > /files/argocd-deployments/$1/stage/deployment.yaml
apiVersion: v1
kind: Service
metadata:
  name: $1-service
spec:
  ports:
    - name: http
      port: 80
      targetPort: 3000
  selector:
    app: $1
  type: NodePort
---
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: $1
  name: $1
spec:
  selector:
    matchLabels:
      app: $1
  template:
    metadata:
      labels:
        app: $1
    spec:
      containers:
        -
          image: gcr.io/$PROJECTID/$IMAGE
          name: $1
          ports:
            -
              containerPort: 3000
      imagePullSecrets:
        - name: gcr-json-key
EOF