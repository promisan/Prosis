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
<cfparam name="url.serviceselected" default="">

<cfquery name="Document" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT * 
		FROM   Ref_EntityDocument 
		WHERE  EntityCode   = 'GLTransaction'
		AND    DocumentType = 'document'
</cfquery>

<cfquery name="getTransaction" 
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT 	*
	FROM 	TransactionHeader
	WHERE 	Journal  = '#journal#'
	AND		Journalserialno = '#journalserialno#'
</cfquery>

<cfif Document.recordCount gt 0>
	<table width="95%" align="center">
		<tr>
			<td width="10%">
				<cfoutput>
					<img src="#session.root#/images/form.png">
				</cfoutput>
			</td>
			<td valign="top">
				<table width="100%" align="center">
					<tr><td height="20"></td></tr>
					<tr valign="middle">
						<td class="labelmedium">
							<cf_tl id="Select a format to print">:
						</td>
					</tr>
					<tr><td height="5"></td></tr>
					<tr>
						<td align="center">
							<select name="printdocument" id="printdocument" style="width:100%" class="regularxl enterastab">
								<option value="">-- <cf_tl id="Select"> --</option>	  
								<cfoutput query="Document">
									<cfif url.serviceselected neq "">
											<option value="#documentid#" data-template="#documenttemplate#" <cfif url.serviceselected eq documentCode>selected</cfif> >#DocumentCode# #DocumentDescription#</option>
										<cfelse>
											<option value="#documentid#" data-template="#documenttemplate#" <cfif getTransaction.printDocumentId eq documentId>selected</cfif> >#DocumentCode# #DocumentDescription#</option>
									</cfif>
								</cfoutput>
							</select>
						</td>
					</tr>
					<tr><td height="15"></td></tr>
					<tr><td class="line"></td></tr>
					<tr><td height="15"></td></tr>
					<tr>
						<td class="labelmedium" align="center">
							<cf_tl id="Print" var="1">
							<cfoutput>
								<input type="button" class="button10g" value="#lt_text#" onclick="doPrintFormat('#journal#', '#journalserialNo#',$('##printdocument').val(), $('##printdocument').find(':selected').attr('data-template'));">
							</cfoutput>
						</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
	
</cfif>