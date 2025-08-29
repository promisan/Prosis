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
<!--- Within the scope of the customer/workorder show all publication with actionstatus = 3

For a selected publication show by section (vertical/hirizontal, not sure)

Show area of the section and all pictures for that area ordered by date/time --->

<cf_screentop html="no" jquery="yes">

<style>
	body, td, div, select, .labelit, .labelmedium, .labellarge { 
		font-family: "Century Gothic", CenturyGothic, "Avant Garde", Avantgarde, "AppleGothic", Verdana, Arial, sans-serif;
	}
</style>

<cfoutput>
	<script>
		_cf_loadingtexthtml="<img src='#session.root#/images/busy10.gif' style='height:26px; width:26px;'>";
	</script>
</cfoutput>

<cfquery name="getPortal" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	*
		FROM   	Ref_ModuleControl
		WHERE  	SystemModule = 'SelfService'
		AND		FunctionClass = 'SelfService'
		AND		FunctionName = '#url.id#'
</cfquery>

<!--- get current defaults --->

<cfquery name="dwo" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	*
		FROM   	UserModuleCondition
		WHERE  	Account         = '#session.acc#'
		AND		SystemFunctionId = '#getPortal.systemFunctionId#'
		AND		ConditionClass = 'Default'
		AND		ConditionField = 'WorkOrder'
</cfquery>

<cfquery name="ddate" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	*
		FROM   	UserModuleCondition
		WHERE  	Account          = '#session.acc#'
		AND		SystemFunctionId = '#getPortal.systemFunctionId#'
		AND		ConditionClass   = 'Default'
		AND		ConditionField   = 'Date' 
</cfquery>

<!--- define if we show access to the customer --->

<cfquery name="Customer" 
	datasource="appsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#"> 
	SELECT    Mission, C.CustomerId, C.CustomerName, OrgUnit
	FROM      Customer C
	WHERE     Mission = '#client.Mission#' 
	<!--- has indeed one or more workorders assigned --->
	AND       Customerid IN (
	                         SELECT CustomerId 
	                         FROM   Workorder 
							 WHERE  Customerid = C.CustomerId
							 AND    Mission = '#client.Mission#'
							)
</cfquery>

<cfquery name="Roles" 
	datasource="appsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#"> 
	SELECT    Role
	FROM      Ref_AuthorizationRole
	WHERE     SystemModule = 'workorder'	
</cfquery>

<cfinvoke component = "Service.Access"  
	   method           = "WorkorderAccessList"  	   
	   mission          = "#mission#" 	  
	   Role             = "#QuotedvalueList(roles.Role)#"
	   returnvariable   = "Access">
	 
<!--- we show workorders that we indeed defined to have access for --->

<cfquery name="woList" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT	C.CustomerId,
				C.CustomerName,
				W.WorkOrderId,
				W.Reference,
				S.Description,
				(W.Reference + ' - ' + S.Description) as Display
		FROM	WorkOrder W  
		        INNER JOIN Customer C	 ON W.CustomerId  = C.CustomerId
				INNER JOIN ServiceItem S ON W.ServiceItem = S.Code
		<cfif Access neq "">		
		WHERE 	W.WorkorderId IN (#preservesingleQuotes(Access)#)
		<cfelse>
		AND		1=0
		</cfif>
		ORDER BY C.CustomerId, S.Description ASC 
</cfquery>

<cfset selWO = "00000000-0000-0000-000000000000">
<cfif dwo.recordCount gt 0>
	<cfset selWO = dwo.conditionValue>
</cfif>

<cfform name="frmPublicationView" style="height:100%;">

	<table width="99%" height="100%" align="center">
		<tr><td height="15"></td></tr>
		<tr>
			<td height="25" width="8%" class="labellarge"><cf_tl id="WorkOrder"></td>
			<td width="1%" class="labellarge">:</td>
			<td width="30%" style="padding-left:5px;">
				<cf_tl id="Please, select a workorder" var="1">
				
				<cfselect 
					name="workorderid" 
					id="workorderid" 
					query="woList" 
					display="Display" 
					value="workorderId" 
					group="CustomerName" 
					selected="#selWO#" 
					required="Yes" 
					class="regularxl"
					message="#lt_text#" 
					queryposition="below" 
					style="font-size:22px; height:40px;">
					<option value="">-- <cf_tl id="Select a workorder"> --
				</cfselect>
				
			</td>
			<td height="25" width="5%" class="labellarge"><cf_tl id="Publication"></td>
			<td width="1%" class="labellarge">:</td>
			<td width="40%" style="padding-left:5px;">
				<cfdiv id="divPublication" bind="url:Publication/setPublication.cfm?id=#url.id#&workOrderId={workorderid}">
			</td>
		</tr>
		<tr><td height="5"></td></tr>
		<tr>
			<td colspan="6" height="100%">
				<cf_divScroll height="100%">
					<cfdiv style="height:100%;" id="divDetail" bind="url:Publication/PublicationViewDetail.cfm?id=#url.id#&publicationId=">
				</cf_divScroll>
			</td>
		</tr>
		
	</table>

</cfform>

