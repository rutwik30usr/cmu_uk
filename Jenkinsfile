pipeline {
    agent any

    environment {
        TF_VAR_file = 'prod.tfvars'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        stage('Terraform Init') {
            steps {
                sh 'terraform init'
            }
        }
        stage('Terraform Plan') {
            steps {
                sh 'terraform plan -var-file="${TF_VAR_file}"'
            }
        }
        stage('Manual Approval') {
            steps {
                script {
                    def userInput = input(
                        id: 'Proceed1', message: 'Do you want to proceed with Terraform Apply?',
                        parameters: [choice(choices: 'No\nYes', description: 'Apply changes?', name: 'proceed')]
                    )
                    if (userInput != 'Yes') {
                        error('Aborting as per user input')
                    }
                }
            }
        }
        stage('Terraform Apply') {
            steps {
                sh 'terraform apply -auto-approve -var-file="${TF_VAR_file}"'
            }
        }
    }

    post {
        always {
            cleanWs()
        }
    }
}
