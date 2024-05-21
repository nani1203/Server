pipeline {
    agent any
    
    stages {
        stage('Execute PowerShell Script') {
            steps {
                script {
                    try {
                        def a = 101
                        def b = 11
                        
                        def powerShellCommand = """
                            param(
                                [int]\$a,
                                [int]\$b
                            )
                            \$sum = \$a + \$b
                            Write-Output \$sum
                        """
                        
                        def scriptFilePath = "${env.WORKSPACE}/Sample.ps1"
                        
                        writeFile file: scriptFilePath, text: powerShellCommand
                        
                        def result = powershell(returnStdout: true, script: "powershell.exe -File '${scriptFilePath}' -a ${a} -b ${b}").trim()
                        
                        echo "Addition result: ${result}"
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
