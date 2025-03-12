pipeline {
    agent any
    
    environment {
        // Update these to match your GCP setup
        PROJECT_ID   = "survey-453423"
        GKE_CLUSTER  = "survey"
        GKE_REGION   = "us-central1"
        
        // Docker image name
        IMAGE_NAME   = "survey"
        
        // Full image URL in GCR
        REGISTRY_URL = "gcr.io/${PROJECT_ID}/${IMAGE_NAME}:latest"
    }
    
    stages {
        stage('Checkout Code') {
            steps {
                // Pull code from your GitHub repository
                git url: 'https://github.com/charishmasetty/Group645', branch: 'main'
            }
        }
        
        stage('Build Docker Image') {
            steps {
                script {
                    // Build and push your Docker image for linux/amd64
                    sh """
                    docker buildx create --use
                    docker buildx build --platform linux/amd64 -t ${REGISTRY_URL} --push .
                    """
                }
            }
        }
        
        stage('Deploy to GKE') {
        steps {
            withCredentials([file(credentialsId: 'jenkins-gcp-key', variable: 'GCP_KEY')]) {
                sh """
                gcloud auth activate-service-account --key-file=${GCP_KEY}
                gcloud config set project survey-453423
                gcloud container clusters get-credentials survey --region us-central1
                kubectl apply -f deploy.yaml
                """
            }
        }
    }

    }   
    
    post {
        success {
            echo 'CI/CD Pipeline completed successfully!'
        }
        failure {
            echo 'CI/CD Pipeline failed. Check logs for details.'
        }
    }
}
