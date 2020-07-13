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
	     	sh "docker build -t ${registry} ."	     	
		sh "docker tag ${registry} ${registry}"
	     	sh "docker push ${registry}"
      }
    }
    stage('Deploying') {
      echo 'Deploying to AWS...'
      dir ('./') {
        withAWS(credentials: 'aws-credentials', region: 'us-east-1') {
            sh "aws eks --region us-east-1 update-kubeconfig --name EKSResouce-3u4jt3knGVdF"
            sh "kubectl apply -f /home/ubuntu/clouddevops-capston/aws/aws-auth-cm.yml"
            sh "kubectl apply -f  /home/ubuntu/clouddevops-capston/aws/capston-app-deployment.yml"
	    sh "kubectl set image deployments/capstone-app capstone-app=${registry}:latest"         
            sh "kubectl get nodes"
            sh "kubectl get pods"
            sh "aws cloudformation update-stack --stack-name udacity-capstone-nodes --template-body /home/ubuntu/clouddevops-capston/aws/worker_nodes.yml --parameters home/ubuntu/clouddevops-capston/aws/worker_nodes_param.json --capabilities CAPABILITY_IAM"
        }
      }
    }
    stage("Cleaning up") {
      echo 'Cleaning up...'
      sh "docker system prune"
    }
}
