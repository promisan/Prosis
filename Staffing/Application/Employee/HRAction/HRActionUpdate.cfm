
<cfquery name="get" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    UPDATE PersonAction
	SET   Remarks = '#form.Remarks#'
	WHERE  PersonActionId = '#url.PersonActionId#'
</cfquery>

&nbsp;<font color="0080C0">saved</font>