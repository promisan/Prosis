<HTML><HEAD>
	<TITLE>Variable</TITLE>
</HEAD>
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

<script language="JavaScript">

function expand(name,nos)

{

v = document.getElementById("vars")
v.style.visibility='visible'

}	

</script>

<cfquery name="Var" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT  *
FROM    Ref_EntityVariable
WHERE EntityCode = '#Attributes.EntityCode#' 
</cfquery>

<select name="" id="" style="background: E6E6E6;">
  <cfloop query="Var">
   <option value="#VariableName#">@<cfoutput>#VariableName#</cfoutput>&nbsp;::&nbsp;<cfoutput>#VariableDescription#</cfoutput></option>
  </cfloop>
 </select>

