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

<!--- launch document from the my clearances listing --->

<cfparam name="url.target" default="0">
<cfparam name="url.portal" default="">

<cftry>

	<cfparam name="url.myclentity" default="">
	
	<cfset client.LogonPage = "default">
	
	<cfquery name="Object" 
	 datasource="AppsOrganization">
	 SELECT *
	 FROM OrganizationObject 		
	 WHERE (ObjectId = <cfqueryparam
						value="#URL.ID#"
						cfsqltype="CF_SQL_IDSTAMP"> 
	 OR ObjectKeyValue4 = <cfqueryparam
						value="#URL.ID#"
						cfsqltype="CF_SQL_IDSTAMP"> )
	 AND Operational  = 1  
	</cfquery>
	
	<!---
	
	This option to show in the portal under my menu is no longer supported : Hanno 8/5/2023 
	
	<cfif url.portal eq "">
	
	    <cfquery name="Portal" 
		 datasource="AppsSystem">	
			SELECT        *
			FROM         Ref_ModuleControl
			WHERE        SystemModule = 'Selfservice' AND FunctionClass = 'Selfservice' AND FunctionCondition = '#Object.Mission#' AND Operational = 1
			ORDER BY Created DESC
		</cfquery>
		
		<cfset url.portal = Portal.FunctionName>
			
	</cfif>
	
	--->
	
	<cfif url.myclentity eq "">
	   <cfset mycl = object.entitycode>
	<cfelse>
	   <cfset mycl = url.myclentity>   
	</cfif>
		
	<cfif Object.recordcount gte "1" and Object.ObjectURL neq "">	
	
		<cfquery name="Entity" 
		 datasource="AppsOrganization">
		 	 SELECT *
			 FROM   Ref_Entity
			 WHERE  EntityCode = '#Object.EntityCode#'	 
		</cfquery>
		
		
		
		<cfif url.target eq "0" or url.portal eq "">
		
			    <cfset client.refer = "workflow">
				
				<cfparam name="hashvalue" default="">
																											
			    <cfinvoke component="Service.Process.System.Security" method="passtru" returnvariable="hashvalue"/>		
																																								
			    <cfif find("myclentity=",Object.ObjectURL)>				
				     <!--- prevent duplication --->
					<cflocation url="#SESSION.root#/#Object.ObjectURL#?#hashvalue#" addtoken="No"> 
				<cfelseif find("refer=",Object.ObjectURL)>							
					<cflocation url="#SESSION.root#/#Object.ObjectURL#&mycl=1&myclentity=#mycl#&#hashvalue#" addtoken="No"> 			
				<cfelse>			
					<cflocation url="#SESSION.root#/#Object.ObjectURL#&mycl=1&myclentity=#mycl#&refer=workflow&#hashvalue#" addtoken="No"> 
				</cfif>	
				
		<cfelse>
		
				
				<cfset client.ObjectId   = object.objectid>
				<cfset client.ActionCode = url.actionCode>
				
				lllllll
				<cfabort>
								
		        <cflocation  url="#session.root#/portal/selfservice/public.cfm?id=#url.portal#&mission=#object.mission#&target=1">
		
		</cfif>		
		
		
	<cfelse>
		
	<cf_screentop html="No" title="Problem">
	
	<table width="90%" height="90" class="formpadding" cellspacing="0" cellpadding="0">
	<tr><td align="center" style="font-size:23px;color:red" class="labelmedium">
	
		<cfif Object.ObjectURL eq "">			
			<b>Attention:</b> Document could not be redirected.<br><font size="2">(Please contact your administrator)		
		<cfelse>	
	  		<b>Attention:</b> Requested document has been processed already or does not longer exist.	
		</cfif>
		
	</td></tr>
	</table>
	
	</cfif>

<cfcatch>

	<cf_screentop html="No" title="Problem">
	
	<table width="90%" height="100" cellspacing="2" cellpadding="2">
	<tr><td align="center" style="padding-top:28px;color:red;font-size:23px" class="labelmedium">	
	  Requested action could not be retrieved. <br><font size="2">(Please contact your administrator if the problem persists).</font>	
	</td></tr></table>

</cfcatch>

</cftry>

