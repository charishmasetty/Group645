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
                git url: 'https://github.com/charishmasetty/Group645.git', branch: 'main'
            }
        }
        
        stage('Deploy YAML First') {
            steps {
                withCredentials([file(credentialsId: 'jenkins-gcp-key', variable: 'GCP_KEY')]) {
                    sh """
                      gcloud auth activate-service-account --key-file=${GCP_KEY}
                      gcloud config set project ${PROJECT_ID}
                      gcloud container clusters get-credentials ${GKE_CLUSTER} --region ${GKE_REGION}
                      
                      # Apply the current manifests
                      kubectl apply -f deploy.yaml
                    """
                }
            }
        }

        stage('Build & Push Docker Image') {
            steps {
                withCredentials([file(credentialsId: 'jenkins-gcp-key', variable: 'GCP_KEY')]) {
                    sh """
                      gcloud auth activate-service-account --key-file=${GCP_KEY}
                      gcloud config set project ${PROJECT_ID}
                      gcloud auth configure-docker

                      docker buildx create --use
                      docker buildx build --platform linux/amd64 -t ${REGISTRY_URL} --push .
                    """
                }
            }
        }
        
        stage('Force Rollout Restart') {
            steps {
                withCredentials([file(credentialsId: 'jenkins-gcp-key', variable: 'GCP_KEY')]) {
                    sh """
                      gcloud auth activate-service-account --key-file=${GCP_KEY}
                      gcloud config set project ${PROJECT_ID}
                      gcloud container clusters get-credentials ${GKE_CLUSTER} --region ${GKE_REGION}

                      # Force a new rollout so pods pull the newly built image
                      kubectl rollout restart deployment survey-app
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
