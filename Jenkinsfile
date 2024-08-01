pipeline { 
         agent any
           environment {
        jenkins_server_url = "http://192.168.5.150:8080"
        notification_channel = 'devops'
        slack_url = 'https://hooks.slack.com/services/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'
        deploymentName = "to-do-application"
    containerName = "to-do-application"
    serviceName = "to-do-application"
    imageName = "harbor.cluster.com/to-do-application/$JOB_NAME:v1.$BUILD_ID"
     applicationURL="http://192.168.5.60"
    //applicationURI="epps-smartERP/" 		   
		   
        
    }
         
    
    
    stages { 
        stage('Build Checkout') { 
            steps { 
              checkout([$class: 'GitSCM', branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/ckmine11/to-do-application.git']]])
         }
        }
        
          
              
      
              stage ('Vulnerability Scan - Docker ') {
              steps {
                  
                 parallel   (
	 	  "Trivy Scan":{
	 		    sh "bash trivy-docker-image-scan.sh"
		     	},
		   "OPA Conftest":{
			sh 'docker run --rm -v $(pwd):/project openpolicyagent/conftest test --policy opa-docker-security.rego Dockerfile'
		    }   	
		             	
   	                      )
                    
              }
               }
              
           
              stage(' Give Permission  to File '){
                steps {
                   
                  sh 'chmod -R 777 /var/lib/jenkins/workspace/to-do-application/Dockerfile'
                  sh 'chmod -R 777 /var/lib/jenkins/workspace/to-do-application/shell.sh'
		//  sh 'chmod -R 777 /var/lib/jenkins/workspace/to-do-application/zap.sh'
                  sh 'chown jenkins:jenkins  /var/lib/jenkins/workspace/to-do-application/trivy-docker-image-scan.sh'                
                 
                                     }
                       }
                       
                     //  stage ("Slack-Notify"){
                    //     steps {
                    //        slackSend channel: 'devops-pipeline', message: 'deployment successfully'
                   //      }
                   //    }

    stage ('Regitsry Approve') {
      steps {
      echo "Taking approval from DEV Manager forRegistry Push"
        timeout(time: 7, unit: 'DAYS') {
        input message: 'Do you want to deploy?', submitter: 'admin'
        }
      }
    }

 // Building Docker images
    stage('Building image | Upload to Harbor Repo') {
      steps{
            sh '/var/lib/jenkins/workspace/to-do-application/shell.sh'  
    }
      
    }
    
    stage('Vulnerability Scan - Kubernetes') {
       steps {
         parallel(
           "OPA Scan": {
             sh 'docker run --rm -v $(pwd):/project openpolicyagent/conftest test --policy opa-k8s-security.rego blue.yml'
         },
          "Kubesec Scan": {
            sh "bash kubesec-scan.sh"
          },
           "Trivy Scan": {
             sh "bash trivy-k8s-scan.sh"
           }
        )
      }
    }
	stage('K8S Deployment - DEV') {
       steps {
         parallel(
          "Deployment": {
            withKubeConfig([credentialsId: 'kubeconfig']) {
              sh "bash k8s-deployment.sh"
	  
             }
           },
         "Rollout Status": {
            withKubeConfig([credentialsId: 'kubeconfig']) {
             sh "bash k8s-deployment-rollout-status.sh"
             }
           }
        )
       }
     }
	  
	    
	   stage('Integration Tests - DEV') {
         steps {
         script {
          try {
            withKubeConfig([credentialsId: 'kubeconfig']) {
               sh "bash integration-test.sh"
             }
            } catch (e) {
             withKubeConfig([credentialsId: 'kubeconfig']) {
               sh "kubectl -n default rollout undo deploy ${deploymentName}"
             }
             throw e
           }
         }
       }
     }  
	    
	
	  
	    
     
}

			 
    }
