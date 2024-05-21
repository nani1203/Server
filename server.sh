pipeline {
    agent any
    
    parameters {
        choice(
            choices: ['dev', 'qa', 'prod'],
            description: 'Select the environment',
            name: 'ENVIRONMENT'
        )
    }
    
    stages {
        stage('Execute Shell Script') {
            steps {
                script {
                    try {
                        // Clone the repository
                        checkout([$class: 'GitSCM', branches: [[name: '*/main']], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[url: 'https://github.com/nani1203/Server.git']]])
                        
                        // Change directory to where the shell script is located
                        dir('.') {
                            // Execute the shell script
                            sh './server.sh'
                        }
                    } catch (Exception e) {
                        error "An error occurred: ${e.message}"
                    }
                }
            }
        }
        
        stage('Deploy to Environment') {
            steps {
                script {
                    // Define deployment steps based on selected environment
                    def deployCommand
                    def environment = params.ENVIRONMENT
                    
                    // Customize deployment steps based on environment
                    switch (environment) {
                        case 'dev':
                            deployCommand = 'Write-Host "Deploying to Development Environment"'
                            break
                        case 'qa':
                            deployCommand = 'Write-Host "Deploying to QA Environment"'
                            break
                        case 'prod':
                            deployCommand = 'Write-Host "Deploying to Production Environment"'
                            break
                        default:
                            error "Invalid environment selected: ${environment}"
                    }
                    
                    // Execute the deployment command
                    powershell(returnStatus: true, script: deployCommand)
                }
            }
        }
    }
}
