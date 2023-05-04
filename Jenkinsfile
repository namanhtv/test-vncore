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
        DOCKER_TAG="${GIT_BRANCH.tokenize('/').pop()}-${GIT_COMMIT.substring(1,7)}"
      }
      steps {
        script{
          withCredentials([sshUserPrivateKey(credentialsId: 'ssh-key', keyFileVariable: 'SSH_KEY', usernameVariable: 'userName')]) {
            def remote = [name: 'jenkins', host: '134.209.223.229', user:userName, identityFile: SSH_KEY, allowAnyHosts: true]
            // sh "whoami"
            // sh "mkdir -p ~/.ssh"
            // sh "ls -la ~/"
            // sh "chmod 600 ~/.ssh/id_rsa"
            // sh "echo $SSH_KEY > ~/.ssh/id_rsa"
            // sh "chmod 700 ~/.ssh"
            // sh "ssh-keyscan -H 134.209.223.229 >> ~/.ssh/known_hosts"
            // sh "chmod 600 ~/.ssh/known_hosts"
            sshCommand remote: remote,command: "docker run -d -p 9000:9000 ${DOCKER_IMAGE}:${DOCKER_TAG}", sudo: true
          }
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
