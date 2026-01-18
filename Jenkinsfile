pipeline {
    agent any

    parameters {
        string(name: 'BRANCH', defaultValue: 'main', description: 'Branch to build from')
        choice(name: 'ENV', choices: ['dev', 'qa', 'prod'], description: 'Select the deployment environment')
    }

    environment {
        APP_NAME = 'vibh-app'
        IMAGE_NAME = 'my-app'
        DOCKER_USER = 'dockervibh'
        DOCKER_REPO = 'dockervibh/practice_java'
    }

    tools {
        jdk 'jdk_main'
        maven 'mvn'
    }

    stages {
        stage('Initialize') {
            steps {
                echo "Building App: ${APP_NAME} for Env: ${params.ENV}"
                checkout scm
            }
        }

        stage('Build & Test') {
            steps {
                sh 'mvn -B clean install'
            }
        }

        stage('Docker Image Build') {
            steps {
                sh "docker build -t ${IMAGE_NAME} ."
            }
        }

        stage('Docker Push to DockerHub') {
            steps {
                // Using 'string' helper for 'Secret text' credential type
                withCredentials([string(credentialsId: 'DOCKERHUB_LOGIN', variable: 'DOCKER_TOKEN')]) {
                    sh """
                        # Tagging with the chosen environment
                        docker tag ${IMAGE_NAME} ${DOCKER_REPO}:${params.ENV}
                        
                        # Login using the Secret Text and hardcoded DOCKER_USER
                        echo "${DOCKER_TOKEN}" | docker login -u "${DOCKER_USER}" --password-stdin
                        
                        # Push to registry
                        docker push ${DOCKER_REPO}:${params.ENV}
                        
                        docker logout
                    """
                }
            }
        }

        stage('Cleanup Local') {
            steps {
                sh "docker rmi ${DOCKER_REPO}:${params.ENV} || true"
            }
        }
    }

    post {
        always {
            sh 'docker image prune -f'
        }
        success {
            echo "Successfully pushed to ${params.ENV}"
        }
    }
}