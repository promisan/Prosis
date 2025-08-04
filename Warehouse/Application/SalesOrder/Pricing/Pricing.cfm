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

<cfif isDefined("form.currency")>

	<cfset url.category        = form.category>
	<cfset url.programcode     = form.ProgramCode>
	<cfset url.currency        = form.currency>
	<cfset url.SelectionDate   = form.SelectionDate>
	<cfset url.taxcode         = form.TaxCode>
	<cfset url.PriceSchedule   = form.PriceSchedule>
	<cfset url.InStock         = form.InStock>
	<cfset url.ReceiptDate     = form.ReceiptDate>
	<cfset url.hasprice        = form.Hasprice>
	
<cfelse>

	<table width="100%" height="300" align="center">
	<tr><td class="label" align="center"><font color="808080">No sales pricing was defined for this facility and category. <br>Please define this under  Maintain Warehouse Category - Set Price Schedule.</font></td></tr>	
	<cfabort>
	
</cfif>

<cfajaximport tags="cfform,cfdiv">

<table width="100%" height="100%" align="center">	
	<tr class="hide"><td height="1" id="process2"></td></tr>	 	
	<tr>	
		<td colspan="2" height="100%" valign="top">			
		<table width="100%" height="100%">		
			<cf_menucontainer item="1" class="regular">
				<cf_securediv id="divPriceMenu" style="height:100%" bind="url:../../SalesOrder/Pricing/Listing/ControlListData.cfm?mission=#url.mission#&warehouse=#url.warehouse#&systemfunctionid=#url.systemfunctionid#&currency=#url.currency#&category=#url.category#&programcode=#url.programcode#&selectionDate=#url.SelectionDate#&taxcode=#url.TaxCode#&InStock=#url.InStock#&PriceSchedule=#url.PriceSchedule#&receiptDate=#url.ReceiptDate#&hasprice=#url.hasPrice#">
			</cf_menucontainer>							
		</table>
		</td>
	</tr>	
</table>