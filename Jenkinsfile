pipeline {
    // Use Node 16 Docker image as the build agent for the entire pipeline
    agent {
        docker {
            image 'node:16-alpine'  // Lightweight Node 16 image for efficiency
        }
    }

    stages {
        stage('Checkout') {
            steps {
                // Checkout code from SCM (handled automatically in Jenkins)
                checkout scm
            }
        }

        stage('Install Dependencies') {
            steps {
                // Install dependencies from package.json
                sh 'npm install'  // Standard command; --save is not needed here as it's for adding packages
            }
        }

        stage('Run Unit Tests') {
            steps {
                // Run tests (uses Mocha from devDependencies)
                sh 'npm test'
            }
        }

        stage('Security Scan') {
            steps {
                // Install Snyk CLI globally
                sh 'npm install -g snyk'

                // Authenticate Snyk using credential (added in Task 4)
                withCredentials([string(credentialsId: 'snyk-token', variable: 'SNYK_TOKEN')]) {
                    sh 'snyk auth $SNYK_TOKEN'
                }

                // Scan for vulnerabilities; fail if high or critical issues are found
                sh 'snyk test --severity-threshold=high --fail-on=upgradable'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Build the image with a tag including build number
                    dockerImage = docker.build("mukeshrai541/aws-express-app:${env.BUILD_ID}")
                }
            }
        }

        stage('Push to Registry') {
            steps {
                script {
                    // Login and push using Docker Hub credentials (added in Task 4)
                    docker.withRegistry('https://registry.hub.docker.com', 'docker-hub') {
                        dockerImage.push()
                        dockerImage.push('latest')  // Also push latest tag
                    }
                }
            }
        }
    }

    post {
        always {
            // Clean up workspace after build
            cleanWs()
        }
    }
}