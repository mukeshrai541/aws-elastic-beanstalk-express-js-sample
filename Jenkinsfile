pipeline {
    agent any  // Run on Jenkins node itself

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Install Dependencies') {
            steps {
                sh 'docker run --rm -v $(pwd):/app -w /app node:16-alpine npm install'
            }
        }

        stage('Run Unit Tests') {
            steps {
                sh 'docker run --rm -v $(pwd):/app -w /app node:16-alpine npm test'
            }
        }

        stage('Security Scan') {
            steps {
                sh 'docker run --rm -v $(pwd):/app -w /app node:16-alpine sh -c "npm install -g snyk && snyk auth $SNYK_TOKEN && snyk test --severity-threshold=high --fail-on=upgradable"'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    dockerImage = docker.build("mukeshrai541/aws-express-app:${env.BUILD_ID}")
                }
            }
        }

        stage('Push to Registry') {
            steps {
                script {
                    docker.withRegistry('https://registry.hub.docker.com', 'docker-hub') {
                        dockerImage.push()
                        dockerImage.push('latest')
                    }
                }
            }
        }
    }

    post {
        always {
            cleanWs()
        }
    }
}