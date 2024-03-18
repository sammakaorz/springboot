pipeline {
    agent any
    tools{
        jdk "Java17"
        maven "Maven3"
    }
    stages{
        stage("cleanup workspace"){
            steps{
                cleanWs()
            }
        }
    }
    stages{
        stage("code checkout"){
            steps{
                git branch: 'main' credentialsId: 'github' url: 'https://github.com/sammakaorz/springboot'
            }
        }
    }

}