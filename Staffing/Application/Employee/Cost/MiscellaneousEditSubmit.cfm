
<cfif Len(Form.Remarks) gt 100>
  <cfset remarks = left(Form.Remarks,100)>
<cfelse>
  <cfset remarks = Form.Remarks>
</cfif>  

<cf_systemscript>

<cfset dateValue = "">
<CF_DateConvert Value="#Form.DateEffective#">
<cfset STR = dateValue>

<cfset dateValue = "">
<cfif Form.DocumentDate neq ''>
    <CF_DateConvert Value="#Form.DocumentDate#">
    <cfset END = dateValue>
<cfelse>
    <cfset END = 'NULL'>
</cfif>	

<!--- verify if record exist --->

<cfquery name="Entitlement" 
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM   PersonMiscellaneous
WHERE  PersonNo = '#Form.PersonNo#' 
AND    CostId   = '#Form.CostId#'
</cfquery>

<cfparam name="Entitlement.RecordCount" default="0">

<cfif Entitlement.recordCount eq 1> 
	
	<cfif ParameterExists(Form.Delete)> 
	
		 <cfquery name="EditEntitlement" 
		   datasource="AppsPayroll" 
		   username="#SESSION.login#" 
		   password="#SESSION.dbpw#">
		   DELETE FROM PersonMiscellaneous		 
		   WHERE  PersonNo = '#Form.PersonNo#' 
		   AND    CostId   = '#Form.CostId#' 
	    </cfquery>

	<cfelse>
	
		 <cfquery name="check" 
		   datasource="AppsPayroll" 
		   username="#SESSION.login#" 
		   password="#SESSION.dbpw#">
		   SELECT * FROM Ref_PayrollItem
		   WHERE PayrollItem = '#Form.Entitlement#'		  
	    </cfquery>	
		
		<cfif check.recordcount eq "1">
		
		 <cfquery name="EditEntitlement" 
		   datasource="AppsPayroll" 
		   username="#SESSION.login#" 
		   password="#SESSION.dbpw#">
			   UPDATE PersonMiscellaneous
			   SET    DateEffective      = #STR#,
					  DocumentDate       = #END#,
					  PayrollItem        = '#Form.Entitlement#',
					  DocumentReference  = '#Form.DocumentReference#',
					  EntitlementClass   = '#Form.EntitlementClass#',
					  Currency           = '#Form.Currency#',
					  Amount             = '#Form.Amount#',
					  Remarks            = '#Remarks#'
			   WHERE  PersonNo           = '#Form.PersonNo#' 
			   AND    CostId             = '#Form.CostId#' 
		   </cfquery>
		   
		  </cfif> 
	  
	  </cfif>
	  
<cfoutput>

<cfset oSecurity = CreateObject("component","Service.Process.System.UserController")/>
<cfset mid = oSecurity.gethash()/>  
	
 <script>
	 ptoken.location("EmployeeMiscellaneous.cfm?ID=#Form.PersonNo#&Status=#URL.Status#&mid=#mid#");
 </script>	
 
</cfoutput>	   
	
</cfif>	
	


