#!groovy

pipeline {
    agent any
    tools {
        maven 'maven'
    }
    environment {
        TEST = 'TEST'
    }
    options {
        buildDiscarder(logRotator(numToKeepStr: '100'))
        ansiColor('xterm')
    }
    stages {
        stage('Clone app from repository') {
            steps {
                checkout([$class: 'GitSCM', branches: [[name: params.BRANCH]], extensions: [], userRemoteConfigs: [[url: 'https://github.com/Ozz007/sb3t']]])
            }
        }
        stage('Compile app') {
            steps {
                script {
                    sh 'mvn clean compile'
                }
            }
        }
        stage('Run unit tests and integration tests') {
            when {
                expression { params.SKIP_TESTS == false }
            }
            steps {
                script {
                   sh 'mvn test'
                }
            }
        }
        stage('Build .jar') {
            steps {
                script {
                    sh 'mvn package'
                }
            }
        }
        /* stage('Move .jar in jenkins workspace') {
            steps {
                
            }
        } */
    }
}