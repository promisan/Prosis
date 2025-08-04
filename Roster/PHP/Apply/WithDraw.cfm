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
<cfquery name="Candidacy" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	DELETE FROM  ApplicantFunction
	WHERE ApplicantNo = '#client.applicantNo#'
	AND   FunctionId  = '#URL.ID#' 
</cfquery>	

<tr><td colspan="6"></td></tr>
<tr><td></td><td colspan="5" class="labelmedium" bgcolor="FFBFBF"><b><font color="FF0000">Attention:</font>&nbsp;Your candidacy was withdrawn</b></td></tr>	
<tr><td colspan="6"></td></tr>