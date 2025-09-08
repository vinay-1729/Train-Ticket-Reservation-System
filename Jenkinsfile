pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "vinay072/project:latest"
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'master',
                    url: 'https://github.com/vinay-1729/Train-Ticket-Reservation-System.git'
            }
        }

        stage('Build WAR with Maven') {
            steps {
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh "docker build -t $DOCKER_IMAGE ."
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                withDockerRegistry([ credentialsId: 'deepak', url: '' ]) {
                    sh "docker push $DOCKER_IMAGE"
                }
            }
        }

        stage('Deploy Container') {
            steps {
                sh '''
                docker stop project || true
                docker rm project || true
                # Run app on container port 8080 but expose as 8090 on host
                docker run -d --name project -p 8090:8080 $DOCKER_IMAGE
                '''
            }
        }
    }
}

