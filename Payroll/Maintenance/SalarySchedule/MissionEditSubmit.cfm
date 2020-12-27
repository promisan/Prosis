 
<cf_wait Text="Saving schedule components">

<cfif url.action eq "delete">
 
<cfquery name="Delete"
  datasource="AppsPayroll" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
     DELETE FROM SalaryScheduleMission
	 WHERE  SalarySchedule  = '#URL.Schedule#'
	 AND    Mission  = '#URL.Mission#' 
</cfquery>

<cfelseif url.action eq "update">

	<cfset dateValue = "">
	<CF_DateConvert Value="#form.DateEffective#">
	<cfset STR = dateValue>
			
	<cf_verifyOperational 
	         datasource= "appsSystem"
	         module    = "Accounting" 
			 Warning   = "No">
	  
	<cfquery name="Update"
	  datasource="AppsPayroll" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	     UPDATE SalaryScheduleMission
		 SET    DateEffective          = #STR#	 	 
		  <cfif operational eq "1">
		  , GLAccount = '#Form.GLAccount#'
		  </cfif>	 	
		  	 	
		 WHERE  SalarySchedule  = '#URL.Schedule#'
		 AND    Mission  = '#URL.Mission#'
	</cfquery>
	
	<cfquery name="Update"
	  datasource="AppsPayroll" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	     DELETE FROM SalaryScale
		 WHERE  SalarySchedule  = '#URL.Schedule#'
		 AND    Mission  = '#URL.Mission#'
		 AND    SalaryEffective < #STR#
	</cfquery>
	
	<cfquery name="Clear"
	  datasource="AppsPayroll" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	     DELETE FROM EmployeeSalary
		 WHERE  SalarySchedule  = '#URL.Schedule#'
		 AND    Mission  = '#URL.Mission#'
		 AND    PayrollStart < #STR#
	</cfquery>
			
</cfif>

<cfoutput>
<script language="JavaScript">   
     ProsisUI.closeWindow('misdialog')
	 ptoken.location('RecordListing.cfm?idmenu=#url.idmenu#&init=1')       
</script>  
</cfoutput>
	

