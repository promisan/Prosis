<!-- 
	MessageEntrySubmit.cfm
	
	Process user request to save new message record.

	Called by: MessageEntry.Cfm
	
	Modification history:
	02Dec04 - created by MM
 -->	

<cfquery name="InsertIncident" datasource="AppsTravel" 
 username="#SESSION.login#" password="#SESSION.dbpw#">
  	INSERT INTO Message
         (ParentId,
		 MessageText,
		 OfficerUserId,
		 OfficerLastName,
		 OfficerFirstName)
     VALUES 
	 	  ('#FORM.ParentId#',
		  '#FORM.msg#',
	      '#SESSION.acc#',
    	  '#SESSION.last#',		  
	  	  '#SESSION.first#')
</cfquery>

<script language="JavaScript">
   window.close()
   opener.history.go()
</script>