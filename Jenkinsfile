pipeline {
    agent any

    environment {
        PROJECT_ID    = "survey-453423"
        GKE_CLUSTER   = "survey"              // Cluster name is "survey"
        GKE_REGION    = "us-central1"
        IMAGE_NAME    = "survey"
        REGISTRY_URL  = "gcr.io/survey-453423/survey:latest"
    }

    stages {
        stage('Checkout Code') {
            steps {
                // Checkout the code from your GitHub repository
                git url: 'https://github.com/charishmasetty/Group645', branch: 'main'
            }
        }
        
        stage('Build Docker Image') {
            steps {
                script {
                    // Create a new builder instance and build the Docker image for linux/amd64, then push to GCR
                    sh """
                    docker buildx create --use
                    docker buildx build --platform linux/amd64 -t ${REGISTRY_URL} --push .
                    """
                }
            }
        }
        
        stage('Deploy to GKE') {
            steps {
                script {
                    // Activate your GCP service account using the key file (ensure gcp-key.json is added as a secret file credential)
                    sh """
                    gcloud auth activate-service-account --key-file=${WORKSPACE}/gcp-key.json
                    gcloud config set project ${PROJECT_ID}
                    gcloud container clusters get-credentials ${GKE_CLUSTER} --region ${GKE_REGION}
                    """
                    // Deploy your Kubernetes manifest (deploy.yaml should be present in your repository)
                    sh "kubectl apply -f deploy.yaml"
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
