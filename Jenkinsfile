pipeline {
    agent {
        docker {
            image 'node:16' 
        }  // Installs Node.js via Docker image
    }
    stages {
        stage('Install Dependencies') {
            steps {
                sh 'npm install --save'  // Installs Node dependencies
            }
        }
        stage('Run Tests') {
            steps {
                sh 'npm test'  // Runs unit tests
            }
        }
        stage('Run App') {
            steps {
                sh '''
                npm start &  // Start the app in background
                sleep 5  // Wait for app to start
                curl -f http://localhost:8081 || exit 1  // Verify app is running
                kill %1  // Stop the background process
                '''
            }
        }
        stage('Security Scan') {
            steps {
                withCredentials([string(credentialsId: 'snyk-token', variable: 'SNYK_TOKEN')]) {
                    sh 'npm install -g snyk'  // Install Snyk CLI
                    sh 'snyk auth $SNYK_TOKEN'  // Authenticate
                    sh 'snyk test --fail-on=upgradable --severity-threshold=high'  // Run Snyk, fail on High/Critical
                }
            }
        }
        stage('Build Docker Image') {
            steps {
                sh 'docker build -t mukeshrai541/express-app:latest .'  // Replace with your username
            }
        }
        stage('Push to Registry') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'docker-hub-credentials', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                    sh 'echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin'
                    sh 'docker push mukeshrai541/express-app:latest'
                }
            }
        }
    }
}