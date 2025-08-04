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

<cfparam name="url.documentid" default="">

<!--- reset status --->

<cfif url.documentid eq "1">
	
	<cfquery name="External" 
	 datasource="AppsOrganization"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		 UPDATE OrganizationObjectDocument
		 SET    Operational = 1
		 WHERE  ObjectId  = '#ObjectId#'			
	</cfquery>
	
<cfelseif url.documentid neq "">

	<cfquery name="External" 
	 datasource="AppsOrganization"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		 UPDATE OrganizationObjectDocument
		 SET    Operational = 0
		 WHERE  DocumentId  = '#URL.documentId#'
		 AND    ObjectId    = '#ObjectId#'	
	</cfquery>

</cfif>

<cfquery name="External" 
 datasource="AppsOrganization"
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
	 SELECT *
	 FROM  OrganizationObjectDocument O, 
	       Ref_EntityDocument R 
	 WHERE O.DocumentId = R.DocumentId
	 AND   O.ObjectId  = '#ObjectId#'	
	 AND   O.Operational = 1
	 ORDER BY R.DocumentCode
</cfquery>

<cfif External.recordcount gte "1">

	<table width="100%" cellspacing="0" cellpadding="0">
	
	<tr><td height="18">&nbsp;&nbsp;<cf_tl id="External Documents"></td></tr>
	<tr><td colspan="3" height="1" bgcolor="d0d0d0"></td></tr>
	<tr><td>
		<table width="98%" align="center" cellspacing="0" cellpadding="0">
		
		<cfoutput query="External">
		
			<tr>
			    <td width="30" align="center">
				<cfif SESSION.isAdministrator eq "Yes" or  SESSION.acc eq url.OwnerId>
				  <img src="#SESSION.root#/Images/trash2.gif" style="cursor: pointer;" alt="remove document" 
				  onclick="del_att('#Objectid#','#documentid#','#url.ownerid#')">
				</cfif>
				</td>
				<td width="200">#DocumentDescription#:</td>
				<td>
				<cfif documentmode eq "Header">
				<cfset mode = "edit">
				<cfelse>
				<cfset mode = "inquiry">
				</cfif>
				<cfset box = "a#currentrow#">
				<cfinclude template="ProcessObjectAttachment.cfm">
				</td>
			</tr>
		
		</cfoutput>
		
		</table>
	</td></tr>	
	</table>
	
</cfif>