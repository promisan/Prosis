
<cfquery name="Check" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT     *
		FROM       PersonContract
	    WHERE ContractId = '#url.id#'
	</cfquery>	

<cfif check.actionStatus eq "9">

	<cf_tl id="Cancelled">
	
<cfelse>
   
    <cfif check.mandateNo neq "">
	   <font color="0080FF"><cf_tl id="Carry-over"></font> 
	<cfelseif check.actionstatus eq "1">
	   <cf_tl id="Cleared">
	<cfelse>
	   <font color="FF0000"><cf_tl id="Pending">
   </cfif>
   
</cfif>	

<script>

 try {
 document.getElementById('dependentbox').className = "hide"
 } catch(e) {}
 
</script>	