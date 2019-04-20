pipeline {
  agent {
    kubernetes {
      label 'mypod'
      defaultContainer 'jnlp'
      yaml """
apiVersion: v1
kind: Pod
metadata:
  labels:
    some-label: some-label-value
spec:
  containers:
  - name: python
    image: python
    command:
    - cat
    tty: true
  - name: zip
    image: kramos/alpine-zip
    command:
    - cat
    tty: true
  - name: terraform
    image: hashicorp/terraform
    command:
    - cat
    tty: true
"""
    }
  }

  environment {
    SVC_ACCOUNT_KEY = credentials('terraform-auth')
  }

  stages {

    stage('Clone repo') {
      steps {
      checkout([$class: 'GitSCM', branches: [[name: '*/test1']],
        userRemoteConfigs: [[url: 'https://github.com/olehdevops/demo3.git']]])
      }
    }
    stage("python"){
      steps {
      container("python"){
        sh "python --version"
          sh "python unit-test.py"
        }
      }
    }

    stage("zip"){
      steps {
      container('zip'){

        sh "zip -v"
        sh "zip -j app.zip main.py requirements.txt"
        }
      }
    }

    stage('Checkout') {
      steps {
        checkout scm
        sh 'mkdir -p keys'
        sh 'echo $SVC_ACCOUNT_KEY | base64 -d > ./keys/gcp-key.json'
      }
    }


    stage("TF plan"){
      steps {
      container('terraform'){

        sh "terraform version"
        sh "terraform init"
        sh "terraform plan -out myplan"
        
        }
      }
    }
    stage("TF Apply") {
      steps {
        container("terraform") {
          sh "terraform apply -input=false myplan"
        }
      }
    }
  }
}
