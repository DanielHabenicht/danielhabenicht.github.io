# Automatic Version Comments on Gitlab PR

Features:
- Only one comment on multiple runs
- Combined with python-semantic-release it shows the next version. 

```
pr-title-check:
  stage: test
  image: python:3.11
  variables:
    GIT_DEPTH: 0
    # gitlab variable that contains a project token with reporter api access
    BOT_TOKEN: $GITLAB_DISCUSSION_TOKEN
    BOT_NAME: pr_comments
    DISCUSSION_API: ${CI_API_V4_URL}/projects/${CI_PROJECT_ID}/merge_requests/${CI_MERGE_REQUEST_IID}/notes
    # Try it out locally with IFS='' read -r -d '' MESSAGE_BODY <<"EOF" <string> EOF
    MESSAGE_BODY: |-
      We are following the [Conventional Commit Format](https://www.conventionalcommits.org/en/v1.0.0/#summary). Please make sure that your Pull Request title ('${CI_MERGE_REQUEST_TITLE}') conforms to this format, otherwise, it might not be released. Here is a short example: 
      ```
      fix(webapp): correct styling in cool component
      <type>[(<optional scope>)]: <description>
      ```

      These are the most used types: (you can find more [here](https://github.com/angular/angular/blob/22b96b9/CONTRIBUTING.md#type))

      | Type                              | Meaning                          | Resulting Semantic Release  |
      | :-------------------------------- |:---------------------------------|:---------------------------:|
      | `fix`                             | patches a bug                    | PATCH (v1.0.0 -> v1.0.1)    |
      | `feat`                            | introduces a new feature         | MINOR (v1.0.0 -> v1.1.0)    |
      | `chore`, `ci`, `refactor`, `test` | other non releasing code changes | NONE  (v1.0.0 -> v1.0.0)    |

      If the user has to do things different than before (excluding new functionality) add a `!` at the end of the type (e.g. `chore!: removing legacy api`). This will trigger a major release (v1.0.0 -> v2.0.0)

      > Note: you might have to push a commit for this check to reevaluate.
  before_script:
    - apt-get update
    - apt-get install jq -y
  script:
    - |
      echo -e "Linting merge request title: ${CI_MERGE_REQUEST_TITLE}"
      # Agreed MR title pattern
      export PATTERN="^(feat: | feat!: |fix: |fix!: |chore: |chore!: |ci: | refactor: |test: |build: | docs: |perf: |style: |revert: )(.+)$"

      #Do not lint if prefix is Draft:
      if [[ "${CI_MERGE_REQUEST_TITLE}" == Draft:* ]]; then
        echo -e "Draft merge request detected, skipping mr-title-lint."
        exit 0
      fi

      # Check if the merge request title matches the pattern
      echo "${DISCUSSION_API}"
      curl --fail --request GET "${DISCUSSION_API}?sort=asc" --header "PRIVATE-TOKEN: $BOT_TOKEN" > notes.json
      export NOTE_ID=$(cat notes.json | jq --arg BOT_NAME "${BOT_NAME}" -c 'first(.[] | select(.author.name | contains("\($BOT_NAME)"))) | .id')

echo -e "NOTE_ID=${NOTE_ID}"
      export MATCH=$(echo "${CI_MERGE_REQUEST_TITLE}" | grep -E "$PATTERN")
      echo "Match: ${MATCH}"
      if [ -z "${MATCH}" ]; then
        echo -e "Merge request title '${CI_MERGE_REQUEST_TITLE}' does not match the agreed format."
        if [ -z "${NOTE_ID}" ]; then
          echo "Creating Comment"
          curl --fail --request POST "${DISCUSSION_API}" --header "PRIVATE-TOKEN: $BOT_TOKEN" --header "Content-Type: application/json" --data-raw "{ \"body\": $(echo "$MESSAGE_BODY" | jq -sR .) }"
        else
          echo "Updating Comment"
          curl --fail --request PUT "${DISCUSSION_API}/${NOTE_ID}" --header "PRIVATE-TOKEN: $BOT_TOKEN" --header "Content-Type: application/json" --data-raw "{ \"body\": $(echo "$MESSAGE_BODY" | jq -sR .) }"
        fi
        exit 1
      fi
      
      git checkout "$CI_MERGE_REQUEST_TARGET_BRANCH_NAME"
      git config --global user.email "you@example.com"
      git config --global user.name "Your Name"
      git commit --allow-empty -m "${CI_MERGE_REQUEST_TITLE}"
      pip install python-semantic-release==9.21.0
      export PREVIOUS_VERSION=$(semantic-release -c semantic-release.toml version --print-last-released)
      export NEXT_VERSION=$(semantic-release -c semantic-release.toml version --print)

      if [ -z "${NEXT_VERSION}" ] || [ "${NEXT_VERSION}" = "${PREVIOUS_VERSION}" ]; then
        export MESSAGE_BODY="Merging this PR will not induce a version change."
      else
        export MESSAGE_BODY="Merging this PR will induce a version change: \`${PREVIOUS_VERSION}\` -> \`${NEXT_VERSION}\`"
      fi

      if [ -z "${NOTE_ID}" ]; then
          echo "Creating version comment"
          curl --fail --request POST "${DISCUSSION_API}" --header "PRIVATE-TOKEN: $BOT_TOKEN" --header "Content-Type: application/json" --data-raw "{ \"body\": \"$MESSAGE_BODY\" }"
      else
          echo "Updating version comment"
          curl --fail --request PUT "${DISCUSSION_API}/${NOTE_ID}" --header "PRIVATE-TOKEN: $BOT_TOKEN" --header "Content-Type: application/json" --data-raw "{ \"body\": \"$MESSAGE_BODY\" }"
      fi

      echo -e "Merge request title pattern check passed."
  rules:
    - if: $DEVELOPMENT != "true"
      when: never
    - if: $CI_PIPELINE_SOURCE == "merge_request_event"
```
