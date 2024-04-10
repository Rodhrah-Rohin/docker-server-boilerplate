# Changelog-SERVER_NAME
This file logs all the repo wide manual changes(Major and Minor) made through time

**Change format**
```
type(Impact): summary
```
Here type can be feature, fix, doc, upgrade, removal, refactor

The impact can be <DomainName>, impacted area in the server, 

## Date - (DD/MM/YYYY)

- changes made 

## CHANGELOG ⏳

### Date - (03/04/2024)
 - reformat(all): Updated the structure and working of the repo
 - docs(readme): Updated the readme and other documentation files to better help a begginer as well, so that they can maintain a secure and robust env

### Date - (11/04/2024)
 - feature(compose): Added a script to help create stack level env files that can be used with docker to securely deploy apps
 - feature(vscode): Added settings config to .vscode to let user distinguish local and server folder(peacock wont show the folder color in a multi repo workspace)
 - refactor(scripts): Moved the scope based scripts to run in the main ./run.sh file
 - refactor(Services): Removed unwanted files from scopes
 - docs(github): Updated the Readme and pull request template to match
 - files(logs): Added .empty to logs in scoped folder
