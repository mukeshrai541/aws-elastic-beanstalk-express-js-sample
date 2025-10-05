pipeline {
    agent {
        docker {
            image 'node:16'
            args '--network jenkins_default -u root:root' // Connect to DinD network
        }
    }

    environment {
        DOCKER_REGISTRY = "docker.io/mukeshrai541"
        APP_NAME = "nodeapp"
        SNYK_TOKEN = credentials('snyk-token') // Add Snyk API token in Jenkins credentials
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Install Dependencies') {
            steps {
                sh 'npm install --save'
            }
        }

        stage('Run Unit Tests') {
            steps {
                sh 'npm test'
            }
        }

        stage('Security Scan') {
            steps {
                sh '''
                    npm install -g snyk
                    snyk auth $SNYK_TOKEN
                    snyk test --severity-threshold=high
                '''
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Build Docker image using DinD
                    sh "docker build -t ${DOCKER_REGISTRY}/${APP_NAME}:latest ."
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    // Login to Docker Hub
                    sh "echo ${DOCKER_HUB_PASSWORD} | docker login -u ${DOCKER_HUB_USERNAME} --password-stdin"
                    sh "docker push ${DOCKER_REGISTRY}/${APP_NAME}:latest"
                }
            }
        }
    }

    post {
        always {
            echo 'Cleaning up workspace...'
            cleanWs()
        }
        success {
            echo 'Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed! Check logs above.'
        }
    }
}
