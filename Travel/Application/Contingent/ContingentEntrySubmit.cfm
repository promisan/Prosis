<!-- 
	ContingentEntrySubmit.cfm
	
	Process user request to save new contingent record.

	Called by: ContingentEntry.Cfm
	
	Modification history:

-->	
<!--- Write person record into Person table --->
<cfquery name="InsertNewRec" datasource="AppsTravel" username="#SESSION.login#" password="#SESSION.dbpw#">
  	INSERT INTO Contingent
        (Name,
		 PermanentMissionId,
		 ContingentUnit_Id,
		 ContingentSubUnit_Id,
		 AuthorizedStrength,
  		 Mission,
		 DeploymentPeriod,
		 Status,
		 Remarks,
		 OfficerUserId,
		 OfficerLastName,
		 OfficerFirstName)
     VALUES 
	    ('#FORM.ContingentName#',
		 #FORM.PermanentMissionId#,
		 '#FORM.ContingentUnitId#',
         '#FORM.ContingentSubUnitId#',
		 '#FORM.authorizedstrength#',
	     '#FORM.Mission#',		 
         #FORM.deploymentperiod#,
		  #FORM.Status#,
	      RTRIM(SUBSTRING('#FORM.Remarks#', 1,200)),
		  '#SESSION.acc#',
    	  '#SESSION.last#',		  
	  	  '#SESSION.first#')
  </cfquery>

<script language="JavaScript">
	window.close();
	opener.history.go();
</script>