
<cfquery name="PO" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT Distinct RC.ExecutionTemplate
    FROM   
	Purchase P, 
	PurchaseExecution PE, 
	PurchaseExecutionRequest PER,
	Ref_OrderClass RC
	WHERE  P.PurchaseNo=PE.PurchaseNo
	and PER.PurchaseNo=PE.PurchaseNo
	and PER.ExecutionId=PE.ExecutionId
	and PER.RequestId='#URL.ID#'
	and RC.Code=P.OrderClass
</cfquery>


<cfoutput>

<cfif PO.ExecutionTemplate neq "">

		
	<cfset path = replaceNoCase(PO.ExecutionTemplate,'\','\\','ALL')> 

	<script>	 	 
		 window.open("#SESSION.root#/Tools/Mail/MailPrepareOpen.cfm?id=print&ID1='#url.id#'&ID0=#path#","_blank", "left=30, top=30, width=800, height=600, toolbar=no, menubar=no, status=yes, scrollbars=no, resizable=no")
	</script>

<cfelse>
	<cf_tl id="No print format defined" var="1">
	<script>
	   alert("#lt_text#");
	</script>

</cfif>

</cfoutput>