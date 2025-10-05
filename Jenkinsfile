// Start of the Jenkins declarative pipeline definition
pipeline {
    // Defines the agent (execution environment) for the pipeline
    agent {
        // Specifies a Docker container as the agent
        docker {
            // Uses the Node.js 16 image based on Debian Bullseye
            image 'node:16-bullseye'
            // Runs the container as root and mounts the host Docker socket for DinD access
            args '-u root -v /var/run/docker.sock:/var/run/docker.sock'
        }
    }
    // Defines environment variables available throughout the pipeline
    environment {
        // Retrieves Docker Hub credentials from Jenkins credentials store
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-credentials')
        // Sets the Docker host to connect to the DinD service via TCP with TLS
        DOCKER_HOST = "tcp://docker:2376"
        // Enables TLS verification for secure Docker communication
        DOCKER_TLS_VERIFY = "1"
        // Specifies the path to TLS certificates for Docker client
        DOCKER_CERT_PATH = "/certs/client"
        // Retrieves Snyk API token from Jenkins credentials store and binds it to SNYK_TOKEN
        SNYK_TOKEN = credentials('snyk-token') // Binds the secret text to $SNYK_TOKEN
    }
    // Defines the stages of the pipeline
    stages {
        // Stage to install system-level dependencies inside the agent container
        stage('Install System Dependencies') {
            // Steps to execute in this stage
            steps {
                // Multi-line shell script to update packages and install required tools
                sh '''
                    apt-get update
                    apt-get install -y git docker.io curl gnupg lsb-release
                '''
            }
        }
        // Stage to checkout the source code from SCM (GitHub in this case)
        stage('Checkout Code') {
            // Steps to execute in this stage
            steps {
                // Checks out the repository configured in the Jenkins job
                checkout scm
            }
        }
        // Stage to install Node.js application dependencies
        stage('Install Node Modules') {
            // Steps to execute in this stage
            steps {
                // Runs npm install to fetch dependencies from package.json
                sh 'npm install --save'
            }
        }
        // Stage to run unit tests for the application
        stage('Run Unit Tests') {
            // Steps to execute in this stage
            steps {
                // Shell script to check if 'test' script exists in package.json and run it if present
                sh '''
                    if npm run | grep -q "test"; then
                        npm test
                    else
                        echo "No test script defined. Skipping tests."
                    fi
                '''
            }
        }
        // Stage for security scanning of dependencies using Snyk
        stage('Security Scan') {
            // Steps to execute in this stage
            steps {
                // Installs Snyk CLI globally using npm
                sh 'npm install -g snyk'
                // Runs Snyk test with specified org and fails on high/critical vulnerabilities
                sh 'snyk test --org=8b480cd6-8689-49de-94b0-1fba1a332bc0 --severity-threshold=high'
            }
        }
        // Stage to build the Docker image for the application
        stage('Build Docker Image') {
            // Steps to execute in this stage
            steps {
                // Builds a Docker image tagged with the user's Docker Hub repo
                sh 'docker build -t mukeshrai541/nodeapp:latest .'
            }
        }
        // Stage to push the built Docker image to Docker Hub
        stage('Push to Docker Hub') {
            // Steps to execute in this stage
            steps {
                // Shell script to login to Docker Hub and push the image
                sh '''
                    echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin
                    docker push mukeshrai541/nodeapp:latest
                '''
            }
        }
    }
    // Post-actions to run after the pipeline stages
    post {
        // Always run these steps regardless of pipeline success or failure
        always {
            // Archives test result artifacts if they exist
            archiveArtifacts artifacts: '**/test-results/*.xml', allowEmptyArchive: true
            // Cleans up the workspace to free resources
            cleanWs()
        }
        // Run if the pipeline succeeds
        success {
            // Prints a success message
            echo 'Pipeline completed successfully!'
        }
        // Run if the pipeline fails
        failure {
            // Prints a failure message
            echo 'Pipeline failed. Check logs for details.'
        }
    }
}