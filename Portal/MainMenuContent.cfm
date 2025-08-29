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
	<cfset Attributes.Heading    = "Main">
	<cfset Attributes.Module     = "'System'">
	<cfset Attributes.Selection  = "">
	<cfset Attributes.Class      = "">
	
	<cfparam name="client.modulecontrol" default="">
	<cfparam name="menudone" default="">
	
	<!--- we determine based on the access to the modules which is derrived from the system function access 
	which modules a users should have access to and then we go up to determine which applications to show --->
		
	<cfinclude template="../tools/SubmenuPrepare.cfm">	
		
	<cfset list = QuotedValueList(SearchResult.SystemModule)>
	
			
<cfquery name="qGroup" 
	     datasource = "AppsSystem" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
			SELECT    DISTINCT  A.Code, A.Description, A.ListingOrder, A.MenuIcon
			FROM      xl#Client.LanguageId#_Ref_Application A INNER JOIN Ref_ApplicationModule M ON
				      A.Code = M.Code AND A.Usage = 'System'
			<cfif list neq "">		  
			WHERE     M.SystemModule IN (#PreserveSingleQuotes(List)#)	
			<cfelse>
			WHERE     1 = 0
			</cfif>
			AND       M.SystemModule != 'System' 
			AND       M.Operational = '1'
			AND       M.Operational = '1'
			ORDER BY  A.ListingOrder
	</cfquery>
	
	<cfoutput>
	
	<ul class="main-ca-menu">
	
	<cfloop query = "qGroup">
	
		<cfif client.modulecontrol neq "">
			<cfif client.modulecontrol eq Description>
				<cfset mselected = "menutitleactive">
				<cfset menudone = "1">
			<cfelse>
				<cfset mselected = "">
			</cfif>
		<cfelse>
			<cfif currentrow eq "1">
				<cfset mselected = "menutitleactive">
			<cfelse>
				<cfset mselected = "">
			</cfif>
		</cfif>
		
				
	    <li class="menutitle #mselected# #MenuIcon#">
		
			<span onclick="togglemenu(this)" class="mitem">
			<!--- use #menuclass# --->
               
				#Description#
                
	    </span>

			<!--- 10/7/2014 added provision to show the system administration function for tree role mananger --->
			
			<cfquery name="getTreeRoleManager" username="#SESSION.login#" password="#SESSION.dbpw#" 
			   datasource = "AppsOrganization">
					SELECT TOP 1 * 
					FROM   OrganizationAuthorization 
					WHERE  UserAccount = '#session.acc#' 
					AND    Role = 'OrgUnitManager'					
					AND    AccessLevel = '3' <!--- support --->
			</cfquery>			
							
			<cfquery name="qModules_per_group" username="#SESSION.login#" password="#SESSION.dbpw#" 
			   datasource = "AppsSystem">
					SELECT  DISTINCT M.SystemModule, 
					        SML.Description, 
							SM.MenuIcon, 
							SML.Hint
					FROM    Ref_Application A 
							INNER JOIN Ref_ApplicationModule M ON A.Code = M.Code AND A.Usage = 'System'
							INNER JOIN Ref_SystemModule SM     ON SM.SystemModule = M.SystemModule 
							INNER JOIN xl#Client.LanguageId#_Ref_SystemModule SML ON SM.SystemModule = SML.SystemModule 
					WHERE   <cfif qGroup.Code eq "AD" and (getAdministrator("*") eq "1" or getTreeRoleManager.recordcount gte "1")>	
					        <!--- to ensure this is visible for the tree role manangers --->											
							(M.SystemModule IN (#PreserveSingleQuotes(List)#) or M.SystemModule = 'System')
							<cfelse>
							M.SystemModule IN (#PreserveSingleQuotes(List)#)
					        </cfif> 	
					AND     A.Operational = '1'
					AND     M.Operational = '1'
					AND     A.Usage = 'System'
					AND     A.Code  = '#qGroup.Code#'
					AND     SM.SystemModule != 'Portal' and SML.Description != 'Self service'
			</cfquery>	
				
			<ul class="ca-menu">	
						
			<cfloop query="qModules_per_group">	
								    			
					<li class="menuitem" id="#SystemModule#">
						<!--- <img src="images/full_screen.png" class="imgfullscreen" onclick="loadrightpanel('#SystemModule#','#qGroup.Description#')"> --->
						<span class="imgfullscreen" onclick="loadrightpanel('#SystemModule#','#qGroup.Description#')"></span>
					     <a onclick="loadrightpanel('#SystemModule#','#qGroup.Description#')">
					     <span class="ca-icon #SystemModule#"></span>
					     <div class="ca-content">						      
					          <h2 class="ca-main">#Description#</h2>							  
					          <h3 class="ca-sub">#Hint#</h3>
					     </div>								
					     </a>
				   </li>
				   
			</cfloop>
			
			</ul>
			
		</li>

	</cfloop>
	
	</cfoutput>
	
	</ul>
		
				
		