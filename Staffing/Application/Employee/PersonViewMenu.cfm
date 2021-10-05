
<cfoutput>

<cfquery name="Applicant" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT IndexNo, PersonNo
	    FROM   Applicant
	    WHERE  EmployeeNo = '#URL.ID#'  
	</cfquery>

<cf_dialogStaffing>
<cf_submenuleftscript>

<script language="JavaScript1.2">

	function contract(s,idmenu) {	   
	    ptoken.location("Contract/EmployeeContract.cfm?ID=#URL.ID#&systemfunctionid="+idmenu,"parent.right")
	}
	
	function locate(s,idmenu) {	   
	   parent.right.ptoken.location("#SESSION.root#/Staffing/Application/Employee/PersonSearch1.cfm")
	}
	
	function request(s,idmenu) {
	   ptoken.location("Request/RequestList.cfm?ID=#URL.ID#&systemfunctionid="+idmenu,"parent.right");
	}
		
	function leave(s,idmenu) {
	   ptoken.location("Leave/EmployeeLeave.cfm?ID=#URL.ID#&systemfunctionid="+idmenu,"parent.right")
	}
	
	function workorder(s,idmenu) {
	    ptoken.location("#SESSION.root#/Staffing/Application/Employee/WorkOrder/WorkOrderListing.cfm?ID1=#URL.ID#&systemfunctionid="+idmenu,"parent.right");
	}
	
	function asset(s,idmenu) {
	    ptoken.location("#SESSION.root#/Warehouse/Application/Asset/AssetControl/ControlListPerson.cfm?ID=Per&ID1=#URL.ID#&systemfunctionid="+idmenu,"parent.right");
	}
			
	function casefile(s,idmenu) {
	    ptoken.location("CaseFile/CaseFileListing.cfm?ID=#URL.ID#&ts="+new Date().getTime(),"parent.right");
	}
	
	function personevent(s,idmenu) {
	    ptoken.location("Events/EventsView.cfm?ID=#URL.ID#&systemfunctionid="+idmenu,"parent.right");
	}
	
	function timesheet(s,idmenu) {		
	    ptoken.location("#SESSION.root#/Attendance/Application/Timesheet/Timesheet.cfm?ID=#URL.ID#&systemfunctionid="+idmenu,"parent.right");
	}
	
	function paction(s,idmenu) {	   
	    ptoken.location("PersonAction/ActionHeader.cfm?mode=person&ID=#URL.ID#&systemfunctionid="+idmenu,"parent.right");
	}
	
	function phistory(s,idmenu) {	   
	    ptoken.location("History/ActionList.cfm?mode=person&ID=#URL.ID#&systemfunctionid="+idmenu,"parent.right");
	}
	
	function profile(s,idmenu) {
	    ptoken.location("Profile/ProfileEntry.cfm?ID=#URL.ID#&systemfunctionid="+idmenu,"parent.right");
	}
		
	function general(s,idmenu) {
	    ptoken.location("EmployeeIdentification.cfm?ID=#URL.ID#&systemfunctionid="+idmenu,"parent.right");	   
	}
			
	function incumbency(s,idmenu) {
	    ptoken.location("../Assignment/EmployeeAssignment.cfm?ID=#URL.ID#&systemfunctionid="+idmenu,"parent.right");	   	   
	}
	
	function entitlement(s,idmenu) {
	    ptoken.location("Entitlement/EmployeeEntitlement.cfm?ID=#URL.ID#&ID1=#URL.ID1#&systemfunctionid="+idmenu,"parent.right");
	}
		
	function miscellaneous(s,idmenu) {
	    ptoken.location("Cost/EmployeeMiscellaneous.cfm?ID=#URL.ID#&ID1=#URL.ID1#&systemfunctionid="+idmenu,"parent.right");
	}
	
	function address(s,idmenu) {
	    ptoken.location("Address/EmployeeAddress.cfm?ID=#URL.ID#&systemfunctionid="+idmenu,"parent.right");
	}
	
	function pas(s,idmenu) {
	    ptoken.location("PAS/EmployeePAS.cfm?ID=#URL.ID#&systemfunctionid="+idmenu,"parent.right");
	}
	
	function advance(s,idmenu) {		
	    ptoken.location("Advance/Ledger.cfm?Id=#URL.ID#&systemfunctionid="+idmenu,"parent.right")
	}
	
	function ledger(s,idmenu) {		
	    ptoken.location("Invoices/Ledger.cfm?Id=#URL.ID#&systemfunctionid="+idmenu,"parent.right")
	}
			
	function ePas(s,idmenu) {
	    ptoken.location("../../../ProgramREM/Portal/Workplan/PASView/ListingPAS.cfm?ID=#URL.ID#&mode=all&systemfunctionid="+idmenu,"parent.right")
	}
	
	function course(s,idmenu) {
	    ptoken.location("Learning/EmployeeCourse.cfm?ID=#URL.ID#&mode=all&systemfunctionid="+idmenu,"parent.right");
	}	
	
	function bankaccount(s,idmenu) {
	    ptoken.open("#SESSION.root#/Payroll/Application/Bankaccount/EmployeeBankAccount.cfm?ID=#URL.ID#&ID1=#URL.ID1#&systemfunctionid="+idmenu, "right");
	}
	
	function distribution(s,idmenu) {
	    ptoken.open("#SESSION.root#/Payroll/Application/PaymentDistribution/EmployeeDistribution.cfm?ID=#URL.ID#&ID1=#URL.ID1#&systemfunctionid="+idmenu, "right");
	}
		
	function payroll(s,idmenu) {
	    ptoken.open("#SESSION.root#/Payroll/Application/Payroll/EmployeePayroll.cfm?ID=#URL.ID#&ID1=#URL.ID1#&systemfunctionid="+idmenu, "right");
	}
	
	function payrolllocal(s,idmenu) {	   
	    ptoken.open("#SESSION.root#/Staffing/Application/Employee/Payroll/LocalisedListing.cfm?ID=#URL.ID#&ID1=#URL.ID1#&systemfunctionid="+idmenu, "right");
	}
	
	function overtime(s,idmenu) {
	    ptoken.location("#SESSION.root#/Payroll/Application/Overtime/EmployeeOvertime.cfm?ID=#URL.ID#&ID1=#URL.ID1#&systemfunctionid="+idmenu,"parent.right");
	}
	
	function dependent(s,idmenu) {
	    ptoken.location("Dependents/EmployeeDependent.cfm?ID=#URL.ID#&systemfunctionid="+idmenu,"parent.right");
	}
	
	function issueddocument(s,idmenu) {
	    ptoken.location("Document/EmployeeDocument.cfm?ID=#URL.ID#&systemfunctionid="+idmenu,"parent.right");
	}

	function issueddocument(s,idmenu) {
	    ptoken.location("Document/EmployeeDocument.cfm?ID=#URL.ID#&systemfunctionid="+idmenu,"parent.right");
	}

	function php(s,idmenu) {	 
		ptoken.open("#SESSION.root#/Roster/Candidate/Details/PHPView.cfm?ID=#Applicant.PersonNo#&mode=Manual", "PHP");
	}
	
	function scheduledtasks() {
		ptoken.location("#SESSION.root#/Staffing/Application/Employee/ScheduledTasks/ScheduledTasks.cfm?ID1=#URL.ID#&ts="+new Date().getTime(),"parent.right");
	}	
	
