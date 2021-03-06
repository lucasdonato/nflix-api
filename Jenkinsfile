//configurações de cores para as notificações slack
def COLOR_MAP = ['SUCCESS': 'good', 'FAILURE': 'danger', 'UNSTABLE': 'danger', 'ABORTED': 'danger']

pipeline {
    agent {
        docker {
            image "ruby:alpine"
            args "--network=skynet"
        }      
    }
    stages {
        stage("Build") {
            steps {
                sh "chmod +x build/alpine.sh"
                sh "./build/alpine.sh"
                sh "gem install bundler -v 2.0.2"
                sh "bundle install"
                sh "bundle update"
            }
        }
        stage("Tests") {
            steps {
                //mensagem disparada antes da execução dos testes..
                slackSend channel: "#automacao-de-testes",
                        color: 'good',
                        message: " Iniciando execucao do testes..\n Job ${env.JOB_NAME} build ${env.BUILD_NUMBER}"
                sh "bundle exec rspec"
            }
            post {
                always {           
                    junit 'log/report.xml'       
                    //configurações do slack
                    slackSend channel: "#automacao-de-testes",
                        color: COLOR_MAP[currentBuild.currentResult],
                        message: "*${currentBuild.currentResult}:* Job ${env.JOB_NAME} build ${env.BUILD_NUMBER}\n Mais informacoes acesse: ${env.BUILD_URL}"

                        //envio de email com report
                        emailext attachLog: true, attachmentsPattern: 'log/report.html', body: 'Relatório final jenkins', replyTo: 'lucaspolimig96@gmail.com', subject: 'Execução Testes Jenkins', to: 'lucaspolimig96@gmail.com'    
                }
            }
        }
        stage('Sonarqube') {
            environment {
                scannerHome = tool 'SonarQubeScanner'
            }
            steps {
                withSonarQubeEnv('sonarqube') {
                    sh "${scannerHome}/bin/sonar-scanner"
                }
                timeout(time: 10, unit: 'MINUTES') {
                    waitForQualityGate abortPipeline: true
                }
            }
        }
    }
}