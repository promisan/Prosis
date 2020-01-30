<cfquery name="Object" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT   * 
    FROM     OrganizationObject
	WHERE    ObjectKeyValue4 =  '#URL.AjaxId#'
</cfquery>

<cfquery name="Get" 
	datasource="AppsPayroll" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
    	SELECT *
	    FROM   PersonOvertime
		WHERE  OvertimeId = '#URL.AjaxId#'
</cfquery>

<cfquery name="GetPayment" 
	datasource="AppsPayroll" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
    	SELECT *
	    FROM   PersonOvertimeDetail
		WHERE  OvertimeId = '#URL.AjaxId#'
		AND    BillingPayment = '1'
</cfquery>

<cfquery name="Person" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   Person
		WHERE  PersonNo = '#Get.PersonNo#' 
</cfquery>
			
<!--- defined the unit of the mission --->
		
 <cfquery name="OnBoard" 
	 datasource="AppsEmployee"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		 SELECT   P.*
		 FROM     PersonAssignment PA, Position P
		 WHERE    PersonNo            = '#Get.PersonNo#'
		 AND      Mission             = '#Object.Mission#'
		 AND      PA.PositionNo       = P.PositionNo
		 AND      PA.DateEffective    < getdate()
		 AND      PA.DateExpiration   > getDate()
		 AND      PA.AssignmentStatus IN ('0','1')
		 AND      PA.AssignmentClass  = 'Regular'
		 AND      PA.AssignmentType   = 'Actual'
		 AND      PA.Incumbency       > 0 
		 ORDER BY PA.DateExpiration DESC
</cfquery>
	
<cfset link = "Payroll/Application/Overtime/OvertimeEdit.cfm?ID=#Get.PersonNo#&ID1=#url.ajaxid#">

<cfif Get.OvertimePayment eq "1" or getPayment.recordcount gte "1">
    <!-- extended flow --->
	<cfset class="Payroll">
<cfelse>
	<cfset class="Compensation">
</cfif>


<cfset vHours = Get.OvertimeHours>
<cfset vMin = Get.OvertimeMinutes>
<cfif len(vHours) eq 1>
	<cfset vHours = "0" & Get.OvertimeHours>
</cfif>
<cfif len(vMin) eq 1>
	<cfset vMin = "0" & Get.OvertimeMinutes>
</cfif>

<cfset vOTTime = vHours & ":" & vMin>
		
<cf_ActionListing 
	    EntityCode       = "EntOvertime"
		EntityClass      = "#class#"
		EntityGroup      = ""
		EntityStatus     = ""
		PersonNo         = "#Person.PersonNo#"
		Mission          = "#Object.Mission#"
		OrgUnit          = "#OnBoard.OrgUnitOperational#"
		ObjectReference  = "#Get.DocumentReference#"
		ObjectReference2 = "#Person.FirstName# #Person.LastName# (#Dateformat(Get.OvertimeDate, CLIENT.DateFormatShow)# #vOTTime#)"
	    ObjectKey1       = "#Get.PersonNo#"
		ObjectKey4       = "#Get.OvertimeId#"
		AjaxId           = "#Get.OvertimeId#"
		ObjectURL        = "#link#"
		Show             = "Yes"		
		Toolbar          = "No">