</script>

<cfif FileExists("#Session.rootPath#\Custom\StaffingScript.cfm")>
	<cfinclude template="../../../Custom/StaffingScript.cfm">
</cfif>

<script>	
	
	<!--- ---------- --->
	<!--- DW UN ONLY --->
	<!--- ---------- --->
	
	function pa(s,idmenu) {	
	    ptoken.open("#SESSION.root#/DWarehouse/Detail/EmployeeGeneral.cfm?ID=#URL.ID1#&systemfunctionid="+idmenu+"&section=history&topic=pa", "right");
	}
	
	function assignment(s,idmenu) {
	    ptoken.open("#SESSION.root#/DWarehouse/Detail/EmployeeGeneral.cfm?ID=#URL.ID1#&systemfunctionid="+idmenu+"&section=history&topic=assignment", "right");
	}
	
	function incumbency0(s,idmenu) {
		ptoken.open("#SESSION.root#/DWarehouse/Detail/EmployeeRouting.cfm?ID=#URL.ID1#&systemfunctionid="+idmenu+"&section=history&topic=assignment", "right");
	   
	}
	
	function grade(s,idmenu) {
	    ptoken.open("#SESSION.root#/DWarehouse/Detail/EmployeeGeneral.cfm?ts="+new Date().getTime()+"&ID=#URL.ID1#&systemfunctionid="+idmenu+"&section=history&topic=grade", "right");
	}
	
	function appointment(s,idmenu) {
	    ptoken.open("#SESSION.root#/DWarehouse/Detail/EmployeeGeneral.cfm?ts="+new Date().getTime()+"&ID=#URL.ID1#&systemfunctionid="+idmenu+"&section=history&topic=appointment", "right");	
	}
	
	function entitlement2(s,idmenu) {
	    ptoken.open("#SESSION.root#/DWarehouse/Detail/EmployeeGeneral.cfm?ts="+new Date().getTime()+"&ID=#URL.ID1#&systemfunctionid="+idmenu+"&section=history&topic=entitlement", "right");
	}
	
	function insurance(s,idmenu) {
	    ptoken.open("#SESSION.root#/DWarehouse/Detail/EmployeeGeneral.cfm?ts="+new Date().getTime()+"&ID=#URL.ID1#&systemfunctionid="+idmenu+"&section=Miscellaneous&topic=insurance", "right");
	}
	
	function medical(s,idmenu) {
	    ptoken.open("#SESSION.root#/DWarehouse/Detail/EmployeeGeneral.cfm?ts="+new Date().getTime()+"&ID=#URL.ID1#&systemfunctionid="+idmenu+"&section=Miscellaneous&topic=medical", "right");
	}
	
	function education(s,idmenu) {
	    ptoken.open("#SESSION.root#/DWarehouse/Detail/EmployeeGeneral.cfm?ts="+new Date().getTime()+"&ID=#URL.ID1#&systemfunctionid="+idmenu+"&section=Miscellaneous&topic=education", "right");	
	}	
			
	function rental(s,idmenu) {
	    ptoken.open("#SESSION.root#/DWarehouse/Detail/EmployeeGeneral.cfm?ts="+new Date().getTime()+"&ID=#URL.ID1#&systemfunctionid="+idmenu+"&section=Miscellaneous&topic=rental", "right");
	}
	
	function offer(s,idmenu) {
	    ptoken.open("#SESSION.root#/DWarehouse/Detail/EmployeeGeneral.cfm?ts="+new Date().getTime()+"&ID=#URL.ID1#&systemfunctionid="+idmenu+"&section=Miscellaneous&topic=offer", "right");
	}

