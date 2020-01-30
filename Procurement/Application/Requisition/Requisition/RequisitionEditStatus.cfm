
<cfparam name="url.id" default="">
<cfparam name="url.requisitionNo" default="#url.id#">

<cfquery name="Line" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT  *
	FROM    RequisitionLine
	WHERE   RequisitionNo = '#url.requisitionNo#'	
</cfquery>	

<cfquery name="Status" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT  *
	FROM    Status
	WHERE   StatusClass = 'Requisition' 
	AND     Status      = '#Line.ActionStatus#'
</cfquery>	
		
<cfif Line.ActionStatus eq "0">
  <cfset c = "blue">
<cfelseif Line.ActionStatus eq "9"> 
  <cfset c = "red"> 
<cfelse>
  <cfset c = "black"> 
</cfif>

<cfoutput>
    <table><tr><td class="labelmedium">
	<font color="#c#">#Status.StatusDescription# (#Line.ActionStatus#)</font>
	</td></tr></table>
</cfoutput>
