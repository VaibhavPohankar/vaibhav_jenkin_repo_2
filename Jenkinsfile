pipeline {
    agent any   // don't run on controller

    parameters {
        choice(name: 'ENVIRONMENT', choices: ['dev', 'staging', 'prod'], description: 'Deploy environment')
    }

    environment {
        DOCKER_USER  = 'vaibhav'
        IMAGE_NAME   = 'my-app'
        DOCKER_CREDS = credentials('DOCKER_PASS')
    }

    stages {

        stage('Checkout') {
            agent { label 'docker-builder' }
            steps {
                checkout scm
            }
        }

        stage('Maven Build') {
            agent { label 'docker-builder' }
            steps {
                sh '''
                docker run --rm -v "$PWD":/app -w /app \
                maven:3.9.6-eclipse-temurin-21 mvn -B clean package
                '''
            }
        }

        stage('Docker Build & Tag') {
            agent { label 'docker-builder' }
            steps {
                sh "docker build -t ${DOCKER_USER}/${IMAGE_NAME}:${params.ENVIRONMENT} ."
            }
        }

        stage('Push to Docker Hub') {
            agent { label 'docker-builder' }
            steps {
                sh "echo \$DOCKER_CREDS_PSW | docker login -u \$DOCKER_CREDS_USR --password-stdin"
                sh "docker push ${DOCKER_USER}/${IMAGE_NAME}:${params.ENVIRONMENT}"
            }
        }

        stage('Local Deploy') {
            agent { label 'deploy-node' }   // optional separate deploy node
            steps {
                sh "docker rm -f ${IMAGE_NAME} || true"
                sh "docker run -d --name ${IMAGE_NAME} -p 8080:8080 ${DOCKER_USER}/${IMAGE_NAME}:${params.ENVIRONMENT}"
            }
        }
    }

    post {
        always {
            agent { label 'docker-builder' }
            steps {
                archiveArtifacts artifacts: 'target/**/*.jar', allowEmptyArchive: true
                sh 'docker logout || true'
                sh 'docker image prune -f || true'
            }
        }
    }
}
