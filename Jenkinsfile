pipeline {
  agent any
  // JAVA와 Maven Tool 등록
  tools {
    jdk 'JDK17'
    maven 'M3'
  }

  // DockerHub 접속 정보
  environment {
    DOCKERHUB_CREDENTIALS = credentials('dockerCredential')
    AWS_CREDENTIALS_NAME = credentials('AWSCredential')
    GIT_CREDENTIALS = credentials('gitCredential')
    REGION = 'ap-northeast-2'
  }

  stages {
    // Github에서 Jenkins 소스코드 복사하여 가져오기
    stage('Git Clone') {
      steps {
        echo 'Git Clone'
        git url: 'https://github.com/raylin048/spring-petclinic.git',
          branch: 'main', credentialsId: 'GIT_CREDENTIALS'
      }
    }
    // Maven 빌드 할 때 test 실패로 뜨는 내용은 생략처리 및 제거 후 패키지화
    stage('Maven Build') {
      steps {
        echo 'Maven Build'
        sh 'mvn -Dmaven.test.failure.ignore=true clean package'
      }
    }
    // Docker Iamge 생성
    stage('Docker Image Build') {
      steps {
        // 환경변수로 특정 디렉토리 지정하여 여기에서만 작업하라는 의미
        echo 'Docker Image build'
        dir("${env.WORKSPACE}") {
          sh """
          docker build -t raylin048/spring-petclinic:$BUILD_NUMBER .
          docker tag raylin048/spring-petclinic:$BUILD_NUMBER raylin048/spring-petclinic:latest
          """
        }
      }
    }
    // DockerHub login
    stage('Docker Login') {
      steps {
        sh """
        echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin
        docker push raylin048/spring-petclinic:latest
        """
      }
    }
    // Docker Image 삭제
    stage('Remove Docker Image') {
      steps {
        sh """
        docker rmi raylin048/spring-petclinic:$BUILD_NUMBER
        docker rmi raylin048/spring-petclinic:latest
        """
      }
    }
    // S3에 Appspec.yml과 실행 스키립트 저장
    stage('Upload to S3') {
      steps {
        echo "Upload to S3"
        dir("${env.WORKSPACE}") {
          sh 'zip -r deploy.zip ./deploy appspec.yml'
          withAWS(region:"${REGION}", credentials:"${AWS_CREDENTIALS_NAME}") {
            s3Upload(file:"deploy.zip", bucket:"user09-codedeploy-bucket")
          } 
          sh 'rm -rf ./deploy.zip'                 
        }        
      }
    }
    // // Code Deploy 실행
    // stage('Codedeploy Workload') {
    //   steps {
    //     echo "create Codedeploy group"   
    //     sh '''
    //     aws deploy create-deployment-group \
    //     --application-name user00-code-deploy \
    //     --auto-scaling-groups user00-asg \
    //     --deployment-group-name user00-code-deploy-${BUILD_NUMBER} \
    //     --deployment-config-name CodeDeployDefault.OneAtATime \
    //     --service-role-arn arn:aws:iam::257307634175:role/user00-codedeploy-service-role
    //     '''
    //     echo "Codedeploy Workload"   
    //     sh '''
    //     aws deploy create-deployment --application-name user00-code-deploy \
    //     --deployment-config-name CodeDeployDefault.OneAtATime \
    //     --deployment-group-name user00-code-deploy-${BUILD_NUMBER} \
    //     --s3-location bucket=user00-codedeploy-bucket,bundleType=zip,key=deploy.zip
    //     '''
    //     sleep(10) // sleep 10s
    //   }
    // }
  }
}

