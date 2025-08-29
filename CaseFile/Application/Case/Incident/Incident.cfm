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
<cfparam name="wf" default="1">
<cfparam name="URL.ID" default="">
<cfparam name="URL.TabNo" default="1">
<cfparam name="URL.TabName" default="1">

<cfif url.id neq "">
	
	<cfquery name="Action" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM  OrganizationObjectAction A, OrganizationObject O
		WHERE A.ObjectId = O.ObjectId
		AND   A.ActionId = '#URL.ID#'
	</cfquery>
	
	<cfparam name="URL.claimid" default="#Action.ObjectKeyValue4#">

</cfif>

<cfquery name="Claim" 
datasource="AppsCaseFile" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT  *
	FROM    Claim
	WHERE   ClaimId = '#URL.ClaimId#'	
</cfquery>

<!--- determine overall access --->
	 
<cfinvoke component = "Service.Access"  
	    method           = "CaseFileManager" 
		mission          = "#Claim.Mission#" 	
		claimtype        = "#Claim.ClaimType#"   
	    returnvariable   = "accessLevel">	
		
<!--- ------------------------------------------------------------------------------ --->
<!--- check if access to the tabs is granted based on the fly access settings in wf- --->
<!--- ------------------------------------------------------------------------------ --->
				
<cfif accesslevel eq "NONE">
	
	<cfset accessgranted = "">
											
	<cfif Object.ObjectId neq "">
							
		<cfinvoke component = "Service.Access"  
	    method           = "AccessEntityFly" 	   
		ObjectId         = "#Object.Objectid#"
	    returnvariable   = "accessgranted">	
				
		<!--- return NULL, 0 (collaborator), 1 (processor) --->
			
	</cfif>
			
<cfelse>
		
		<cfset accessgranted = "2">
		
</cfif>						

<cfif accessLevel eq "EDIT" or accessLevel eq "ALL">
    <cfset mode = "Edit">
<cfelse>
	<cfset mode = "View">
</cfif>   

<cfoutput>

