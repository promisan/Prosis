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
<!--- this template is to show pending internal and external taskorders
and show quantities received [external] or picked [internal  ---------- --->
<!--- ----------------------------------------------------------------- --->

<cfparam name="form.filter"      default="action">
<cfparam name="form.filtersub"   default="">
<cfparam name="url.actormode"    default="Recipient">

<cfif form.filter neq "">

  <cfset url.filter = form.filter>

<cfelse>

 <cfset url.filter = form.filtersub>

</cfif>

<cf_compression>

<cfquery name="param" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
   SELECT    *
   FROM      Ref_ParameterMission
   WHERE     Mission = '#url.mission#'  
</cfquery>

<cfif param.taskorderdifference neq "">

   <cfset diff = (100+param.taskorderdifference)/100>   

<cfelse>

   <cfset diff = "1">  

</cfif>

<cfoutput>

<cfinvoke component = "Service.Access"  
		method           = "WarehouseAccessList" 
		mission          = "#url.mission#" 					   					 
		Role             = "'WhsPick'"
		accesslevel      = "'2'" 					  
		returnvariable   = "FacilityAccess">
		
<cfif FacilityAccess eq "">
   <cfset FacilityAccess = "''">
</cfif>		

<!--- ----------------------------- --->
<!--- to be replaced by a component --->
<!--- ----------------------------- --->

<cfsavecontent variable="requestaccess">
			
	      SELECT  DISTINCT Warehouse 
	      FROM    Warehouse R
		  WHERE   Mission = '#url.mission#'
		  <!--- AND   Distribution = 1 --->
		  AND    (
		            R. MissionOrgUnitId IN (
			                       SELECT MissionOrgUnitId
			                       FROM   Organization.dbo.Organization Org, 
								          Organization.dbo.OrganizationAuthorization O, 
										  Organization.dbo.Ref_EntityAction A
								   WHERE  O.UserAccount = '#SESSION.acc#'									   
								   AND    O.Role        = 'WhsRequester'		
								   AND    O.OrgUnit     = Org.OrgUnit									   
								   AND    A.ActionCode  = O.ClassParameter
								   AND    A.ActionType  = 'Create' 
							   )
				    OR 
					R.Mission  IN (
						           SELECT Mission 
			                       FROM   Organization.dbo.OrganizationAuthorization O, Organization.dbo.Ref_EntityAction A 
								   WHERE  O.UserAccount = '#SESSION.acc#'
								   AND    O.Role        = 'WhsRequester'		
								   AND    O.Mission     = '#url.mission#'		
								   AND    A.ActionCode  = O.ClassParameter
								   AND    A.ActionType  = 'Create'		   
								   AND    (O.OrgUnit is NULL or O.OrgUnit = 0)
		   )   
		   )
				
</cfsavecontent>


</cfoutput>

<!--- ------------------------------------------------- --->
<!--- -------------- end of preparation --------------- --->
<!--- ------------------------------------------------- --->

<cfif url.filter neq "Completed">

<script>
	document.getElementById("pendingheader").className = "regular"
</script>
		
<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center" align="center" class="navigation_table">		  
			
	<tr><td valign="top">
				
		<table width="99%" style="border:0px solid silver" height="100%" cellspacing="0" cellpadding="0" align="center">
					
		<cfset headermode = "dummy">
		<cfinclude template="TaskViewRecipientHeader.cfm">
						
		<cfset row = 0>
		
		<cfinclude template="TaskViewRecipientLinesSubmission.cfm">
		
		<tr>
		<td id="search" colspan="13">
				
				<cfinvoke component = "Service.Presentation.TableFilter"  
				   method           = "tablefilterfield" 
				   name             = "linesearch"				  
				   filtermode       = "direct"
				   style            = "font:18px;height:25;width:120"
				   rowclass         = "clsRequest"
				   rowfields        = "creference">			
								
		</td>
		</tr>
					
		<cfif url.filter eq "" or (url.filter neq "Action" and url.filter neq "Purchase" and url.filter neq "Collect" and url.filter neq "Deliver")>
		
			<cfinclude template="TaskViewRecipientLinesPending.cfm">
			
			<cfif pendingRequests.recordcount eq "0">				
			
			<tr><td colspan="13" height="50" style="color:6688aa" align="center" class="labelmedium"><i>There are no pending requests</td></tr>
			<tr><td colspan="13" style="padding-top:4px" class="linedotted"></td></tr>
			</cfif>
		
		</cfif>
		
		<cfif url.filter eq "" or (url.filter eq "Action" or url.filter eq "Purchase" or url.filter eq "Collect" or url.filter eq "Deliver")>
										
			<cfinclude template="TaskViewRecipientLinesShipment.cfm">
			
			<cfif pendingShipment.recordcount eq "0">				
			
			<tr><td colspan="13" height="50" style="color:6688aa" align="center" class="labelmedium"><i>There are no pending deliveries/collections</td></tr>
			<tr><td colspan="13" style="padding-top:4px" class="linedotted"></td></tr>
			
			</cfif>
		
		</cfif>
				
		</table>			
	
	</td></tr>

</table>		

<cfelse>
	
	<script>
		try { document.getElementById("pendingheader").className = "hide" } catch(e) {}
	</script>
		
	<table width="98%" height="100%" border="0" cellspacing="0" cellpadding="0" align="center" align="center">		  
	
	<tr><td>
	
	<cfparam name="url.systemfunctionid" default="">
	<cfinclude template="TaskViewRecipientLinesCompleted.cfm">
	
	</td></tr>
	
	</table>

</cfif>

<cfset AjaxOnLoad("doHighlight")>	

