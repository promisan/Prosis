
<cfquery name="Update" 
	 datasource="AppsControl" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 	DELETE FROM Observation	
		WHERE  ObservationId = '#URL.Id#'	
</cfquery>	

<cfoutput>
	
	<script language="JavaScript1.1">
	 try {	
		opener.applyfilter('','','#URL.Id#') } catch(e) {}
	    window.close()
	</script>

</cfoutput>

