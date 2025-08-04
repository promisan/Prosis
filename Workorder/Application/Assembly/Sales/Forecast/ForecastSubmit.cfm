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