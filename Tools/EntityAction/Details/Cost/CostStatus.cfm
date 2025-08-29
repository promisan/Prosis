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
<cfparam name="url.toggle" default="0">

<cfoutput>

<cfif url.toggle eq "1">
	
	<cfquery name="Record"
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT *
		FROM   OrganizationObjectActionCost
		WHERE  ObjectCostId = '#ObjectCostId#'
	</cfquery>
	
	<cfif record.actionStatus is "0">
	  <cfset st = "1">
	   <script>
		   document.getElementById("check#url.row#").className = "regular"
       </script>
	<cfelse>  
	  <cfset st = "0">
	   <script>
		   document.getElementById("check#url.row#").className = "hide"
	   </script>
	</cfif>

	<cfquery name="Update"
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	UPDATE OrganizationObjectActionCost
	SET actionStatus    = '#st#',
	   actionStatusUserId = '#SESSION.acc#',
	   actionStatusDate = getDate() 
	WHERE  ObjectCostId = '#ObjectCostId#'
   </cfquery>
   		
</cfif>

<cfquery name="Record"
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM   OrganizationObjectActionCost
	WHERE  ObjectCostId = '#ObjectCostId#'
</cfquery>

<!--- show result --->

	<table cellspacing="0" cellpadding="0" class="formpadding"><tr>		
		<td width="45" align="center">	
				
			   <cfif record.actionstatus eq "0">
		
			    <img src="#SESSION.root#/Images/light_red3.gif"
			     border="0"
				 alt="Enable"
				 onClick="costtoggle('#ObjectCostId#','#url.row#')"
				 align="absmiddle"
			     style="cursor: pointer;">	
			
			   <cfelse>
			    
			     <img src="#SESSION.root#/Images/light_green2.gif"
			     border="0"
				 alt="Disable"
				 onClick="costtoggle('#ObjectCostId#','#url.row#')"
				 align="absmiddle"
			     style="cursor: pointer;">
									
   			   </cfif>			  
		</td>
			
</cfoutput>	

</tr></table>
