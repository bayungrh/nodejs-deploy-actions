def notifyBuild(String buildStatus = 'STARTED') {
    // build status of null means successful
    buildStatus =  buildStatus ?: 'SUCCESS'

    // Default values
    def colorName = 'RED'
    def colorCode = '#FF0000'
    def subject = "${buildStatus}: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'"
    def summary = "${subject} (${env.BUILD_URL})"

    // Override default values based on build status
    if (buildStatus == 'STARTED') {
      color = 'YELLOW'
      colorCode = '#FFFF00'
    } else if (buildStatus == 'SUCCESS') {
      color = 'GREEN'
      colorCode = '#00FF00'
    } else {
      color = 'RED'
      colorCode = '#FF0000'
    }
}

pipeline {
  agent any
  stages {
    stage('Initial') {
      when {
        expression {
          BRANCH_NAME ==~ /(master)/
        }
      }
      steps {
        echo 'Killing Docker'
        sh 'docker kill service-1 || true'
        sh 'docker rm service-1 || true'
      }
    }
    stage('Deploy Production') {
      when {
        expression {
          BRANCH_NAME ==~ /(master)/
        }
      }
      steps {
        script {
          try {
            echo 'Deploying'
            sh 'docker build -t muhbayu/nodejs-deploy:${BUILD_NUMBER} .'
            sh 'docker run -d -p 3000:3000 --name service-1 muhbayu/nodejs-deploy:${BUILD_NUMBER}'
            notifyBuild('SUCCESS')
            currentBuild.result = 'SUCCESS'
          } catch (e) {
            notifyBuild('FAILURE')
            currentBuild.result = 'FAILURE'
          }
        }
      }
    }
    stage('Unit Test') {
      when {
        expression {
          BRANCH_NAME ==~ /(master)/
          currentBuild.result == 'SUCCESS'
        }
      }
      steps {
        script {
          try {
            input id: 'Unittest', message: "Proceed?"
            echo 'Unit test here'
          } catch (e) {
            echo 'Skip'
          }
        }
      }
    }
    stage('Clean') {
      when {
        expression {
          BRANCH_NAME ==~ /(master)/
        }
      }
      steps {
        echo 'clean'
        sh 'docker image prune -f || true'
      }
    }
  }
}
