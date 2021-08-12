pipeline {
    agent any

    options {
        ansiColor('xterm')
    }

    stages {

        stage('Test') {
            steps {
                echo 'Testing...'
                withGradle {
                    sh './gradlew clean test pitest'
                }
                post {
                    always {
                        junit 'build/test-results/test/TEST-*.xml'
                        jacoco execPattern:'build/jacoco/*.exec'
                        recordIssues(enabledForFailure:true,tool: pit(pattern:"build/reports/pitest/**/*.xml"))
                    }
                }
            }
        }

        stage('Analisys'){

            parallel{

                stage('SonarQube Analysis') {
             
                    echo 'Analisys SonarQube stage'    

                    when { expression { false } } 
                    steps {
                        withSonarQubeEnv ('sonarqube') {
                            sh './gradlew sonarqube'
                        }        
                    }
                }

                stage('QA') {
                    steps {
                        echo 'Analisys QA stage'    
                        withGradle {
                            sh './gradlew check'
                        }
                    }
                    post {
                        always {
                            recordIssues(
                                tools: [
                                    pmdParser(pattern: 'build/reports/pmd/*.xml'),
                                    spotBugs(pattern: 'build/reports/spotbugs/*.xml', useRankAsPriority: true)
                                ]
                            )
                        }
                    }
                }
            }
        }

        stage('Build') {

            steps {
                echo '\033[34mHello\033[0m \033[33mcolorful\033[0m \033[35mworld!\033[0m'
                sh '''docker-compose build'''
                sh '''docker image tag hello-gradle:latest hello-gradle:MAIN-1.0.${BUILD_NUMBER}-${GIT_COMMIT}'''
            }
        }

        stage('Security') {
            steps {
                echo 'Security analysis...'
                sh 'trivy image --format=json --output=trivy-image.json hello-gradle:latest'
            }
            post {
                always {
                    recordIssues(
                        enabledForFailure: true,
                        aggregatingResults: true,
                        tool: trivy(pattern: 'trivy-*.json')
                    )
                }
            }
        }

        stage('Publish'){
            echo 'Publish Stage'
            steps{
                tag 'docker tag hello-spring-testing:latest 10.250.4.3:5050/esteban/hello-spring/hello-spring-testing:MAIN-1'
                withDockerRegistry([url:'10.250.4.3', credentialsId: 'dockerCli']){
                tag 'docker push --all-tags 10.250.4.3:5050/esteban/hello-spring-testing'
                }
            }
        }

        stage('Deploy') {
            steps {
                echo 'Deploy Stage'
                sshagent (credentials: ['jenkins-key']) {
                    sh 'git tag MAIN-1.0.${BUILD_NUMBER}'
                    sh 'git push --tags'
                }
                sshagent (credentials: ['app-key']) {
    			    sh "ssh app@10.250.4.3 'cd hello-spring && docker-compose pull && docker-compose up -d'"
                }
            }
        }
    }
}    

