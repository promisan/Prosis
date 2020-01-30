
<cfset st = createDate(year(get.PaymentDate),month(get.PaymentDate),1)>
<cfset ed = createDate(year(get.PaymentDate),month(get.PaymentDate),day(get.PaymentDate))>

<!--- obtain the EOD date of the person to be recalculated leave from the start --->

<cfif EOD neq "">

	<!--- recalculated it now --->

	<cfquery name="LeaveType" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">	 
 	  SELECT    LeaveType
      FROM      Ref_LeaveType
      WHERE     EnablePayroll = '1' 	 	
	</cfquery>
			
	<cfloop query="LeaveType">
															
		<cfinvoke component = "Service.Process.Employee.Attendance"  
		   method           = "LeaveBalance" 
		   PersonNo         = "#get.PersonNo#" 
		   Mission          = "#get.Mission#"
		   LeaveType        = "#LeaveType#"		
		   Mode             = "regular"
		   BalanceStatus    = "#BalanceStatus#"  <!--- put this information in a different status to not mess with the current --->		   		   
		   StartDate        = "#min#" 
		   EndDate          = "#max#">			   
	
	</cfloop>  		

</cfif>
	