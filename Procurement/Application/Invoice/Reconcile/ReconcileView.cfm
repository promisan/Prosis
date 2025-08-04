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

<cfinclude template="InitParam.cfm">

<table width="100%" border="0" height="100%" align="center" border="0">
	
	<tr><td height="20" colspan="2" class="labellarge" style="font-size:22px;height:40px;padding-left:24px">
		<cfoutput>
		#url.Mission# ERP disbursement - #SESSION.welcome# Reconciliation
		</cfoutput>
	</td></tr>
		
	<tr><td id="reconcile" style="height:80" colspan="2"><cfinclude template="ReconcileResult.cfm"></td></tr>
		
	<tr>
		<td colspan="2" height="100%">
				
			<table class="formpadding" border="0" width="100%" height="100%">
				<tr>
			 		<td valign="top" id="invoicebox" width="50%" height="100%" style="border-top:1px solid silver;padding:8px">
						<cfinclude template="ReconcileViewInvoice.cfm">
					</td>					
			 		<td valign="top" width="50%" height="100%" style="border-top:1px solid silver;border-left:1px solid gray;padding:8px">
						<cfinclude template="ReconcileViewLedger.cfm">
					</td>
				</tr>
			</table>
		
		</td>
	</tr>
	
</table>

