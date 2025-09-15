pipeline {
    agent any

    environment {
        IMAGE_NAME = 'menu'
    }

    stages {
        stage('Cloning the Repo') {
            steps {
                git branch: 'main', url: 'https://github.com/TechTitans-Academy/testing.git'
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

        stage('Update Image in Manifest') {
            steps {
                sh '''
                    NEW_IMAGE="techtitansacademy/${IMAGE_NAME}:${BUILD_NUMBER}"
                    sed -i "s|image: .*|image: ${NEW_IMAGE}|" manifest/deployment.yaml
                '''
                sh 'cat manifest/deployment.yaml'
            }
        }

        stage('Commit & Push Manifest to Repo') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'github', passwordVariable: 'GH_TOKEN', usernameVariable: 'GH_USER')]) {
                    sh '''
                        git config user.email "learnwithtechtitans@gmail.com"
                        git config user.name "TechTitans"
                        git add manifest/deployment.yaml
                        git commit -m "Update image to techtitansacademy/${IMAGE_NAME}:${BUILD_NUMBER}" || echo "No changes to commit"
                        git push https://${GH_USER}:${GH_TOKEN}@github.com/TechTitans-Academy/testing.git HEAD:main
                    '''
                }
            }
        }
    }

    post {
        always {
            cleanWs()
        }
    }
}
