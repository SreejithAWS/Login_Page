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
        stage('Git checkout') {
            steps {
               git branch: 'main', url: 'https://github.com/SreejithAWS/Login_Page.git'
            }
        }
    }
     stages {
        stage('Comple') {
            steps {
                sh 'mvn compile'
            }
        }
    }
     stages {
        stage('Test') {
            steps {
                sh 'mvn test'
            }
        }
    }
     stages {
        stage('Trivy FS Scan') {
            steps {
                sh 'trivy fs --format table -o fs.html . '
            }
        }
    }
     stages {
        stage('Sonarqube Analysis') {
            steps {
                withSonarQubeEnv('sonarqube_server') {
                    sh ''' $SCANNER_HOME/bin/sonar-scanner \
                        -Dsonar.projectName=Login_Page \
                        -Dsonar.projectKey=Login_Page \
                        -Dsonar.java.binaries=target '''
                }
            }
        }
    } 
    stages {
        stage('Build') {
            steps {
                sh ' mvn package'
            }
        }
    }
     stages {
        stage('Publish artifact') {
            steps {
                withMaven(globalMavenSettingsConfig: 'maven.settings', jdk: 'jdk17', maven: 'maven3', mavenSettingsConfig: '', traceability: true) {
                    sh 'mvn deploy'
                }
            }     
         }
    }
 /*  stages {
        stage('Hello') {
            steps {
                echo 'Hello World'
            }
        }
    }
     stages {
        stage('Hello') {
            steps {
                echo 'Hello World'
            }
        }
    } */
}