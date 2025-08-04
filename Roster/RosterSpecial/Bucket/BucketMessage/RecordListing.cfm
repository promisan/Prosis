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

<cfparam name="url.message" default="6">

<cfquery name="Check" 
    datasource="AppsSelection" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
     SELECT *
	 FROM   FunctionOrganizationMessage
	 WHERE  FunctionId = '#url.idFunction#'			
</cfquery>

<cfif Check.recordcount lt "#url.message#">
	
	<cfloop index="itm" from="#Check.recordcount+1#" to="6">
		
		<cfquery name="Insert" 
		    datasource="AppsSelection" 
		    username="#SESSION.login#" 
		    password="#SESSION.dbpw#">
		     INSERT INTO FunctionOrganizationMessage
			 (FunctionId)
			 VALUES
			 ('#url.idFunction#')			
		</cfquery>
	
	</cfloop>

</cfif>

<cfquery name="getList" 
    datasource="AppsSelection" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
     SELECT *
	 FROM   FunctionOrganizationMessage
	 WHERE  FunctionId = '#url.idFunction#'			
</cfquery>

<table width="100%" height="100%">
	
	<tr><td height="45">
	
		<table width="100%" height="100%" border="0" align="center" cellspacing="0" cellpadding="0">		  		
							
				<cfset ht = "40">
				<cfset wd = "40">
																
				<tr>		
				
					<cfloop query="getList">	
					  					  
					  <cfif currentrow eq "1">
					  	<cfset cl = "highlight">
					  <cfelse>
					  	<cfset cl = "regular">
					  </cfif>
					  						
					  <cf_menutab item       = "#currentrow#" 					            
						        iconsrc    = "Logos/System/Message.png" 
								iconwidth  = "#wd#" 
								iconheight = "#ht#" 
								targetitem = "#currentrow#"
								class      = "#cl#"
								name       = "Message #currentrow#"
								source     = "">	
					
					</cfloop>				
																		 		
				</tr>
				
		</table>
	
	</td></tr>

	<tr><td class="linedotted"></td></tr>
	
	<tr>
		<td style="padding-left:5px;padding-right:5px" height="100%" valign="top">
		
			<table width="100%" height="100%" cellspacing="0" cellpadding="0" class="formpadding">
				
				<cfloop query="getList">
					
					<cfif currentrow eq "1">
						<cfset cl = "regular">
					<cfelse>
						<cfset cl = "hide">
					</cfif>
				
					<cf_menucontainer item="#currentrow#" class="#cl#">
					
						<cfset box = "content#currentrow#">
					    <cfset messageid = getList.Messageid>
						<cfinclude template="MessageEdit.cfm">
						
					</cf_menucontainer>	
				
				</cfloop>
				
				
			
			</table>
		
		</td>
	</tr>

</table>