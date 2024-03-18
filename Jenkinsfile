pipeline {
    agent any
    tools{
        jdk "java17"
        maven "Maven3"
    }
    stages{
        stage("cleanup workspace"){
            steps{
                cleanWs()
            }
        }
        stage("code checkout"){
            steps{
                git branch: 'main', credentialsId: 'github', url: 'https://github.com/sammakaorz/springboot'
            }
        }
        stage("Build Applicaton"){
            steps{
                sh "mvn clean package"
            }
        }
        stage("test Applicaton"){
            steps{
                sh "mvn test"
            }
        }
        stage("Sonarqube Analysis"){
            steps{
                script{
                     withSonarQubeEnv(credentialsId: 'jenkins-sonarqube-token'){
                    sh "mvn sonar:sonar"
                    }
                }
            }
        }
        stage("Sonarqube Analysis"){
            steps{
                script{
                     waitForQualityGate abortPipeline: false, credentialsId: 'jenkins-sonarqube-token'
                }
            }
        }
    }
}

