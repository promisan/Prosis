
<cfquery name="Verify" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM stLedgerRouting
	WHERE RoutingNo = '#Form.RoutingNo#' 
</cfquery>


<cfif Verify.RecordCount eq 1> 
	<cfquery name="qUpdate" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE stLedgerRouting
		SET 
		ReconcileMode  = '#FORM.mode#',
		NOVA_GlAccount = '#FORM.glaccount#' ,
		NOVA_Object    = '#FORM.obj#',
		NOVA_Fund      = '#FORM.fund#'
		WHERE RoutingNo = '#FORM.RoutingNo#'
    </cfquery>
    <cfoutput>
	<script language="JavaScript">
		 try {			   	   
			window.opener.applyfilter('1','','#FORM.RoutingNo#') } 
		 catch(e) 
		 	{
				alert('test');	 
				returnValue = 1
			}
	     window.close()
	</script>
	</cfoutput>      
</cfif>	
	
