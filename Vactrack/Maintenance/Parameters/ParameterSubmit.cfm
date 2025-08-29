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
	
