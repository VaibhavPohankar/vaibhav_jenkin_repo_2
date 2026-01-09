pipeline {
    agent any

    // set up tools configured in Jenkins global config
    tools {
        maven 'mvn'           // name of Maven installation in Jenkins
    }

    stages {

        stage('Checkout') {
            steps {
                // checkout code from git (this Jenkinsfile should be in the repo)
                git "https://github.com/rahultiple31/devops-dec-25/Jenkins.git"
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
    }
}
