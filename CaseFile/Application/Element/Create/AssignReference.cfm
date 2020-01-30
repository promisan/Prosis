
<cflock timeout="30" throwontimeout="No" name="SerialNo" type="EXCLUSIVE">
	
		<cfquery name="Parameter" 
		datasource="AppsCaseFile" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT *
		    FROM Ref_ElementClass
			WHERE Code = '#URL.elementClass#' 
		</cfquery>
		
		<!--- check if number is used --->
							
		<cfset ser = Parameter.ReferenceSerialNo+1>
		
		<cfif len(ser) eq "1">
			 <cfset num = "0000#ser#">
		<cfelseif len(ser) eq "2">
		     <cfset num = "000#ser#">
		<cfelseif len(ser) eq "3">
			 <cfset num = "00#ser#">
		<cfelseif len(ser) eq "4">
			 <cfset num = "0#ser#">		
		</cfif>
		
		<cfset ref = "#Parameter.ReferencePrefix##num#">
					
		<cfquery name="Update" 
		datasource="AppsCaseFile" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    UPDATE Ref_ElementClass
			SET    ReferenceSerialNo = '#ser#'
			WHERE  Code = '#URL.elementClass#' 			
		</cfquery>
	
</cflock>