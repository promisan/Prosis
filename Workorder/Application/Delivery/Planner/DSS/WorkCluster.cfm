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
<!DOCTYPE html>

<cfparam name="URL.mission" 	default = "">
<cfparam name="URL.date" 		default = "06/01/2015">
<cfparam name="URL.id" 			default = "">
<cfparam name="URL.step" 		default = "1">
<cfparam name="URL.loadmode" 	default = "">
<cfparam name="SESSION.unit_scope" 	default = "">

<cfset SESSION.WorkPlanMission = URL.mission>

<cfinclude template="../../getTreeData.cfm">

<cfif SESSION.unit_scope neq "" and units eq "">
	<cfset units = SESSION.unit_scope>
<cfelse>
	<cfset SESSION.unit_scope = units>	
</cfif>	


<div id="dResult" name="dResult"></div>

<cfset VARIABLES.Instance.dateSQL = DateFormat(URL.date,"DDMMYYY")/>

<cfset vInit = FALSE>
<cfset vOverwrite = FALSE>
<cfinclude template="WorkClusterPrepare.cfm">


<cfif NOT vInit>
	<cfquery name="qAllUnits"
		datasource="AppsTransaction" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT DISTINCT OrgUnitOwner, O.OrgUnitName
	    FROM   stNodes_#SESSION.WorkPlanMission#_#VARIABLES.Instance.dateSQL# N INNER JOIN Organization.dbo.Organization O
	       ON N.OrgUnitOwner = O.OrgUnit
		WHERE  Date = #dts#
	</cfquery>
</cfif>


<cfif url.loadmode neq "pass">
	<cfif units eq "">
		<cfset vOverwrite = false>
	<cfelse>
		<!---- compare with existing ---->	
		<cfif isdefined('qAllUnits')>
			<cfset Existing_Scope = ValueList(qAllUnits.OrgUnitOwner)>
			<cfif ListLen(Existing_Scope) neq ListLen(Units)>
				<cfset vOverwrite = true>
			<cfelse>
				<cfloop list="#units#" index="j">
					<cfif NOT ListContains(Existing_Scope,j)>
						<cfset vOverwrite = true>
						<cfbreak>
					</cfif>	
				</cfloop>					
			</cfif>
		</cfif>			
	</cfif>
<cfelse>
		<cfset SESSION.unit_scope = ValueList(qAllUnits.OrgUnitOwner)>
</cfif>


<cfoutput>
	<cfif StructKeyExists(SESSION,"unit_scope")>
		<input type="hidden" id="input_unit_scope" name="input_unit_scope" value="#SESSION.unit_scope#">
	<cfelse>
		<input type="hidden" id="input_unit_scope" name="input_unit_scope" value="">
	</cfif>	
</cfoutput>


<cfif vOverwrite or vInit>
		<cfinclude template="WorkClusterOverwrite.cfm">
<cfelse>
		
	<cfoutput>
		
	<table height="100%" width="100%">
	
	<tr><td height="100%" width="100%">
	
	<cf_divscroll>
	
	<table border="0" cellspacing="0" cellpadding="0" align="center" height="100%" width="100%">

		<tr>
			<td colspan="2" align="center" valign="center">
				<cfinclude template="WorkClusterProgressBar.cfm">		
			</td>	
		</tr>		
		<tr class="labellarge" id="rdProgressBar">			
			<td valign="top" height="100%" width="100%" style="padding:5px;border:0px solid gray" id="dDContent" name="dDContent">				
				<cfinclude template="WorkClusterContent.cfm">
			</td>
			<td valign="top" align="left" style="height:100%;padding:5px;border-left:1px solid gray" width="50%">
				<cfdiv bind="url:#client.root#/WorkOrder/Application/Delivery/Planner/DSS/WorkClusterMap.cfm?mission=#url.mission#&id=#URL.ID#&Step=#URL.Step#&date=#URL.date#" ID="dss_map"/>
			</td>	
		</tr>	
		<tr><td id="process"></td></tr>												
	</table>
	
	</cf_divscroll>
	
	</td></tr></table>
	
	</cfoutput>
	
</cfif>

<cfset ajaxOnload('block_selection')>

