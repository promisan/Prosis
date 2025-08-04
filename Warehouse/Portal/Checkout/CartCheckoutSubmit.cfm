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

<!--- space for validations on the form that is submitted --->

<cfif Form.OrgUnit eq "">

	  <cf_waitEnd Frm="result">	
      <cf_tl id="Your have to identify a unit." var="1">
	  <cf_alert message = "#lt_text#">
	  <cfabort>
	  
</cfif>

<cfset url.resultRequisitionNo = "">
<cfinclude template="../../Application/StockOrder/Request/Create/RequestEntrySubmitAction.cfm">

<cfquery name="Parameter"
   datasource="AppsMaterials"
   username="#SESSION.login#"
   password="#SESSION.dbpw#">
	SELECT *
	FROM   Ref_ParameterMission
	WHERE  Mission = '#URL.mission#'
</cfquery>

<cfoutput>

<script language="JavaScript">

	alert("Your request was successfully submitted.");
	
	// we show the request as a PDF to be printed
	<cfif url.resultRequisitionNo neq "">
	 	window.open("../../../Tools/Mail/MailPrepareOpen.cfm?id=print&ID1=#url.resultRequisitionNo#&ID0=#Parameter.RequisitionTemplateMultiple#","_blank", "left=30, top=30, width=800, height=600, toolbar=no, menubar=no, status=yes, scrollbars=no, resizable=no");
	</cfif>
	
	// we refresh the entry screen which will now be blank
	ColdFusion.navigate('Checkout/CartCheckoutContent.cfm?process=refresh&mission=#url.mission#&webapp=#url.webapp#','main');
	
	// we also refresh the portal request screen to show request and refresh the yellow bar  
	se = document.getElementById('details')
	if (se) {
	filter = document.getElementById('filter').value
	ColdFusion.navigate('#SESSION.root#/warehouse/application/stockorder/task/Process/TaskViewRecipientLines.cfm?mission=#url.mission#&filter='+filter,'details')
	}
	
	// we also refresh the portal home screen to show request and refresh the yellow bar  
	se = document.getElementById('checkpending')
	if (se) {
	ColdFusion.navigate('#session.root#/warehouse/portal/checkout/checkPending.cfm?mission=#url.mission#','checkpending')	
	}
	
	// we also refresh
</script>
	
</cfoutput>  



