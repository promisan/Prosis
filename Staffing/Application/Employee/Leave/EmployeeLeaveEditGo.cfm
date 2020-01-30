
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>"> 
   
<cfset oSecurity = CreateObject("component","Service.Process.System.UserController")/>
<cfset mid = oSecurity.gethash()/>   
  
<cfoutput>
   <script language="JavaScript">			      			     			   			   
      window.location = "#SESSION.root#/Attendance/Application/LeaveRequest/EmployeeRequest.cfm?scope=#url.scope#&ID=#PersonNo#&mid=#mid#"					 
   </script>
</cfoutput> 
   
	
