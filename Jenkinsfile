node('build') {
   stage('SCM') {
    git 'https://github.com/NareshAbbanapuri/game-of-life.git'
}
stage('build') {
        sh label: '', script: 'mvn clean package'
}
stage('CodeQuality'){
    
    // performing sonarqube analysis with "withSonarQubeENV(<Name of Server configured in Jenkins>)"
    withSonarQubeEnv('sonarqube') {
      // requires SonarQube Scanner for Maven 3.2+
      sh 'mvn org.sonarsource.scanner.maven:sonar-maven-plugin:3.2:sonar'
    }

}
stage('artifactory'){
    withCredentials([usernamePassword(credentialsId: 'jfrog', usernameVariable: 'dockerHubUser', passwordVariable: "dockerHubPassword")]) {
      sh "curl -u${env.dockerHubUser}:${env.dockerHubPassword}    -T /home/maven/workspace/nightbuild-pipeline/gameoflife-web/target/gameoflife${BUILD_NUMBER}.war http://35.164.244.170:8082/artifactory/new/gameoflife${BUILD_NUMBER}.war"
		}

}
}
node('docker'){
   stage('scm-dockerfile') {
    git 'https://github.com/NareshAbbanapuri/practice.git'
}
 stage('build-image') {
     sh "docker image build --build-arg url=http://35.164.244.170:8082/artifactory/new/gameoflife${BUILD_NUMBER}.war -t cicd:1.0 ."
 }
 stage('push'){
    sh label: '', script: '''docker login -u abbanapurinaresh -p 9989435354
 docker tag cicd:1.0 abbanapurinaresh/k8s:${BUILD_NUMBER}
docker push  abbanapurinaresh/k8s:cicd'''     
 }
}
node('kubectl'){
    stage('scm-manifest'){
        git 'https://github.com/NareshAbbanapuri/practice.git'
    }
    stage('deploy'){
        sh label: '', script: '''kubectl apply -f Deploy.yaml
        kubectl apply -f service.yaml'''
    }
}