<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0" align="center">
								
		<tr><td width="100" valign="top" style="border-right:1px dotted silver; padding-right:3px;">
				
			<table width="100" cellspacing="0" cellpadding="0" class="formpadding">			
			
			<tr>		
								 		  
			  <cfset wd = "48">
			  <cfset ht = "48">		  
						
			  <cfset itm = 1>		
			 							
			  <cf_menutab  item       = "#itm#" 
         			        base       = "subtab_#url.tabno#"
							target     = "subtabtarget_#url.tabno#"
				            iconsrc    = "Logos/Workorder/General.png" 
							iconwidth  = "#wd#" 
							iconheight = "#ht#" 	
							class      = "highlight1"						
							name       = "About Incident"
							source     = "#SESSION.root#/casefile/application/case/Incident/IncidentDetail.cfm?box=subtabtarget_#url.tabno##itm#&mode=#mode#&claimId=#URL.claimId#">
							

				</tr>
											
				<!--- ---------------------------- --->
			    <!--- --custom code for UNHQ only- --->
				<!--- ---------------------------- --->
				
				<!--- hide for collaborator --->				
				
				<cfif accessGranted gte "1">
				
					<cfset itm = itm+1>
					
					<tr>
				
					<cf_menutab item       = "#itm#" 
					            iconsrc    = "Logos/Location.png" 
								base       = "subtab_#url.tabno#"
								target     = "subtabtarget_#url.tabno#"
								targetitem = "#itm#"
								iconwidth  = "#wd#" 								
								iconheight = "#ht#" 																
								name       = "Notes"
								source     = "#SESSION.root#/casefile/application/case/ClaimMemo/ClaimMemo.cfm?target=contentsubtabtarget_#url.tabno##itm#&claimid=#url.claimid#">								
								
						</tr>		
											
				</cfif> 				
			
			     <cfquery name="myTabs" 
						datasource="AppsCaseFile" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						SELECT   *
						FROM     Ref_ClaimTypeTab
						WHERE    Code = '#Claim.ClaimType#'	
						AND      TabName != 'Control'
						AND      Mission = '#Claim.mission#'
						AND      (ClaimTypeClass is NULL or ClaimTypeClass = '#claim.ClaimTypeClass#')
						AND      Operational = 1
						
						<!--- hardcoded --->					
						AND      TabNameParent = '#url.tabname#'
						
						ORDER BY TabOrder				    
				</cfquery>	
																				 
				<cfloop query="mytabs">
							
					<!--- ----------------------------------------------------------- --->
					<!--- define if the tab will be shown based on the value 0, 1, 2- --->
					<!--- ----------------------------------------------------------- --->
					
					<cfif accessgranted gte accesslevelread and accessgranted neq "">		
					
						<cfset itm = itm+1>
						
						<tr>
						
						<cfif tabtemplate eq "element">
						
							<cf_menutab base       = "subtab_#url.tabno#"
							            item       = "#itm#" 
							            target     = "subtabtarget_#url.tabno#"
							            iconsrc    = "#TabIcon#" 
										iconwidth  = "#wd#" 
										iconheight = "#ht#" 
										name       = "#TabLabel#"
										source     = "../../Element/Listing/ElementView.cfm?tabname=#itm#&claimId=#URL.claimId#&elementclass=#TabElementClass#">
						
						<cfelseif ModeOpen eq "Bind">
							
							<cf_menutab base       = "subtab_#url.tabno#"
										item       = "#itm#" 
							            target     = "subtabtarget_#url.tabno#"
							            iconsrc    = "#TabIcon#" 
										iconwidth  = "#wd#" 
										iconheight = "#ht#" 
										name       = "#TabLabel#"
										source     = "#TabTemplate#?tabname=#itm#&claimId=#URL.claimId#">
										
						<cfelse>
							
							<cf_menutab base       = "subtab_#url.tabno#"
										item       = "#itm#" 
							            target     = "subtabtarget_#url.tabno#"
							            iconsrc    = "#TabIcon#" 
										iconwidth  = "#wd#" 
										iconheight = "#ht#" 
										name       = "#TabLabel#">
												
						</cfif>		
							
						</tr>	
										
					</cfif>		
					
			
				</cfloop>
							 
			  </table>
			  </td>		  
		  
		  	  <td height="100%" valign="top">
		  		 		  
			  <table height="100%" width="99%" align="center">	
			  
				  
			  			  					  
				  <cfset itm = 1>				  				  
				  
				  <cf_menucontainer name="subtabtarget_#url.tabno#" item="#itm#" class="regular">
				 							 	
					 <cfset url.box = "subtabtarget_#url.tabno##itm#">			 				  
				     <cfinclude template="IncidentDetail.cfm">
				  
				  <cf_menucontainer>
				  
				  <cfif accessGranted gte "1">
				  				  
				 	 <cfset itm = itm+1>
				 	 <cf_menucontainer name="subtabtarget_#url.tabno#" item="#itm#" class="hide">
				  
				  </cfif>
			  
				  <cfloop query="mytabs">
				  					
						<cfif accessgranted gte accesslevelread and accessgranted neq "">		
																				
							<cfset itm = itm+1>
							
							<cfif tabtemplate neq "Embed">						
								<cf_menucontainer name="subtabtarget_#url.tabno#" item="#itm#" class="hide">					
							<cfelse>								
							    <cf_menucontainer name="subtabtarget_#url.tabno#" item="#itm#" class="hide">					
									<cfinclude template="#TabTemplate#">
								</cf_menucontainer>						
							</cfif>
						
						</cfif>
										
				</cfloop>
								
				</table>
		  		  
		  </td>
		  </tr>
		
	
</table>	
	
</cfoutput>	

<cfset ajaxonload("doCalendar")>
				


