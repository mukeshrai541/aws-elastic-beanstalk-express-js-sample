pipeline {
  agent {
    docker {
        image 'node:16'
        args '-u root'
      }
  }
  stages {
    stage('Install') {
      steps { sh 'npm install' }
    }
    stage('Test') {
      steps { sh 'npm test' }
    }
    stage('Build Image') {
      steps { sh 'docker build -t mukeshrai541/nodeapp:latest .' }
    }
    stage('Security Scan') {
      steps {
        sh 'npm install -g snyk'
        sh 'snyk test --severity-threshold=high'
      }
    }
    stage('Push Image') {
      steps { sh 'docker push mukeshrai541/nodeapp:latest' }
    }
  }
}
