pipeline {
    agent any
    tools {
        jdk 'jdk17'
        maven 'maven3'
    }

    environment {
        SCANNER_HOME = tool 'sonar-scanner'
    }

    stages {
        stage('Git Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/SreejithAWS/Login_Page.git'
            }        
        }

        stage('Compile') {
            steps {
                sh 'mvn compile'
            }
        }

        stage('Test') {
            steps {
                sh 'mvn test'
            }
        }

        stage('Trivy FS Scan') {
            steps {
                sh 'trivy fs --format table -o fs.html .'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('sonar-server') {
                    sh '''$SCANNER_HOME/bin/sonar-scanner \
                        -Dsonar.projectName=Login_Page \
                        -Dsonar.projectKey=Login_Page \
                        -Dsonar.java.binaries=target'''
                }
            }
        }

        stage('Build') {
            steps {
                sh 'mvn package'
            }
        }

        stage('Publish Artifact') {
            steps {
                withMaven(globalMavenSettingsConfig: 'manage-settings', jdk: 'jdk17', maven: 'maven3', traceability: true) {
                    sh 'mvn deploy'
                }
            }     
        }

        stage('Docker Build and Tag') {
            steps {
                script {
                    withDockerRegistry(credentialsId: 'Docker_Cred', toolName: 'docker') {
                        sh 'docker build -t sreejitheyne/login_page:latest .' 
                    }
                }
            }
        }

        stage('Trivy Image Scan') {
            steps {
                sh 'trivy image --format table -o image.html sreejitheyne/login_page:latest'
            }
        }

        stage('Docker Push') {
            steps {
                script {
                    withDockerRegistry(credentialsId: 'Docker_Cred', toolName: 'docker') {
                        sh 'docker push sreejitheyne/login_page:latest'
                    }
                }
            }
        }

        stage('Kubernetes Deployment') {
            steps {
                script {
                    withKubeConfig(
                        clusterName: 'login_page-cluster',
                        credentialsId: 'kubernetes',
                        namespace: 'webapp',
                        serverUrl: 'https://40AACB2BEFC20596B90AC78913A0D429.gr7.us-east-1.eks.amazonaws.com'
                    ) {
                        sh 'kubectl apply -f deployment-service.yaml'
                        sleep 20
                    }
                }
            }    
        }

        stage('Kubernetes Status Check') {
            steps {
                script {
                    withKubeConfig(
                        clusterName: 'login_page-cluster',
                        credentialsId: 'kubernetes',
                        namespace: 'webapp',
                        serverUrl: 'https://40AACB2BEFC20596B90AC78913A0D429.gr7.us-east-1.eks.amazonaws.com'
                    ) {
                        sh 'kubectl get pods'
                        sh 'kubectl get svc'
                    }
                }
            }    
        }              
    }
}
post {
    always {
        script {
            def jobName = env.JOB_NAME
            def buildNumber = env.BUILD_NUMBER
            def pipelineStatus = currentBuild.result ?: 'UNKNOWN'
            def bannerColor = pipelineStatus.toUpperCase() == 'SUCCESS' ? 'green' : 'red'

            def body = """
            <html>
            <body>
            <div style="border: 4px solid ${bannerColor}; padding: 10px;">
                <h2>${jobName} - Build ${buildNumber}</h2>
                <div style="background-color: ${bannerColor}; padding: 10px;">
                    <h3 style="color: white;">Pipeline Status: ${pipelineStatus.toUpperCase()}</h3>
                </div>
                <p>Check the <a href="${BUILD_URL}">console output</a>.</p>
            </div>
            </body>
            </html>
            """
        }

        emailext (
            subject: "${jobName} - Build ${buildNumber} - ${pipelineStatus.toUpperCase()}",
            body: body,
            to: 'sreejitheyne@gmail.com',
            from: 'jenkins@example.com',
            replyTo: 'jenkins@example.com',
            mimeType: 'text/html'
        )
    }
}
