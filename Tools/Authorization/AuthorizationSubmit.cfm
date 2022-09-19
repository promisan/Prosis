
<!--- dialog which has module and mission as reference --->
    
<cfquery name="getAut"
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT  *
	FROM    Ref_ModuleControlAuthorization
	WHERE   Mission = '#url.mission#'
	AND     SystemFunctionId = '#url.systemfunctionid#'
	<!--- AND     Account = '#session.acc#' --->
	AND     DateEffective <= getDate() and DateExpiration >= getDate()
	AND     AuthorizationCode = '#url.val#'	
	
</cfquery>	

<cfoutput>

<cfif getAut.recordcount eq "0">
	
	<script>	
		alert('invalid authorization')
		ProsisUI.closeWindow('authorizationwindow')	
	</script>

<cfelse>

	<script>		
		document.getElementById('#url.object#').readOnly = false
		document.getElementById('#url.object#').focus()
		ProsisUI.closeWindow('authorizationwindow')	
	</script>

</cfif>

</cfoutput>
