<!--
    Copyright © 2025 Promisan

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->
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

