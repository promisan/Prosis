# Summary of scrips

## ListFileExtensions.java

    #Obtain the list of extensions,the related files and the group number.
    java ListFileExtensions <path/To/Prosis>

    #Obtain the summary of the extensions found in the project
    java ListFileExtensions <path/To/Prosis> summary

    #Obtain the list we got from `summary` but divided in non-text and text base files
    #The code contains a list of knownTextExtensions since some files contains non standard MIME types.
    java ListFileExtensions <path/To/Prosis> summary  text-only


## Apply license to text-base files

The migration uses the `license-maven-plugin` to include Apache license headers recursively to all supported text-base files including and 
excluding custom extensions configured in the root project `pom.xml` file with the help of custom header definition when required via file `custom-headers.xml`: 

<details>
  <summary>Click to expand "includes" section </summary>

```xml
<includes>
    <!-- Files without standard extensions -->
    <include>**/csslintrc</include>
    <include>**/jshintrc</include>

    <!-- CFM and special CFM files -->
    <include>**/*.cfm</include>
    <include>**/*.05152010cfm</include>
    <include>**/*.2010-03cfm</include>
    <include>**/*.backcfm</include>
    <include>**/*.cfm06162008</include>
    <include>**/*.cfm_01_27_2010</include>
    <include>**/*.cfmold</include>
    <include>**/*.copycfm</include>
    <include>**/*.newcfm</include>
    <include>**/*.cfc</include>

    <!-- Standard web files -->
    <include>**/*.css</include>
    <include>**/*.ejs</include>
    <include>**/*.htm</include>
    <include>**/*.html</include>
    <include>**/*.java</include>
    <include>**/*.jnlp</include>
    <include>**/*.js</include>
    <include>**/*.json</include>
    <include>**/*.less</include>
    <include>**/*.php</include>
    <include>**/*.scss</include>
    <include>**/*.svg</include>
    <include>**/*.ts</include>
    <include>**/*.xml</include>
    <include>**/*.yml</include>

    <!-- Documentation files -->
    <include>**/*.markdown</include>
    <include>**/*.md</include>
    <include>**/*.mdown</include>

    <!-- Text and config files -->
    <include>**/*.csv</include>
    <include>**/*.dcl</include>
    <include>**/*.lang</include>
    <include>**/*.lock</include>
    <include>**/*.log</include>
    <include>**/*.map</include>
    <include>**/*.nuspec</include>
    <include>**/*.old</include>
    <include>**/*.org</include>
    <include>**/*.rtf</include>
    <include>**/*.sample</include>
    <include>**/*.sh</include>
    <include>**/*.tab</include>
    <include>**/*.txt</include>
    <include>**/*.txt_</include>
</includes>
```

</details>

<details>
  <summary>Click to expand "excludes" section </summary>

```xml
<excludes>
    <exclude>**/ValidationScript.cfm</exclude>
    <exclude>**/RecordDialog.cfm</exclude>
    <exclude>**/*.zip</exclude>
    <exclude>**/*.bin</exclude>
    <exclude>**/*.cfr</exclude>
    <exclude>**/*.class</exclude>
    <exclude>**/*.eot</exclude>
    <exclude>**/*.fla</exclude>
    <exclude>**/*.gif</exclude>
    <exclude>**/*.ico</exclude>
    <exclude>**/*.idx</exclude>
    <exclude>**/*.jar</exclude>
    <exclude>**/*.jbf</exclude>
    <exclude>**/*.jpg</exclude>
    <exclude>**/*.GIF</exclude>
    <exclude>**/*.JPG</exclude>
    <exclude>**/*.otf</exclude>
    <exclude>**/*.pack</exclude>
    <exclude>**/*.pdf</exclude>
    <exclude>**/*.png</exclude>
    <exclude>**/*.psd</exclude>
    <exclude>**/*.rep</exclude>
    <exclude>**/*.scssc</exclude>
    <exclude>**/*.swf</exclude>
    <exclude>**/*.template</exclude>
    <exclude>**/*.ttf</exclude>
    <exclude>**/*.vsd</exclude>
    <exclude>**/*.woff</exclude>
    <exclude>**/*.woff2</exclude>
    <exclude>**/.gitattributes</exclude>
    <exclude>**/.gitignore</exclude>
  
</excludes>
```
</details>



### Check current License headers in the project
```shell
mvn clean license:check
```

### Apply License headers in the project
```shell
mvn clean license:format
```

The file `OSS/ignoredFilesAfterLicense-maven-plugin.rep` contains the list of files not
modified by `mvn clean license:format`

