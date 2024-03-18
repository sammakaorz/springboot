pipeline {

    agent any
    
    tools{
        jdk "java17"
        maven "Maven3"
    }
    environment{
        APP_NAME = "springboot"
        RELEASE =  "1.0.0"
        DOCKER_USER = "sammakaorz"
        DOCKER_PASS = 'dockerhub'
        IMAGE_NAME = "${DOCKER_USER}" + "/" + "${APP_NAME}"
        IMAGE_TAG = "${RELEASE}"-"${BUILD_NUMBER}"
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

        stage("Build and Push Docker Image"){
            steps{
                script{
                    docker.withRegistry('',DOCKER_PASS){
                        docker_image = docker.build "${IMAGE_NAME}"
                    }
                    docker.withRegistry('',DOCKER_PASS){
                        docker_image.push("$(IMAGE_TAG)")
                        docker_image.push('latest')
                    }
                }
            }
        }


    }
}