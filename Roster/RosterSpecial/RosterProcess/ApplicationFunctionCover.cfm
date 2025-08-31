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
	<cfquery name="Cover" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT * 
		FROM  ApplicantFunctionDocument
		WHERE ApplicantNo         = '#URL.ID#' 
		AND   FunctionId          = '#URL.ID1#'
	</cfquery>
	
	<cfif cover.recordcount gt 0 and len(cover.documenttext) gte "5">

		
		<tr><td colspan="2">
		
       		<table width="95%" align="center" border="0" cellspacing="0" cellpadding="0" class="regular" id="coverletter">
			<tr><td height="2"></td></tr>
			
			<tr><td>
						   
					<table width="100%" cellspacing="0" cellpadding="0" class="formpadding">			
					<cfoutput query="Cover">
							<tr><td style="padding:3px"><font face="Verdana" color="gray" style="font-style: italic;">#DocumentText#</td></tr>
					</cfoutput>					
		   			</table>					
						
			</td></tr>
			</table>

		</td></tr>
		
	</cfif>
	