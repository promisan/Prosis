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
<cfparam name="URL.DocumentServer"  default="">
<cfparam name="URL.dialog"          default="1">
<cfparam name="Form.KeepOriginal"   default="0">
<cfparam name="Form.DocumentServer" default="#URL.DocumentServer#">

<cfif Form.DocumentServer eq "0">
	<cfparam name="Form.DocumentServerPath" default="">
<cfelse>
	<!--- kherrera(2014-12-05): #CLIENT.DocumentServerPath# was removed as the default to make it work without the dialgo in Chrome --->
	<cfparam name="Form.DocumentServerPath" default="">
</cfif>	

<cfoutput>
	
	<!--- parameters --->
	<CFSET IsOverwriteEnabled = "NO">
	
	<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">
	
	<!--- upload file with unique name --->
	
	<cfset host = replaceNoCase(url.host,"|","\","ALL")> 
	
	<CFSET dir = replace(url.dir,"/","\",'ALL')>
	<CFSET dir = replace(dir,"\\","\",'ALL')>
	<CFSET dir = replace(dir,"|","\",'ALL')>
	
			
		
	<cf_assignId>


	<cfquery name="LogAction" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		
		INSERT INTO Attachment
		(AttachmentId,
		 DocumentPathName,
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
		 '#dir#',
		 'documentserver',
		 '<UniteDocs>',
		 '#URL.ID1#_#FORM.DocumentServerPath#', 
		 '#URL.ID#',
		 '#Form.attachmentMemo#',
		 '#SESSION.acc#',
		 '#SESSION.last#',
		 '#SESSION.first#') 
	</cfquery>					


					<script language="JavaScript">																
													
					try {										    
							parent.parent.document.getElementById("att_#URL.Box#_refresh").click()			
							parent.parent.ProsisUI.closeWindow('attachdialog')						
							} catch(e) {}				
							
					try {										    
							parent.document.getElementById("att_#URL.Box#_refresh").click()			
							parent.ProsisUI.closeWindow('attachdialog')						
							} catch(e) {}			
							
					// cfdivscroll 
							
					try {													    							
						parent.parent.document.getElementById('#url.box#_holdercontent_close').click()														
					} catch(e) {}		
					

					</script>
	
		
</cfoutput>


