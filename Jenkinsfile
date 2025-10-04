pipeline {
    agent {
        docker {
            image 'docker:dind'
            args '-u root --privileged'
        }
    }
    stages {
        stage('Setup Node.js') {
            steps {
                sh '''
                    apk add --no-cache nodejs npm
                '''
            }
        }
        stage('Install') {
            steps {
                sh 'npm install'
            }
        }
        stage('Test') {
            steps {
                sh 'npm test'
            }
        }
        stage('Build Image') {
            steps {
                sh 'docker build -t mukeshrai541/nodeapp:latest .'
            }
        }
        stage('Security Scan') {
            steps {
                sh '''
                    npm install -g snyk
                    snyk test --severity-threshold=high
                '''
            }
        }
        stage('Push Image') {
            steps {
                sh 'docker push mukeshrai541/nodeapp:latest'
            }
        }
    }
}