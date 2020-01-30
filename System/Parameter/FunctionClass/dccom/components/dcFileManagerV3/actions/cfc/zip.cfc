<cfcomponent displayname="webclarity zip component"
	hint="zip file utitlity using the java api">

<cfscript>
	init();
	
	/*
		zip.cfc
		
		this component utilizes existing java methods to create and extract 
		zip files from disk.  nothing is required to be installed on the mx
		server!
		
		to create a zip file with one file, it only takes 4 lines of code!
		
		to extract a zip file, it only takes 2 lines of code!
		
		
		author:  	Nate Nielsen
					nnielsen@cfgod.com
	
		license:	you are free to use this component in any application as
					long as you do not charge any money for it, and this 
					header information remains in tact.
					
					enjoy!
		
	*/
</cfscript>

<!--- call the initialization routine --->
<cffunction name="init" hint="internal.  initialize component" access="private">
	<cfscript>
		// set a bool to tell any methods called that we are still initializing
		this.initialized = false;
		
		// file entries for zip
		this.entries = arrayNew(1);
		// name of zip file 
		this.zipFile = '';
		// directory of zip file
		this.zipDirectory = '';
		// compression level
		this.compressionLevel = 9;
		
		// set a bool to tell any methods called that we have finished initializing
		this.initialized = true;
	</cfscript>
</cffunction>

<cffunction name="newZip"
	hint="call to create a new zip file, initializes variables for storing zip entries">
	<cfargument name="zipFileAndPath" required="yes" type="string"
		hint="full path and name of zip file to create.  should end with the .zip extension.">
	<cfscript>
		this.entries = arrayNew(1);
		this.zipFile = getFileFromPath(zipFileAndPath);
		this.zipDirectory = stripPath(zipFileAndPath);
	</cfscript>
</cffunction>

