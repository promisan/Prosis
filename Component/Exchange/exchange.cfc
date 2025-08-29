<!--
    Copyright © 2025 Promisan B.V.

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
<!--- 
   Name : /Component/Exchange/Exchange.cfc
   Description : Test access rights
  
   content 
   1.0.  POP : upload POP mail into workflow object 
         
--->   

<cfcomponent>

    <cfproperty name="name" type="string">
    <cfset this.name = "Exchange Routined">
	
	<!--- 1.0 GENERAL ACCESS TO A MENU FUNCTION --->
	
	<cffunction access="public" name="POP" output="true" returntype="string" displayname="Upload POP mail into Workflow Object">
	    <cfargument name="Action" type="string" default="Insert" required="yes">
		<cfargument name="ObjectId" type="string" required="true">
		<cfargument name="ActionCode" type="string" required="false" default="">
		<cfargument name="ActionId" type="string" required="false" default="">
		<cfargument name="DocumentItem" type="string" required="true" default="">
		<cfargument name="MailDate" type="date" required="yes">
		<cfargument name="MailTo" type="string" required="true">
		<cfargument name="MailFrom" type="string" required="true">
		<cfargument name="MailSubject" type="string" required="true">
		<cfargument name="MailBody" type="string" required="true">
		<cfargument name="MailAttachmentPath" type="string" required="false">	
		<cfargument name="MailAttachment" type="string" required="false">	
		
		<cfif action eq "Insert">
		
					<cf_assignId>
				
					<cfset att = rowguid>
				
					<cfquery name="Object" 
					datasource="AppsOrganization" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					SELECT   *
					FROM     OrganizationObject
					WHERE    ObjectId = '#ObjectId#' 					
					</cfquery>
					
					<cfif Object.recordcount eq "1">
				
						<cfif actionCode eq "">
						
							<cfquery name="Code" 
						datasource="AppsOrganization" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							SELECT   TOP 1  *
							FROM     OrganizationObjectAction
							WHERE    ObjectId = '#ObjectId#' 
							AND      (ActionStatus = '0')
							ORDER BY ActionStatus DESC, ActionFlowOrder
							</cfquery>
							
							<cfset actionCode = Code.ActionCode>
											
						</cfif>
						
						<cfif len(mailto) gt "200">
						
							<cfset mailto = left(mailto,200)>
						
						</cfif>
						
						<cfif len(mailsubject) gt "200">
						
							<cfset mailsubject = left(mailsubject,200)>
						
						</cfif>
			
						<cfquery name="Insert" 
							datasource="AppsOrganization" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
								INSERT INTO  OrganizationObjectActionMail
								( ThreadId,
								  SerialNo,
								  ObjectId,
								  ActionCode,
								  <cfif actionId neq "">
								  ActionId,
								  </cfif>
								  <cfif documentitem neq "">
								  DocumentId,
								  DocumentItem,
								  </cfif>
								  MailType,						  
								  MailDate,						
								  MailTo,						 
								  MailSubject,
								  MailBody,								  
								  AttachmentId,
								  OfficerUserId,
								  OfficerLastName,
								  OfficerFirstName)
								VALUES 
								( '#rowguid#',
								  '1',
								  '#ObjectId#',
								  '#ActionCode#',
								  <cfif actionId neq "">
								  '#Check.actionId#',
								  </cfif>
								  <cfif documentitem neq "">
								  '#Form.documentId#',
								  '#Form.DocumentItem#',
								  </cfif>
								  'Exchange',
								  '#dateformat(MailDate,client.dateSQL)# #timeformat(MailDate,"HH:MM:SS")#',
								  '#MailTo#',						 
								  '#MailSubject#',
								  '#MailBody#',						  
								  '#att#',
								  '#SESSION.acc#',
								  '#SESSION.last#',
								  '#SESSION.first#')
							</cfquery>
						
							<!--- attachments --->
							
							<cfset files = MailAttachment>
							<cfloop index="suf" list="doc,xls,ppt,txt,rtf,jpg,gif,pdf" delimiters=",">									     				
								<cfset files = replaceNoCase(files,'.#suf#','.#suf#|','ALL')>
							</cfloop>	
																														
							<cfloop index="thisfile" list="#files#" delimiters="|">
																
								<cftry>									
									<cfdirectory action="CREATE" directory="#SESSION.rootdocumentpath#\#object.entitycode#\#att#">		
								    <cfcatch></cfcatch>			
								</cftry>	
								
								<cftry>							
								
								<cffile action="COPY"
							        source="#MailAttachmentPath##ltrim(thisfile)#"
							        destination="#SESSION.rootdocumentpath#\#object.entitycode#\#att#\#ltrim(thisfile)#">
															
									<!--- logging in database --->
													
									<cf_assignId>
								
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
										 'document',
										 '#object.entitycode#/#att#/',
										 '#ltrim(thisfile)#', 
										 '#att#',
										 'Exchange Upload',
										 '#SESSION.acc#',
										 '#SESSION.last#',
										 '#SESSION.first#')
									</cfquery>
									
									<cfset aid = rowguid>
									<cfset ser = 1>						
															
									<cfquery name="LogAction" 
										datasource="AppsSystem" 
										username="#SESSION.login#" 
										password="#SESSION.dbpw#">
										INSERT INTO AttachmentLog
										(AttachmentId,
										 SerialNo, 
										 FileAction, 	
										 FileActionMemo,		
										 OfficerUserid, 
										 OfficerLastName, 
										 OfficerFirstName)
										VALUES
										('#aid#',
										 '#ser#',
										 'Insert',		
										 'Exchange Upload',	
										 '#SESSION.acc#',
										 '#SESSION.last#',
										 '#SESSION.first#')
									</cfquery>	
									
									<cfcatch></cfcatch>
									
									</cftry>
																
							</cfloop>						
																			
							<cfset actionresult = "1">
							
					<cfelse>
					
						<cfset actionresult = "0">
					
					</cfif>		
		
		</cfif>
		
				
		<cfreturn actionresult>
		 
	</cffunction>
	
				
</cfcomponent>