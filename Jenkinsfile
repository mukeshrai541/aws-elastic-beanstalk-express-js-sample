pipeline {
    agent {
        docker { image 'node:16' }  // Runs the pipeline in a node:16 container
    }
    environment {
        DOCKER_HUB_USERNAME = 'mukeshrai541'  // Your Docker Hub username
        DOCKER_IMAGE_NAME = 'express-app'
        DOCKER_IMAGE_TAG = 'latest'
    }
    stages {
        stage('Install Dependencies') {
            steps {
                sh 'npm install --save'  // Installs project dependencies
            }
        }
        stage('Run Tests') {
            steps {
                sh 'npm test'  // Runs unit tests (assumes package.json has test script)
            }
        }
        stage('Security Scan') {
            steps {
                withCredentials([string(credentialsId: 'snyk-token', variable: 'SNYK_TOKEN')]) {
                    sh 'npm install -g snyk'  // Installs Snyk CLI globally
                    sh 'snyk auth $SNYK_TOKEN'  // Authenticates with Snyk
                    sh 'snyk test --fail-on=upgradable --severity-threshold=high'  // Scans for vulnerabilities, fails on High/Critical
                }
            }
        }
        stage('Build Docker Image') {
            steps {
                sh "docker build -t ${DOCKER_HUB_USERNAME}/${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG} ."  // Builds the Docker image
            }
        }
        stage('Push to Registry') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'docker-hub-credentials', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                    sh 'echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin'  // Logs into Docker Hub
                    sh "docker push ${DOCKER_HUB_USERNAME}/${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG}"  // Pushes the image
                }
            }
        }
    }
}