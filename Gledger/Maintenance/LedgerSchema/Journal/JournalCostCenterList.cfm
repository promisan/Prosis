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
<cfparam name="url.orgunit" default="">
<cfparam name="url.action" default="insert">

<cfif url.orgunit neq "">
	
	<cfif url.action eq "insert">
		
		<cfquery name="Insert" 
			datasource="AppsLedger" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				INSERT INTO JournalOrgUnit
				
						(Journal,
						 OrgUnit,
						 OfficerUserId,
						 OfficerLastName,
						 OfficerFirstName)
						 
				VALUES	('#url.id1#',
	   				     '#url.orgunit#',
					     '#session.acc#',
					     '#session.last#',
					     '#session.first#')	
		</cfquery>			
	
	<cfelse>
	
		<cfquery name="Delete" 
			datasource="AppsLedger" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			DELETE FROM JournalOrgUnit
			WHERE  Journal = '#url.id1#'
			AND    OrgUnit = '#url.orgunit#'		
		</cfquery>		
	
	</cfif>

</cfif>

<cfquery name="Org" 
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT    O.Mission, 
		          O.MandateNo, 
				  O.OrgUnit, 
				  O.OrgUnitCode, O.OrgUnitName
		FROM      JournalOrgUnit JO INNER JOIN
	              Organization.dbo.Organization O ON JO.OrgUnit = O.OrgUnit
		WHERE     JO.Journal = '#url.id1#'	  
		ORDER BY  O.MandateNo
</cfquery>			
	
	<table width="100%" cellspacing="0" cellpadding="0" class="navigation_table">
			
			<tr class="labelmedium line">
				<td width="3%" align="center"></td>
				<td width="15%"><cf_tl id="Period"></td>
				<td width="10%" class="labelit"><cf_tl id="Code"></td>
				<td width="60%" class="labelit"><cf_tl id="Name"></td>			
			</tr>
						
			<cfoutput query="Org">	
		
				<tr class="line labelmedium navigation_row">
					<td style="padding-left:3px;width:30px" class="navigation_action">
						<cf_img icon="delete" 
						 onclick="_cf_loadingtexthtml='';ColdFusion.navigate('JournalCostCenterList.cfm?id1=#url.id1#&action=delete&orgunit=#orgunit#','myprocess')">
					</td>
					<td>#MandateNo#</td>
					<td>#OrgUnitCode#</td>
					<td>#OrgUnitName#</td>						
				</tr>
						
			</cfoutput>
		
	</table>	