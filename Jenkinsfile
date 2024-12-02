pipeline {
  agent any
  // JAVA와 Maven Tool 등록
  tools {
    jdk 'jdk17'
    maven 'M3'
  }

  stages {
    // Github에서 Jenkins 소스코드 복사
    stage('Git Clone') {
      steps {
        git url: 'https://github.com/raylin048/spring-petclinic.git', branch: 'main'
      }
    }
    // 빌드 할 때 test 실패로 뜨는 내용은 생략처리 및 제거 후 패키지화
    stage('Maven Build') {
      steps {
        sh 'mvn -Dmaven.test.failure.ignore=true clean package'
      }
    }
    // stage('Docker Image') {
    //   steps {
        
    //   }
    // }
    // // 
    // stage('Docker Image Push') {
    //   steps {
        
    //   }
    // }
    // // target 컴퓨터로 명령어 날리는 단계
    // stage('SSH Publish') {
    //   steps {
        
    //   }
    // }
  }
}
