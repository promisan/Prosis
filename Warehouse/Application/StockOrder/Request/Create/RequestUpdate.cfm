
<!--- update the request --->

<cfquery name="update" 
  datasource="AppsMaterials" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
      UPDATE Request
	  SET    #url.field# = '#url.value#'
	  WHERE  RequestId = '#url.requestid#'	  
</cfquery>

<cf_compression>