</script>


</cfoutput>

<cfset fcolor = "002350">

<cfif client.personNo eq url.id>
	<cfset mode = "enforce">
<cfelse>
	<cfset mode = "verify">
</cfif>

<cfquery name="Assignment" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT  * 
	FROM    PersonAssignment
	WHERE   AssignmentStatus IN ('0','1')
	AND     PersonNo = '#URL.ID#' 	
</cfquery>

<cfif Assignment.recordcount gte "1">
	
	<cfinvoke component="Service.Access"  
	     method="employee" 
		 personno="#URL.ID#" 
		 returnvariable="access">
						 
	<cfif access eq "NONE">
		
		 <!--- give only access to anonymous functions --->
		 <cfset access    = "ALL">	 
		 <cfset anonymous = "1">
		 		 
	</cfif>	 
		
<cfelse>

	<cfset access = "EDIT">		
	
</cfif>	


<cfset vColor = "ffffff">

<cfinvoke component="Service.Access"  
     method="roster"
	 role="'AdminRoster','RosterClear'"
	 returnvariable="accessRoster">
			  				  
<cfif access eq "READ" 
     OR access eq "EDIT" 
	 OR access eq "ALL"
	 OR accessRoster eq "EDIT" OR accessRoster eq "ALL">
	 
	<table width="99%" border="0" cellspacing="0" cellpadding="0" align="right">
	<tr>
	
	<tr><td height="10" style="padding-top:4px">
	
		<cfif Applicant.PersonNo neq "">
		
			<cfset cl = "'General','Applicant'">
			
		<cfelse>
		
			<cfset cl = "'General'">
		
		</cfif>
						
		<cf_tl id="Employee" var="1">
		<cfset heading      = "#LT_Text#">
		<cfset module       = "'Staffing'">
		<cfset selection    = "'Employee'">
		<cfset menuclass    = "#preservesinglequotes(cl)#">
		<cfset titlecolor   = vColor>
		<cfinclude template = "../../../Tools/SubmenuLeft.cfm">
		
	</td></tr>
		
	<cfif Applicant.recordcount eq "0">
	
	<!---
	<tr><td style="padding-top:2px;padding-bottom:8px;padding-left:10px" 
	     style="background-image:url('<cfoutput>#SESSION.root#</cfoutput>/Images/border.png'); background-position:top right; background-repeat:repeat-y">
		<font face="Calibri" size="2" color="808080"><i>No candidate profile</i>
	</td>
	</tr>
	--->
	
	</cfif>
	
	<tr><td>
	
	<cf_tl id="Employment" var="1">
	<cfset heading      = "#LT_Text#">
	<cfset module       = "'Staffing'">
	<cfset selection    = "'Employee'">
	<cfset menuclass    = "'History'">
	<cfset titlecolor   = vColor>
	<cfinclude template="../../../Tools/SubmenuLeft.cfm">	
	
	</td></tr>
		
	<tr><td>	
	
	<cf_tl id="Payroll" var="1">
	<cfset heading      = "#LT_Text#">
	<cfset module       = "'Payroll'">
	<cfset selection    = "'Employee'">
	<cfset menuclass    = "'Payroll'">
	<cfset titlecolor   = vColor>
	<cfinclude template = "../../../Tools/SubmenuLeft.cfm">
	
	</td></tr>
		
	<tr><td>	
	<cf_tl id="Learning" var="1">
	<cfset heading      = "#LT_Text#">
	<cfset module       = "'Staffing'">
	<cfset selection    = "'Employee'">
	<cfset menuclass    = "'Learning'">
	<cfset open         = "no">
	<cfset titlecolor   = vColor>
	<cfinclude template = "../../../Tools/SubmenuLeft.cfm">	
	
	</td></tr>
	
	<tr><td>	
	<cf_tl id="Resources" var="1">
	<cfset heading      = "#LT_Text#">
	<cfset module       = "'Staffing'">
	<cfset selection    = "'Employee'">
	<cfset menuclass    = "'Resource'">
	<cfset open         = "no">
	<cfset titlecolor   = vColor>
	<cfinclude template = "../../../Tools/SubmenuLeft.cfm">	
	
	</td></tr>
	
	<tr><td>
	
	<cf_tl id="Miscellaneous" var="1">
	<cfset heading      = "#LT_Text#">
	<cfset module       = "'Staffing'">
	<cfset selection    = "'Employee'">
	<cfset menuclass    = "'Miscellaneous'">
	<cfset open         = "yes">
	<cfset titlecolor   = vColor>
	<cfinclude template = "../../../Tools/SubmenuLeft.cfm">
	
	</td></tr>
			  
	<tr><td>
		<cfset heading      = "Enterprise Data">
		<cfset module       = "'Staffing'">
		<cfset selection    = "'Employee'">
		<cfset menuclass    = "'DW'">
		<cfset titlecolor   = vColor>
		<cfinclude template = "../../../Tools/SubmenuLeft.cfm">
	</td></tr>	
		
	<tr><td>
		<cfset heading      = "Other Data">
		<cfset module       = "'Staffing'">
		<cfset selection    = "'Employee'">
		<cfset menuclass    = "'MA'">
		<cfset titlecolor   = vColor>
		<cfinclude template = "../../../Tools/SubmenuLeft.cfm">
	</td></tr>	
	

	
	</td>
	
	</tr>
	
	</table>

</cfif>
