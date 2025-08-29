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
<cfoutput>



<cfinclude template="ActionStepPrintHeader.cfm">

<cfset LineColor = "F1F1F1">

<br>
	<table width="100%" align="center" cellspacing="0" cellpadding="0">
		<tr valign="top">
			<td width="5%"><strong>Action Code</strong></td>
			<td width="5">&nbsp;</td>
			<td width="35%"><strong>Description</strong></td>
			<td width="17%"><strong>Reference</strong></td>
			<td width="33%"><strong>Document</strong></td>
			<td width="5%"><strong>Type</strong></td>
		</tr>
		
		<tr><td colspan="6" class="line"></td></tr>
		
		<cfset RowNum = 1>

		<cfloop query="GetAction">
		
			<cfquery name="QueryDocuments" 
				dbtype="query">
				Select DocumentDescription, DocumentMode, DocumentTemplate
				FROM GetDocuments
				WHERE ActionCode = '#GetAction.ActionCode#'
				</cfquery>
				
				<cfset DocNum = 0>
				
			<tr valign="top" <cfif RowNum MOD 2 eq 0> bgcolor="#LineColor#"</cfif>>
				<td>#GetAction.ActionCode#</td>
				<td>&nbsp;</td>
				<td>#GetAction.ActionDescription#</td>
				<td>#GetAction.ActionReference#</td>
				<td colspan="2">
				<table width="100%" align="center" cellspacing="0" cellpadding="0">
				<cfloop query="QueryDocuments">
						<tr>
						<td colspan="2">#QueryDocuments.DocumentDescription#</td>
						<td align="right">#QueryDocuments.DocumentMode#</td>
						</tr>
						<tr <cfif RowNum MOD 2 eq 0> bgcolor="#LineColor#"</cfif>>						
							<td colspan="2">
							<table width="100%" cellspacing="0" cellpadding="0">							
								<tr>
								<td style="font-size: smaller;">&nbsp;&nbsp;&nbsp;&nbsp;
									<cfif Find("/",Reverse(QueryDocuments.DocumentTemplate)) gt 0>
										#Right(QueryDocuments.DocumentTemplate,Find("/",Reverse(QueryDocuments.DocumentTemplate))-1)#
									</cfif>	
								</td>
								</tr>
<!---								<td style="font-size: smaller;">#Replace(QueryDocuments.DocumentTemplate,"/"," ","All")#</td> --->
							</table>
							</td>	
						</tr>
				</cfloop>
				</table>
				
				</td>

<!---				<cfloop query="QueryDocuments">
						<td>#QueryDocuments.DocumentDescription#</td>
						<td>#QueryDocuments.DocumentMode#</td>
					</tr>
					<tr <cfif RowNum MOD 2 eq 0> bgcolor="E7E7E7"</cfif>>
						<td colspan="3"></td>	
						<td colspan="2" style="font-size: smaller;">#QueryDocuments.DocumentTemplate#</td>
					</tr>
				
					<cfset DocNum++>
					<cfif DocNum lt QueryDocuments.RecordCount>
						<tr <cfif RowNum MOD 2 eq 0> bgcolor="E7E7E7"</cfif>>
						<td colspan="3"></td>	
					</cfif>
				</cfloop>
				
				<cfif QueryDocuments.RecordCount eq 0>
					<td colspan="2"></td>	
				</cfif>
--->
			</tr>

			<cfset RowNum++>
				
		</cfloop>

	</table>


</cfoutput>