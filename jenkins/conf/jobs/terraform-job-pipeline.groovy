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
                checkout([$class: 'GitSCM', branches: [[name: 'master']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/lucasboinet/DevOps_Project']]])
            }
        }
        stage('Init terraform instance') {
            steps {
                sh 'cd /var/jenkins_home/'
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