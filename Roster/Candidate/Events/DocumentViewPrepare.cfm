<cfset condition = "">

<cfif Form.PersonStatus neq "">
  <cfset condition = "#condition# AND E.PersonStatus = '#Form.PersonStatus#'">
</cfif>

<cfif Form.EventCategory neq "">
  <cfset condition = "#condition# AND E.EventCategory = '#Form.EventCategory#'">
</cfif>

<cfif Form.LastName neq "">
  <cfset condition = "#condition# AND A.LastName LIKE '%#Form.LastName#%'">
</cfif>

<cfif Form.FirstName neq "">
  <cfset condition = "#condition# AND A.FirstName LIKE '%#Form.FirstName#%'">
</cfif>

<cfif Form.Nationality neq "">
  <cfset condition = "#condition# AND A.Nationality = '#Form.Nationality#'">
</cfif>

<cfif Form.Gender neq "">
  <cfset condition = "#condition# AND A.Gender = '#Form.Gender#'">
</cfif>

<cfset dateValue = "">
<cfif Form.AgeFrom neq ''>
    <CF_DateConvert Year ="#Form.AgeFrom#">
    <cfset condition = "#condition# AND A.DOB <= #DateValue#">
</cfif>

<cfset dateValue = "">
<cfif Form.AgeTo neq ''>
    <CF_DateConvert Year ="#Form.AgeTo#">
    <cfset condition = "#condition# AND A.DOB >= #DateValue#">
</cfif>

<cfif Form.IndexNo neq "">
  <cfset condition = "#condition# AND A.IndexNo = '#Form.IndexNo#'">
</cfif>
		
<CF_DropTable dbName="AppsQuery"  tblName="#SESSION.acc#Event">		

<cfquery name="Searchresult" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT  A.*, 
        E.EventId, 
		E.EventDate,
		E.Owner, 
		E.Status, 
		S.Description, 
		S.InterfaceColor
INTO    userQuery.dbo.#SESSION.acc#Event
FROM   ApplicantEvent E, Applicant A, Ref_PersonStatus S 
WHERE  E.PersonStatus = S.Code
  AND  E.PersonNo = A.PersonNo
  AND  E.PersonStatus != '9'
  
  <cfif SESSION.isAdministrator eq "No">
	
	AND ( 
	
		E.Owner IN (SELECT GroupParameter
                  FROM   Organization.dbo.OrganizationAuthorization
		          WHERE  Role = 'CandidateClear' 
				  AND    UserAccount = '#SESSION.acc#')
				  
		OR
		
		E.Owner IN (SELECT ClassParameter
                  FROM   Organization.dbo.OrganizationAuthorization
		          WHERE  Role = 'OrgUnitManager' 
				  AND    AccessLevel = '3'
				  AND    UserAccount = '#SESSION.acc#')
				
		)						  
						  
	</cfif>		
    
#preserveSingleQuotes(condition)# 
ORDER BY E.Status, A.LastName, A.FirstName
</cfquery>

<cflocation url="DocumentViewListing.cfm?ID=#URL.ID#&ID1=#URL.ID1#" addtoken="No">