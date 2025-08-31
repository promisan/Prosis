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
<cfquery name="Candidacy" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	DELETE FROM  ApplicantFunction
	WHERE ApplicantNo = '#client.applicantNo#'
	AND   FunctionId  = '#URL.ID#' 
</cfquery>	

<table width="80%" align="center">
<tr>
	<td colspan="5" class="labelit"><font color="FF0000"><cf_tl id="Your interest has been withdrawn"></b></td>
</tr>	
</table>

<cfoutput>
	<script>
		if ($('.shortApplyContainer_#url.id#').length == 1) {
			$('.shortApplyContainer_#url.id#').show();
		}
	</script>
</cfoutput>