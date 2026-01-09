pipeline {
    agent any

    // set up tools configured in Jenkins global config
    tools {
        maven 'mvn'           // name of Maven installation in Jenkins
    }

    stages {

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
    }
}
