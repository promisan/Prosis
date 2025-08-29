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
<cfquery name="qTypes" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
  SELECT AddressType, Operational, T.Description
  FROM   Ref_SubmissionEditionAddressType R
  LEFT   OUTER JOIN Organization.dbo.Ref_AddressType T
  		ON R.AddressType = T.Code
  WHERE  SubmissionEdition = '#URL.SubmissionEdition#'
</cfquery>

<cfoutput>

<cfset TotalActive = 0>

<table border="0"">	
	
	<TR valign="top">

	<TD style="padding-left:53px"></TD>	
	<TD>
		<table border="0">
			<tr height="20px" align="left">
			
				<cfloop query="qTypes">
					
						<td width="2%">
							<cfif operational eq 1>
								<input type="checkbox" onclick="recipienttype('disable','#URL.SubmissionEdition#','#AddressType#')" checked>
								<cfset TotalActive = TotalActive + 1>
							<cfelse>
								<input type="checkbox" onclick="recipienttype('enable','#URL.SubmissionEdition#','#AddressType#')">
							</cfif>
		
						</td>		
						<td  class="labelmedium fixlength" style="padding-left:4px;padding-right:10px;">
							<cfif Description neq "">	
								#Description#
							<cfelse>
								#AddressType#
							</cfif>
						</td>
								
				</cfloop>
			
		   </tr>
		</table>
	</TD>

	</TR>		

</TABLE>

<script language="JavaScript1.1">
	$('##ltypesrecipients').html('<b>Types of Addressee (#TotalActive#)</b>');
</script>

</cfoutput>


