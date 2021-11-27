
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

<cfset dateValue = "">
<cfif Form.PayrollStart neq ''>
    <CF_DateConvert Value="#Form.PayrollStart#">
    <cfset PAY = dateValue>
<cfelse>
    <cfset PAY = 'NULL'>
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
						  PayrollStart       = #PAY#,
						  PayrollItem        = '#Form.Entitlement#',
						  DocumentReference  = '#Form.DocumentReference#',
						  EntitlementClass   = '#Form.EntitlementClass#',
						  <cfif form.EntitlementClass neq "Deduction">
						  <!--- the user removed the option to process as deduction --->
							  Source             = 'Manual',
							  SourceId           = NULL,							  	
						  <cfelseif form.Ledger neq "">
						  	  Source            = 'Ledger',								  
							  SourceId           = '#Form.Ledger#',
						  <cfelse>
						  	  Source             = 'Manual',
							  SourceId           = NULL,		
     					  </cfif>						
						  Currency           = '#Form.Currency#',
						  Amount             = '#Form.Amount#',
						  Remarks            = '#Remarks#'
				   WHERE  PersonNo           = '#Form.PersonNo#' 
				   AND    CostId             = '#Form.CostId#' 
			   </cfquery>
		   
		  </cfif> 
	  
	  </cfif>
	  
<cfoutput>
	
 <script>
	 ptoken.location("EmployeeMiscellaneous.cfm?ID=#Form.PersonNo#&Status=#URL.Status#");
 </script>	
 
</cfoutput>	   
	
</cfif>	
	