<cffunction name="stripPath"
	hint="internal method to get path from path and file string" 
	returntype="string" access="private">
	<cfargument name="pathAndFile" hint="the full path and file to get the directory of" required="yes" type="string">
	<cfscript>
		if(listLen(pathAndFile, '\') gt 0){
			return listDeleteAt(pathAndFile,listLen(pathAndFile, '\'), '\') & '\';
		}else{
			return listDeleteAt(pathAndFile,listLen(pathAndFile, '/'), '/') & '/';
		}
	</cfscript>
</cffunction>

<cffunction name="setCompression"
	hint="sets the level of zip compression to use">
	<cfargument name="compressionLevel"	 default="9" required="no" 
		hint="number 0 through 9 to set compression level to.  9 = maximum">
	<cfset this.compressionLevel = compressionLevel>
</cffunction>

<cffunction name="addFile">
	<cfargument name="fileAndPathToAdd" required="yes" type="string" 
		hint="full path and file name of file to add to zip.  returns a boolean if file was added">
	<cfargument name="pathToStore" required="no" type="string"
		hint="directory to store the specified file inside the zip. ex: myDirectory\directoryTwo\ will create two directories inside the zip file, and place the file in 'directoryTwo'" default="">
	<cfargument name="fileNameToStore" required="no" type="string" 
		hint="file name to store.  this argument can be used to 'rename' the file that is stored in the zip file" 
		default="#getFileFromPath(fileAndPathToAdd)#">
	<cfscript>
		var e = arrayLen(this.entries) + 1;
		var newEntry = structNew();
		var sucess = false;
		if(fileExists(fileAndPathToAdd)){
			newEntry.sourceName = getFileFromPath(fileAndPathToAdd);
			newEntry.sourcePath = stripPath(fileAndPathToAdd);
			newEntry.storePath = pathToStore;
			newEntry.storeName = fileNameToStore;
			this.entries[e] = newEntry;
			sucess = true;
		}
		return sucess;
	</cfscript>
</cffunction>

<cffunction name="createZip" 
	hint="creates a zip file based on the files that were added with the addFile() method.">
	<cfset buildComplete = true>
	<cftry>
		<cfscript>
			// path to put zipped file
			outputPath = this.zipDirectory & this.zipFile;
			// FileOutputString for zip 
			fileOut = createObject("java","java.io.FileOutputStream");
			// initialize the fileoutput to our output dir
			fileOut.init(outputPath);
			// make a zip output stream
			zipOut = createObject("java", "java.util.zip.ZipOutputStream");
			// initialize the zip output stream
			zipOut.init(fileOut);
			// make a byte array for use when creating zip
			byteArray = repeatString(" ", 1000).getBytes();
			// input for writing our data
			input = '';
			// set our compression level
			zipOut.setLevel(this.compressionLevel);
			
			for(i = 1; i lte arrayLen(this.entries); i = i + 1){
				if(fileExists(this.entries[i].sourcePath & this.entries[i].sourceName)){
					// create a File obj and set it to next entry
					fio = createObject("java","java.io.File").init(this.entries[i].sourcePath & this.entries[i].sourceName);
					// make a fileInputStream to read the file into
					fileInput = createObject("java","java.io.FileInputStream").init(fio.getPath());
					// make an entry for this file in the zip
					zipEntry = createObject("java","java.util.zip.ZipEntry").init(this.entries[i].storePath & this.entries[i].storeName);
					// put the entry into the zip stream
					zipOut.putNextEntry(zipEntry);
					// put bytes into the our zip file
					l = fileInput.read(byteArray);
					while (l GT 0) {
						// write to the zip 
						zipOut.write(byteArray, 0, l);
						// read next chunk
						l = fileInput.read(byteArray);
					}
					//close out this entry
					zipOut.closeEntry();
					// close our input stream, we're done with that file now
					fileInput.close();
				}else{
					writeOutput('FILE DOES NOT EXIST: ' & this.entries[i].sourcePath & this.entries[i].sourceName);
				}
			}
			//close the zip output stream, all done!
			zipOut.close();
		</cfscript>
		<cfcatch type="any">
			<cfset buildComplete = false>
		</cfcatch>
	</cftry>
	<cfreturn buildComplete>
</cffunction>

<cffunction name="extractZip"
	hint="extracts the specified zip archive into the specified directory">
	<cfargument name="zipFileAndPath" required="yes" type="string" 
		hint="the full path and file to the zip archive to extract">
	<cfargument name="extractPath" required="no" type="string" 
		hint="the path to extract the zip files to, should contain trailing slash" 
		default="#stripPath(zipFileAndPath)#">
	<cfscript>
		
		// path to put zipped file
		inPath = zipFileAndPath;
		// FileOutputString for zip 
		inputIO = createObject("java","java.io.FileInputStream").init(inPath);
		// initialize the fileoutput to our output dir
		//input.init(outputPath);
		// make a zip output stream
		zipInput = createObject("java", "java.util.zip.ZipInputStream");
		// initialize the zip output stream
		zipInput.init(inputIO);
		// create a zip entry obj
		zipEntry = createObject("java","java.util.zip.ZipEntry").init(".");
	
		loopcount = 1;
		
		// loop through the zip entries
		while(true){
			// get the next entry
			zipEntry = zipInput.getNextEntry();
			
			// try to read the entry, it will become undefined when we are out of entries
			if(not isDefined("zipEntry")){
				break;
			}
			
			// create a byte array
			byteArray = repeatString(" ", 1000).getBytes();
			// path to put zipped file
			outPath = extractPath;
			outFile = zipEntry.getName();
			outFileAndPath = outPath & outFile;
			
			// fileio obj with path to where to store
			fileio = createObject("java", "java.io.File").init(stripPath(outFileAndPath));
			// make any new directories needed for this entry
			fileio.mkdirs();
			
			// FileOutputString for zip 			
			output = createObject("java","java.io.FileOutputStream").init(outFileAndPath);
		
			// read in the zip data
			n = zipInput.read(byteArray);
			while(n gte 0){
				// write chunk to file
				output.write(byteArray, 0, n);
				n = zipInput.read(byteArray);
			}
			output.close();
				
			// get the next entry
			zipInput.closeEntry();
		}
		zipInput.close();
	</cfscript>
</cffunction>

</cfcomponent>