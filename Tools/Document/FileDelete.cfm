<!--
    Copyright © 2025 Promisan

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->

<cfparam name="attributes.attachmentid"  default="">
<cfparam name="attributes.mode"          default="Interface">
<cfparam name="url.attachmentid"         default="">
<cfparam name="url.documentserver"       default="no">

<cfif attributes.attachmentid neq "">
	<cfset attachmentid = attributes.attachmentid>
<cfelse>
	<cfset attachmentid = url.attachmentid>
</cfif>
							  
<cfquery name="Attachment" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT * 
		FROM   Attachment
		WHERE  AttachmentId = '#attachmentid#'															
</cfquery>

<cfif Attachment.recordcount eq "1">

	<cftry>	
		
		<cfset path = replaceNoCase(attachment.ServerPath,"|","\","ALL")> 
		<cfset path = replaceNoCase(path,"/","\","ALL")> 
		
		<!--- backward compatibility --->
		<cfif left(Path,9) eq "document\">
		  <cfset Path = mid(path,  10,  len(path)-9)>
		</cfif>		
		
		<cfif attachment.server neq "document" and attachment.server neq "documentServer">
		
		    <cfif attachment.server eq "report">
			    <!--- path contains the full info --->
			    <cfset svr = "#path#">
			<cfelse>
			    <cfset svr = "#attachment.server#\#path#">			
			</cfif>
			
			<cffile action="DELETE" 
			     file="#svr#\#attachment.filename#">
				 
			<!--- remove also the log file directory  ------------         --->
			<!--- ATTENTION --->
			<!--- 15/2/2011 : MAYBE this is not a good idea to remove this --->
									
			<cfif directoryExists("#svr##Path#\Logging\#attachmentid#\")>
				
				<cfdirectory action="DELETE" 
				 directory="#svr#\Logging\#attachmentid#" 
				 recurse="Yes">	 
					
			</cfif>	 
							
			<!--- check if there are any files left --->
				 
			<cfdirectory action="LIST"
	             directory="#svr#"
	             name="CheckFiles"             
	             type="file"
				 recurse = "yes"
	             listinfo="name">	
				 
			 <cfif checkFiles.recordcount eq "0">				
			
			  	<cfdirectory 
				  action   = "DELETE" 
			      directory= "#svr#"
				  recurse="Yes">	 
					  
			 </cfif>	  
			
		<cfelse>								
										
				<cfif URL.documentServer neq "No">
				
						<cfquery name="Parameter" 
						datasource="AppsInit">
							SELECT * 
							FROM Parameter
							WHERE HostName = '#CGI.HTTP_HOST#'
						</cfquery>		
		               						
						<cfif Parameter.DocumentServer neq "">
								<cftry>
									<cfset oDocumentServer = CreateObject("component","Service.ServerDocument.Document")/>
									<cfset aResponse = oDocumentServer
										.SetMode("Individual")
										.Delete("#attachment.ServerPath#","#UCASE(attachmentid)#-#attachment.filename#")/>
																		
								<cfcatch>
									#attachment.DocumentServerPath#","#attachmentid#-#attachment.filename#"
								</cfcatch>
		
								</cftry>	
		
						</cfif>						
						
				<cfelse>
								
					<!--- take the default location --->
					
					<cfif FileExists("#SESSION.rootDocumentPath#\#Path#\#attachment.filename#")>
					
						<cffile action="DELETE" 
					     file="#SESSION.rootDocumentPath#\#Path#\#attachment.filename#">		
					 
					</cfif> 
					 
					 <!--- remove also the log file directory  ------------         --->
					<!--- ATTENTION --->
					<!--- 15/2/2011 : MAYBE this is not a good idea to remove this --->
											
					<cfif directoryExists("#SESSION.rootDocumentPath#\#Path#\Logging\#attachmentid#\")>
						
						<cfdirectory action="DELETE"
			             directory="#SESSION.rootDocumentPath#\#Path#\Logging\#attachmentid#\"
			             recurse="Yes">	 
							
					</cfif>	 
										 
					 <!--- check if there are any files left but the thums file is an issue to I changed it 30/7/2014 --->
				 
					<cfdirectory 
					    action="LIST" 
						directory="#SESSION.rootDocumentPath#\#Path#" 
						name="CheckFiles" 						 
						type="file" 
						listinfo="name">							 						
												 
						 <cfif checkFiles.recordcount eq "0" or (checkfiles.recordcount eq "1" and Checkfiles.name is "thumbs.db")>		
						 									
							<cftry>					   							 					
						  	<cfdirectory action="DELETE" directory="#SESSION.rootDocumentPath#\#Path#" recurse="Yes">	 												  
							<cfcatch></cfcatch>
							</cftry>
							
						 </cfif>	 
													 
				</cfif>	
							
		</cfif>	
						
		<cfquery name="Last" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT   max(serialNo) as last 
				FROM     AttachmentLog
				WHERE 	 AttachmentId = '#Attachment.attachmentId#'								
		</cfquery>	
														
		<cfif Last.last neq "">
								
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
							('#Attachment.attachmentid#',
							 '#last.last+1#',
							 'Delete',		
							 '#protocol#://#CGI.HTTP_HOST#/',			
							 '#SESSION.acc#',
							 '#SESSION.last#',
							 '#SESSION.first#') 
				</cfquery>	
				
		</cfif>		
						
		<cfquery name="Delete" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			UPDATE Attachment
			SET    FileStatus = '9'
			WHERE  AttachmentId = '#attachment.attachmentid#'														
		</cfquery>
										
							
	<cfcatch>
				
			<font color="FF0000"><cfoutput>#Path#\#attachment.filename#</cfoutput> could not be removed</font>		
				
	</cfcatch>
	
	</cftry>	
	
	
<cfelse>

	<cfif attributes.mode eq "xInterface">
		<font color="FF0000"><cfoutput>#Path#\#attachment.filename#</cfoutput> does not appear to exist.</font>			
	</cfif>	

</cfif>

<cfif attributes.mode eq "Interface">
	<cfinclude template="FileLibraryShow.cfm">
</cfif>	

