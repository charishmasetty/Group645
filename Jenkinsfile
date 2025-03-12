pipeline {
    agent any

    environment {
        PROJECT_ID   = "survey-453423"
        GKE_CLUSTER  = "survey"
        GKE_REGION   = "us-central1"
        IMAGE_NAME   = "survey"
        REGISTRY_URL = "gcr.io/${PROJECT_ID}/${IMAGE_NAME}:latest"
    }
    
    stages {
        stage('Checkout Code') {
            steps {
                // Checkout the code from your GitHub repo (use credentials if needed)
                git url: 'https://github.com/charishmasetty/Group645.git', branch: 'main', credentialsId: 'github-creds'
            }
        }
        
        stage('Build Docker Image') {
            steps {
                // Use the GCP key for Docker authentication as well
                withCredentials([file(credentialsId: 'jenkins-gcp-key', variable: 'GCP_KEY')]) {
                    sh """
                    # Authenticate with GCP and configure Docker to use these credentials
                    gcloud auth activate-service-account --key-file=${GCP_KEY}
                    gcloud config set project ${PROJECT_ID}
                    gcloud auth configure-docker
                    gcloud container clusters get-credentials ${GKE_CLUSTER} --region ${GKE_REGION}
                    kubectl apply -f deploy.yaml

                    # Build and push the Docker image using buildx
                    docker buildx create --use
                    docker buildx build --platform linux/amd64 \
                        -t gcr.io/survey-453423/survey:latest --push .
                    """
                }
            }
        }
        
        stage('Deploy to GKE') {
            steps {
                // Use the GCP key again to authenticate with GCP for deployment
                withCredentials([file(credentialsId: 'jenkins-gcp-key', variable: 'GCP_KEY')]) {
                    sh """
                    gcloud auth activate-service-account --key-file=${GCP_KEY}
                    gcloud config set project ${PROJECT_ID}
                    gcloud container clusters get-credentials ${GKE_CLUSTER} --region ${GKE_REGION}
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
