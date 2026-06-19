pipeline {
    agent any

    environment {
        AWS_REGION = "ap-south-1"
        ECR_REPO = "453809273399.dkr.ecr.ap-south-1.amazonaws.com/crate-web"
        IMAGE_TAG = "latest"
        EC2_IP = "15.206.163.142"
        PEM_PATH = "/var/lib/jenkins/deploy.pem"
        EC2_USER = "ubuntu"
    }

    stages {

        stage('Build & Deploy on EC2') {
            steps {
                sshagent(['ec2-key']) {
                    sh """
                    ssh -i $PEM_PATH $EC2_USER@$EC2_IP << EOF
                    mkdir -p ~/crate-web
                    cd ~/crate-web
                    # Clone or pull latest code
                    if [ -d .git ]; then
                        git reset --hard
                        git pull
                    else
                        git clone https://github.com/dutta249/crate-web.git .
                    fi
                    # Build, tag, login, push, and run Docker container
                    docker build -t crate-web .
                    docker tag crate-web:latest $ECR_REPO:$IMAGE_TAG
                    aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $ECR_REPO
                    docker push $ECR_REPO:$IMAGE_TAG
                    docker stop crate-web || true
                    docker rm crate-web || true
                    docker run -d -p 80:3000 --name crate-web $ECR_REPO:$IMAGE_TAG
                    EOF
                    """
                }
            }
        }

    }
}
