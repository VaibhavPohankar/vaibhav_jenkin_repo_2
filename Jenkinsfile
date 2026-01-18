pipeline {
    agent any

parameters {
        string(name: 'main', defaultValue: 'main', description: 'Branch to build from')
  choice(name: 'ENV', choices: ['dev', 'qa', 'prod'], description: 'Select the deployment environment')
    }
  
    environment {
    APP_NAME = 'vibh-app'
    DOCKER_USER = dockervibh
    DOCKER_PASS = 'DOCKER_PASS'
    IMAGE_NAME = 'my-app'
    DOCKER_HUB_IMAGE_NAME = "dockervibh/practice_java:latest"
    }
    
tools {
        jdk 'java11'
        maven 'mvn'
    }

    stages {
        stage('print enviroment variables') {

            steps {
                    echo "Application name : $APP_NAME"
                    echo "Dev enviroment : $ENV_NAME"
                    echo "Hello ${params.PERSON}"
                    echo "Enviroment: ${params.CHOICE}"
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
        stage('Docker image build') {
            steps {
                sh '''
                    docker --version
                    docker build -t $IMAGE_NAME .
                    docker images
                '''
            }
        }
             stage('Docker push to dockerHub repository') {

            steps {
                withCredentials([usernamePassword(credentialsId: 'DOCKERHUB_LOGIN', passwordVariable: 'DOCKER_PASS', usernameVariable: 'DOCKER_USER')]) {

                sh '''
                    echo "docker delete image if exists"
                    docker rmi $DOCKER_HUB_IMAGE_NAME || true
                    echo "tag change"
                    docker tag $IMAGE_NAME $DOCKER_HUB_IMAGE_NAME
                    echo "Docker login"
                    echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" -p $DOCKER_PASS
                    echo "docker push"
                    docker push $DOCKER_HUB_IMAGE_NAME
                    echo "docker logout"
                    docker logout

                '''
                }

            }

        }

    }
