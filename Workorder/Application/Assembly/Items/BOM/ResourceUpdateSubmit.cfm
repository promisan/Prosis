
<cfset qty = replaceNoCase(FORM.Quantity,",","")> 
<cfset prc = replaceNoCase(FORM.Price,",","")> 

<cfquery name="qUpdate" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">	 
	UPDATE WorkOrderLineResource 
	SET    Quantity     = '#qty#',
	       Price        = '#prc#',
	       Memo         = '#Left(Trim(FORM.Remarks),100)#',
		   ResourceMode = '#Form.ResourceMode#'
    WHERE  ResourceId   = '#URL.ResourceId#'    									  
</cfquery>

<cfoutput>
<script>
	ColdFusion.Window.hide('adddetail');
	try {
		window.applyfilter('1','','#URL.ResourceId#')
	}
	catch(e){}	
</script>
</cfoutput>