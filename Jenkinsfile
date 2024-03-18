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
        IMAGE_TAG = "${RELEASE}-${BUILD_NUMBER}"
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
                    withSonarQubeEnv(credentialsId: 'jenkins-sonarqube-token'){
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
                        docker_image.push("${IMAGE_TAG}")
                        docker_image.push('latest')
                    }
                }
            }
        }

        stage('Checkout K8S manifest SCM'){
            steps {
                git branch: 'main', credentialsId: 'github', url: 'https://github.com/sammakaorz/springboot.git'
            }
        }

        stage('Update K8S manifest & push to Repo'){
            environment {
                        GITHUB_PERSONAL_TOKEN = credentials('GITHUB_PERSONAL_TOKEN')
                }
		    steps {
                	script{
                        	sh '''
	                        git config --global user.email "sammakaorz@hotmail.com"
	                        git config --global user.name "sammakaorz"
        	                cat deployment.yaml
                	        sed -i "s/springboot:.*/springboot:${IMAGE_TAG}/g" deployment.yaml
                        	cat deployment.yaml
	                        git add deployment.yaml
        	                git commit -m 'Updated the deployment yaml with new image tag ${IMAGE_TAG} | Jenkins Pipeline'
                	        git remote -v
                        	git push https://$GITHUB_PERSONAL_TOKEN@github.com/sammakaorz/springdemo.git HEAD:main
                        	'''
                		}
            		}
        	}




    }
}
