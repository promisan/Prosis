<cfquery name="Object" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT   * 
    FROM     OrganizationObject
	WHERE    ObjectKeyValue4 =  '#URL.AjaxId#'
</cfquery>

<cfparam name="URL.Mission" default = "#Object.Mission#">

<cfquery name="Get" 
	datasource="AppsPayroll" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
    	SELECT *
	    FROM   PersonMiscellaneous
		WHERE  CostId = '#URL.AjaxId#'
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
		 AND      Mission             = '#URL.Mission#'
		 AND      PA.PositionNo       = P.PositionNo
		 AND      PA.DateEffective    < getdate()
		 AND      PA.DateExpiration   > getDate()
		 AND      PA.AssignmentStatus IN ('0','1')
		 AND      PA.AssignmentClass  = 'Regular'
		 AND      PA.AssignmentType   = 'Actual'
		 AND      PA.Incumbency       > 0 
		 ORDER BY PA.DateExpiration DESC
</cfquery>

<cfquery name="PayrollItem" 
   datasource="AppsPayroll" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
 	SELECT * 
	FROM   Ref_PayrollItem
	WHERE  PayrollItem = '#get.PayrollItem#'
</cfquery>

<cfset link = "Staffing/Application/Employee/Cost/MiscellaneousEdit.cfm?id=#Person.personno#&id1=#url.ajaxid#">
			
<cf_ActionListing 
    EntityCode       = "EntCost"
	EntityClass      = "#payrollItem.entityclass#"
	EntityGroup      = ""
	EntityStatus     = ""
	Mission 		 = "#url.Mission#"
	PersonNo         = "#Person.PersonNo#"
	ObjectReference  = "#PayrollItem.PayrollItemName#"
	ObjectReference2 = "#Person.FirstName# #Person.LastName#" 
	ObjectKey1       = "#Person.PersonNo#"
	ObjectKey4       = "#url.ajaxid#"
	AjaxId           = "#url.ajaxid#"
	ObjectURL        = "#link#"
	Show             = "Yes"
	CompleteFirst    = "No">

