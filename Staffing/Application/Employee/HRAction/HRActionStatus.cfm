
<cfquery name="Check" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT     *
		FROM       PersonAction
	    WHERE PersonActionId = '#url.id#'
	</cfquery>	

<cfif check.actionStatus eq "9">

	<cf_tl id="Cancelled">
	
<cfelse>
   
    <cfif check.actionstatus eq "1">
	   <cf_tl id="Cleared">
	<cfelse>
	   <font color="FF0000"><cf_tl id="Pending">
   </cfif>
   
</cfif>		