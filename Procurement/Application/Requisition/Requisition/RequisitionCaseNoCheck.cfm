<cfparam name="URL.CaseNo" default="">
<cfparam name="URL.RequisitionNo" default="">

<cfquery name="Check" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT * 
	FROM   RequisitionLine
	WHERE  CaseNo='#URL.CaseNo#'
	<cfif URL.RequisitionNo neq "">
	AND    RequisitionNo != '#URL.RequisitionNo#'
	</cfif>
</cfquery>

<cfoutput>

	<cfif check.recordcount gt "0">
	
		<script>
			alert("Problem, CaseNo [#URL.CaseNo#] has been recorded already.")
		</script>
		<font color="green"><img src="#SESSION.root#/Images/alert4.gif" align="absmiddle" alt="Value has been used before" width="16" height="15" border="0"></font>
		
	
	<cfelse>
	
		<font color="green"><img src="#SESSION.root#/Images/check_mark3.gif" align="absmiddle" alt="Value has not been used before" width="16" height="15" border="0"></font>
		
	</cfif>
	
	
	
</cfoutput>	
		
		