pipeline {
    agent {
        docker {
            image 'node:16'
            args '-u root -v /var/run/docker.sock:/var/run/docker.sock'
        }
    }
    environment {
        SNYK_TOKEN = credentials('snyk-token') // Add Snyk token in Jenkins credentials
        DOCKERHUB_CREDENTIALS = credentials('docker-hub-credentials') // Add Docker Hub credentials
    }
    stages {
        stage('Setup Docker') {
            steps {
                sh '''
                    apt-get update
                    apt-get install -y docker.io
                '''
            }
        }
        stage('Install') {
            steps {
                sh 'npm install --save'
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
                withDockerRegistry([credentialsId: 'docker-hub-credentials', url: 'https://index.docker.io/v1/']) {
                    sh 'docker push mukeshrai541/nodeapp:latest'
                }
            }
        }
    }
    post {
        always {
            archiveArtifacts artifacts: 'npm-debug.log', allowEmptyArchive: true
            cleanWs()
        }
    }
}