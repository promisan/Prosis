
<TITLE>Preferences submit</TITLE>
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

<!--- prevent caching --->
<meta http-equiv="Pragma" content="no-cache"> 
<script language="JavaScript">
javascript:window.history.forward(1);
</script> 

<cfparam name="Form.EnableMailHolder" default="0">

<cfquery name="UpdateUser" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
UPDATE   UserNames 
SET      eMailAddressExternal     = '#Form.eMailAddressExternal#'
WHERE    Account = '#SESSION.acc#'
</cfquery>

<cfquery name="Update" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
UPDATE  UserEntitySetting
SET     EnableMailHolder = '#Form.EnableMailHolder#'
WHERE   Account    = '#SESSION.acc#' 
AND     EntityCode = '#URL.EntityCode#'
</cfquery>
		
<cfquery name="System" 
	datasource="AppsSystem">
	SELECT *
	FROM Ref_ModuleControl
	WHERE SystemModule = 'SelfService'
	AND   FunctionClass IN ('SelfService','Report')
	AND   FunctionName = '#URL.ID#' 
</cfquery>
										
<cfoutput>
	<script language="JavaScript">
		window.location = "#SESSION.root#/#System.FunctionDirectory#/#System.FunctionPath#?ID=#URL.ID#&#system.FunctionCondition#"
	</script>
</cfoutput>
	