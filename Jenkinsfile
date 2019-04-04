#!/usr/bin/env groovy
//vim: set ts=2 sts=2 sw=2 noexpandtab

pipeline {

  agent {
    node {
        label 'docker'
      }
  }

  environment {
    CALCULATED_DOCKER_TAG = "${BRANCH_NAME}_${BUILD_NUMBER}".replace('/','_')
  }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }
    stage('Build Image and run tests'){
      steps {
        script {
            docker.withRegistry(
              'https://medneo-docker.jfrog.io',
              'jfrogDockerRegistryCredentials',
              {
                app = docker.build('acme:' + env.CALCULATED_DOCKER_TAG)
              }
            )
        }
      }
    }
    stage('Publish'){
      steps {
        script {
          docker.withRegistry(
                'https://medneo-docker.jfrog.io',
                'jfrogDockerRegistryCredentials',
                {
                  //first push with our dedicated build tag
                  app.push()
                  //which branch should trigger a push as latest..
                  if((env.BRANCH_NAME == 'develop')){
                    //now push as latest directly after (should not be problematic, as all layers are already pushed to the registry)
                    app.push('latest')
                  }
                }
          )
        }
      }
    }
    stage('Release'){
      when {
        tag "release-*";
      }
      steps {
        script {
          docker.withRegistry(
                'https://medneo-docker.jfrog.io',
                'jfrogDockerRegistryCredentials',
                {
                  app.push(env.TAG_NAME.substring(8))
                }
          )
        }
      }
    }
  }
}

