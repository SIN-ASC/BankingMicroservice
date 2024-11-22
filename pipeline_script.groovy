pipeline {
    agent none  // Only run on a Jenkins agent with the 'centos-node' label

    stages {
        stage('Clear Workspace') {
            agent { label 'Mas02' }
            steps {
                script {
                    deleteDir()  // This will delete everything in the workspace
                    echo "Workspace cleared."
                }
            }
        }
        // Stage 1: Git Clone
        stage('Git Clone') {
            
            agent { label 'Mas02' }
            steps {
                // Checkout code from the Git repository
                git branch: 'main', credentialsId: 'githubcred', url: 'git@github.com:SIN-ASC/BankingMicroservice.git'
            }
        }

        // Stage 2: Install epel-release and Ansible
        stage('Install epel-release and Ansible') {
            agent { label 'Mas02' }
            steps {
                script {
                    // Install epel-release and Ansible
                    sh '''
                    sudo dnf -y update
                    sudo dnf -y install epel-release
                    sudo dnf -y install ansible
                    ansible --version
                    '''
                }
            }
        }

        // Stage 3: Capture IP Address and Edit Inventory File
        stage('Capture IP Address and Edit Inventory File') {
            agent { label 'Mas02' }
            steps {
                script {
                    // Capture the machine's IP address using 'ip a'
                    def ipAddress = sh(script: "ip a show eth0 | grep inet | grep -v inet6 | awk '{print \$2}' | cut -d'/' -f1 | head -n 1", returnStdout: true).trim()

                    // Define the inventory file path (adjust as necessary)
                    def inventoryFile = '/etc/ansible/hosts'

                    // Check if the IP address already exists in the inventory file
                    def existingIpCheck = sh(script: "grep -q '${ipAddress}' ${inventoryFile} && echo 'found' || echo 'not_found'", returnStdout: true).trim()

                    if (existingIpCheck == 'not_found') {
                        // If IP is not found, add it to the inventory file
                        sh """
                        echo '[server]' | sudo tee -a ${inventoryFile}
                        echo 'host1 ansible_host=${ipAddress}' | sudo tee -a ${inventoryFile}
                        """

                        // Verify the added lines in the inventory file
                        sh 'cat /etc/ansible/hosts'
                    } else {
                        echo "IP address ${ipAddress} already exists in the inventory. Skipping update."
                    }
                }
            }
        }

        // Stage 4: Run Ansible Playbook to Install Terraform
        stage('Run Ansible Playbook') {
            agent { label 'Mas02' }
            steps {
                script {
                    // Run the Ansible playbook to install Terraform
                    sh 'ansible-playbook ansi-playbooks/install_terraform.yaml'
                }
            }
        }

        // Stage 5: Terraform Init and Plan
        stage('Terraform Init and Plan') {
            agent { label 'Mas02' }
            steps {
                script {
                    // Change to the terraform directory
                    dir('Terraform') {
                        // Run terraform init
                        sh 'terraform init -force-copy'
                        // Run terraform plan
                        sh 'terraform plan'
                        // Run terraform apply with auto-approval
                        sh 'terraform apply -auto-approve'
                    }
                }
            }
        }

        // Stage 6: SCM Checkout
        stage('SCM Checkout') {
            agent { label 'java' }
            steps {
                input message: "Do you want to approve?",
                    ok: 'Approve'
                git branch: 'main', 
                    credentialsId: 'adminuser', 
                    url: 'https://github.com/SIN-ASC/BankingMicroservice'
            }
        }

        // Stage 7: Run Ansible Playbook for Docker
        stage('Run Ansible Playbook for Docker') {
            agent { label 'java' }
            steps {
                script {
                    // Ensure the playbook is run from the correct path
                    sh 'ansible-playbook ./ansi-playbooks/pipeline.yaml'
                }
            }
        }

        // Stage 8: Maven Build
        stage('Maven Build') {
            agent { label 'java' }
            steps {
                script {
                    // Running Maven build
                    sh 'mvn clean install'
                }
            }
        }

        // Stage 9: Docker Compose Up
        stage('Docker Compose Up') {
            agent { label 'java' }
            steps {
                script {
                    // Run docker-compose to start containers in detached mode
                    sh 'sudo docker compose -f docker-compose.yaml up -d'
                }
            }
        }

        // Stage 10: Build
        // stage('Build') {
        //     steps {
        //         echo 'Building...'
        //     }
        // }

        // Stage 11: Approval
        stage('Approval') {
            agent { label 'Mas02' }
            steps {
                script {
                    // Wait for manual approval
                    input message: 'Do you approve this build?', 
                          ok: 'Approve'
                }
            }
        }

        // Stage 12: Deploy
        stage('Deploy') {
            agent { label 'Mas02' }
            steps {
                echo 'Deploying...'
            }
        }
        
        stage('Approval for Destroy') {
            agent { label 'Mas02' }
            steps {
                script {
                    // Wait for manual approval
                    sh 'curl 52.228.62.78:8000'
                    input message: 'Do you approve this destroy?', ok: 'Approve'
                }
            }
        }
        // Stage 13: Terraform Init and Destroy
        stage('Terraform Init and Destroy') {
            agent {label 'Mas02' }
            steps {
                script {
                    dir('Terraform') {
                        sh 'terraform destroy -auto-approve'
                    }
                }
            }
        }
    }
}