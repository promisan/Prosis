<!-- 
	ContingentActivityEntrySubmit.cfm
	
	Process user request to save new contingent activity record.

	Called by: ContingentActivityEntry.Cfm
	
	Modification history:

-->	
<cfset dateValue = "">
<CF_DateConvert Value="#Form.DateEffective#">
<cfset DateEff = #dateValue#>

<!--- Write person record into Person table --->
<cfquery name="InsertNewRec" datasource="AppsTravel" username="#SESSION.login#" password="#SESSION.dbpw#">
  	INSERT INTO ContingentActivity
        (Contingent_Id,
		 ContingentEvent_Id,
		 DateEffective,
		 PersonCount,
		 FemaleCount,
		 Remarks,
		 OfficerUserId,
		 OfficerLastName,
		 OfficerFirstName)
     VALUES 
	    (#FORM.ContingentId#,
		 '#FORM.ContingentEventId#',
		 #DateEff#,
         #FORM.PersonCount#,
         #FORM.FemaleCount#,		 
	      RTRIM(SUBSTRING('#FORM.Remarks#', 1,200)),
		  '#SESSION.acc#',
    	  '#SESSION.last#',		  
	  	  '#SESSION.first#')
  </cfquery>

<script language="JavaScript">
//	opener.location.reload();
	opener.history.go();	
</script>

<cflocation url="ContingentDetail.cfm?CONT_ID=#FORM.ContingentId#"> 