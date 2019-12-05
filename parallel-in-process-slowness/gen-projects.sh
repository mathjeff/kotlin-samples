#!/bin/bash
set -e

function usage() {
  echo "Usage: $0 <numberOfProjectsToGenerate>"
  exit 1
}

numProjects="$1"
if [ "$numProjects" == "" ]; then
  usage
fi

echo "def includeProject(name, filePath) {
    settings.include(name)

    def file
    if (filePath instanceof String) {
        file = new File(filePath)
    } else {
        file = filePath
    }
    project(name).projectDir = file
}" > settings.gradle

rm children -rf
mkdir -p children

function generateProject() {
  oldName=template-project
  newName="parallelism:children:$1"
  newDir="$(echo $newName | sed 's|:|/|g' | sed 's|parallelism/||')"
  rm $newDir -rf
  mkdir -p $newDir
  cp -rT $oldName $newDir
  echo 'includeProject(":'$newName'", "'$newDir'")' >> settings.gradle
}

for i in $(seq $numProjects); do
  generateProject $i
done
