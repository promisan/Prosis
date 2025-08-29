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
<cfquery name="Get"
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM   Ref_PayrollItem
	WHERE  PayrollItem = '#URL.ID1#'
</cfquery>

<cfquery name="Source"
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM   Ref_PayrollSource	
</cfquery>

<cfquery name="Section"
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM   Ref_SlipGroup
</cfquery>

<cfquery name="Check"
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM   SalaryScheduleComponent
	WHERE  PayrollItem = '#URL.ID1#'
</cfquery>

<cfquery name="ClassList"
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM   Ref_EntityClass
	WHERE  EntityCode IN ('EntEntitlement','EntCost')
</cfquery>

<!--- edit form --->

<cfform action="RecordSubmit.cfm?idMenu=#url.idmenu#" method="POST" name="dialog">

<table width="95%" align="center" class="formpadding">
	
    <cfoutput>
	
	<tr><td height="4"></td></tr>	
	<TR>
    <TD class="labelmedium"><cf_tl id="Source">:</TD>
    <TD class="regular">
		<select name="Source" class="regularxl">
     	   <cfloop query="Source">
        	   <option value="#Code#" <cfif get.Source eq code>selected</cfif>>#Description#</option>
         	</cfloop>
	    </select>
		
    </TD>
	</TR>
					
    <TR>
    <TD class="labelmedium"><cf_tl id="Code">:</TD>
    <TD>
	   <table><tr><td>
  	   <cfinput type="text" name="PayrollItem" value="#get.PayrollItem#" message="Please enter a code" required="Yes" size="10" maxlength="30" class="regularxl">
       <input type="hidden" name="PayrollItemOld" value="#get.PayrollItem#" class="regular">
	   </td>
	   <TD style="padding-left:10px" class="labelmedium"><cf_tl id="Operational">:</TD>
       <TD style="padding-left:5px">
			
		    <table><tr class="labelmedium2">
			<td><input type="radio" class="radiol" name="Operational" id="Operational" <cfif get.Operational eq "1" or url.id1 eq "">checked</cfif> value="1"></td>
			<td><cf_tl id="Active"></td>
			<td style="padding-left:5px"><input type="radio" class="radiol" name="Operational" id="Operational" <cfif get.Operational eq "0">checked</cfif> value="0"></td>
			<td><cf_tl id="Disabled"></td>
			</tr>
			</table>
				
		</td>
	   
	   </tr>
	   </table>
    </TD>
	</TR>
		
   <TR>
    <TD class="fixlength labelmedium"><cf_tl id="Entitlement Workflow">:</TD>
    <TD>
  	  <select name="EntityClass" class="regularxl">
	       <option value="">N/A</option>
     	   <cfloop query="ClassList">
        	   <option value="#EntityClass#" <cfif get.EntityClass eq entityClass>selected</cfif>>#EntityClassName#</option>
         	</cfloop>
	    </select>
    </TD>
	</TR>
	
	<TR>
    <TD class="labelmedium"><cf_tl id="Default class">:</TD>
     <TD>
		    <table>
			<tr class="labelmedium2">
			    <td><INPUT type="radio" class="radiol" name="DefaultEntitlementClass" value="" <cfif get.DefaultEntitlementClass eq "">checked</cfif>></td>
				<td style="padding-left:5px;padding-right:10px"><cf_tl id="Any"></td>
				<td><INPUT type="radio" class="radiol" name="DefaultEntitlementClass" value="Payment" <cfif get.DefaultEntitlementClass eq "payment">checked</cfif>></td>
				<td style="padding-left:5px;padding-right:10px"><cf_tl id="Payment">/<cf_tl id="Earning"></td>
				<td><INPUT type="radio" class="radiol" name="DefaultEntitlementClass" value="Deduction" <cfif get.DefaultEntitlementClass eq "deduction">checked</cfif>></td>
				<td style="padding-left:5px;padding-right:10px"><cf_tl id="Deduction">/<cf_tl id="Recovery"></td>		
				<td><INPUT type="radio" class="radiol" name="DefaultEntitlementClass" value="Contribution" <cfif get.DefaultEntitlementClass eq "contribution">checked</cfif>></td>
				<td style="padding-left:5px"><cf_tl id="Contribution"></td>							
			</tr>
			</table>				
	</TD>
	</TR>
			
	<TR>
    <TD class="labelmedium"><cf_tl id="Description">:</TD>
    <TD>
	   <table>
	   <cf_LanguageInput
				TableCode       = "Ref_PayrollItem" 
				Mode            = "Edit"
				Name            = "PayrollItemName"
				Type            = "Input"
				Required        = "Yes"
				Value           = "#get.PayrollItemName#"
				Key1Value       = "#get.PayrollItem#"
				Message         = "Please enter a description"
				MaxLength       = "50"
				Size            = "40"
				Class           = "regularxl" 
				Label           = "yes">
		</table>
    </TD>
	</TR>
	
	<TD class="labelmedium" valign="top" style="padding-top:5px"><cf_tl id="Memo">:</TD>
    <TD><textarea rows="3" name="PayrollItemMemo" style="padding:3px;font-size:14px;width:100%" class="regular">#get.PayrollItemMemo#</textarea>
	</TD>
	</TR>
							
	<tr class="line"><td height="20" class="labelmedium"  style="font-size:20px" colspan="2">Presentation on Pay slip:</td></tr>
	<tr><td height="3"></td></tr>		
	
				<TR>
			    <TD class="labelmedium" style="padding-right:4px"><cf_tl id="Print Group">:</TD>
			    <TD class="regular">
				
				<table><tr><td>
				
					<select name="PrintGroup" class="regularxl">
			     	   <cfloop query="Section">
			        	   <option value="#PrintGroup#" <cfif get.PrintGroup eq PrintGroup>selected</cfif>>#Description#</option>
			         	</cfloop>
				    </select>
					
			    </TD>
										
			    <TD class="labelmedium" style="padding-left:7px">&nbsp;<cf_tl id="Order">:</TD>
			    <TD>&nbsp;
				
				<cfif get.PrintOrder eq "">
				 <cfset m = 1>
				<cfelse>
				 <cfset m = get.PrintOrder>
				</cfif>
					
				<cfinput type="Text"
			       name="PrintOrder"
			       value="#m#"
			       validate="integer"
			       required="Yes"
			       visible="Yes"
				   class="regularxl"
			       enabled="Yes"
			       size="2"
			       maxlength="3">
				  
				</TD>
				</TR>	
				
				</table>
				
				</td>
				</tr>
				

				<TR>
			    <TD valign="top" style="padding-top:7px;padding-right:6px" class="labelmedium"><cf_tl id="Name">:</TD>
			    <TD>
					<table>
						<cf_LanguageInput
							TableCode       = "Ref_PayrollItem" 
							Mode            = "Edit"
							Name            = "PrintDescription"
							Type            = "Input"
							Required        = "Yes"
							Value           = "#get.PrintDescription#"
							Key1Value       = "#get.PayrollItem#"
							Message         = "Please enter a code/short description to be shown on the payslip"
							MaxLength       = "40"
							Size            = "30"
							Class           = "regularxl" 
							Label           = "yes">
					</table>
				</TD>
				</TR>	
				
				<TR>
			    <TD valign="top" style="padding-top:7px;padding-right:6px" class="labelmedium"><cf_tl id="Name Long">:</TD>
			    <TD>
				  <table>
					 <cf_LanguageInput
						TableCode       = "Ref_PayrollItem" 
						Mode            = "Edit"
						Name            = "PrintDescriptionLong"
						Type            = "Input"
						Required        = "Yes"
						Value           = "#get.PrintDescriptionLong#"
						Key1Value       = "#get.PayrollItem#"
						Message         = "Please enter the full name to be shown on the payslip"
						MaxLength       = "60"
						Size            = "30"
						Class           = "regularxl" 
						Label           = "yes">
					</table>
				  
				</TD>
		</TR>	
		<tr><td height="3"></td></tr>				
		<tr class="line"><td height="20" colspan="2" style="font-size:20px" class="labelmedium">Settlement Settings:</td></tr>
		<tr><td height="3"></td></tr>	

				<TR>
			    <TD class="labelmedium fixlength" style="padding-right:5px"><cf_tl id="Entitlement registration overlap">:</TD>
			    <TD class="labelmedium" style="padding-left:10px">
				   <table>
				   <tr class="labelmedium">
				   <td><INPUT type="radio" class="radiol" name="AllowOverlap" value="1" <cfif "1" eq get.AllowOverlap>checked</cfif>><td>
				   <td style="padding-left:4px">Allowed</td>
				   <td style="padding-left:8px"><INPUT type="radio" class="radiol" name="AllowOverlap" value="0" <cfif "1" neq get.AllowOverlap>checked</cfif>></td>
				   <td style="padding-left:4px">No</td>
				   </tr>
				   </table>
				</TD>
				</TR>
				
				<TR>
			    <TD class="fixlength labelmedium"><cf_tl id="Posting Multiplier">:</TD>
			    <TD style="padding-left:13px">
				<cfif get.PaymentMultiplier eq "">
				 <cfset m = 1>
				<cfelse>
				 <cfset m = get.PaymentMultiplier> 
				</cfif>
				
				<cfinput type="Text"
			       name="PaymentMultiplier"
			       value="#m#"
			       validate="float"
			       required="Yes"
			       visible="Yes"
				   class="regularxl"
			       enabled="Yes"
				   style="width:35;text-align:center"
			       size="1"
			       maxlength="3">
				  
				</TD>
				</TR>
				
				<TR>
			    <TD class="labelmedium"><cf_tl id="Settlement">:</TD>
			    <TD>
				
				<table width="600" cellspacing="0" cellpadding="0">
				<tr><td style="padding-left:10px"><INPUT class="radiol" type="radio" name="Settlement" value="1" <cfif "1" eq get.settlement>checked</cfif>></td>
					 <td style="padding-left:2px" class="labelmedium">Enabled</td>
				     <td style="padding-left:4px"><INPUT class="radiol" type="radio" name="Settlement" value="0" <cfif "1" neq get.settlement>checked</cfif>></td>
					 <td style="padding-left:4px" class="labelmedium">Disabled</td>
				</TD>
																							
				<TD style="padding-left:14px;cursor: pointer;" class="labelit fixlength" align="right" title="Determines if calculated entitlements will be settled directly or settled in one or more specific months">
					<cf_tl id="Settle in Month(s)">:
				</TD>
			    <TD class="labelit fixlength" style="padding-left:4px" title="0 = <cf_tl id="monthly">; |1|7| = <cf_tl id="jan/july">">
				
				<cfif get.SettlementMonth eq "">
				 <cfset m = 0>
				<cfelse>
				 <cfset m = get.SettlementMonth>
				</cfif>
					
				<cfinput type="Text"
			       name="MonthPayment"
			       value="#m#"
			       required="Yes"
			       visible="Yes"
			       enabled="Yes"
				   class="regularxl"
			       size="10"
			       maxlength="10">
				   
				   0 = <cf_tl id="monthly">; |1|7| = <cf_tl id="jan/july"> 
				   
				   </td></tr></table>
				  
				</TD>
				</TR>	
						
				<TR>
			    <TD class="labelmedium fixlength"><cf_tl id="Only part of Final Payment">:</TD>
			    <TD class="labelmedium">
					<table><tr class="labelmedium">
					<td style="padding-left:10px"><INPUT type="radio" class="radiol" name="ExpirationPayment" value="1" <cfif "1" eq get.ExpirationPayment or get.ExpirationPayment eq "">checked</cfif>></td>
					<td style="padding-left:4px">Yes</td>
				    <td style="padding-left:10px"><INPUT type="radio" class="radiol" name="ExpirationPayment" value="0" <cfif "0" eq get.ExpirationPayment>checked</cfif>></td>
					<td style="padding-left:4px">No</td>
					</td></tr></table>
					
				</TD>
				</TR>

				<TR>
			    <TD valign="top" style="padding-top:5px" class="labelmedium"><cf_tl id="Settlement mode">:</TD>
			    <TD class="labelmedium">
					<table><tr class="labelmedium">
						<td style="padding-left:10px"><INPUT type="radio" class="radiol" name="AllowSplit" value="1" <cfif "1" eq get.AllowSplit>checked</cfif>></td>
						<td style="padding-left:4px">Split on Initial and Final (1) : <i>if option is applicable, it works like an advance</td>
						</tr>
						<tr class="labelmedium">
				    	<td style="padding-left:10px"><INPUT type="radio" class="radiol" name="AllowSplit" value="2" <cfif "2" eq get.AllowSplit>checked</cfif>></td>
						<td style="padding-left:4px">Pay item <u>only</u> on Final (2) : <i>unless the entitlement refers to a prior month</td>
						</tr>						
						<tr class="labelmedium">
				    	<td style="padding-left:10px"><INPUT type="radio" class="radiol" name="AllowSplit" value="4" <cfif "4" eq get.AllowSplit or "3" eq get.AllowSplit>checked</cfif>></td>
						<td style="padding-left:4px">Pay in full as soon as possible {4) : <i>recommended setting</i></td>
						</tr>
						
					</td>
					</tr>
					</table>
					
				</TD>
				</TR>
		
	</cfoutput>
	
	<tr><td height="5"></td></tr>
	<tr><td colspan="2" class="line"></td></tr>
	<tr><td height="5"></td></tr>
	<tr><td colspan="2" align="center" height="30">

	<cfif url.id1 eq "">	
    	<input class="button10g" type="submit" name="Insert" value="Save">
	<cfelse>
	    <input class="button10g" type="submit" name="Update" value="Save">
	</cfif>
	</td></tr>
		
</TABLE>

</CFFORM>
	

