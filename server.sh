pipeline {
    agent any

    stages {
        stage('Check URL') {
            steps {
                script {
                    def url = 'htps://youtube.com/'  // Specify the URL you want to check

                    def response = httpRequest(url: url, ignoreSslErrors: true)
                    
                    if (response.status == 200) {
                        println "URL ${url} is reachable."
                    } else {
                        println "URL ${url} is not reachable. Response status: ${response.status}"
                    }
                }
            }
        }
    }
}
