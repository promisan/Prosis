
<!--- apply gl account --->

<cfquery name="clear" 
		datasource="appsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		DELETE  WorkOrderThreshold			
		WHERE   WorkOrderId   = '#url.workorderid#'			
		AND     WorkorderLine = '#url.workorderline#'
</cfquery>

<cfif Form.thresholddateeffective neq "">
	    <CF_DateConvert Value="#Form.thresholddateeffective#">
		<cfset eff = dateValue>
	<cfelse>
	    <cfset eff = "">
	</cfif>	

<cfif LSIsNumeric(form.thresholdamount) 
    AND eff neq "" 
	AND form.thresholdamount neq "0">
	
	<cfquery name="insert" 
				datasource="appsWorkOrder" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				INSERT INTO WorkOrderThreshold			
				(WorkOrderId, 
				 WorkOrderLine, 
				 DateEffective, 
				 Charged, 
				 Threshold, 
				 OfficerUserId, 
				 OfficerLastName, 
				 OfficerFirstName)
	           VALUES (
			   '#url.workorderid#',
			   '#url.workorderline#',
			   #eff#,
			   '1',
			   '#form.thresholdamount#',
			   '#SESSION.acc#',
			   '#SESSION.last#',
			   '#SESSION.first#'
			   )			
	</cfquery>
	
	<font color="008000">Saved!</font>
	
<cfelse>

	<cfoutput><font color="FF0000">Revoked</font></cfoutput>	

</cfif>

				
	
