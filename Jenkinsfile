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

        stage('Deploy') {
            steps {
                sh '''
                    chmod +x deploy.sh
                    ./deploy.sh dev
                '''
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
