
<link rel="stylesheet" type="text/css" href="../../../../<cfoutput>#client.style#</cfoutput>"> 

<cfif ParameterExists(Form.Update)>

	<cfquery name="Update" 
	datasource="AppsEPas" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	UPDATE Parameter
	SET PasNo                  = '#Form.PasNo#',
	    ApplicationName        = '#Form.ApplicationName#',
		TemplateRoot           = '#Form.TemplateRoot#',
		TemplateHome           = '#Form.TemplateHome#',  
		PeriodDefault          = '#Form.PeriodDefault#', 
		NoTasks                = '#Form.NoTasks#', 
		MinTasks               = '#Form.MinTasks#',		
		HideObjective          = '#Form.HideObjective#',
		HideTraining           = '#Form.HideTraining#'
	WHERE ParameterKey      = '#Form.ParameterKey#'
	</cfquery>

<table width="100%" align="center">

<tr><td class="labelmedium" style="font-size:20px;padding-top:100px" align="center" >Parameters have been updated!</td></tr>
<tr><td align="center" style="padding-top:20px">
<cfform action="ParameterEdit.cfm" method="POST">
<INPUT class="button10g" type="submit" name="Staff" value="    OK    ">
</CFFORM>
</td></tr>
</table>

<cfelse> 

    <cflocation url="../../Menu.cfm" addtoken="No">

</cfif>	
	
