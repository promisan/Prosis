<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<html>
<head>
	<title>Process Profiles</title>
</head>

<body>

<CF_RegisterAction 
SystemFunctionId="0001" 
ActionClass="Vacancy Action Users" 
ActionType="Reset" 
ActionReference="" 
ActionScript="">    

<!--- remove role --->

	<cfquery name="Remove" 
datasource="#CLIENT.DataSource#" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
DELETE FROM ActionAuthorization 
WHERE UserAccount = '#URL.ID#'
AND Mission = '#URL.IDMission#'
    </cfquery>

<!--- define selected users --->

<cfoutput>#CLIENT.RecordNo#</cfoutput>

<cfloop index="Rec" from="1" to="#CLIENT.RecordNo#">

  <cfset actionid   = Evaluate("FORM.actionid_" & #Rec#)>
  <cfset access     = Evaluate("FORM.selected_" & #Rec#)>

  <cfquery name="Insert" 
  datasource="#CLIENT.DataSource#" 
  username=#SESSION.login# 
  password=#SESSION.dbpw#>
  INSERT INTO ActionAuthorization  
         (ActionId, 
		  UserAccount,
		  Mission,
		  AccessLevel,
		  OfficerUserId,
		  OfficerLastName,
		  OfficerFirstName,
		  Created)
  VALUES ('#actionid#',
          '#URL.ID#',
		  '#URL.IDMission#', 
		  '#access#',  
		  '#SESSION.acc#',
		  '#SESSION.last#',
		  '#SESSION.first#',
		  getDate())
  </cfquery>		

</cfloop>

<!--- close window --->

<SCRIPT LANGUAGE = "JavaScript">
{
    window.close()
    opener.location.reload();
}
</SCRIPT>

</body>
</html>
