
<cfquery name="old" 
     datasource="AppsEmployee" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
		SELECT *
		FROM  PersonLeave
		WHERE LeaveId = '#url.LeaveId#' 
</cfquery>

<CF_DateConvert Value="#dateformat(old.DateEffective,client.dateformatshow)#">						
<cfset STR  = CreateDate(Year(dateValue),Month(dateValue),1)>
				 		 
<cfinvoke component = "Service.Process.Employee.Attendance"  
   method         = "LeaveBalance" 
   PersonNo       = "#old.PersonNo#" 
   Mission        = "#old.mission#"
   LeaveType      = "#old.LeaveType#"
   BalanceStatus  = "0"
   StartDate      = "#STR#"
   EndDate        = "#STR+100#">						
	  						  
 <cfinvoke component     = "Service.Process.Employee.Attendance"  
   method       = "LeaveAttendance" 
   PersonNo     = "#old.PersonNo#" 		
   Mission      = "#old.Mission#"	   					  
   StartDate    = "#dateformat(old.DateEffective,client.dateformatshow)#"
   EndDate      = "#dateformat(old.DateExpiration,client.dateformatshow)#"					  
   Mode         = "reset">		
      
<CF_DateConvert Value="#dateformat(old.dateEffective,client.dateformatshow)#">
<cfset STR = dateValue>
	
<CF_DateConvert Value="#dateformat(old.dateExpiration,client.dateformatshow)#">
<cfset END = dateValue>

<cf_BalanceDays personno  = "#old.personno#" 
    LeaveType         = "#old.LeaveType#" 
	leavetypeclass    = "#old.Leavetypeclass#" 
	start             = "#STR#" 
	startfull         = "#old.DateEffectiveFull#" 
	end               = "#END#" 
	endfull           = "#old.DateExpirationFull#">
	
<cftransaction>
	
<cfquery name="reset" 
     datasource="AppsEmployee" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
		UPDATE PersonLeave
		SET    DaysDeduct  = '#days#'
		WHERE  LeaveId     = '#url.LeaveId#' 
</cfquery>	

<cfquery name="reset" 
   datasource="AppsEmployee" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
	 	DELETE FROM PersonLeaveDeduct
		WHERE  Leaveid = '#url.LeaveId#'
</cfquery>	 
 
<cfoutput query="deduction">

	<cfset dte = dateformat(date,client.dateSQL)>

	 <cfquery name="insert" 
     datasource="AppsEmployee" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">	 
		INSERT INTO	PersonLeaveDeduct
		(LeaveId,CalendarDate,Deduction,OfficerUserId,OfficerLastName,OfficerFirstName)
		VALUES
	    ('#url.LeaveId#','#dte#','#Deduct#','#SESSION.acc#','#SESSION.last#','#SESSION.first#')								
	  </cfquery>
 			
</cfoutput>	

</cftransaction>	
	
<cfoutput>	
#NumberFormat(Days,".__")#		
</cfoutput>

<script>Prosis.busy('no')</script>
