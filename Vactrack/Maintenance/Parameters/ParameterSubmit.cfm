
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>"> 


<cfif ParameterExists(Form.Update)>

<cfquery name="Delete" 
 datasource="AppsVacancy" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
UPDATE Parameter
SET DocumentNo          = '#Form.DocumentNo#',
    MaximumAge          = '#Form.MaximumAge#',
	InterviewStep       = '#Form.InterviewStep#',
	ShowAttachment      = '#Form.ShowAttachment#',
	ShortlistConflict   = '#Form.ShortlistConflict#'
WHERE Identifier      = '#Form.Identifier#'
</cfquery>

<!---
<hr>
 <p align="center"><font face="Calibri" size="3">Recruitment parameters have been updated! </b></p>
<hr>

<cfform action="ParameterEdit.cfm" method="POST">
<INPUT class="button10g" type="submit" name="Staff" value="OK">
</CFFORM> --->

<script>
	alert('Parameters have been saved.');
</script>

<cfinclude template="ParameterEdit.cfm">

<cfelse> 

<cflocation url="../../../Portal/Portal.cfm" addtoken="No">
 

</cfif>	
	
