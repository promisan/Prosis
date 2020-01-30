<!---
	PersonEditSubmit.cfm
	
	Process user request to save changes made on the person record.

	Called by: PersonEdit.Cfm
	
	Modification history:

--->	
<!-- Convert BirthDay value in the Calling form into a usable format -->
<cfset BirthDay = "">
<cfif #FORM.BirthDate# NEQ "">
	<cfset dateValue = "">
	<CF_DateConvert Value="#FORM.BirthDate#">
	<cfset BirthDay = #dateValue#>
</cfif>
 
<!--- Convert Last Name to uppercase --->
<cfset sLastName = UCase(#FORM.LastName#)>
 
<!--- Write person record into Person table --->
<cfquery name="UpdatePerson" datasource="AppsEmployee" username="#SESSION.login#" password="#SESSION.dbpw#">
  	UPDATE Person
	SET  IndexNo = '#FORM.IndexNo#',
		 LastName = '#sLastName#',
  		 MiddleName = '#FORM.MiddleName#',
		 FirstName = '#FORM.FirstName#',
		 Rank = '#FORM.Rank#',
		 Category = '#FORM.Category#',
		 Gender = '#FORM.Gender#',
		 Nationality = '#FORM.Nationality#',
		 BirthNationality = '#FORM.BirthNationality#',
		 BirthDate = <cfif #FORM.BirthDate# NEQ "">#Birthday#<cfelse>NULL</cfif>
	WHERE PersonNo = '#URL.PERSNO#'
</cfquery>

  <!--- Write log entry into UserAction table --->
<CF_RegisterAction 
   SystemFunctionId="1261" 
   ActionClass="Update Person" 
   ActionType="Update" 
   ActionReference="#URL.PERSNO#" 
   ActionScript="">    

<script language="JavaScript">
   window.close()
   opener.history.go()
</script>
