
<cfquery name="function" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM   Ref_ModuleControl
	WHERE  SystemFunctionId = '#URL.Id#'
	</cfquery>

<cfoutput>
  <cfif Function.Operational eq "0">
    <img src="#SESSION.root#/Images/alert_stop.gif" align="absmiddle" alt="Deactivated" border="0">
  <cfelse>
    <img src="#SESSION.root#/Images/status_ok1.gif" align="absmiddle" alt="Operational" border="0">
  </cfif>
</cfoutput>  
  