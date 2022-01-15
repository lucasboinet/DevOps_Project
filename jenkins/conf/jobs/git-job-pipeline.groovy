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
                sh 'mvn clean compile'
            }
        }
        stage('Run unit tests and integration tests') {
            when {
                expression { params.SKIP_TESTS == false }
            }
            steps {
                sh 'mvn test'
            }
        }
        stage('Build .jar') {
            steps {
                sh 'mvn package'
            }
        }
        stage('Move .jar in jenkins workspace') {
            steps {
                sh "mv /var/jenkins_home/workspace/CI/Git_Job/sb3t-ws/target/*.jar /var/jenkins_home/workspace/${params.VERSION}-${params.VERSION_TYPE}.jar"
            }
        }
        stage('Launch terraform job') {
            steps {
                build job: '../IaC/Terraform_Job', parameters: [[$class: 'BooleanParameterValue', name: 'INSTANCE_ACTION', value: true]]
]
            }
        }
    }
}