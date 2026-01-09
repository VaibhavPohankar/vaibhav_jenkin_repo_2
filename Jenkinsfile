pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build') {
            steps {
                sh 'mvn clean package'
            }
        }

        stage('Docker Build') {
            steps {
                sh 'docker build -t vaibhav/my-app:latest .'
            }
        }

        stage('Docker Run') {
            steps {
                sh '''
                docker rm -f my-app || true
                docker run -d --name my-app vaibhav/my-app:latest
                '''
            }
        }
    }
}
