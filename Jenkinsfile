node {
    def registry = 'denyshubh/myportfolio_client'
    stage('Testing out git repo') {
      echo 'Checkout...'
      checkout scm
    }
    stage('Testing environment') {
      echo 'Testing environment...'
      sh 'git --version'
      echo "Branch: ${env.BRANCH_NAME}"
      sh 'docker -v'
    }
    stage("Lint Test") {
      echo 'Checking Proper Linting...'
      sh ' /home/ubuntu/.linuxbrew/Cellar/hadolint/1.18.0/bin/hadolint Dockerfile'
    }
    stage('Build Docker Image') {
	    echo 'Building Docker image...'
      withCredentials([usernamePassword(credentialsId: 'dockerhub', passwordVariable: 'dockerHubPassword', usernameVariable: 'dockerHubUser')]) {
	     	sh "docker login -u ${env.dockerHubUser} -p ${env.dockerHubPassword}"
      }
    }
    stage('Deploying') {
      echo 'Deploying to AWS...'
      dir ('./') {
        withAWS(credentials: 'aws-credentials', region: 'us-east-1') {
            sh "aws eks --region us-east-1 update-kubeconfig --name Udacity-Capston-Project-01"
            sh "kubectl apply -f aws/aws-auth-cm.yaml"
            sh "kubectl set image deployments/capstone-app capstone-app=${registry}:latest"
            sh "kubectl apply -f aws/capstone-app-deployment.yml"
            sh "kubectl get nodes"
            sh "kubectl get pods"
            sh "aws cloudformation update-stack --stack-name udacity-capstone-nodes --template-body file://aws/worker_nodes.yml --parameters file://aws/worker_nodes_parameters.json --capabilities CAPABILITY_IAM"
        }
      }
    }
    stage("Cleaning up") {
      echo 'Cleaning up...'
      sh "docker system prune"
    }
}
