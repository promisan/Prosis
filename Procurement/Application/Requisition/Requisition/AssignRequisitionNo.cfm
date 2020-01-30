

<cflock timeout="30" throwontimeout="No" name="SerialNo" type="EXCLUSIVE">
	
		<cfquery name="Parameter" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT *
		    FROM Ref_ParameterMission
			WHERE Mission = '#URL.Mission#' 
		</cfquery>
		
		<cfif Parameter.recordcount eq "0" or Parameter.MissionPrefix eq "">
		
			<cf_tl id="REQ017" var="1">
			<cfset vReq017=#lt_text#>			
			<cf_message message="#vReq017# : Prefix">
			<cfabort>
		
		</cfif>
			
		<cfset No = Parameter.RequisitionNo+1>
		<cfif No lt 10000>
		     <cfset No = 10000+No>
		</cfif>
			
		<cfquery name="Update" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    UPDATE Ref_ParameterMission
			SET    RequisitionNo = '#No#'
			WHERE  Mission = '#URL.Mission#' 
		</cfquery>
	
</cflock>