pipeline {
    agent any

    environment {
        APPLICATION = "my-flask-app"
        DOCKER_HUB_ACCOUNT_ID = "sohelkhan2001"
    }

    stages {
        stage('Clone Repo') { 
            git url: 'https://github.com/sohelkhan121101/flask-demo02.git', branch: 'master'
        }    

        stage('Build Project') {
            steps {
                sh 'pip install -r requirements.txt'
            }
        }

        stage('Build Docker Image with new code') {
            steps {
                script {
                    dockerImage = docker.build("${DOCKER_HUB_ACCOUNT_ID}/${APPLICATION}:${env.BUILD_NUMBER}")
                }
            }
        }

        stage('Push Image to Remote Repo') {
            steps {
                script {
                    docker.withRegistry('', 'dockerHub') {
                        dockerImage.push("${env.BUILD_NUMBER}")
                        dockerImage.push("latest")
                    }
                }
            }
        }

        stage('Remove running container with old code') {
            steps {
                sh "docker rm -f \$(docker ps -a -f name=${APPLICATION} -q) || true"
            }
        }

        stage('Deploy Docker Image with new changes') {
            steps {
                sh "docker run --name ${APPLICATION} -d -p 5000:5000 ${DOCKER_HUB_ACCOUNT_ID}/${APPLICATION}:${env.BUILD_NUMBER}"
            }
        }  

        stage('Remove old images') {
            steps {
                sh "docker rmi ${DOCKER_HUB_ACCOUNT_ID}/${APPLICATION}:latest -f"
            }
        }
    }
}
