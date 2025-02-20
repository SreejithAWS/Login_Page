pipeline {
    agent any
    tools {
        jdk 'jdk17'
        maven 'maven3'
    }

    environment {
        SCANNER_HOME= tool 'sonar-scanner'
    }
    stages{
        stage('Git checkout') {
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
            sh 'trivy fs --format table -o fs.html . '
        }
    }
    stage('Sonarqube Analysis') {
        steps {
            withSonarQubeEnv('sonar-server') {
                 sh ''' $SCANNER_HOME/bin/sonar-scanner -Dsonar.projectName=Login_Page -Dsonar.projectKey=Login_Page \
                    -Dsonar.java.binaries=target '''
             }
        }
    }
    stage('Build') {
        steps {
            sh ' mvn package'
        }
    }
    stage('Publish artifact') {
        steps {
            withMaven(globalMavenSettingsConfig: 'manage-settings', jdk: 'jdk17', maven: 'maven3', mavenSettingsConfig: '', traceability: true) {
                sh 'mvn deploy'
            }
        }     
    }
    stage('Docker Build and Tag') {
        steps {
            script {
                // This step should not normally be used in your script. Consult the inline help for details.
                withDockerRegistry(credentialsId: 'Docker_Cred', toolName: 'docker') {
                sh 'docker build -t sreejitheyne/login_page:latest .' 
                }
            }
        }
    }
    stage('Trivy Image Scan') {
        steps {
            sh 'trivy image --format table -o image.html sreejitheyne/login_page:latest '
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
 /*   }
     stages {
        stage('Hello') {
            steps {
                echo 'Hello World'
            }
        }
    } */
}
}
    
