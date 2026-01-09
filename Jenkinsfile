pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build & Test (Maven in Docker)') {
            steps {
                sh '''
                docker run --rm \
                    -v "$PWD":/app \
                    -w /app \
                    maven:3.9.6-eclipse-temurin-21 \
                    mvn -B clean package
                '''
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

        stage('Artifacts') {
            steps {
                sh 'ls -l target'
            }
        }
    }

    post {
        always {
            archiveArtifacts artifacts: 'target/**/*.jar', allowEmptyArchive: true
            sh 'docker image prune -f'
        }
        success {
            echo 'Build succeeded'
        }
        failure {
            echo 'Build failed'
        }
    }
}
