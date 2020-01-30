<!-- 
	IncidentPersonSubmit.cfm
	
	Process user request to create a new IncidentPerson record.

	Called by: PersonInquiryResult.cfm via AddIncidentPerson() 
	
	
	Modification history:

-->	
<cfset inc_id = Val(#URL.ID#)>

<cfquery name="Insert_IncidentPerson" datasource="AppsTravel" username="#SESSION.login#" password="#SESSION.dbpw#">
	INSERT INTO IncidentPerson
        (Incident, 
		PersonNo, 
		OfficerUserId,
		OfficerLastName,
		OfficerFirstName)
	VALUES 
		(#inc_id#, 
		'#URL.ID1#',
		'#SESSION.acc#',
    	'#SESSION.last#',		  
	  	'#SESSION.first#')
</cfquery>

<cfoutput>
<script language="JavaScript">
	opener.location.reload()
    window.close()
</script>
</cfoutput>
