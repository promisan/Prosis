<cfquery name="Delete" 
datasource="appsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	DELETE FROM Ref_AddressType
	WHERE CODE = '#url.id1#'
   </cfquery>

<cf_ModuleControlLog systemfunctionid="#url.idmenu#" 
      action="Delete" 
	 content="#form#">

<script>
    window.close()
	opener.location.reload()
</script>  