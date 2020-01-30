
<cfquery name="Leave" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   PersonLeave
	WHERE  LeaveId = '#URL.LeaveId#' 	
</cfquery>

<cfquery name="Deduction" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   PersonLeaveDeduct
	WHERE  LeaveId = '#URL.LeaveId#' 	
</cfquery>

<cfloop query="Deduction">
	
	<cfset ded = evaluate("Form.Deduction_#currentrow#")>
	<cfset mem = evaluate("Form.Memo_#currentrow#")>
	
	<cfif deduction neq ded>
		
		<cfquery name="update" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    UPDATE PersonLeaveDeduct
			SET    Deduction        = '#ded#', 
			       Mode             = 'Overwrite',
				   OfficerUserId    = '#session.acc#',
				   OfficerLastName  = '#session.last#',
				   OfficerFirstName = '#session.first#',
				   Created          = #now()#	
			WHERE  LeaveId      = '#URL.LeaveId#' 	
			AND    CalendarDate = '#calendarDate#'
		</cfquery>
	
	</cfif>
	
	<cfif memo neq mem>
	
		<cfquery name="update" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    UPDATE PersonLeaveDeduct
			SET    Memo             = '#mem#', 		     
				   OfficerUserId    = '#session.acc#',
				   OfficerLastName  = '#session.last#',
				   OfficerFirstName = '#session.first#',
				   Created          = #now()#	
			WHERE  LeaveId      = '#URL.LeaveId#' 	
			AND    CalendarDate = '#calendarDate#'
		</cfquery>
		
	</cfif> 

</cfloop>

<cfquery name="get" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT sum(Deduction) as Total
    FROM   PersonLeaveDeduct
	WHERE  LeaveId = '#URL.LeaveId#' 	
</cfquery>

<cfquery name="update" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    UPDATE PersonLeave
		SET    DaysDeduct   = '#get.total#'
		WHERE  LeaveId      = '#URL.LeaveId#' 
</cfquery>

<cfinvoke component = "Service.Process.Employee.Attendance"  
		   method        = "LeaveBalance" 
		   PersonNo      = "#Leave.PersonNo#" 			   
		   LeaveType     = "#Leave.LeaveType#"
		   BalanceStatus = "0"
		   StartDate     = "#dateformat(Leave.DateEffective,client.datesql)#">		

<cfoutput>#numberformat(get.total,'.__')#</cfoutput>

<script>
	try { ProsisUI.closeWindow('deduction',true) } catch(e) {}
</script>