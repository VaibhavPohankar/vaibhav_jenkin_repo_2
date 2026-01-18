pipeline {
    agent any

    parameters {
        string(name: 'BRANCH', defaultValue: 'main', description: 'Branch to build from')
        choice(name: 'ENV', choices: ['dev', 'qa', 'prod'], description: 'Select the deployment environment')
    }

    environment {
        APP_NAME = 'vibh-app'
        IMAGE_NAME = 'my-app'
        DOCKER_HUB_IMAGE_NAME = "dockervibh/practice_java:latest"
        DOCKER_USER = "dockervibh"   // static since token has no username
    }

    tools {
        jdk 'jdk_main'
        maven 'mvn'
    }

    stages {

        stage('Print Environment Variables') {
            steps {
                echo "App: ${APP_NAME}"
                echo "Env: ${params.ENV}"
                echo "Branch: ${params.BRANCH}"
            }
        }

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Clean') {
            steps {
                sh 'mvn clean'
            }
        }

        stage('Build') {
            steps {
                sh 'mvn -B install'
            }
        }

        stage('Test') {
            steps {
                sh 'mvn test'
            }
        }

        stage('Docker Image Build') {
            steps {
                sh '''
                    docker build -t $IMAGE_NAME .
                '''
            }
        }

        stage('Docker Push to DockerHub') {
            steps {
                withCredentials([string(credentialsId: 'DOCKERHUB_LOGIN', variable: 'DOCKER_TOKEN')]) {
                    sh '''
                        docker rmi $DOCKER_HUB_IMAGE_NAME || true
                        docker tag $IMAGE_NAME $DOCKER_HUB_IMAGE_NAME
                        echo "$DOCKER_TOKEN" | docker login -u "$DOCKER_USER" --password-stdin
                        docker push $DOCKER_HUB_IMAGE_NAME
                        docker logout
                    '''
                }
            }
        }
    }
}
