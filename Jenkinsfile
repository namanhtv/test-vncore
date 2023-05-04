pipeline {

  agent any

  environment {
    DOCKER_IMAGE = "anhtvndevops/vncorelnp"
  }

  stages {

    stage("build") {
      environment {
        DOCKER_TAG="${GIT_BRANCH.tokenize('/').pop()}-${GIT_COMMIT.substring(0,7)}"
      }
      steps {
        withCredentials([usernamePassword(credentialsId: 'docker-hub', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
            sh "docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} . "
            sh 'echo $DOCKER_PASSWORD | docker login --username $DOCKER_USERNAME --password-stdin'
            sh "docker push ${DOCKER_IMAGE}:${DOCKER_TAG}"
        }

        //clean to save disk
        sh "docker image rm ${DOCKER_IMAGE}:${DOCKER_TAG}"
      }
    }
    stage("deploy") {
      environment {
        DOCKER_TAG="${GIT_BRANCH.tokenize('/').pop()}-${GIT_COMMIT.substring(0,7)}"
      }
      steps {
        withCredentials([sshUserPrivateKey(credentialsId: 'ssh-key', keyFileVariable: 'SSH_KEY')]) {
            sh "mkdir -p ~/.ssh"
            sh "echo $SSH_KEY > ~/.ssh/id_rsa"
            sh "chmod 600 ~/.ssh/id_rsa"
            sh "chmod 700 ~/.ssh"
            sh "ssh-keyscan -H 134.209.223.229 >> ~/.ssh/known_hosts"
            sh "chmod 600 ~/.ssh/known_hosts"
            sh "ssh -i ~/.ssh/id_rsa  jenkins@134.209.223.229 'docker run -d -p 9000:9000 ${DOCKER_IMAGE}:${DOCKER_TAG}'"
        }
      }
    }
  }

  post {
    success {
      echo "SUCCESSFUL"
    }
    failure {
      echo "FAILED"
    }
  }
}
