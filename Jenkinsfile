pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'muhamedusama92/jpetstore-app:v2.0'
    }

        stage('Provision Infrastructure') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'aws-creds', usernameVariable: 'AWS_ACCESS_KEY_ID', passwordVariable: 'AWS_SECRET_ACCESS_KEY')]){
                    dir('infrastructure') {
                        sh '''
                             terraform init
                             terraform destroy -auto-approve
                             terraform plan
                             terraform apply -auto-approve
                        '''
                    }
                }
            }
        }

        stage('Generate Inventory') {
            steps {
                dir('infrastructure'){
                    sh 'chmod +x generate-inventory.sh'
                    sh './generate-inventory.sh'
                }
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
                        ansible-playbook -i infrastructure/inventory.ini deploy.yml --private-key $SSH_KEY
                    '''
                }
            }
        }
    }
}
