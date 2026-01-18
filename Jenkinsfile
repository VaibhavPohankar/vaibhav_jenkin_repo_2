pipeline {
    agent any

    parameters {
        string(name: 'BRANCH', defaultValue: 'main', description: 'Branch to build from')
        choice(name: 'ENV', choices: ['dev', 'qa', 'prod'], description: 'Select the deployment environment')
    }

    environment {
        APP_NAME = 'vibh-app'
        DOCKER_USER = 'dockervibh'
        IMAGE_NAME = 'my-app'
        DOCKER_HUB_IMAGE_NAME = "dockervibh/practice_java:latest"
        DOCKER_PASS = credentials('DOCKERHUB_PASS')
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
                    docker --version
                    docker build -t $IMAGE_NAME .
                    docker images
                '''
            }
        }

        stage('Docker Push to DockerHub') {
            steps {
                withCredentials([
                    usernamePassword(
                        credentialsId: 'DOCKERHUB_LOGIN',
                        usernameVariable: 'DOCKER_USER',
                        passwordVariable: 'DOCKER_PASS'
                    )
                ]) {
                    sh '''
                        docker rmi $DOCKER_HUB_IMAGE_NAME || true
                        docker tag $IMAGE_NAME $DOCKER_HUB_IMAGE_NAME
                        echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                        docker push $DOCKER_HUB_IMAGE_NAME
                        docker logout
                    '''
                }
            }
        }
    }
}
