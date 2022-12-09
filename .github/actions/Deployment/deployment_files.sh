#!/bin/bash
IMAGE=$1
cat <<EOF > /files/$1/yamls/deployment.yaml
apiVersion: v1
kind: Service
metadata:
  name: nextapp-service
spec:
  ports:
    - name: http
      port: 80
      targetPort: 3000
    - name: https
      port: 443
      targetPort: 3000
  selector:
    app: nextapp
  type: NodePort
---
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: nextapp
  name: nextapp
spec:
  selector:
    matchLabels:
      app: nextapp
  template:
    metadata:
      labels:
        app: nextapp
    spec:
      containers:
        -
          image: wgall/$IMAGE
          name: nextapp
          ports:
            -
              containerPort: 3000
EOF