#!/bin/bash 
CLUSTER=$1
GITTOKEN=$2
GITUSER=$3
PROJECTID=$4
PROJECT=$5
SACREDS=$6
OWNER=$7


ansible-galaxy collection install google.cloud
ansible-galaxy collection install kubernetes.core
cd /files 

echo $SACREDS > /files/creds/.cred.json
gcloud auth login --cred-file=/files/creds/.cred.json
echo $PATH
#!/bin/bash
git config  --global user.name "$GITUSER"
git config  --global user.email "example@example.net"
git config --global --add safe.directory '*'

git clone https://$GITUSER:$GITTOKEN@github.com/$OWNER/argocd-deployments.git
cd argocd-deployments
mkdir $PROJECT 
cp -r template/* $PROJECT/
/files/deployment_files.sh $PROJECT $PROJECTID
cp /files/argocd-deployments/$PROJECT/stage/deployment.yaml /files/argocd-deployments/$PROJECT/prod/deployment.yaml
git add .
git commit -am "Add deployment files"
git push https://$GITUSER:$GITTOKEN@github.com/$OWNER/argocd-deployments.git

 gcloud container clusters get-credentials $CLUSTER --zone europe-central2-a --project $PROJECTID
 export ANSIBLE_HOST_KEY_CHECKING=False
 ansible-playbook /files/ansible/app.yml -i /files/ansible/inventory -e "project=$PROJECT"  -e "gituser=$GITUSER" -e "gittoken=$GITTOKEN" -e "process=prod" -e "owner=$OWNER" -e "projectid=$PROJECTID"
