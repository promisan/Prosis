<!-- 
	PersonEntrySubmit.cfm
	
	Process user request to save new person record.

	Called by: PersonEntry.Cfm
	
	Modification history:
	17OCt03 - created by MM
--->	
<cfquery name="AggregateNo" datasource="AppsEmployee" username="#SESSION.login#" password="#SESSION.dbpw#">
	UPDATE Parameter SET PersonNo = PersonNo+1
</cfquery>

<cfquery name="LastNo" datasource="AppsEmployee" username="#SESSION.login#" password="#SESSION.dbpw#">
	SELECT * FROM Parameter
</cfquery>
 
<!-- Convert BirthDay value in the Calling form into a usable format -->
<cfif #FORM.BirthDate# NEQ "">
	 <cfset dateValue = "">
	 <CF_DateConvert Value="#FORM.BirthDate#">
	 <cfset BirthDay = #dateValue#>
<cfelse>
	 <cfset BirthDay = ""> 	 
</cfif>
 
<!--- Convert Last Name to uppercase --->
<cfset sLastName = UCase(#FORM.LastName#)>
 
<!--- Write person record into Person table --->
<cfquery name="InsertPerson" datasource="AppsEmployee" username="#SESSION.login#" password="#SESSION.dbpw#">
  INSERT INTO Person
         (PersonNo,
		 LastName,
  		 <cfif #FORM.MiddleName# NEQ "">MiddleName,</cfif>
		 FirstName,
		 Category,
		 Rank,
		 Gender,
		 Nationality,
		 <cfif #BirthDay# NEQ "">BirthDate,</cfif>
		 OfficerUserId,
		 OfficerLastName,
		 OfficerFirstName)
      VALUES ('#LastNo.PersonNo#',
	      '#sLastName#', 
		  <cfif #FORM.MiddleName# NEQ "">'#FORM.MiddleName#',</cfif>
		  '#FORM.FirstName#',
		  '#FORM.Category#',		  
		  '#FORM.Rank#',
		  '#FORM.Gender#',
          '#FORM.Nationality#',
   		  <cfif #BirthDay# NEQ "">#BirthDay#,</cfif>
		  '#SESSION.acc#',
    	  '#SESSION.last#',		  
	  	  '#SESSION.first#')
</cfquery>

<!--- Write log entry into UserAction table --->
<CF_RegisterAction 
   SystemFunctionId="1201" 
   ActionClass="Enter Person" 
   ActionType="Enter" 
   ActionReference="#LastNo.PersonNo#" 
   ActionScript="">    

<script language="JavaScript">
   window.close()
   opener.history.go()
</script>