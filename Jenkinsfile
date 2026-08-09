pipeline {
    agent any

    environment {
        DOCKERHUB_USER = 'riyaz7373'
        IMAGE_NAME = 'devops-build-dev'
        IMAGE_TAG = 'dev'
        DOCKER_CREDENTIALS = 'dockerhub-creds'
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                sh '''
                    chmod +x build.sh
                    ./build.sh dev
                '''
            }
        }

        stage('Tag Docker Image') {
            steps {
                sh '''
                    docker tag devops-build-web:dev \
                    ${DOCKERHUB_USER}/${IMAGE_NAME}:${IMAGE_TAG}
                '''
            }
        }

        stage('Push to Docker Hub') {
            steps {
                withCredentials([
                    usernamePassword(
                        credentialsId: "${DOCKER_CREDENTIALS}",
                        usernameVariable: 'DOCKER_USER',
                        passwordVariable: 'DOCKER_PASSWORD'
                    )
                ]) {
                    sh '''
                        echo "$DOCKER_PASSWORD" | docker login \
                        -u "$DOCKER_USER" \
                        --password-stdin

                        docker push \
                        ${DOCKERHUB_USER}/${IMAGE_NAME}:${IMAGE_TAG}
                    '''
                }
            }
        }

        stage('Deploy to EC2-3') {
            steps {
                sshagent(credentials: ['app-server-key']) {
                    sh '''
                        ssh -o StrictHostKeyChecking=no ubuntu@172.31.12.13 "
                            docker pull riyaz7373/devops-build-dev:dev &&
                            docker stop devops-app || true &&
                            docker rm devops-app || true &&
                            docker run -d \
                                --name devops-app \
                                --restart always \
                                -p 80:80 \
                                riyaz7373/devops-build-dev:dev
                        "
                    '''
                }
            }
        }
    }

    post {
        success {
            echo 'Dev deployment completed successfully!'
        }

        failure {
            echo 'Dev deployment failed!'
        }
    }
}
