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

<cfcomponent>

    <cfproperty name="name" type="string">
    <cfset this.name = "Document Management Functions">
		
	<cffunction access="public" 
	    name="VerifyDBAttachment" 
		output="false" 
		returntype="query" 		
		displayname="VerifyAttachment">
		
	<cfargument name="server"       default="document">
	<cfargument name="docpath"      default="">
	<cfargument name="filename"     default="">
	<cfargument name="reference"    default="">
	<cfargument name="attachmentId" default="{00000000-0000-0000-0000-000000000000}">	
	
	<cfif arguments.attachmentid eq "">
		<cfset arguments.attachmentid="{00000000-0000-0000-0000-000000000000}">
	</cfif>
	
	<cfquery name="Attachment" 
		 datasource="AppsSystem"
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
		     SELECT   TOP 1 *
			 FROM     Attachment				
			 WHERE    			 
		 	 <cfif server eq "documentserver">
				  AttachmentId = '#arguments.attachmentid#'
			 <cfelseif server eq "report">
			 	  FileName   = '#filename#'	 
				  AND
  				  ServerPath LIKE '#docpath#%' 
			 <cfelse>
			     <!--- % added to cater for the // of the path recorded --->
				 (ServerPath LIKE '#docpath#%' 
				  or ServerPath LIKE 'document/#docpath#%') AND  FileName   = '#filename#'			
			 </cfif>
			 ORDER BY Created DESC
	</cfquery>		
							 
	<cfif Attachment.recordcount eq "0">
		 
	 	<cf_assignId>	
		
		<cfif docpath neq "">			 
				
			<cfquery name="LogAction" 
				datasource="AppsSystem" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					INSERT INTO Attachment
					(AttachmentId,
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
						 '#server#',
						 '#docPath#',
						 '#FileName#', 
						 '#reference#',
						 'Detected',
						 '#SESSION.acc#',
						 '#SESSION.last#',
						 '#SESSION.first#')
			</cfquery>
			
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
					('#rowguid#',
					 '1',
					 'Detected',	
					 '#protocol#://#CGI.HTTP_HOST#/',		
					 '#SESSION.acc#',
					 '#SESSION.last#',
					 '#SESSION.first#')
							 
			</cfquery>
						
			<cfquery name="Attachment" 
			 datasource="AppsSystem"
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
			     SELECT   *
				 FROM     Attachment
				 WHERE    AttachmentId = '#rowguid#'			
			</cfquery>	
		
		</cfif>	
					
	<cfelseif server eq "Document" and Attachment.FileStatus eq "9">
	
			<!--- ------------------- --->	 
		    <!--- file has re-emerged --->
			<!--- ------------------- --->
			
		 	<cfquery name="Reset" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				UPDATE Attachment
				SET    FileStatus = '1'
				WHERE  AttachmentId = '#attachment.attachmentid#'															
			</cfquery>
			
			<cfquery name="Attachment" 
			 datasource="AppsSystem"
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
			     SELECT   *
				 FROM     Attachment
				 WHERE    AttachmentId = '#attachment.attachmentid#'			
			</cfquery>	
			
	<cfelseif server eq "documentserver" and Attachment.FileStatus eq "9">		

			<!--Removing the one that was 9 --->
			<cfquery name="Remove" 
					 datasource="AppsSystem"
					 username="#SESSION.login#" 
					 password="#SESSION.dbpw#">
				     DELETE
					 FROM     Attachment
					 WHERE    AttachmentId = '#attachment.attachmentid#'	
			</cfquery>				 
	
			<!--Looking for the very last one that was active so now it is enabled again
			in Xythos --->
			<cfquery name="Attachment" 
					 datasource="AppsSystem"
					 username="#SESSION.login#" 
					 password="#SESSION.dbpw#">
				     SELECT   *
					 FROM     Attachment
					 WHERE    AttachmentId = '#arguments.attachmentid#'
					 ORDER BY Created DESC
			</cfquery>
															 						 					 
	</cfif>	
			
	<cfreturn attachment>
		
	</cffunction>
	
	<cffunction access="public" 
	    name="CleanDBAttachment" 
		output="false" 			
		displayname="VerifyAttachment">
		
		<cfargument name="server"   default="document">
		<cfargument name="docpath"  default="">
		<cfargument name="filter"   default="">
		<cfargument name="found"    default="">
		
		<cfif found neq "">
			
			<cfquery name="SetAsDeleted" 
				datasource="AppsSystem" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					UPDATE Attachment
					SET    FileStatus = '9'
					WHERE  Server     = '#server#'
					AND    ServerPath = '#docpath#'
					<cfif filter neq "">
					AND    FileName LIKE '#filter#_%'
					</cfif>
					AND    AttachmentId NOT IN (#preservesinglequotes(found)#)
																				
			</cfquery>	
		
		</cfif>
		
		<!--- logging is missing yet --->			
		
	</cffunction>		
	
</cfcomponent>	
	
