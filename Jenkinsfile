pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'muhamedusama92/jpetstore-app:v2.0'
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/muhamedusama92/JpetStoreApplication.git'
            }
        }

        stage('Build with Maven') {
            steps {
                sh 'mvn clean package'
            }
        }

        stage('Docker Build') {
            steps {
                sh 'docker build -t $DOCKER_IMAGE .'
            }
        }

        stage('Docker Login & Push') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-cred', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh '''
                        docker login -u $DOCKER_USER -p $DOCKER_PASS
                        docker push $DOCKER_IMAGE
                    '''
                }
            }
        }

        stage('Deploy with Ansible') {
            steps {
                withCredentials([sshUserPrivateKey(credentialsId: 'ansible-ssh-key', keyFileVariable: 'SSH_KEY')]) {
                    sh '''
                        // ssh-keyscan -H 3.84.125.110 >> ~/.ssh/known_hosts
                        ansible-playbook -i ec2-hosts.ini deploy.yml --private-key $SSH_KEY
                    '''
                }
            }
        }
    }
}
