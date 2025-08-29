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
<cfparam name="url.requestid"  default="">
<cfparam name="url.orgunit"    default="0">

<cfquery name="Line" 
   datasource="AppsWorkOrder" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
		 SELECT  *	
	     FROM    Request
		<cfif url.requestid eq "">
	WHERE 1=0
	<cfelse>
	WHERE  Requestid = '#url.requestid#'
	</cfif>		
</cfquery>

<cfif url.orgunit neq "0" and url.orgunit neq "">
		
	<cfquery name="Org" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   Organization
		WHERE  OrgUnit = '#url.orgunit#'	
	</cfquery>
	
<cfelse>
	
	<cfquery name="Org" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   Organization
		WHERE  OrgUnit = '#line.orgunit#'			
	</cfquery>
	
	<cfif Org.recordcount eq "0" and url.requestid eq "">
	
	    <!--- do no longer inherit this 21/9/2011
		
		<cfquery name="Last" 
		datasource="AppsWorkorder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT TOP 1 *
			FROM   Request
			WHERE  OfficerUserid = '#SESSION.acc#'	
			ORDER BY Created DESC
		</cfquery>
		
		<cfquery name="Org" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT *
			FROM   Organization
			WHERE  OrgUnit = '#Last.orgunit#'			
		</cfquery>
		
		--->
		
		<cfparam name="org.orgunit"     default="">
		<cfparam name="org.orgunitname" default="">
				
	</cfif>
	
</cfif>

<table width="400" height="100%" cellspacing="0" cellpadding="0">

<tr>

	<cfif org.recordcount eq "0">
		<td style="height:25px;font-size:13px;padding-left:3px;border-left:1px solid silver;padding-top:1px;padding-bottom:1px;border-right: 1px solid Silver;border-top: 1px solid Silver;border-bottom: 1px solid Silver;"></td>	
	</cfif>

	<cfoutput query="Org">
	
	<td style="width:2px">
		<script>
			document.getElementById('orgunit').value = "#org.orgunit#"
		</script>
	
	</td>
	<td style="height:25px;font-size:13px;padding-left:3px;border-left:1px solid silver;padding-top:1px;padding-bottom:1px;border-right: 1px solid Silver;border-top: 1px solid Silver;border-bottom: 1px solid Silver;">
	#Org.OrgUnitName#
	</td>
	
	</cfoutput>
	
</tr>

</table>
