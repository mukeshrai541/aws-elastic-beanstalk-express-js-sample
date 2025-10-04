pipeline {
    agent any  // Runs on any available agent
    environment {
        DOCKER_HUB_USERNAME = 'mukeshrai541' // Your Docker Hub username
        DOCKER_IMAGE_NAME = 'express-app'
        DOCKER_IMAGE_TAG = 'latest'
    }
    stages {
        stage('Install Dependencies') {
            steps {
                sh 'npm install --save'
            }
        }
        stage('Run Tests') {
            steps {
                sh 'npm test'
            }
        }
        stage('Security Scan') {
            steps {
                withCredentials([string(credentialsId: 'snyk-token', variable: 'SNYK_TOKEN')]) {
                    sh 'npm install -g snyk'
                    sh 'snyk auth $SNYK_TOKEN'
                    sh 'snyk test --fail-on=upgradable --severity-threshold=high'
                }
            }
        }
        stage('Build Docker Image') {
            steps {
                sh "docker build -t ${DOCKER_HUB_USERNAME}/${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG} ."
            }
        }
        stage('Push to Registry') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'docker-hub-credentials', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {  // Added comma after usernameVariable
                    sh 'echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin'
                    sh "docker push ${DOCKER_HUB_USERNAME}/${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG}"
                }
            }
        }
    }
}