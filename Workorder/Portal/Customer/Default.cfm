
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
				('[' + W.Reference + '] ' + S.Description) as Display
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

<cfform name="frmDefaultValues" action="#session.root#/WorkOrder/Portal/Customer/DefaultValuesSubmit.cfm?id=#url.id#">

	<cfoutput>
		<input type="Hidden" id="systemFunctionId" name="systemFunctionId" value="#getPortal.systemFunctionId#">
		<table width="98%" align="center">
			<tr><td height="10"></td></tr>
			<tr>
				<td height="25" width="15%" class="labelit"><cf_tl id="Workorder">:</td>
				<td colspan="2">
					<cf_tl id="Please, default workorder" var="1">
					
					<cfselect 
						name="workOrderId" 
						query="woList" 
						display="Display" 
						value="workorderId" 
						group="CustomerName" 
						selected="#selWO#" 
						required="Yes" 
						class="regularxl"
						message="#lt_text#" 
						queryposition="below">
						<option value="">-- <cf_tl id="Select a workorder"> --
					
					</cfselect>
					
				</td>
			</tr>
			<tr>
				<td height="25" width="15%" class="labelit"><cf_tl id="Date">:</td>
				<td width="15%">
					<cf_tl id="Please, select a valid date criteria" var="1">
					<cfselect 
						name="dateCriteria" 
						id="dateCriteria" 
						required="Yes" 
						class="regularxl"
						message="#lt_text#" 
						onchange="if (this.value == 4) { $('##tblDateDetail').css('display','block'); } else { $('##tblDateDetail').css('display','none'); } ;">
							<option value="">-- <cf_tl id="Select a date criteria"> --
							<option value="1" <cfif ddate.conditionValue eq "1">selected</cfif>><cf_tl id="Always Today">
							<option value="2" <cfif ddate.conditionValue eq "2">selected</cfif>><cf_tl id="Always Tomorrow">
							<option value="3" <cfif ddate.conditionValue eq "3">selected</cfif>><cf_tl id="Always Yesterday">
							<option value="4" <cfif ddate.conditionValue neq "1" and ddate.conditionValue neq "2" and ddate.conditionValue neq "3" and ddate.recordCount gt 0>selected</cfif>><cf_tl id="Specific Date">
					</cfselect>
				</td>
				<td>
					<cfset vDisplay = "display:none;">
					<cfset vDate = now()>
					<cfif ddate.conditionValue neq "1" and ddate.conditionValue neq "2" and ddate.conditionValue neq "3" and ddate.recordCount gt 0>
						<cfset vDisplay = "">
						<cfset vDate = ddate.conditionValue>
					</cfif>
					
					<table cellspacing="0" cellpadding="0" id="tblDateDetail" style="#vDisplay#">
						<tr>
							<td>
								<cf_intelliCalendarDate9
									FieldName="specificDate"
									Message="Select a valid default date"
									Default="#dateformat(vDate, CLIENT.DateFormatShow)#"
									class="regularxl"
									AllowBlank="False">
							</td>
						</tr>
					</table>
				</td>
			</tr>
			<tr><td height="10"></td></tr>
			<tr><td colspan="3" class="line"></td></tr>
			<tr><td height="10"></td></tr>
			<tr>
				<td colspan="3" align="center">
					<cf_tl id="Save" var="1">
					<cf_button type="Submit" name="btnSubmit" id="btnSubmit" value="#lt_text#">
				</td>
			</tr>
		</table>
	</cfoutput>

</cfform>