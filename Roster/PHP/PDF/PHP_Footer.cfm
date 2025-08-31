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
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />		
	<style type="text/css">
		td.footer {
			font-size : 7pt;
		}
	</style>
	
</head>
	<cfoutput>
	<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">

	<tr>
		<td width="2%"></td>
		<td class="footer" width="71%" align="left">PHP for #Applicant.FirstName# #UCase(Applicant.LastName)# (#Applicant.SubmissionSource#) Ref. #Applicant.SourceOrigin# <cfif prefix neq "">- #qFunction.ReferenceNo# </cfif>
		 <cfif prefix neq "">Submitted PHP</cfif>	
	</td>
		<td class="footer" align="right">
			#cfdocument.currentpagenumber# of #cfdocument.totalpagecount#
		</td>
		<td width="2%"></td>
	</tr>	
	</table>
	</cfoutput>

