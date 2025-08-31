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

<cfparam name="url.settlementphase" 	default="Final">
<cfparam name="url.documentCurrency" 	default="0">

<cf_screentop height="100%" layout="webapp" label="Payroll Slip" banner="gray" user="Yes" option="Statement of Earnings and Deductions" >
	
	<table width="100%" align="center" height="100%" border="0" cellspacing="0" cellpadding="0">
	
	<tr><td width="100%" height="100%" align="center">
		<iframe src="SalarySlipPrint.cfm?settlementid=#url.settlementid#&settlementphase=#url.settlementphase#&documentCurrency=#url.documentCurrency#" width="100%" height="100%" frameborder="0"></iframe>
	</td></tr>
	
	</table>

<cf_screenbottom layout="webapp">

</cfoutput>