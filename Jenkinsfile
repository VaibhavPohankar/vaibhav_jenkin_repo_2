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
                echo "Building App: ${APP_NAME}"
                echo "Environment: ${params.ENV}"
                echo "Branch: ${params.BRANCH}"
                checkout scm
            }
        }

        stage('Build & Test') {
            steps {
                // 'install' runs clean, compile, and test in one go
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
                withCredentials([
                    usernamePassword(
                        credentialsId: 'DOCKERHUB_LOGIN',
                        usernameVariable: 'HUB_USER',
                        passwordVariable: 'HUB_PASS'
                    )
                ]) {
                    sh """
                        # Tagging with the specific environment selected
                        docker tag ${IMAGE_NAME} ${DOCKER_REPO}:${params.ENV}
                        
                        # Secure Login and Push
                        echo "${HUB_PASS}" | docker login -u "${HUB_USER}" --password-stdin
                        docker push ${DOCKER_REPO}:${params.ENV}
                        
                        docker logout
                    """
                }
            }
        }
    }

    post {
        always {
            // Cleanup to save disk space on the Jenkins agent
            sh 'docker image prune -f'
        }
        success {
            echo "Successfully built and pushed ${IMAGE_NAME} to ${params.ENV}"
        }
        failure {
            echo "Pipeline failed. Check the console output for errors."
        }
    }
}