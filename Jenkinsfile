pipeline {
    agent any

    environment {
        IMAGE_NAME = 'dinner-menu-ui'
    }

    stages {
        stage('Cloning the Repo') {
            steps {
                git branch: 'main', url: 'https://github.com/TechTitans-Academy/Dinner-menu-Static-Website.git'
            }
        }

        stage('Docker Image Build') {
            steps {
                sh 'docker build -t ${IMAGE_NAME} .'
            }
        }

        stage('Upload to DockerHub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub', passwordVariable: 'dockerHubPass', usernameVariable: 'dockerHubUser')]) {
                    sh 'docker tag ${IMAGE_NAME} techtitansacademy/${IMAGE_NAME}:${BUILD_NUMBER}'
                    sh 'echo "${dockerHubPass}" | docker login -u "${dockerHubUser}" --password-stdin'
                    sh 'docker push techtitansacademy/${IMAGE_NAME}:${BUILD_NUMBER}'
                }
            }
        }

        stage('Update Manifests in Git') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'github', usernameVariable: 'GIT_USER', passwordVariable: 'GIT_PASS')]) {
                    sh '''
                        # update the image tag inside manifest/deployment.yml
                        sed -i "s|image: techtitansacademy/${IMAGE_NAME}.*|image: techtitansacademy/${IMAGE_NAME}:${BUILD_NUMBER}|" manifest/deployment.yml

                        # commit and push changes
                        git config user.email "learnwithtechtitans@gmail.com"
                        git config user.name "Jenkins-Git-ArgoCD"
                        git add manifest/deployment.yml
                        git commit -m "Update image to techtitansacademy/dinner-menu-ui:${BUILD_NUMBER}" || echo "No changes to commit"
                        git push https://${GIT_USER}:${GIT_PASS}@github.com/TechTitans-Academy/Dinner-menu-Static-Website.git HEAD:main
                    '''
                }
            }
        }

        stage('Apply Kubernetes Manifest & Sync App with ArgoCD') {
            steps {
                withKubeConfig([credentialsId: 'kubeconfig', serverUrl: 'https://192.168.49.2:8443']) {
                    sh '''
                        ARGOCD_PASS=$(kubectl get secret -n argocd argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)
                        argocd login 172.105.51.7:32619 --username admin --password $ARGOCD_PASS --insecure
                        argocd app sync dinner-menu-ui
                    '''
                }
            }
        }
    }
}
