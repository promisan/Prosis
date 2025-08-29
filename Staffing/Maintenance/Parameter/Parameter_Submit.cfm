<!--
    Copyright © 2025 Promisan B.V.

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
	
