# 🚀 Helm Charts Setup on MicroK8s

## 🧪 Testing Environment
- We'll use **MicroK8s** to host a lightweight Kubernetes cluster.
- Let us host a mini kubernetes cluster using **micro k8s** <a href ="https://microk8s.io/docs">Link to Microk8s</a>
- 📦 Install MicroK8s
```bash
sudo snap install microk8s --classic --channel=1.32
echo $HOME
cd $HOME
mkdir .kube
chmod 700 .kube
cd .kube
sudo usermod -aG microk8s ubuntu
newgrp microk8s
microk8s config > config
cat config #To check the kube config file
kubectl get all -A
```
- Install kubectl cli
```bash
curl -LO https://dl.k8s.io/release/v1.32.0/bin/linux/amd64/kubectl #x86 arch
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
chmod +x kubectl
mkdir -p ~/.local/bin
mv ./kubectl ~/.local/bin/kubectl
kubectl version --client
```

## Installing Helm charts.
- To install Helm chart follow the <a href="https://helm.sh/docs/intro/install/">docs</a>
```bash
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh
helm version
```

## 🧱 Helm Chart Architecture
- Charts -> Helm Repo -> Helm along with Kubectl -> Kube-api-server(kube-dns, etcd, controller manager, scheduler) -> Nodes

## ⚡ Helm Quick Start
- To create helm chart - "helm create nameoffolder"
- It should create a directory with Helm charts directory structure. To verify, cd into the directory and run "tree ."
```tree
.
├── Chart.yaml
├── charts
├── templates
│   ├── NOTES.txt
│   ├── _helpers.tpl
│   ├── deployment.yaml
│   ├── hpa.yaml
│   ├── ingress.yaml
│   ├── service.yaml
│   ├── serviceaccount.yaml
│   └── tests
│       └── test-connection.yaml
└── values.yaml
```
- This is how the directory structure will look like.
- **Chart.yaml**: Contains metadata like api version
- **charts**
- **templates**: Contains application specific kuberentes definition files
- **values.yaml**: Contains variables that will override values in templates.
- Helm quick test
```bash
helm install nameofchart nameoffolder # To deploy the helmchart 
helm list -a # To list the charts running inside the cluster
```
- With microk8s we have a dashboard where we can view the kubernetes cluster in a dashboard, run the command **"microk8s dashboard-proxy"**
```bash
microk8s dashboard-proxy
```
- You will get a https://IP:Port to access the dashboard and a token, Simply pass the token to login to the dashboard and view the workloads on microk8s cluster.
- DASHBOARD<img src="./microks-dashboard-proxy.png" alt="DASHBOARD"/>
- Now lets delete or uninstall the helm chart we deployed. run the command "helm uninstall nameofchart" 

## 📘 Helm Commands Cheat Sheet
### 🚀 Basic Helm Usage

- **`helm create helloworld`**  
  Creates a new Helm chart named `helloworld` with the default template structure.

- **`helm install myhelloworld helloworld`**  
  Installs a Helm release named `myhelloworld` from the `helloworld` chart directory.  
  Starts with **REVISION 1**.

- **`helm list -a`**  
  Lists **all** Helm releases, including deleted or failed ones.

---

### 🔄 Upgrade & Rollback

- **`helm upgrade myhelloworld helloworld`**  
  Upgrades the `myhelloworld` release using updated templates in the `helloworld` folder.  
  REVISION increases sequentially (e.g., to 2, 3, etc.).

- **`helm rollback myhelloworld 1`**  
  Rolls back the `myhelloworld` release to **REVISION 1**.  
  Note: Revision number will still increase after rollback.

---

### 🧪 Debugging & Validation

- **`helm install myhelloworld --debug --dry-run helloworld`**  
  Simulates an install and validates the chart with the Kubernetes API without applying anything.

- **`helm template helloworld`**  
  Renders Kubernetes manifests locally from the `helloworld` chart without installing.

