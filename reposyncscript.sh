#!/bin/bash
for OUTPUT in $(yum repolist | awk '{print $1}')
do
	case $OUTPUT in
	  Loaded)
	    echo "Skipping"
	    ;;
	  Loading)
	    echo "Skipping"
	    ;;
	  repo)
	    echo "Skipping"
	    ;;
	  repolist)
	    echo "Ending"
	    end
	    ;;
	  *)
	    reposync -l --repoid=$OUTPUT --download_path=/home/repos/ --newest-only --downloadcomps --download-metadata
	    ;;
	esac
done
