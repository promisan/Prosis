
<cfparam name="attributes.file"   default="karin_cost.txt">
<cfparam name="attributes.path"   default="c:\">

<cfquery name="Engine" 
datasource="appsInit">
	SELECT   *
	FROM     Parameter
	WHERE HostName = '#CGI.HTTP_HOST#'  
</cfquery>	

<cfset pdf = Engine.PDFEngine>

<!--- ---------------------------------- --->
<!--- rename the file to a PDF extension --->
<!--- ---------------------------------- --->

<cfset size = len(attributes.file)>
<cfset dest = "#left(attributes.file,size-4)#.pdf">
	
	<!---
	
	Converting a Single File
	To convert a single file, say D:\MyFolder\Doc1.DOC to C:\Results Folder\Doc1.PDF use the following syntax:

	   ConvertDoc /S "D:\MyFolder\Doc1.DOC" /T "C:\Results Folder\Doc1.PDF" /F9 /C12 /M2 /V

	The /S and /T switches above specify Source (input) and Target (output) path respectively and are both required when converting a single file.  It is always a good idea to use double quotes around the path especially if there are space characters within the path. 

	The /M2 switch tells ‘Convert Doc’ to use the ‘Convert Doc’ method (it is one of 3 different possible Conversion Methods).  

	/F9 is the original (input) file type, which in this case is a word DOC file.  Looking up the file types within the File Type Constants Specification for the ‘Convert Doc’ method will show that the numeric value of 9 corresponds to a DOC file. 

	/C12 is the target (output) file type, which in this case is a PDF file.  Looking up the file types within the File Type Constants Specification for the ‘Convert Doc’ method will show that the numeric value of 12 corresponds to a PDF file. 

	Finally, the /V (for Verbose) switch is used to give instant feedback by having the program report the status of the conversion with a message box.  You can remove this once you have perfected your command line specification.  You can also (or instead of /V) create a Log file that will contain the results of the conversion by using the /L switch. 

	HINT: You may use the /W switch to specify a File Open password.  The Example below makes the word Apples the password to open the newly created PDF file:

     ConvertDoc.EXE     /S "c:\input files\tryme.doc" /T "c:\input files\tryme.pdf" /F9 /C12 /M2 /V /WApples 

	--->
	
	
	<cfif findNocase(".txt",attributes.file) or findNocase(".htm",attributes.file) or findNocase(".html",attributes.file)>

		<cfif pdf eq "OpenOffice">
				
			<cfdocument 
			    format="pdf" 
				overwrite="Yes"				
			    srcfile="#attributes.path#\#attributes.file#" 
			    filename="#attributes.path#\#dest#"> 
			</cfdocument>
		
		<cfelse>
		
		<cfexecute name="#pdf#" 
			arguments="/S #attributes.path#\#attributes.file# /T #attributes.path#\#dest# /F1 /C12 /M2 /L" 
			timeOut="5"></cfexecute>
			
		</cfif>	
	
	<!---	not working yet, maybe CF9  !!!!!	
	
	<cfset xls = Engine.XLSEngine>
			
	<cfelseif findNocase(".xls",attributes.file)>
	
		<cfexecute name="#xls#" 
			arguments="/S #attributes.path#\#attributes.file# /T #attributes.path#\#dest# /F5 /C12 /M2 /L" 
			timeOut="5"></cfexecute>	
			
	--->		
		
	<cfelseif findNocase(".rtf",attributes.file)>
	
		<cfif pdf eq "OpenOffice">
				
			<cfdocument 
			    format="pdf" 
				overwrite="true"
			    srcfile="#attributes.path#\#attributes.file#" 
			    filename="#attributes.path#\#dest#"> 
			</cfdocument>
		
		<cfelse>
	
		<cfexecute name="#pdf#" 
			arguments="/S #attributes.path#\#attributes.file# /T #attributes.path#\#dest# /F5 /C12 /M2 /L" 
			timeOut="5"></cfexecute>
			
		</cfif>	
		
	<cfelse>
	
		<cfif pdf eq "OpenOffice">
				
			<cfdocument 
			    format="pdf" 
				overwrite="Yes"
			    srcfile="#attributes.path#\#attributes.file#" 
			    filename="#attributes.path#\#dest#"> 
			</cfdocument>
		
		<cfelse>
	
			<cfexecute name="#pdf#" 
			arguments="/S #attributes.path#\#attributes.file# /T #attributes.path#\#dest# /F9 /C12 /M2 /L" 
			timeOut="5"></cfexecute>
			
		</cfif>	
		
	</cfif>
	
	<!---
	<cftry>
	---> 
			
		<!--- log the creation --->	
					
		<cfquery name="Check" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT TOP 1 * 
			FROM   Attachment					
			WHERE  ServerPath = '#replace(attributes.pathurl,'\','/')#/'
			AND    FileName   = '#dest#'										
		</cfquery>
		
		<cftry>
			
		<cfif Check.recordcount eq "0">
			
			<cf_assignId>
			
			<cfquery name="Reference" 
				datasource="AppsSystem" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT * 
				FROM   Ref_Attachment					
				WHERE  DocumentPathName= '#attributes.documentpathname#'												
			</cfquery>
		
			<cfquery name="InsertAction" 
				datasource="AppsSystem" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				
				INSERT INTO Attachment
					(AttachmentId,
					 <cfif Reference.recordcount eq "1">
						 DocumentPathName,
					 </cfif>
					 Server, 
					 ServerPath, 
					 FileName, 
					 Reference,
					 AttachmentMemo,
					 OfficerUserid, 
					 OfficerLastName, 
					 OfficerFirstName)
					 
				VALUES
				
				('#rowguid#',					
				 <cfif Reference.recordcount eq "1">
					'#attributes.documentpathname#',
				 </cfif>
				
			     <cfif attributes.host eq "#SESSION.rootDocumentPath#\">
				    'document',
				 <cfelse>
				 	'#attributes.host#',
				 </cfif>					 	
				
				 '#replace(attributes.pathurl,'\','/')#/',
				 '#dest#', 
				 '#attributes.ID#',
				 '#attributes.Memo#',				
				 '#SESSION.acc#',
				 '#SESSION.last#',
				 '#SESSION.first#')
				 
				</cfquery>
				
				<cfset aid = rowguid>
				<cfset ser = 1>
				<cfset act = "insert">
				
				<cfif client.logattachment eq "1">
				
						<cftry>		  				  		
				  		<cfdirectory action="CREATE" 
				               directory="#attributes.path#\logging\#aid#">
					    <cfcatch></cfcatch>
						</cftry>
										
					    <!--- copy the file to the log --->
						
					    <cffile action="COPY"
					        source="#attributes.path#\#dest#" 
							destination="#attributes.path#\logging\#aid#">										
							  
						<cffile action="RENAME" 
							source="#attributes.path#\logging\#aid#\#dest#" 
							destination="[#ser#]_#dest#">	  							
									
					</cfif>			
												
			<cfelse>
			
				<cfquery name="Log" 
					datasource="AppsSystem" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT max(SerialNo) as No
						FROM   AttachmentLog
						WHERE  AttachmentId = '#check.attachmentid#'
					</cfquery>	
					
					<cfset aid = check.attachmentid>
					<cfset ser = log.No+1>
					<cfset act = "update">					
					
					<!--- If the file is deleted, then reinstate it --->
					<cfquery name = "UpdateAttachment" 
						datasource    = "AppsSystem" 
						username      = "#SESSION.login#" 
						password      = "#SESSION.dbpw#">
							UPDATE Attachment
							SET    FileStatus   = '1'
							WHERE  AttachmentId = '#Check.Attachmentid#'
					</cfquery>
					
					<cfif client.logattachment eq "1">
					
						<cftry>		  				  		
				  		<cfdirectory action="CREATE" 
				               directory="#attributes.path#\logging\#aid#">
					    <cfcatch></cfcatch>
						</cftry>
										
					    <!--- copy the file to the log --->
						
					    <cffile action="COPY"
					        source="#attributes.path#\#dest#" 
							destination="#attributes.path#\logging\#aid#">										
							  
						<cffile action="RENAME" 
							source="#attributes.path#\logging\#aid#\#dest#" 
							destination="[#ser#]_#dest#">	 					
									
									
					</cfif>			
											
			</cfif>	
			
			<cfif CGI.HTTPS eq "off">
	    	  <cfset protocol = "http">
			<cfelse> 
			  <cfset protocol = "https">
			</cfif>
			
			<cfquery name="LogAction" 
				datasource="AppsSystem" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					INSERT INTO AttachmentLog
					(AttachmentId,
					 SerialNo, 
					 FileAction, 
					 FileActionServer,			
					 OfficerUserid, 
					 OfficerLastName, 
					 OfficerFirstName)
					VALUES
					('#aid#',
					 '#ser#',
					 '#act#',	
					 '#protocol#://#CGI.HTTP_HOST#/',		
					 '#SESSION.acc#',
					 '#SESSION.last#',
					 '#SESSION.first#')
				</cfquery>	
				
				<cfcatch></cfcatch>
				
			</cftry>	  
				
			<!--- if abbove succeeded mark the original to be removed --->
			<!--- delayed removeal --->
				
			<cfif attributes.keepfile eq "No">
							  
					<cfquery name="Delete" 
						datasource="AppsSystem" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						UPDATE Attachment
						SET    DelayedAction = 'delete' 
						WHERE  AttachmentId = '#attributes.attachmentid#'															
					</cfquery>					
					
			</cfif>	 
		
		<!---				
		<cfcatch></cfcatch>
		
		</cftry>
		
		--->
	
	

