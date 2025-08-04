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
<cfparam name="url.currentrow" 			default="1">
<cfparam name="url.ContractDuration" 	default="0">
<cfparam name="url.Credit" 				default="0">
<cfparam name="url.style" 				default="">

<cfoutput>
	<table width="230" cellspacing="0" cellpadding="0" class="formpadding">
		<tr class="clsCreditRows" id="CreditRow_#url.currentRow#" style="#url.style#" data-val="#url.currentRow#">
			<td align="center" width="10%">
				<cf_img icon="delete" onclick="removeCreditLine('#url.currentRow#');">
			</td>
			<td width="45%" style="border:1px solid silver;border-bottom:0px">
				<cf_tl id="Please enter a valid integer duration" var="1">
				<input 
					type="Text" 
					class="regularh enterastab" 
					name="ContractDuration_#url.currentRow#" 
					id="ContractDuration_#url.currentRow#" 
					value="#url.ContractDuration#" 
					validate="integer" 
					required="Yes" 
					message="#lt_text#"
					style="width:100%;text-align:center;;border:0px">
			</td>
			<td width="45%" style="border:1px solid silver;border-bottom:0px">
				<cf_tl id="Please enter a valid integer credit" var="1">
				<input 
					type="Text" 
					class="regularh enterastab" 
					name="Credit_#url.currentRow#" 
					id="Credit_#url.currentRow#" 
					value="#url.Credit#" 
					validate="numeric" 
					required="Yes"
					message="#lt_text#"
					style="width:100%;text-align:center;border:0px">
			</td>
		</tr>
	</table>
</cfoutput>