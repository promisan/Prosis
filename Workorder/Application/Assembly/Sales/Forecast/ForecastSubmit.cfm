
<cfset vValue = 0>
<cfset vVariation = 0>

<cfset vTest = 0>
<cfset vTest = evaluate("url.value")>
<cfset vTest = trim(vTest)>
<cfset vTest = replace(vTest, ",", "", "ALL")>
<cfif isNumeric(vTest)>
	<cfset vValue = INT(vTest)>
</cfif>

<cfset vTest = 0>
<cfset vTest = evaluate("url.variation")>
<cfset vTest = trim(vTest)>
<cfset vTest = replace(vTest, ",", "", "ALL")>
<cfif isNumeric(vTest)>
	<cfset vVariation = INT(vTest)>
</cfif>

<cf_DatePeriodLeap 
	year="#url.year#" 
	period="#url.period#"
	leap="#url.itemperiod#">

<cfset vRequestDue = leapDate>

<cfquery name="delete" 
	datasource="appsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
		DELETE 	
		FROM	ServiceItemCustomerRequest
		WHERE	ServiceItem = '#url.serviceItem#'
		AND		CustomerId = '#url.customerId#'
		AND		RequestDue = #vRequestDue#
		AND		ItemNo = '#url.ItemNo#'
		AND		UoM = '#url.UoM#'
		
</cfquery>

<cf_assignId>

<cfquery name="insert" 
	datasource="appsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
		INSERT INTO ServiceItemCustomerRequest
			(
				RequirementId,
				ServiceItem,
				CustomerId,
				RequestDue,
				RequestQuantity,
				RequestVariation,
				ItemNo,
				UoM,
				Operational,
				ActionStatus,
				OfficerUserId,
				OfficerLastName,
				OfficerFirstName
			)
		VALUES
			(
				'#RowGuid#',
				'#url.serviceItem#',
				'#url.customerId#',
				#vRequestDue#,
				'#vValue#',
				'#vVariation#',
				'#url.ItemNo#',
				'#url.UoM#',
				'1',
				'0',
				'#session.acc#',
				'#session.last#',
				'#session.first#'
			)
		
</cfquery>


<cfset vSaveColor = "##13C432">
<cfoutput>
	<script>
		$('##fc_#url.ItemNo#_#url.UoM#_#url.itemPeriod#').val('#vValue#');
		$('##fc_var_#url.ItemNo#_#url.UoM#_#url.itemPeriod#').val('#vVariation#');
		$('##td_#url.ItemNo#_#url.UoM#_#url.itemPeriod#').css('background-color','#vSaveColor#');
	</script>
</cfoutput>