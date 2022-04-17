#!/usr/bin/env groovy

//@Library("global-jenkins-library@master") _ /

pipeline {
    agent any
    
  options {
  buildDiscarder logRotator(daysToKeepStr: '', numToKeepStr: '10')
  }

  environment { 
      ARTIFACTORY_CREDS = "aws-artifactory"
      ARTIFACTORY_REPO   = "rbi-docker.us-artifactory.cicd.cloud.fpdev.io"     
     
       }

    stages {

 /*         stage("SCM Checkout"){
           environment {
             REPO_NAME = sh(script: 'echo $GIT_URL | rev | cut -d \'/\' -f1 | rev | cut -d \'.\' -f1|tr -d \'\n\'', returnStdout: true)
           }
        
          steps{
              git url: "$GIT_URL", branch: "$BRANCH_NAME"
            script {
	     	echo "$REPO_NAME"
		sh "git log | head -n20"
		sh "git describe --tags || true"
		sh "pwd"
                GIT_TAG = sh(script: 'git tag --contains|head -n 1|tr -d \'\n\'', returnStdout: true)
                if (GIT_TAG.isEmpty())
                {
                  GIT_TAG='NA'
                }
                REPO_NAME = REPO_NAME.toLowerCase()
              
                }
             }
          }
*/
        stage("Build Container Image"){
            //when {
            //    tag "*"
            // }
            steps {
		//git url: "$GIT_URL", branch: "$BRANCH_NAME", credentialsId: 'ghe-jenkins-bot'
                script {
                GIT_TAG = sh(script: 'git tag --contains|head -n 1|tr -d \'\n\'', returnStdout: true)
                  echo "GIT_TAG insde 'Build container Image'=$GIT_TAG"
                  if (env.BRANCH_NAME == 'main' && GIT_TAG != 'NA') {
                    //docker.withRegistry("https://${ARTIFACTORY_REPO}", ARTIFACTORY_CREDS) {
                    //dockerfile = 'Dockerfile'
                    //docker_app_image = docker.build("${ARTIFACTORY_REPO}/${REPO_NAME}:$GIT_TAG", "--no-cache=true -f ${dockerfile} .")      
                    echo "GIT_TAG insde Build container Image -> If condition 'Build container Image'=$GIT_TAG"

                    //}
                  }
                  else
                  {
                    echo "Not main or Tag found"
                  }
                }
             }
          }
   }

   post {
     success {
        echo 'This build has success.'
      }
      unsuccessful {
        echo 'This build has failed.'
      }        
    }
}
