FROM openjdk:17-oracle                                #base iamge 설치
ARG JAR_FILE_PATH=./target/*.jar                      #.jar파일 경로 변수 지정
COPY ${JAR_FILE_PATH} spring-petclinic.jar            #해당경로의 파일의 이름을 변경
EXPOSE 8080                                           #포트 열기
ENTRYPOINT ["java", "-jar", "spring-petclinic.jar"]
