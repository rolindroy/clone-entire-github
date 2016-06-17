#!/bin/bash

githubBaseUrl="https://github.com";
repoUrl="narezchand";
tempLocation=`pwd`/temp;
tempFile="data"
echo "INFO:: Checking temporary files."
if [ ! -d $tempLocation ]
	then
	mkdir $tempLocation;
	mkdir "repositories";
else
	rm $tempLocation/*;
fi

curlClient=`which curl`
	if [[ $curlClient = "" ]] 
		then
		echo "ERROR:: curlClient not found.";
	else
		echo $githubBaseUrl"/"$repoUrl"?tab=repositories";
		curl $githubBaseUrl"/"$repoUrl"?tab=repositories" > $tempLocation/$tempFile;
		sed -n '/codeRepository">/,/<\/a>/p' $tempLocation/$tempFile |  sed -e 's/<\/a>$//g;/">/d;s/ //g' > $tempLocation"/repoList";
		
		if [ ! -d "repositories"/$repoUrl ]
			then
			mkdir "repositories"/$repoUrl;
		fi
		
		gitClient=`which git`;
		if [[ $gitClient = "" ]]
			then
			echo "ERROR:: Git Client not found";
			exit 0;
		fi
		cd $(pwd)/"repositories"/$repoUrl;
		while IFS= read -r repo
		do
			echo "$repo";
			if [ ! -d $repo ]
				then
				echo $(pwd);
				echo "svn co $githubBaseUrl/$repoUrl/$repo.git"
				#git clone $githubBaseUrl/$repoUrl/$repo.git;
			else
				git pull $githubBaseUrl/$repoUrl/$repo.git; 
			fi 
		done < "$tempLocation/repoList" 

	fi
