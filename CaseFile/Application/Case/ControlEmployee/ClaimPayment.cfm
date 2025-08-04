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
<cfparam name="URL.CaseNo" default="">

<cfquery name="Details" 
	datasource="AppsCaseFile" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT C.ClaimMemo,CI.Remarks
	FROM   Claim C, ClaimIncident CI
	where
	C.ClaimId=CI.ClaimId and C.CaseNo='#URL.CaseNo#' 
</cfquery>


	<table width="100%" border="0" cellspacing="0" cellpadding="0" class="formpadding" bordercolor="E4E4E4">
	
		<tr>
	    <td width="100%">
	    <table width="100%" border="0" cellspacing="0" cellpadding="0">
			<cfif Details.recordcount eq "0">
			  <TR><td height="15" colspan="4" align="center">&nbsp;<cf_tl id="No records found for this view" class="message"></b></td><TR>
			<cfelse>

		    <cfoutput query="Details">
		   
			<TR>
		    <TD height="15" width="10%"></TD>
			<TD height="15" width="1%"><img src="#Client.VirtualDir#/Images/join.gif"></TD>
			<TD height="15" width="79%%">#ClaimMemo#</TD>
		    </TR>	
			<TR>
		    <TD height="15" width="10%"></TD>
			<TD height="15" width="1%"></TD>
			<TD height="15" width="79%%">#Remarks#</TD>
		    </TR>	

			
			</CFOUTPUT>
			
			
			
			</cfif>
			
		
		</table>

		</td></tr>

	</table>
