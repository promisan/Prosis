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
<cfset claimId = replace(URL.claimid,' ','','ALL')>

<cfquery name="Object" 
   datasource="AppsOrganization"
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">	
		SELECT  *
		FROM    OrganizationObject
		WHERE   ObjectKeyValue4 = '#claimid#' 			
</cfquery>
	
<table width="98%" align="center" cellspacing="0" class="formpadding">

	<tr>
	<td colspan= "2" valign="top">
	
		<cf_InformationContent 
		SystemFunctionId = 'C9D63DF2-5056-B134-02A7-67461B372396'
		Id               = '#claimId#'
		columns          = 1>
	
	</td>

	<td valign = "top" style = "padding-top:15">
	
	<table width = "100%" height="100%">
	<cfif Object.recordcount gte "1">
	
		<cfquery name="InsertAttach" 
	    datasource="AppsOrganization"
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
		INSERT INTO OrganizationObjectDocument
		       (ObjectId,
			    DocumentId,
				DocumentCode,
				OfficerUserId, 
				OfficerLastName,
				OfficerFirstName)
		SELECT '#Object.ObjectId#',
		       DocumentId,
			   DocumentCode,
			   '#SESSION.acc#',
			   '#SESSION.last#',
			   '#SESSION.first#'
		FROM   Ref_EntityDocument
		WHERE  EntityCode = '#Object.EntityCode#' 
		AND    DocumentType = 'attach'
		AND    DocumentId NOT IN (SELECT DocumentId 
		                          FROM OrganizationObjectDocument 
								  WHERE ObjectId = '#Object.ObjectId#')
	    </cfquery>
	
		<cfquery name="Attachment" 
		 datasource="AppsOrganization"
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
		 SELECT *
		 FROM  OrganizationObject O,
		       OrganizationObjectDocument D, 
		       Ref_EntityDocument R 
		 WHERE O.ObjectId = D.ObjectId
		 AND   D.DocumentId = R.DocumentId
		 AND   O.ObjectKeyValue4  = '#ClaimId#'	
		 AND   D.Operational = 1
		 ORDER BY R.DocumentCode
		</cfquery>
		
				
		<tr><td height="10" colspan="2"></td></tr>
		
		<cfloop query="Attachment">
		
			<cfoutput>
				<tr>
								    
				<td height="24" class="labelit">#DocumentDescription#:</td>
				<td>			
					
					<cfset box = "bs#currentrow#">		
								
				
					<cfif documentmode eq "Header">
					
						<cf_filelibraryN
						DocumentPath  = "#EntityCode#"
						SubDirectory  = "#ObjectId#" 
						Filter        = "#DocumentCode#"						
						LoadScript    = "0"		
						Width         = "98%"
						Box           = "#box#"
						Insert        = "yes"
						Remove        = "yes">	
										
					<cfelse>				
						<cf_filelibraryN
						DocumentPath  = "#EntityCode#"
						SubDirectory  = "#ObjectId#" 
						Filter        = "#DocumentCode#"				
						Width         = "98%"
						LoadScript    = "0"	
						Box           = "#box#"
						Insert        = "no"
						Remove        = "no">													
	
					</cfif>				
		
					</td>
				</tr>
				
				
				<tr><td colspan="2" class="line"></td></tr>
				
			</cfoutput>
		</cfloop>
		
	<cfelse>
	
		<!--- provision --->
	
		<cfoutput>
				<tr class="labelmedium">
				    
					<td style="padding-left:20px" width="200"><cf_tl id="Attachments">:</td>
					<td>				
										
						<cf_filelibraryN
						DocumentPath  = "#Object.EntityCode#"
						SubDirectory  = "#claimid#" 
						Filter        = "Generic"										
						Width         = "100%"
						LoadScript    = "0"							
						Insert        = "yes"
						Remove        = "yes">		
		
					</td>
				</tr>
									
			</cfoutput>
	
	</cfif>	
	</table>	
	
	</td>	 
	</tr>
</table>
