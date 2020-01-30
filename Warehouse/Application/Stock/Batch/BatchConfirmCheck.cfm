	
<cf_compression>		

<cfquery name="Check"
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   *
	FROM     ItemTransaction
	WHERE    TransactionBatchNo = '#URL.BatchNo#'
	AND      ActionStatus = '0'
</cfquery>

<cfoutput>
	
<cfif check.recordcount eq "0">

	<script language="JavaScript">
	try {  document.getElementById("actionbox").className = "regular" } catch(e) {}		
	</script>
				
	<cf_tl id="Confirm" var="1">
		
	<cf_button onclick="batchdecision('confirm')" 
		   name="Confirm" 
		   id="Confirm"
		   mode="greenlarge" 
		   label="#lt_text#" 
		   label2="transaction" 
		   icon="images/selectDocument.gif">		   
				   
</cfif>

</cfoutput>
