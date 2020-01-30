
<cfquery name="Object" 
datasource="appsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   OrganizationObject
	WHERE  ObjectKeyValue4 = '#URL.ajaxId#'
</cfquery>

<cfquery name="DependentSel" 
datasource="appsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   PersonDependent
	WHERE  DependentId = '#URL.ajaxId#'
</cfquery>

<cfquery name="Person" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT  *
	FROM    Person
	WHERE   PersonNo = '#DependentSel.PersonNo#' 
</cfquery>

<cfif Object.Mission neq "">

	<cfset mission = object.Mission>
	
<cfelse>
	
		 <cfquery name="Mission" 
			 datasource="AppsEmployee"
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
				 SELECT   TOP 1 *
				 FROM     PersonContract
				 WHERE    PersonNo    = '#DependentSel.PersonNo#'
				 AND      ActionStatus != '9'					 
				 ORDER BY DateEffective DESC
		</cfquery>
		
		<cfif Mission.Mission eq "">
			 
			 <cfquery name="Mission" 
			 datasource="AppsEmployee"
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
				 SELECT   TOP 1 P.*
				 FROM     PersonAssignment PA, Position P
				 WHERE    PersonNo = '#DependentSel.PersonNo#'
				 AND      PA.PositionNo = P.PositionNo		
				 AND      PA.AssignmentStatus IN ('0','1')
				 AND      PA.AssignmentClass = 'Regular'
				 AND      PA.AssignmentType  = 'Actual'
				 AND      PA.Incumbency      = '100' 
				 ORDER BY PA.DateExpiration DESC
			</cfquery>
		
		</cfif>			

		<cfset mission = mission.mission>	
		
</cfif>

 <cfset link = "Staffing/Application/Employee/Dependents/DependentEdit.cfm?id=#Person.Personno#&id1=#URL.ajaxId#">
	
<cf_ActionListing 
    EntityCode       = "Dependent"
	EntityClass      = "Standard"
	EntityGroup      = ""
	EntityStatus     = ""	
	PersonNo         = "#Person.Personno#"
	Mission          = "#mission#"
	ObjectReference  = "#DependentSel.Relationship#"
	ObjectReference2 = "#Person.FirstName# #Person.LastName#" 	
    ObjectKey1       = "#Person.Personno#"
	ObjectKey4       = "#URL.ajaxId#"
	AjaxId           = "#URL.ajaxId#"	
	ObjectURL        = "#link#"
	Show             = "Yes">