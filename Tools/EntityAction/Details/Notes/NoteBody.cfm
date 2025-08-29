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
<cfquery name="Object" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT     *
FROM       OrganizationObject
WHERE      ObjectId = '#URL.Objectid#'
</cfquery>

<cfquery name="Get" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT     *
FROM       OrganizationObjectActionMail
WHERE      ThreadId = '#URL.ThreadId#'
AND        SerialNo >= '#URL.SerialNo#'
ORDER BY SerialNo
</cfquery>

<cfparam name="pdf" default="0">

<table width="100%" height="100%" align="center" border="0" cellspacing="0" cellpadding="0">

<cfif pdf eq "0">
	
	<tr><td colspan="2" height="30">
	
	<table width="120">
	<tr>
	<cfoutput>
	<cfset wd = "28">
	<cfset ht = "28">
						
		<cf_menutab item       = "4" 
		            iconsrc    = "Logos/System/Reply.png" 
					iconwidth  = "#wd#" 
					iconheight = "#ht#" 
					type       = "Vertical"
					name       = "Reply"
					source     = "javascript:noteentry('#url.objectid#','#URL.ThreadId#','','embed','','regular','notecontainerdetail')">
					
			<cf_menutab item       = "5" 
		            iconsrc    = "Print.png" 
					iconwidth  = "#wd#" 
					iconheight = "#ht#" 
					type       = "Vertical"
					name       = "Print"
					source     = "javascript:printme()">		
	
	</cfoutput>
	</tr>
	</table>
	</td>
	</tr>

</cfif>

<tr><td height="1" colspan="2" class="linedotted"></td></tr>

<tr><td width="100%" height="100%" style="padding:10px">

<cf_divscroll style="height:100%">

<table class="navigation_table" width="100%">

	<cfoutput query="Get">
		
		<tr class="navigation_row"><td colspan="2" height="35" class="labelmedium"><font size="4" color="0080C0">#MailSubject#</td></tr>
		<cfif mailto neq "">
		<tr class="navigation_row_child"><td width="50" class="labelit"><font color="0080C0">To:<font color="0080C0"></b></td><td width="90%" class="labelmedium">#MailTo#</td></tr>
		</cfif>
		<cfif mailcc neq "">
			<tr class="navigation_row_child"><td class="labelit"><font color="0080C0">Cc:<font color="0080C0"></b></td><td class="labelmedium">#MailCc#</td></tr>
		</cfif>
		<tr class="navigation_child"><td class="labelit" width="50"><font color="0080C0">From:<font color="0080C0"></b></td><td width="90%" class="labelmedium">#OfficerFirstName# #OfficerLastName#</td></tr>
		<tr class="navigation_child"><td class="labelit"><font color="0080C0">Date:<font color="0080C0"></b></td><td class="labelmedium">#dateformat(MailDate,CLIENT.DateFormatShow)# #TimeFormat(MailDate,"HH:MM")#</td></tr>
		
		<cfdirectory action="LIST"
		             directory="#SESSION.rootDocumentPath#\#object.entitycode#\#attachmentid#"
		             name="GetFiles"
		             filter="*.*"
		             sort="DateLastModified DESC"
		             type="file"
		             listinfo="name">
			
		<cfif getfiles.recordcount gte "1">
		
		<tr><td class="labelit"><b><font color="0080C0"><cf_tl id="Attachment"><cfif getfiles.recordcount gte "2">s</cfif>:<font color="0080C0"></b></td>
		   <td><table width="100%" cellspacing="0" cellpadding="0">
		       <cfloop query="getfiles"><tr><td class="labelit">
			   <cfif pdf eq "0">
			   <a href="javascript:showmyfile('#object.entitycode#','#get.attachmentid#','#name#')">#name#</a>
			   <cfelse>
			   <a href="#SESSION.rootDocument#/#object.entitycode#/#get.attachmentid#/#name#"
				   target="_blank">#name#</a>
			   </cfif>
			   </td></tr>
			   </cfloop>
			   </table>
		   </td>
		</tr>
		
		</cfif>	
		
		<tr><td height="5"></td></tr>
		<tr><td height="1" colspan="2" class="linedotted"></td></tr>
		<tr><td height="5"></td></tr>
		<tr><td colspan="2" valign="top" class="labelmedium">#Get.MailBody#</td></tr>
		<tr><td height="5"></td></tr>
		<tr><td height="1" colspan="2" class="linedotted"></td></tr>
		<tr><td height="8"></td></tr>
	
	</cfoutput>
	
</table>

</cf_divscroll>

</td></tr>

</table>

<cfset ajaxonload("doHighlight")>
