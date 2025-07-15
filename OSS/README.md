# Summary of scrips

## ListFileExtensions.java

    #Obtain the list of extensions,the related files and the group number.
    java ListFileExtensions <path/To/Prosis>

    #Obtain the summary of the extensions found in the project
    java ListFileExtensions <path/To/Prosis> summary

    #Obtain the list we got from `summary` but divided in non-text and text base files
    #The code contains a list of knownTextExtensions since some files contains non standard MIME types.
    java ListFileExtensions <path/To/Prosis> summary  text-only




