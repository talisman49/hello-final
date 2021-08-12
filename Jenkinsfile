pipeline {
    agent any

    options {
        ansiColor('xterm')
    }

    stages {
        stage('Build') {
            steps {
                echo '\033[34mHello\033[0m \033[33mcolorful\033[0m \033[35mworld!\033[0m'
                sh '''docker-compose build'''
                sh '''docker image tag hello-gradle:latest hello-gradle:MAIN-1.0.${BUILD_NUMBER}-${GIT_COMMIT}'''
            }
        stage('Test') {
            steps {
                echo 'Testing...'
                junit 'build/test-results/test/TEST-*.xml'

            }
        }
        stage('Deploy') {
            steps {
                sh 'docker-compose up'
                sshagent (credentials: ['jenkins-key']) {
                    sh 'git tag MAIN-1.0.${BUILD_NUMBER}'
                    sh 'git push --tags'
                }
            }
        }
    }
}

