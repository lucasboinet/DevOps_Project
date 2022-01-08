#!groovy

pipeline {
    agent any
    options {
        buildDiscarder(logRotator(numToKeepStr: '100'))
        ansiColor('xterm')
    }
    stages {
        stage('Clone terraform config from git') {
            steps {
                checkout([$class: 'GitSCM', branches: [[name: 'master']], extensions: [], userRemoteConfigs: [[credentialsId: '0cbc5da8-49bd-4690-9551-e101ff8eb701', url: 'https://github.com/lucasboinet/DevOps_Project']]])
            }
        }
        stage('Init terraform instance') {
            steps {
                sh 'cd ./terraform'
                sh 'terraform init'
            }
        }
        stage('Start terraform instance') {
            steps {
                sh 'terraform apply --auto-approve'
            }
        }
    }
}