- **`helm lint helloworld`**  
  Performs static analysis on your Helm chart to detect syntax or structural issues (similar to Terraform's `tflint`).

---

### 🗑️ Cleanup

- **`helm uninstall myhelloworld`**  
  Uninstalls the `myhelloworld` release.  
  All associated resources like pods, services, etc., will be deleted.  
  The `helloworld` chart folder can still be reused to reinstall.

## Create custom helm charts
- I have created a simple flask app using python, that is accessible at http://localhost:9001
- Now I will containerize this flask app using dockerfile.
- I will push this to my docker hub as public image with name adityahub2255/python-helm
```bash
docker build -t adityahub2255/python-helm .
push adityahub2255/python-helm
```
- helm create pythonapp - To create a working directory of helm with template files and helm tree structure.
- vi pythonapp/chart.yml - Comment out the app version as we wont be using it. As api version will add image versions automatically next to image because of this "image: "{{ .Values.image.repository }}:{{ .Values.image.tag | default .Chart.AppVersion }}""
```yaml
#appVersion: "1.16.0"
```
- vi pythonapp/values.yml - To modify some values to change image name
```yaml
image:
  repository: adityahub2255/python-helm:latest

service:
  type: NodePort
  port: 9001

#livenessProbe:
# httpGet:
#   path: /
#   port: http
#readinessProbe:
# httpGet:
#   path: /
#   port: http
# or change
livenessProbe:
httpGet:
  path: /hello
  port: http
readinessProbe:
httpGet:
  path: /hello
  port: http
```
- vi pythonapp/templates/deployment.yml
```yaml
containers:
    image: "{{ .Values.image.repository }}" # removed app version

    ports:
    - name: http
        containerPort: {{ .Values.service.port }}
        protocol: TCP
# IF YOU COMMENTED LIVENESS AND READINESS PROBE COMMENT THESE VALUES, IF YOU ADDED /HELLO DONT COMMENT THESE PARTS.
    #  {{- with .Values.livenessProbe }}
    #livenessProbe:
    #{{- toYaml . | nindent 12 }}
    #{{- end }}
    #{{- with .Values.readinessProbe }}
    #readinessProbe:
    #{{- toYaml . | nindent 12 }}
    #{{- end }}
    #{{- with .Values.resources }}
```
- helm lint pythonapp
- helm install flaskapp pythonapp
- helm uninstall flaskapp

## HELMFILE
- What is helm file why we need it? Helps manage helm charts even better than helm CLI commands
- For example a single command "helmfile sync" will do both installing "helm install flaskapp python" and uninstalling helm charts "helm uninstall flaskapp"
- How? It maintains a helmfile 
```yaml
releases:
  - name: flaskapp # chart name
    chart: pythonapp # name of folder
    installed: true # set true to install false to uninstall
```
- Installing <a href="https://github.com/roboll/helmfile/releases">helm file</a>
```bash
cd $HOME
wget https://github.com/roboll/helmfile/releases/download/v0.144.0/helmfile_linux_amd64
mv helmfile_linux_amd64 helmfile
chmod 700 helmfile 
sudo mv helmfile /usr/local/bin
helmfile -version # verify installation
```
- We can reuse the python workdir
```bash
cp -r pythonapp /helmfile
cat << EOF > helmfile.yml
releases:
  - name: flaskapp # chart name
    chart: pythonapp # name of folder
    installed: true # set true to install false to uninstall
EOF
helmfile -f helmfile.yml sync # Will deploy/install the chart
```
- This should create the deployment
```bash
sed -i 's/installed: true/installed: false/g' helmfile.yml
helmfile -f helmfile.yml sync # Will delete/uninstall the chart
```
- helmfile can take the helm package from git repo as well, we need **helm-git** tool to connect helm with git. <a href="https://github.com/aslafy-z/helm-git">Helm-git Plugin</a>
```bash
helm plugin install https://github.com/aslafy-z/helm-git --version 1.3.0
```
- To package and publish Helm charts to GitHub Repo, First enable pages in GitHub Repository settings.
- Now, In helm charts we have an important file called **index.html**. <a href="https://helm.sh/docs/topics/chart_repository/">More info</a>.
- Follow these steps to create helm package
```bash
cp -r pythonapp helmpackage
cd helmpackage
└── pythonapp
    ├── Chart.yaml
    ├── charts
    ├── templates
    │   ├── NOTES.txt
    │   ├── _helpers.tpl
    │   ├── deployment.yaml
    │   ├── hpa.yaml
    │   ├── ingress.yaml
    │   ├── service.yaml
    │   ├── serviceaccount.yaml
    │   └── tests
    │       └── test-connection.yaml
    └── values.yaml
helm package pythonapp
# From github repo, after pages is setup get the URL
helm repo index --url https://aditya1234556.github.io/Terraform-Terragrunt/ .
# This will create an index.html file
git clone https://github.com/ADITYA1234556/Terraform-Terragrunt.git
mv index.html pythonapp-0.1.0.tgz Terraform-Terragrunt/HELM/helmpackage/
# git commit and push, index.html and package should be at repo root level or docs 
helm repo remove mychartrepo
helm repo add mychartrepo https://aditya1234556.github.io/Terraform-Terragrunt/
helm repo list
helm search repo pythonapp # mychartrepo/pythonapp
```
- Now lets create a helmfile to point to our packaged helmchart. Create a helmfile.yml
```yaml
repositories:
  - name: helloworld
    url: https://aditya1234556.github.io/Terraform-Terragrunt
releases:
  - name: flaskapp # chart name
    chart: pythonapp # name of folder
    installed: true # set true to install false to uninstall
```
```bash
helmfile -f helmfile.yml sync
helm list -a
kubectl get pods
```
- Follow these steps to create a helm package and use it from a central repo, accessible anywhere.


## HELM REPOS
- Helm has repo database
- We can search for repo using, **helm search hub wordpress**
- To add third party repo, 
```bash
helm repo add bitnami https://charts.bitnami.com/bitnami
helm show readme bitnami/wordpress #--version 10.0.3
helm show values bitnami/wordpress #--version 10.0.3
```
- To add our applicaiton package, 
