
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>"> 

<cfparam name="Form.Operational"      default="1">
<cfparam name="Form.EnableContract"   default="0">
<cfparam name="Form.EnableAmount"     default="0">
<cfparam name="Form.TriggerCondition" default="None">
<cfparam name="Form.EntitlementClass" default="Rate">

<cfset trg = replace(Form.SalaryTrigger," ","","ALL")>

<cfif ParameterExists(Form.Insert)> 
	
	<cfquery name="Verify" 
	datasource="AppsPayroll" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM Ref_PayrollTrigger
		WHERE SalaryTrigger  = '#Form.SalaryTrigger#' 
	</cfquery>

   <cfif Verify.recordCount is 1>
   
   <script language="JavaScript">
   
     	alert("A record with this code has been registered already!")
     
   </script>  
  
   <cfelse>   
		
		<cfquery name="Insert" 
		datasource="AppsPayroll" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		INSERT INTO Ref_PayrollTrigger
		         (SalaryTrigger, 
				  Description, 
				  TriggerGroup, 
				  TriggerCondition, 
				  TriggerConditionPointer,
				  EnableAmount,
				  TriggerInstruction,
				  EntitlementClass, 
				  EnableContract, 
				  EnablePeriod,
				  Operational)
		  VALUES ('#trg#',
        		  '#Form.Description#', 
				  '#Form.TriggerGroup#',
				  '#Form.TriggerCondition#',
				  '#Form.TriggerConditionPointer#',
				  '#Form.EnableAmount#',
				  '#Form.TriggerInstruction#',
				  '#Form.EntitlementClass#',
				  '#Form.EnableContract#',
				  '#Form.EnablePeriod#',
				  '#Form.Operational#')</cfquery>
		     		  
    </cfif>		  
           
</cfif>

<cfif ParameterExists(Form.Update)>
	
	<cfquery name="Update" 
	datasource="AppsPayroll" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE Ref_PayrollTrigger
		SET SalaryTrigger           = '#trg#', 
			Description             = '#Form.Description#', 
			TriggerGroup            = '#Form.TriggerGroup#', 
			TriggerCondition        = '#Form.TriggerCondition#', 
			TriggerConditionPointer = '#Form.TriggerConditionPointer#',
			TriggerInstruction      = '#Form.TriggerInstruction#',
			TriggerDependent		= '#Form.TriggerDependent#',
			EnableAmount            = '#Form.EnableAmount#',
			EntitlementClass        = '#Form.EntitlementClass#', 
			EnableContract          = '#Form.EnableContract#', 
			EnablePeriod            = '#Form.EnablePeriod#',
			Operational             = '#Form.Operational#' 
		WHERE SalaryTrigger         = '#Form.CodeOld#'
	</cfquery>
	
</cfif>	

<cfif ParameterExists(Form.Delete)> 
	
	<cfquery name="CountRec"
	datasource="AppsPayroll" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
		FROM Ref_PayrollComponent
		WHERE SalaryTrigger = '#Form.CodeOld#'
	</cfquery>
    
    <cfif CountRec.recordCount gt 0>
		 
     <script language="JavaScript">
    
	   alert("Code is in use. Operation aborted.")
	        
     </script>  
	 
    <cfelse>
	
	
			
	<cfquery name="Delete" 
	datasource="AppsPayroll" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	DELETE FROM PersonEntitlement
	WHERE SalaryTrigger    = '#Form.CodeOld#'
    </cfquery>
	
	<cfquery name="Delete" 
	datasource="AppsPayroll" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	DELETE FROM PersonDependentEntitlement
	WHERE SalaryTrigger    = '#Form.CodeOld#'
    </cfquery>
				
	<cfquery name="Delete" 
	datasource="AppsPayroll" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	DELETE FROM Ref_PayrollTrigger
	WHERE SalaryTrigger    = '#Form.CodeOld#'
	</cfquery>
			
	</cfif>
		
</cfif>	

<script language="JavaScript">
   
     window.close()
	 opener.history.go()
        
</script>  
