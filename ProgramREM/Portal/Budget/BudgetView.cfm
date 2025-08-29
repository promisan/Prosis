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
<head>
<cfoutput>
<script type="text/javascript">
  // Change cf's AJAX "loading" HTML
  _cf_loadingtexthtml="<div><img src='#SESSION.root#/images/busy5.gif'/>";
</script>
</cfoutput>
</head>

<cfoutput>

<cfif Client.googlemapid neq "">
   <cfajaximport tags="cfmap,cfwindow" params="#{googlemapkey='#client.googlemapid#'}#">
</cfif>

<cfquery name="System" 
datasource="AppsSystem">
	SELECT *
	FROM   Ref_ModuleControl
	WHERE  SystemModule   = 'SelfService'
	AND    FunctionClass  IN ('SelfService','Portal')
	AND    FunctionName   = '#URL.ID#' 
</cfquery>

<cfparam name="URL.Label"    default="ICT">
<cfparam name="URL.PersonNo" default="#client.PersonNo#">
	  
<cfajaximport tags="cfchart">

<cf_dialogREMProgram> 
<cf_dialogOrganization>
<cf_dialogStaffing>
<cf_ListingScript>
<cf_MenuScript>
<cf_dialogPosition>
<cf_dialogProcurement>
<cf_dropdown>

<!--- populate slide menu --->

<style type="text/css">
<!--
A.ssmItems:link		{color:black;text-decoration:none;}
A.ssmItems:hover	{color:black;text-decoration:none;}
A.ssmItems:active	{color:black;text-decoration:none;}
A.ssmItems:visited	{color:black;text-decoration:none;}

html,
	body {
		background-color: transparent;
	}
	
//-->
</style>

<script language="JavaScript1.2" src="ssm.js"></script>
<cf_slideMenu functionname="#url.id#">

<cf_screentop html="no" layout="webapp" scroll="yes" user="no" banner="blank">

<table width="100%" height="100%"  align="center" border="0" cellspacing="0" cellpadding="0">

<!--- top menu --->

<cfparam name="url.mission" default="#system.FunctionCondition#">
										
<cfquery name="Parameter" 
datasource="AppsProgram">
	SELECT *
	FROM   Ref_ParameterMission
	WHERE  Mission = '#url.mission#'	
</cfquery>
		
<cfquery name="Period" 
datasource="AppsOrganization">
	SELECT *
	FROM   Ref_MissionPeriod
	WHERE  Mission = '#url.mission#'
	AND    Period  = '#Parameter.BudgetPortalPeriod#'			
</cfquery>
		
