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

<table width="97%" cellspacing="0" cellpadding="0" align="center" class="formpadding">
	
	<tr><td height="6"></td></tr>		
		
	<TR class="labelmedium2">
    <td width="200">Taskorder Prefix/LastNo:</b></td>
    <TD>
 		<input type="text" class="regularxl" name="TaskOrderPrefix" id="TaskOrderPrefix" value="#TaskOrderPrefix#" size="6" maxlength="6" style="text-align: right;">
		<input type="text" class="regularxl" name="TaskOrderSerialNo" id="TaskOrderSerialNo" value="#TaskOrderSerialNo#" size="6" maxlength="6" style="text-align: right;">
    </TD>
	</TR>
		
	<TR class="labelmedium2">
    <td>External Funding Order Type:</b></td>
    <TD>
  	   
		<cfquery name="OrderType" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT  *
			FROM    Ref_OrderType
			WHERE  Code IN (SELECT Code 
			                FROM   Ref_OrderTypeMission 
							WHERE  Mission = '#url.mission#')
		</cfquery>
		
		<cfif OrderType.recordcount eq "0">
		
			<cfquery name="OrderType" 
				datasource="AppsPurchase" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT  *
				FROM    Ref_OrderType		
			</cfquery>
		
		</cfif>
		
		<select name="FundingOrderType" id="FundingOrderType" class="regularxl">
		
			<cfloop query="OrderType">
			<option value="#Code#" <cfif get.FundingOrderType eq Code>selected</cfif>>#Description#</option>
			</cfloop>
			
		</select>
	   
    </TD>
	</TR>
		
	<tr><td height="4"></td></tr>
		
	</table>
	
</cfoutput>	