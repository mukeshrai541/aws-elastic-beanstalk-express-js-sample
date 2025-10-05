pipeline {
    agent {
        docker { image 'node:16' }  // Use Node 16 as build agent
    }
    stages {
        stage('Install Dependencies') {
            steps {
                sh 'npm install --save'  // Install deps
            }
        }
        stage('Run Tests') {
            steps {
                sh 'npm test'  // Run unit tests (assume tests exist; add if needed)
            }
        }
        stage('Build Docker Image') {
            steps {
                script {
                    def appImage = docker.build("your-username/app:${env.BUILD_ID}")  // Build image
                }
            }
        }
        stage('Push to Registry') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', 'docker-credentials-id') {  // Use your Docker Hub creds (add to Jenkins first)
                        appImage.push()
                    }
                }
            }
        }
    }
}