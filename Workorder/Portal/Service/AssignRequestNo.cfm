
<cflock timeout="30" throwontimeout="No" name="SerialNo" type="EXCLUSIVE">
	
		<cfquery name="Parameter" 
		datasource="AppsWorkorder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT *
		    FROM   Ref_ParameterMission
			WHERE  Mission = '#Mission#' 
		</cfquery>
		
		<cfif Parameter.recordcount eq "0" or Parameter.RequisitionPrefix eq "">
					
			<cf_alert message="Invalid Reference">
			<cfabort>
		
		</cfif>
			
		<cfset No = #Parameter.RequisitionSerialNo#+1>
		<cfif No lt 10000>
		     <cfset No = 10000+#No#>
		</cfif>
			
		<cfquery name="Update" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    UPDATE Ref_ParameterMission
			SET    RequisitionSerialNo = '#No#'
			WHERE  Mission = '#Mission#' 
		</cfquery>
		
		<cfset reference = "#Parameter.RequisitionPrefix#-#No#">
	
</cflock>