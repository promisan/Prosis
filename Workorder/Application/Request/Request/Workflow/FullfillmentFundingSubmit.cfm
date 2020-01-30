
<cfif form.Fundingid neq "">
	
	<cfquery name="setstatus"
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	   UPDATE  Request
	   SET     FundingId       = '#Form.FundingId#'
	   WHERE   RequestId       = '#Object.ObjectKeyValue4#'	
	</cfquery>		

</cfif>