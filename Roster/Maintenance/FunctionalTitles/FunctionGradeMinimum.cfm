<cfparam name="url.mode" default="dialog">

<cfquery name="Grade" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM FunctionTitle F, OccGroup O,
	     FunctionTitleGrade G
	WHERE F.FunctionNo = G.FunctionNo
	AND   F.FunctionNo = '#URL.ID#' 
	AND   O.OccupationalGroup = F.OccupationalGroup
	AND   Operational = 1
</cfquery>

<cfparam name="URL.ID1" default="#Grade.GradeDeployment#">

<cfquery name="Profile" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   FunctionTitleGrade
	WHERE  FunctionNo= '#URL.ID#'
	AND    GradeDeployment = '#URL.ID1#'
</cfquery>

<cfinvoke component="Service.AccessGlobal"  
	      method="global" 
		  role="FunctionAdmin" 
		  returnvariable="Access">

<cfoutput>


<table width="99%" cellspacing="0" cellpadding="0" align="center">

<tr><td height="4"></td></tr>

<cfif url.mode eq "Dialog">

<cfelse>
	
	<tr><td height="1" colspan="3" class="linedotted"></td></tr>
		  
	<tr><td colspan="3" align="center" height="30">
	<input type="button" name="Print" value="Print profile" class="button10g" onFocus="javascript:print()">
	<cfif Access eq "EDIT" or Access eq "ALL"> 
		<input type="submit" name="Save" class="button10g" value="Save">
	</cfif>
	</td></tr>
	<input type="hidden" name="GradeDeployment" value="#URL.ID1#">

</cfif>

<tr><td height="1" colspan="3" class="linedotted"></td></tr>

<tr><td height="1"></td></tr>
<tr><td colspan="3">
	<cfinclude template="FunctionBuilder/FunctionBuilder.cfm">
</td></tr>
<tr><td height="4"></td></tr>

</table>

</cfoutput>