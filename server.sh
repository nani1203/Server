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
                        
                        def scriptFilePath = "${env.WORKSPACE}/Addition.ps1"
                        
                        writeFile file: scriptFilePath, text: powerShellCommand
                        
                        def result = powershell(returnStdout: true, script: "powershell.exe -File '${scriptFilePath}' -a ${a} -b ${b}").trim()
                        
                        echo "Addition result: ${result}"
                    } catch (Exception e) {
                        error "An error occurred: ${e.message}"
                    }
                }
            }
        }
    }
}
