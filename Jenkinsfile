pipeline {
    agent any

    parameters {
        choice(name: 'ENVIRONMENT', choices: ['dev', 'staging', 'prod'], description: 'Deploy environment')
    }

    environment {
        DOCKER_USER  = 'vaibhav'
        IMAGE_NAME   = 'my-app'
        DOCKER_CREDS = credentials('docker-hub-creds')
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Maven Build') {
            steps {
                sh '''
                docker run --rm -v "$PWD":/app -w /app \
                maven:3.9.6-eclipse-temurin-21 mvn -B clean package
                '''
            }
        }

        stage('Docker Build & Tag') {
            steps {
                sh "docker build -t ${DOCKER_USER}/${IMAGE_NAME}:${params.ENVIRONMENT} ."
            }
        }

        stage('Push to Docker Hub') {
            steps {
                sh "echo \$DOCKER_CREDS_PSW | docker login -u \$DOCKER_CREDS_USR --password-stdin"
                sh "docker push ${DOCKER_USER}/${IMAGE_NAME}:${params.ENVIRONMENT}"
            }
        }

        stage('Local Deploy') {
            steps {
                sh "docker rm -f ${IMAGE_NAME} || true"
                sh "docker run -d --name ${IMAGE_NAME} -p 8080:8080 ${DOCKER_USER}/${IMAGE_NAME}:${params.ENVIRONMENT}"
            }
        }
    }

    post {
        always {
            archiveArtifacts artifacts: 'target/**/*.jar', allowEmptyArchive: true
            sh 'docker logout'
            sh 'docker image prune -f'
        }
    }
}