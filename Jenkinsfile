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
    }
}