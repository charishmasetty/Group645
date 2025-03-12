pipeline {
    agent any
    environment {
        DOCKER_IMAGE = "gcr.io/warm-drive-453300-q6/survey-tomcat:v1"
        KUBERNETES_DEPLOYMENT = "survey-app"
        CONTAINER_NAME = "survey-tomcat"
    }
    stages {
        stage('Clone Repository') {
    steps {
        git branch: 'main', credentialsId: 'github-credentials', url: 'https://github.com/charishmasetty/Group645.git'
    }
}

        stage('Build Docker Image') {
            steps {
                sh "docker build -t $DOCKER_IMAGE ."
            }
        }
        stage('Push to Google Container Registry') {
            steps {
                sh "docker push $DOCKER_IMAGE"
            }
        }
        stage('Deploy to Kubernetes') {
            steps {
                sh """
                kubectl set image deployment/$KUBERNETES_DEPLOYMENT $CONTAINER_NAME=$DOCKER_IMAGE --record
                """
            }
        }
    }
}
