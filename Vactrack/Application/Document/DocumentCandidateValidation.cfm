
<cfquery name="Insert" 
	datasource="AppsVacancy" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	INSERT INTO DocumentValidation
		(DocumentNo,ValidationCode,OfficerUserId,OfficerLastName,OfficerFirstName)
	VALUES
		('#url.documentNo#','OverwriteSelection','#SESSION.acc#','#SESSION.last#','#SESSION.first#')	
</cfquery>

<cfquery name="Validation" 
		datasource="AppsVacancy" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT *
		    FROM  DocumentValidation
			WHERE DocumentNo = '#URL.documentNo#'
			AND   ValidationCode = 'OverwriteSelection'
	</cfquery>			

<cfoutput>

<table cellspacing="0" cellpadding="0">

	<cfif Validation.Recordcount eq "1">

	<tr><td height="20">	
		&nbsp;<font color="red">Candidate selection validation is disabled by <b>#Validation.OfficerFirstName# #Validation.OfficerLastName#</b> on #dateformat(Validation.created, CLIENT.DateFormatShow)#</font>
		</td>
	</tr>	
		
	<cfelse>
		
	<tr><td height="20">	
		 &nbsp;<a href="javascript:ptoken.navigate('#session.root#/Vactrack/Application/Document/DocumentCandidateValidation.cfm?documentNo=#url.documentno#','selectionvalidation')">		 
		 Press here to overwrite the candidate selection limitation		 
		 </a>
		</td>
	</tr>	
	

	</cfif>
</td></tr>
</table>	

</cfoutput>	