pipeline {
    agent {
        docker {
            image 'node:16'
            args '-u root -v /usr/bin/docker:/usr/bin/docker -v /var/run/docker.sock:/var/run/docker.sock --env DOCKER_HOST=tcp://docker:2376 --env DOCKER_TLS_VERIFY=1 --env DOCKER_CERT_PATH=/certs/client'
        }
    }
    environment {
        SNYK_TOKEN = credentials('snyk-token') // Snyk API token
        DOCKERHUB_CREDENTIALS = credentials('docker-hub-credentials') // Docker Hub credentials
    }
    stages {
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
        stage('Archive Artifacts') {
            steps {
                archiveArtifacts artifacts: 'npm-debug.log', allowEmptyArchive: true
            }
        }
    }
    post {
        always {
            cleanWs()
        }
    }
}