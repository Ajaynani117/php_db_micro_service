pipeline{    
    agent any
    environment {
        IMAGE_NAME = 'ajaynani117/test:php$BUILD_NUMBER'
        DEV_SERVER = 'ec2-user@54.86.19.100'
        TEST_SERVER = 'ec2-user@3.87.197.139'
    }

    stages {
        stage('Build the docker image for php and push to docker hub') {

            steps {
                script {
                    sshagent(['DEV_SERVER'])  {
                    withCredentials([usernamePassword(credentialsId: 'docker-hub', passwordVariable: 'PASSWORD', usernameVariable: 'USERNAME')]) 
                        echo 'Building the docker image...'
                        sh "scp -o StrictHostKeyChecking=no -r  devserverconfig ${DEV_SERVER}:/home/ec2-user"
                        sh "ssh -o StrictHostKeyChecking=no  ${DEV_SERVER}'bash ~/devserverconfig/docker-script.sh'" 
                        sh "ssh ${DEV_SERVER}sudo  docker build -t ${IMAGE_NAME} /home/ec2-user/devserverconfig"   
                        sh "ssh ${DEV_SERVER}sudo docker login -u $USERNAME -p $PASSWORD"
                        sh "ssh ${DEV_SERVER}sudo docker push ${IMAGE_NAME}"
                    }
                  
                    }
                }
            }

        stage('run the php_db app on test server') {
        
            steps{
                script {
                    sshagent(['TEST_SERVER']){
                        withCredentials([usernamePassword(credentialsId: 'docker-hub', passwordVariable: 'PASSWORD', usernameVariable: 'USERNAME')]){
                        echo 'Run the docker image...'
                        sh "scp -o StrictHostKeyChecking=no -r  testserverconfig ${TEST_SERVER}:/home/ec2-user"
                        sh "ssh -o StrictHostKeyChecking=no  ${TEST_SERVER}'bash ~/testserverconfig/docker-script.sh'"  
                        sh "ssh ${TEST_SERVER}sudo docker login -u $USERNAME -p $PASSWORD"
                        sh "ssh ${TEST_SERVER}bash /home/ec2-user/testserverconfig/compose-script.sh ${IMAGE_NAME}"
                    
                    }
                  
                    }
                }
            }
        }
    }
}
       
    
