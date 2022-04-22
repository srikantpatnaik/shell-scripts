#!/usr/bin/env groovy

//@Library("global-jenkins-library@master") _

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

          stage("SCM Checkout"){
           environment {
             REPO_NAME = sh(script: 'echo $GIT_URL | rev | cut -d \'/\' -f1 | rev | cut -d \'.\' -f1|tr -d \'\n\'', returnStdout: true)
           }
        
          steps{
	      // next line has caused the tag build issue
              //git url: "$GIT_URL", branch: "$BRANCH_NAME", credentialsId: 'ghe-jenkins-bot'
            script {
                GIT_TAG = sh(script: 'git tag --contains|head -n 1|tr -d \'\n\'', returnStdout: true)
		echo "SCM Checkout: $GIT_TAG"
                if (GIT_TAG.isEmpty())
                {
                  GIT_TAG='NA'
                }
                REPO_NAME = REPO_NAME.toLowerCase()
              
                }
             }
          }

        /*stage('Unit Testing') {
           agent {
               docker {
                   image 'golang'
                   args  '-u root'
                   
                 }
             }
           steps {
               sh 'go test -v ./... '
               
                 }
             }*/

        stage("Build Container Image"){
            steps {
                script {
                  echo "Git tag is = $GIT_TAG"
		  echo "Build ID is = $BUILD_ID"
                  if (env.BRANCH_NAME == 'main' || GIT_TAG != 'NA') {
                    String GIT_TAG = getVersion()
		    echo $GIT_TAG
		   /* docker.withRegistry("https://${ARTIFACTORY_REPO}", ARTIFACTORY_CREDS) {
                    dockerfile = 'Dockerfile'
                    docker_app_image = docker.build("${ARTIFACTORY_REPO}/${REPO_NAME}:$GIT_TAG", "--no-cache=true -f ${dockerfile} .")       
		  
                    }
		  */
                  }
                  else
                  {
                    echo "Build Container Image: No main branch or any tag found"
                  }
                  }
                }
               }

 /*       stage("Push image to artifactory ") {
          steps{
            script {
                    artifactory_server = Artifactory.server('us-artifactory') 
                    artifactory_docker = Artifactory.docker(server: artifactory_server)
                    build_info = Artifactory.newBuildInfo()

                    if (env.BRANCH_NAME == 'main' || GIT_TAG != 'NA') {
                      String GIT_TAG = getVersion()
                      build_info = artifactory_docker.push("${ARTIFACTORY_REPO}/${REPO_NAME}:$GIT_TAG", 'rbi-docker')
                    } 
                    else {
                      echo "Push image to artifactory: No main branch or any tag found"
                    }
                    build_info.env.capture = true
                    artifactory_server.publishBuildInfo(build_info)
                 }
             }
         }

        stage("X-ray Scan"){
          steps{
            script{
                    if (build_info != null) {
                      scan_config = [
                     'buildName'   : build_info.name,
                     'buildNumber' : build_info.number,
                     'failBuild'   : true
                     ]

                //scanResult = artifactory_server.xrayScan scan_config // Srikant
                //print scanResult // Srikant
              }
            }
          }
         }
*/

         /*stage("Security Vulnerability scan"){
             environment {
                 ORGANIZATION_NAME = "RBI"
                }

             steps {
                 globalSecurityVulnerabilityScanner(organization:"${ORGANIZATION_NAME}", repository:"${REPO_NAME}", reportFormat:"yaml", reportFileName:"${REPO_NAME}-report")

              }
          }*/

/*      stage("static Analysis"){
          environment {
            scanner_home = tool 'SonarQube Scanner'
            SONAR_KEY = credentials('sonarqube-jenkins')
            
          }

          steps{
             withSonarQubeEnv('sonarqube-ent'){
                sh '${scanner_home}/bin/sonar-scanner -Dsonar.host.url=https://sonarqube-ent.cicd.cloud.fpdev.io -Dsonar.login=$SONAR_KEY'
              }
               
          }
      }

      stage("Quality Gate"){
          steps{
            timeout(time: 30, unit: 'MINUTES'){
              waitForQualityGate abortPipeline: true
             }
         
          }
      }
*/
      stage("Helm"){
         /*agent {
            
	     docker {
                image 'alpine/helm:3.5.4'
                args '-u root -i --entrypoint='

               }
             }
          environment {
            HELM_REPO_URL = "https://us-artifactory.cicd.cloud.fpdev.io/artifactory/rbi-helm"
          }*/
         steps {
           script {
             if (env.BRANCH_NAME == 'main' || GIT_TAG != 'NA') {
             String GIT_TAG = getVersion()
		echo "inside helm stage: $GIT_TAG"
            /*withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId: 'helm-creds', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD']]) {                          
              sh  "helm repo add rbi-helm ${HELM_REPO_URL} --username ${env.USERNAME} --password ${env.PASSWORD}"
              sh  "sed \"s/latest/${GIT_TAG}/g\" ./chart/values.yaml -i"
              sh  "helm dependency ./chart update"
              sh  "helm package  ./chart --version ${GIT_TAG}"
              sh  "apk add curl"
              sh  "curl -H \"X-JFrog-Art-Api:${env.PASSWORD}\" -T isla-${REPO_NAME}-${GIT_TAG}.tgz \"${HELM_REPO_URL}/isla-${REPO_NAME}-${GIT_TAG}.tgz\""
		}
		*/
            }
            else {
              echo "Helm: No main branch or any tag found"
            }
                    }
              }
              
           }
  
 }

   post {

     success {
        echo 'Build succeeded.'
      }

      unsuccessful {
        echo 'Build failed.'
      }        
  
    }

}


def getVersion() {
	int year = Calendar.getInstance().get(Calendar.YEAR);
        int month = (Calendar.getInstance().get(Calendar.MONTH) + 1);
	String sMonth
	String sYear = String.valueOf(year)
	String version
	int buildno = env.BUILD_ID
	if (month < 10) {
	    String s = String.valueOf(month);
	    sMonth = '0' + s;
	}
	else {
	    sMonth = String.valueOf(month);
	}

	version = sYear + '.' + sMonth + '.' + buildno
	return version
}
