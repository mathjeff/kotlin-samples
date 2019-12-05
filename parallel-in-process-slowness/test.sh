#!/bin/bash
set -e

function runTest() {
  numProjects="$1"
  daemonMode="$2"
  echo
  echo Timing building $numProjects projects with compiler execution strategy $daemonMode
  echo "org.gradle.jvmargs=-Dkotlin.compiler.execution.strategy=\"$daemonMode\"" > gradle.properties
  ./gen-projects.sh $numProjects
  time ./gradlew compileKotlin --rerun-tasks
}

runTest 30 "daemon"
runTest 30 "daemon"
runTest 30 "in-process"
runTest 30 "in-process"
