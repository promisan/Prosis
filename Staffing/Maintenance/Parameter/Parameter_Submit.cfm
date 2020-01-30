
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>"> 

<cfparam name="Form.Reset" default="0">

<cfif ParameterExists(Form.Update)>

<cfquery name="Update" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
UPDATE Parameter
SET 
<!---
<cfif Form.Reset eq "1">
TimeStampFactTable     = NULL, 
</cfif>
--->
    AssignmentMemo        = '#Form.AssignmentMemo#',
	EnablePersonGroup     = '#Form.EnablePersonGroup#',
	GenerateApplicant     = '#Form.GenerateApplicant#' 
WHERE Identifier           = '#Form.Identifier#'
</cfquery>

<cfif Form.Reset eq "1">

	<cfinclude template="../../Reporting/PostView/Global/FactTable.cfm">
	
	<cf_waitEnd>

</cfif>

<hr>
 <p align="center"><b><font face="Verdana" size="2">Parameters have been updated!</font></b></p>
<hr>
<cfform action="ParameterEdit.cfm" method="POST">
<INPUT class="button10p" type="submit" name="Staff" value="    OK    ">
</CFFORM>
  
<cfelse> 

<cflocation url="../../../Portal/Portal.cfm" addtoken="No">
 

</cfif>	
	
