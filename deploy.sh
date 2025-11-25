#!/usr/bin/env bash
set -euo pipefail

read -p "enter remote url: " REM_URL
read -p "enter remote repository id: " REPO_ID
PARAM_ARR=("-Durl="$REM_URL"" "-DrepositoryId="$REPO_ID"")

read -p "enter local scanned repository : " LOC_REPO

cd $LOC_REPO
find ./ -name "*.pom" |while read -r POM; do
	REAL_PARAM_ARR=("${PARAM_ARR[@]}" -DpomFile="$POM")
	JAR="${POM%pom}jar"
	if [[ ! -f "$JAR" ]]; then
		REAL_PARAM_ARR+=(-Dfile="$POM" -Dpackaging=pom -DupdateReleaseInfo=true)
	else
		REAL_PARAM_ARR+=(-Dfile="$JAR")
	fi

	mvn deploy:deploy-file "${REAL_PARAM_ARR[@]}"
done
