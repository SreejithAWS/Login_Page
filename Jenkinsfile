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
      stage('Check SonarQube Server') {
            steps {
                sh 'curl -I http://3.85.208.12:9000'
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
            withMaven(globalMavenSettingsConfig: 'maven.settings', jdk: 'jdk17', maven: 'maven3', mavenSettingsConfig: '', traceability: true) {
                sh 'mvn deploy'
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
}
    