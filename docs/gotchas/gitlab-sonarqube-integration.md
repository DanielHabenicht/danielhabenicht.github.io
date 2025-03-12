# Integrating Sonarqube and Gitlab

Simply running the sonar-scanner cli is quite easy but adding advanced features like Code Quality Widgets or Inline MR Comments can be quite a hassle. 
After a few to many hours trying to get it running this is the config I ended up with: 

```yml
sonarqube-check-master:
  stage: test
  rules:
    - if: $CI_COMMIT_BRANCH == $CI_DEFAULT_BRANCH
      when: always
    - when: never
  variables:
    SONAR_TOKEN: ${SONAR_TOKEN}
    SONAR_USER_HOME: '${CI_PROJECT_DIR}/.sonar' # Defines the location of the analysis task cache
    GIT_DEPTH: '0' # Tells git to fetch all the branches of the project, required by the analysis task
  image:
    name: sonarsource/sonar-scanner-cli:latest
    entrypoint: ['']
  cache:
    key: '${CI_JOB_NAME}'
    paths:
      - .sonar/cache
  script:
    # Uses this plugin: https://github.com/javamachr/sonar-gitlab-plugin
    # The token has to be provided again as the plugin does not respect the environment variable
    - sonar-scanner -X
      -Dsonar.login=${SONAR_TOKEN}
      -Dsonar.gitlab.json_mode=CODECLIMATE
      -Dsonar.gitlab.url=https://gitlab.de/
      -Dsonar.gitlab.commit_sha=${CI_COMMIT_SHA}
      -Dsonar.gitlab.project_id=${CI_PROJECT_ID}
      -Dsonar.gitlab.ref_name=${CI_COMMIT_REF_NAME}
      -Dsonar.gitlab.user_token=${SONAR_DISCUSSION_TOKEN}
      -Dsonar.gitlab.failure_notification_mode=exit-status
      -Dsonar.gitlab.all_issues=true
  artifacts:
    paths:
      - gl-code-quality-report.json
    reports:
      codequality: gl-code-quality-report.json

sonarqube-check:
  stage: test
  rules:
    - if: $CI_PIPELINE_SOURCE == 'merge_request_event'
      when: always
    - when: never
  variables:
    SONAR_TOKEN: ${SONAR_TOKEN}
    SONAR_USER_HOME: '${CI_PROJECT_DIR}/.sonar' # Defines the location of the analysis task cache
    GIT_DEPTH: '0' # Tells git to fetch all the branches of the project, required by the analysis task
  image:
    name: sonarsource/sonar-scanner-cli:latest
    entrypoint: ['']
  cache:
    key: '${CI_JOB_NAME}'
    paths:
      - .sonar/cache
  script:
    # Uses this plugin: https://github.com/javamachr/sonar-gitlab-plugin
    # The token has to be provided again as the plugin does not respect the environment variable
    - sonar-scanner -X
      -Dsonar.login=${SONAR_TOKEN}
      -Dsonar.gitlab.ci_merge_request_iid=$CI_MERGE_REQUEST_IID
      -Dsonar.gitlab.merge_request_discussion=true
      -Dsonar.gitlab.all_issues=true
      -Dsonar.gitlab.json_mode=CODECLIMATE
      -Dsonar.gitlab.url=https://gitlab.de/
      -Dsonar.gitlab.commit_sha=${CI_COMMIT_SHA}
      -Dsonar.gitlab.project_id=${CI_PROJECT_ID}
      -Dsonar.gitlab.ref_name=${CI_COMMIT_REF_NAME}
      -Dsonar.gitlab.user_token=${SONAR_DISCUSSION_TOKEN}
      -Dsonar.gitlab.failure_notification_mode=commit-status
  artifacts:
    paths:
      - gl-code-quality-report.json
    reports:
      codequality: gl-code-quality-report.json

```


Using Sonarqube CE 9.9.4 (build 87374) and the plugins [`sonar-gitlab-plugin`](https://github.com/javamachr/sonar-gitlab-plugin) 5.4.0 and [`sonarqube-community-branch-plugin`](https://github.com/mc1arke/sonarqube-community-branch-plugin) 1.14.0. 

You can get the plugins installed from `https://your-instance.de/api/plugins/installed`. 