<cfif Period.recordcount eq "1">
		
	<cfset url.mode     = "PRG">		
	<cfset url.mandate  = "#Period.MandateNo#">		
	<cfset url.period   = "#parameter.BudgetPortalPeriod#">	
	<cfset url.edition  = "#parameter.BudgetPortalEdition#">
		
	<cfinclude template = "BudgetViewScript.cfm">
	
	<cfset url.portal   = "1">		

	<cfquery name="PortalOrg" 
	   datasource="AppsOrganization" 
	   username="#SESSION.login#" 
	   password="#SESSION.dbpw#">
		   SELECT    *
		   FROM      Organization
		   WHERE     MandateNo = '#URL.Mandate#'
			 AND     Mission   = '#URL.Mission#' 
			 <cfif getAdministrator("*") eq "0">
			 AND     OrgUnit IN (
			                     SELECT OrgUnit 
			                     FROM   OrganizationAuthorization
						    	 WHERE  Mission     = '#URL.Mission#'
							     AND    UserAccount = '#SESSION.acc#'
							     AND    Role IN ('BudgetOfficer','BudgetManager')
							     )							  
			</cfif>		
			AND      SourceGroup = 'Budget'					  
			ORDER BY HierarchyCode 					
	</cfquery>
	
	<cfif PortalOrg.recordcount eq "0">
	
		<cfquery name="PortalOrg" 
		   datasource="AppsOrganization" 
		   username="#SESSION.login#" 
		   password="#SESSION.dbpw#">
			   SELECT *
			   FROM   Organization
			   WHERE  MandateNo = '#URL.Mandate#'
				 AND  Mission   = '#URL.Mission#' 
				 <cfif getAdministrator("*") eq "0">
				 AND  OrgUnit IN (SELECT OrgUnit 
				                  FROM   OrganizationAuthorization
								  WHERE  Mission = '#URL.Mission#'
								  AND    UserAccount = '#SESSION.acc#'
								  AND    Role IN ('BudgetOfficer','BudgetManager'))								  
				</cfif>									  
				ORDER BY HierarchyCode 					
		</cfquery>
		
	</cfif>
	
	<!--- general text --->
	<cfif len(system.functioninfo) gt "30">
	
		<tr id="infobox" class="hide">
			<td>
			<table width="96%" align="center">
				<tr><td><cfoutput>#System.FunctionInfo#</cfoutput></td></tr>
			</table>
		    </td>
		</tr>	
		
	</cfif>	
	
	<tr><td colspan="2">
					
		<table cellspacing="0" cellpadding="0" bgcolor="white">
		<tr>
		
			<td height="25" style="padding-left:20px;padding-right:4px">
	
	        <!---
			
			<input type = "button" 
			  class     = "button10s" 
			  style     = "width:120px" 
			  name      = "InitBudget" 
			  onclick   = "init()"
			  value     = "Refresh">
			  
			  --->
	
			</td>
			
			<cfparam name="url.id1" default="#PortalOrg.OrgUnit#">		
			
			<cfif PortalOrg.recordcount gte "2">
			
				 <td>
							 					  
				  <select name="orgunit" style="font:11px" onchange="selectmenu('budget')">
				  
					  <cfloop query="PortalOrg">
						  <option value="#OrgUnit#" <cfif url.id1 eq orgunit>selected</cfif>>
						   <cfif Len(OrgUnitName) gt 40>#hierarchycode# #Left(OrgUnitName, 40)#...<cfelse>#hierarchycode# #OrgUnitName#</cfif>		
					      </option>
					  </cfloop>		
				  	  
				  </select>
				  
				  </td>
				  
			<cfelse>
					
				<input type="hidden" name="orgunit" value="#portalOrg.orgunit#">	  
						  
			</cfif>	  
			
			
							
			<td height="25" colspan="2" align="right">
		
				<table>
				
				<!---
				
				<tr>
				
				<td>
					<img src="#SESSION.root#/images/information.gif"  style="cursor:pointer" alt="Submission info" border="0" onclick="info()">	
				</td>
				
				<script>
				
				 function info() {		  
					  se = document.getElementById("infobox")
					  if (se.className == "hide") {
					     se.className = "regular" 
					  } else {
				    	 se.className = "hide" 
					  }
				  }
				 
				</script>
				
				--->
				
				<cfif PortalOrg.recordcount gte "1">
				
				<td>&nbsp;&nbsp;|&nbsp;&nbsp;</td>	
				
				<td style="cursor:pointer"><font face="Verdana">
				    <a href="javascript:selectmenu('budget')" title="Requirements and Budget Preparation">#URL.Label# Budget Requirements</a></font>
				</td>	
				
				<td id="budget" class="regular" bgcolor="ffffaf">
					
					<table width="100%" cellspacing="0" cellpadding="0">
					
						<tr>
						<td>&nbsp;:&nbsp;</td> 
						<td height="20" class="regular" id="budgetchart" onClick="toggle('budget','chart')" style="cursor:pointer">
												
							<img src="#SESSION.root#/images/graph2.gif" id="charticon" align="absmiddle"  alt="Show Chart" border="0">				
								Show Graph
							
						</td>
						
						<td class="hide" id="budgetlist" onClick="toggle('budget','list')" style="cursor:pointer">
						
						<img src="#SESSION.root#/images/listing.gif" height="15" width="15" align="absmiddle" id="charticon" alt="Show Chart" border="0">					
								Show Listing
								
						</td>
						
						</tr>
						
					</table>
			
				</td>
				
				<cfif Parameter.BudgetPortalMode eq "1">
				
				<td>&nbsp;&nbsp;|&nbsp;&nbsp;</td>			
				<td><a href="javascript:selectmenu('staffing')" title="Staffing Table"><font face="Verdana">#URL.Label# Staffing</td>
				
				</cfif>
				
				<td>&nbsp;&nbsp;|&nbsp;&nbsp;</td>		
				
				<td style="cursor:pointer" style="padding-right:20px"><font face="Verdana">
				<a href="javascript:selectmenu('service')" title="Service Inventory">#URL.Label# Service Inventory</a></font></td>
				
				<td id="service" class="hide" bgcolor="ffffaf" style="padding-right:20px">
			
					<table width="100%" cellspacing="0" cellpadding="0">
						
						<tr>	
						    <td>&nbsp;:&nbsp;</td> 
							<td height="20" class="regular" id="servicechart" onClick="toggle('service','chart')" style="cursor:pointer">
													
								<img src="#SESSION.root#/images/graph2.gif" id="charticon" align="absmiddle"  alt="Show Chart" border="0">				
									Show Graph
								
							</td>
							
							<td class="hide" id="servicelist" onClick="toggle('service','list')" style="cursor:pointer">
							
							<img src="#SESSION.root#/images/listing.gif" align="absmiddle" id="charticon" alt="Show Chart" border="0">					
									Show Listing
									
							</td>
							
						</tr>
					</table>
					
				</td>
				
				</cfif>
												
				</tr>
		</table>	
			
	</td></tr>
	
	</table>	
			
	</td></tr>
		
	<tr>
	<td valign="top" height="100%" bgcolor="white">
			
		<table width="96%" height="100%"  align="center" border="0" cellspacing="0" cellpadding="0">
							
			<cfif PortalOrg.recordcount eq "0">
			
			<tr>
				<td id="menucontent" align="center">							
				<b><font size="3" color="FF0000">No access was granted. Please contact administrator</font></b>				
				</td>
			</tr>
				
			<cfelse>	
			
					<cfparam name="url.header" default="Portal">
					<cfparam name="URL.ID1"    default="#PortalOrg.OrgUnit#">  
					<cfparam name="URL.ID4"    default="">  				
					
					<!--- special script for customer handling --->		
					<cfinclude template="../../../System/Organization/Customer/CustomerScript.cfm">
					
					<!--- special script for staffing handling --->
					<cfinclude template="../../../Staffing/Application/Position/MandateView/MandateViewGeneralScript.cfm">
		  									
				<tr>
				<td id="menucontent" valign="top">						
					<cfinclude template="BudgetViewAction.cfm">								
				</td>
				</tr>	
				
			</cfif>
			
		</table>
		
	</td>	
	</tr>
	
	<cfelse>
			
		<br><b><font color="FF0000">Problem, configuration file missing</font></b>
		<cfoutput>
		#parameter.BudgetPortalPeriod#<br><br><br>
		#url.mission#
		</cfoutput>
		
	</cfif>

</table>

</cfoutput>	 

