pipeline {
    agent any
    tools{
        jdk "java17"
        maven "Maven3"
    }
    stages{
        stage("Clean Workspace"){
            steps{
                cleanWs()
            }
        }

        stage("Code Checkout"){
            steps{
                git branch: 'main', credentialsId: 'github', url: 'https://github.com/sammakaorz/springboot'
            }
        }

        stage("Build Code"){
            steps{
                sh 'mvn clean package'
            }
        }

        stage("Test Code"){
            steps{
                sh 'mvn test'
            }
        }

        stage("Sonarqube Analysis"){
            steps{
                script{
                    withSonarQubeEnv(credentialsID: 'jenkins-sonarqube-token'){
                        sh "mvn sonar:sonar"
                    }
                }
            }
        }

        stage("Sonarqube quality gate"){
            steps{
                script{
                    waitForQualityGate abortPipeline: false, credentialsId: 'jenkins-sonarqube-token'
                }
            }
        }
        
    }
}