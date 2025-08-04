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

<cfoutput>

<table width="97%" cellspacing="0" cellpadding="0" align="center" class="formpadding">
	
	<tr><td height="6"></td></tr>
	
	<TR>
    <td width="200" class="labelmedium2">Operation Mode:</b></td>
    <TD width="70%" class="labelmedium2">
		<table>
			<tr class="labelmedium2">
			<td style="padding-left:0px"><input type="radio" class="radiol" name="OperationMode" id="OperationMode" <cfif OperationMode eq "Internal">checked</cfif> value="Internal"></td>
			<td style="padding-left:3px">Internal (Internal Distribution)</td>
			<td style="padding-left:6px"><input type="radio" class="radiol" name="OperationMode" id="OperationMode" <cfif OperationMode eq "External">checked</cfif> value="External"></td>
			<td style="padding-left:3px">External (External Customers, Sales)</td>
			</tr>
		</table>
    </td>
    </tr>	
				
	<TR>
    <td class="labelmedium2">Lot Management:</b></td>
    <TD class="labelmedium2">
	<table>
		<tr class="labelmedium2">
		<td style="padding-left:0px"><input type="radio" class="radiol" name="LotManagement" id="LotManagement" <cfif LotManagement eq "1">checked</cfif> value="1"></td>
		<td style="padding-left:3px">Yes</td>
		<td style="padding-left:6px"><input type="radio" class="radiol" name="LotManagement" id="LotManagement" <cfif LotManagement eq "0">checked</cfif> value="0"></td>
		<td style="padding-left:3px">No</td>
		</tr>
	</table>
    </tr>	
	
	<cfquery name="Tree" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT     *
	FROM       Ref_Mission
	WHERE      MissionStatus = '1'
	</cfquery>
	
	<TR>
    <td class="labelmedium2">POS Customer Tree:</b></td>
    <TD>
	<select name="TreeCustomer" id="TreeCustomer" class="regularxl">
	<cfloop query="Tree">
	<option value="#Mission#" <cfif get.TreeCustomer eq mission>selected</cfif>>#Mission#</option>
	</cfloop>
	</select>
    </td>
    </tr>	
	
	<TR>
    <td class="labelmedium2">Sales Price setting:</b></td>
    <TD class="labelmedium2">
	<table>
		<tr class="labelmedium2">
		<td style="padding-left:0px"><input type="radio" class="radiol" name="PriceManagement" id="PriceManagement" <cfif PriceManagement eq "1">checked</cfif> value="1"></td>
		<td style="padding-left:3px">Define on level store</td>
		<td style="padding-left:6px"><input type="radio" class="radiol" name="PriceManagement" id="PriceManagement" <cfif PriceManagement eq "0">checked</cfif> value="0"></td>
		<td style="padding-left:3px">Entity level</td>
		</tr>
	</table>
    </tr>			
	
	<TR>
    <td class="labelmedium2">Sales Tax Mode COGS:</b></td>
    <TD class="labelmedium2">
	<table>
		<tr class="labelmedium2">
		<td style="padding-left:0px"><input type="radio" class="radiol" name="TaxManagement" id="TaxManagement" <cfif TaxManagement eq "1">checked</cfif> value="1"></td>
		<td style="padding-left:3px">Apply tax correction to Sales</td>
		<td style="padding-left:6px"><input type="radio" class="radiol" name="TaxManagement" id="TaxManagement" <cfif TaxManagement eq "0">checked</cfif> value="0"></td>
		<td style="padding-left:3px">Manual (like Fomtex)</td>
		</tr>
	</table>
    </tr>						
		
	<TR>
    <td class="labelmedium2">Distribution Prefix/LastNo:</b></td>
    <TD class="labelmedium2">
	<table>
		<tr class="labelmedium2">
		<td style="padding-left:0px">
		<input type="text" class="regularxl" name="DistributionPrefix" id="DistributionPrefix" value="#DistributionPrefix#" size="6" maxlength="6" style="text-align: right;">
		</td>
		<td style="padding-left:2px">
		<input type="text" class="regularxl" name="DistributionSerialNo" id="DistributionSerialNo" value="#DistributionSerialNo#" size="6" maxlength="6" style="text-align: right;">
		</td>
		</tr>
	</table>
    </TD>
	</TR>
	
			
	<TR>
    <td class="labelmedium2">Forward BackOrdered requirements to Associated Warehouse:</b></td>
    <TD>
	<table>
		<tr class="labelmedium2">
		<td style="padding-left:0px"><input type="radio" class="radiol" name="ForwardBackorder" id="ForwardBackorder" <cfif ForwardBackorder eq "1">checked</cfif> value="1"></td>
		<td style="padding-left:3px">Auto</td>
		<td style="padding-left:6px"><input type="radio" class="radiol" name="ForwardBackorder" id="ForwardBackorder" <cfif ForwardBackorder eq "0">checked</cfif> value="0"></td>
		<td style="padding-left:3px">Manual</td>
		</tr>
	</table>
    </td>
    </tr>			
	
	<TR>
    <td class="labelmedium2">Pickticket Template:</b></td>
    <TD>
  	    <cfinput class="regularxl" type="Text" name="PickTicketTemplate" value="#PickTicketTemplate#" message="Please enter a directory name" required="No" size="60" maxlength="80">
    </TD>
	</TR>
	
	
	<TR>
    <td class="labelmedium2">Receipt Delivery Device (Fuel):</b></td>
    <TD>
  	   
	<cfquery name="Category" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT  *
		FROM    Ref_Category
	</cfquery>
	
	<select name="ReceiptDevice" id="ReceiptDevice" class="regularxl">
	<option>
	<cfloop query="Category">
	<option value="#Category#" <cfif get.ReceiptDevice eq Category>selected</cfif>>#Description#</option>
	</cfloop>
	</select>
	   
    </TD>
	</TR>
	
	<TR>
    <td class="labelmedium2">FIFO/LIFO revaluation cutoff date:</b></td>
    <TD class="labelmedium2">
	
	  <cf_intelliCalendarDate9
			FieldName="RevaluationCutoff" 
			Default="#Dateformat(RevaluationCutoff, CLIENT.DateFormatShow)#"
			class="regularxl"
			AllowBlank="False">			
		
    </td>
    </tr>
	
	
	
	<tr><td height="4"></td></tr>
		
	</table>
	
</cfoutput>	