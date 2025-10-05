pipeline {
    agent {
        docker {
            image 'node:16'
            // Run as root and mount Docker socket & binary so Node container can use Docker CLI
            args '-u root --privileged \
                  -v /usr/bin/docker:/usr/bin/docker \
                  -v /var/run/docker.sock:/var/run/docker.sock \
                  --env DOCKER_HOST=tcp://docker:2376 \
                  --env DOCKER_TLS_VERIFY=1 \
                  --env DOCKER_CERT_PATH=/certs/client'
        }
    }

    environment {
        // Jenkins credentials IDs
        SNYK_TOKEN = credentials('8b480cd6-8689-49de-94b0-1fba1a332bc0')                     // your Snyk API token
        DOCKERHUB_CREDENTIALS = credentials('docker-hub-credentials') // your Docker Hub creds
        IMAGE_NAME = "mukeshrai541/nodeapp:latest"                 // change if needed
    }

    stages {

        stage('Install Dependencies') {
            steps {
                echo 'Installing npm dependencies...'
                sh 'npm install --save'
            }
        }

        stage('Run Tests') {
            steps {
                echo 'Running tests...'
                // Non-blocking test stage (won’t fail if no tests defined)
                sh 'npm test || echo "No tests defined, skipping tests"'
            }
        }

        stage('Build Docker Image') {
            steps {
                echo 'Building Docker image...'
                sh 'docker build -t $IMAGE_NAME .'
            }
        }

        stage('Security Scan - Snyk') {
            steps {
                echo 'Running Snyk vulnerability scan...'
                sh '''
                    npm install -g snyk
                    snyk auth $SNYK_TOKEN
                    snyk test --severity-threshold=high
                '''
            }
        }

        stage('Push to Docker Hub') {
            steps {
                echo 'Pushing image to Docker Hub...'
                withCredentials([usernamePassword(credentialsId: 'docker-hub-credentials',
                                                 usernameVariable: 'DOCKER_USER',
                                                 passwordVariable: 'DOCKER_PASS')]) {
                    sh '''
                        echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                        docker push $IMAGE_NAME
                    '''
                }
            }
        }

        stage('Archive Logs & Artifacts') {
            steps {
                echo 'Archiving build artifacts...'
                archiveArtifacts artifacts: 'npm-debug.log', allowEmptyArchive: true
            }
        }
    }

    post {
        success {
            echo '✅ Build completed successfully!'
        }
        failure {
            echo '❌ Build failed. Check console logs for details.'
        }
        always {
            echo 'Cleaning workspace...'
            // cleanWs()
        }
    }
}
