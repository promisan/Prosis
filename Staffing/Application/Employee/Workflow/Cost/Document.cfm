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
<cfquery name="Currency" 
datasource="AppsLedger"
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM Currency
</cfquery>

<cfquery name="Entitlement" 
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT  *
    FROM    PersonMiscellaneous
	WHERE   PersonNo = '#Object.ObjectKeyValue1#'
	AND     CostId   = '#Object.ObjectKeyValue4#'
</cfquery>

<cfquery name="Justification" 
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT  *
    FROM    PersonMiscellaneousAction 
	WHERE   PersonNo = '#Object.ObjectKeyValue1#'
	AND     CostId   = '#Object.ObjectKeyValue4#'
	AND     ActionCode = 'Justification'
</cfquery>

 <table align="center" width="100%" class="formpadding formspacing">
	
	<tr><td height="5"></td></tr>
	    			
		
	<TR class="labelmedium">
        <td valign="top" style="min-width:200px;padding-top:5px"><cf_tl id="Tasks to complete">:</td>
        <td style="width:80%">
		<textarea style="width:99%;padding:3px;font-size:14px" class="regular" rows="7" name="ActionContent"><cfoutput>#Justification.ActionContent#</cfoutput></textarea> 
		</td>
	</TR>
		
	<TR>
    <TD class="labelmedium"><cf_tl id="Effective date">:</TD>
    <TD>
  
		  <cf_intelliCalendarDate9
			FormName="MiscellaneousEdit"
			FieldName="DateEffective" 
			class="regularxxl"
			DateFormat="#APPLICATION.DateFormat#"
			Default="#Dateformat(Entitlement.DateEffective, CLIENT.DateFormatShow)#"
			AllowBlank="False">	 
		
	</TD>
	</TR>
	
		
	<TR class="labelmedium">
    <TD><cf_tl id="Amount">:</TD>
    <TD>
	
		<table>
			<tr>
			<td>
			
			  	<select name="Currency" size="1" style="height:28px" class="regularxxl">
				<cfoutput query="Currency">
					<option value="#Currency#" <cfif Entitlement.Currency eq Currency>selected</cfif>>#Currency#</option>
				</cfoutput>
			    </select>
			
			</td>
			<td style="padding-left:3px">
			
			    <cfoutput>
				
				<input type="Text" 
				    name="Amount" 
					value="#NumberFormat(Entitlement.Amount, ".__")#"
				    message="Please enter a correct amount" 
					validate="float" 
					required="Yes" 
					size="12" 
					maxlength="16" 
					class="regularxxl"
					style="text-align: right">	
					
				</cfoutput>	
				
			</td>
			</tr>
		</table>	
			
	</TD>
	</TR>	
		
	<tr><td> 
		<input name="savecustom" type="hidden"  
		    value="Staffing/Application/Employee/Workflow/Cost/DocumentSubmit.cfm">
		</td>
	</tr>      		
		  
</table>

