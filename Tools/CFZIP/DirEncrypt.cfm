<cfparam name="attributes.Directory"   default = "">
<cfparam name="attributes.Origin"      default = "">
<cfparam name="attributes.Destination" default = "">
<cfparam name="attributes.Zip"         default = "No">


<cfquery name="qEncryptionEngine" 
	datasource="AppsSystem">
    SELECT TOP 1 EncodeEngine 
	FROM Parameter
</cfquery>

<cfsetting enablecfoutputonly="yes">

<cfif fileexists(qEncryptionEngine.EncodeEngine)>
	<cfset cfencode_engine = "#qEncryptionEngine.EncodeEngine#" />
	
	<cfoutput>
	<cfsavecontent variable="script">
	xcopy #attributes.directory#\#attributes.Origin#\*.* #attributes.directory#\#attributes.Destination#\ /s /e /y
	</cfsavecontent>
	</cfoutput>
	
	<cffile action="WRITE" file="#attributes.directory#\#attributes.Destination#.bat"
		       output="#script#"
		       addnewline="Yes" 
			   fixnewline="No">	
	
	<cfexecute name="#attributes.directory#\#attributes.Destination#.bat" 
	           timeOut="15">
	</cfexecute>		   
	
	<cfif attributes.directory neq "">
	
	<cfdirectory name = "decrypted_files"
	  Directory       = "#attributes.directory#\#attributes.Destination#\" 
	  Filter          = "*.cfm"
	  Sort            = "DateLastModified DESC"
	  Recurse         =  "Yes">
	
			<cfloop query = "decrypted_files">
			
			  <cfset decryptedfile = "#decrypted_files.directory#\#decrypted_files.Name#">  
			  <cfset session.status  = session.status + 0.001>  
			  <cfset session.message = "Encrypting #decrypted_files.Name#">  
			  
			  <cfset encryptedFile = reReplaceNoCase(
				decryptedFile,
				"(.+?)(?:\.decrypted)?\.(cf(m|c))$",
				"\1.encrypted.\2",
				"one"
				) />
				
			  <cfif FileExists("#encryptedfile#")>
				<cffile action="delete" file="#encryptedfile#">
			  </cfif>
				
			 <cftry>
			  <cfexecute
				name="""#cfencode_engine#"""
				arguments="""#decryptedFile#"" ""#encryptedFile#"" /v ""2"""
				timeout="5">
			   </cfexecute>	
			
			   <cffile action="delete" file="#decryptedfile#">
			   
			   <cffile action  = "rename"
				source         = "#encryptedfile#"
				destination    = "#decryptedfile#">
				
			
			   
			 <cfcatch>
				<cfoutput>
					#decryptedfile#
					<br>
				</cfoutput>	
			 </cfcatch>
			 </cftry>	
			</cfloop>
			
			
			<cfdirectory name = "encrypted_files"
			  Directory       = "#attributes.directory#\#attributes.Destination#\" 
			  Filter          = "*.*"
			  Sort            = "DateLastModified DESC"
			  Recurse         = "Yes">
			
			
			<cfif attributes.Zip eq "Yes">
			
				   <cfset session.status  = session.status + 0.001>  
				   <cfset session.message = "Zipping encrypted files">  
			
			  
					<cfzip file         = "#attributes.directory#\#attributes.Destination#.zip"
							overwrite   = "yes">
						  
						  <cfloop query = "encrypted_files">
						
						    <cfset encryptedfile = "#encrypted_files.directory#\#encrypted_files.Name#">  
							<cfset vFile = Replace(encryptedfile,attributes.directory,"\")>
					
							<cfif fileexists(encryptedfile)>	
					
								
								<cfzipparam
									entrypath  = "#vFile#" 
									source     = "#encryptedfile#"/>
							</cfif>		
						</cfloop>			
					</cfzip>
			
			</cfif>  
	
	</cfif>

</cfif>

<cfsetting enablecfoutputonly="no">