
<!--- remove role --->

<cfquery name="Edition" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM FunctionOrganization 
WHERE FunctionId = '#URL.ID#'
    </cfquery>

	<cfquery name="Remove" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
DELETE FROM RosterAccessAuthorization
WHERE UserAccount = '#URL.ACC#'
AND   AccessLevel = '#URL.ID1#'
AND   FunctionId IN (SELECT FunctionId FROM FunctionOrganization WHERE SubmissionEdition = '#Edition.SubmissionEdition#')
    </cfquery>

<cfloop index="Rec" from="1" to="#CLIENT.RecordNo#">

  <cfset actionid   = Evaluate("FORM.actionid_" & #Rec#)>
  <cfset access     = Evaluate("FORM.sel_" & #Rec#)>

<cfif access eq "1">

	<cfquery name="Insert" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	INSERT INTO RosterAccessAuthorization  
	         (FunctionId,
			  UserAccount,
			  AccessLevel,
			  OfficerUserId,
			  OfficerLastName,
			  OfficerFirstName,
			  Created)
	  VALUES ('#actionId#',
	          '#URL.ACC#',
	          '#URL.ID1#',  
			  '#SESSION.acc#',
			  '#SESSION.last#',
			  '#SESSION.first#',
			  getDate())
	</cfquery>		

</cfif>

</cfloop>

<cfoutput>

	<script language="JavaScript">
	
	  parent.window.close()
	  parent.opener.history.go()
	
	</script>

</cfoutput>

</body>
</html>
