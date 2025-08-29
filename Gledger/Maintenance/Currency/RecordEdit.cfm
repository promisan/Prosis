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
<cfparam name="url.idmenu" default="">

<cf_screentop height="100" 
			  scroll="no" 
			  layout="webapp" 
			  banner="gray"
			  title="currency" 
			  label="Edit Currency" 
			  jquery="Yes"
			  line="no"
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">
			  
<cfajaximport tags="cfwindow">			  
  
<cfquery name="Get" 
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT B.*, I.Description as InvoiceTax, S.Description as SalesTax
FROM         Currency B LEFT OUTER JOIN
                      Ref_Account I ON B.GLAccountInvoiceTax = I.GLAccount LEFT OUTER JOIN
                      Ref_Account S ON B.GLAccountSalesTax = S.GLAccount
WHERE B.Currency = '#URL.ID1#' 
</cfquery>

<script language="JavaScript">

function ask() {
	if (confirm("Do you want to remove this currency ?")) {
	return true 
	}
	return false
	
}	

function applyinvoice(acc) {
   ptoken.navigate('setAccount.cfm?mode=invoice&account='+acc,'process')
}  


function applysale(acc) {
   ptoken.navigate('setAccount.cfm?mode=sale&account='+acc,'process')
}  

</script>

<cf_dialogLedger>

<cfform action="RecordSubmit.cfm" method="POST" name="dialog">

<!--- Entry form --->

<table width="93%" cellspacing="0" cellpadding="0" align="center" class="formpadding formspacing">
	
	<tr class="hide" ><td id="process"></td></tr>
	<tr><td height="6"></td></tr>
    <cfoutput>
    <TR>
    <TD class="labelmedium"><cf_tl id="Acronym">:</TD>
    <TD>
  	   <input type="text" class="regularxl" name="Currency" value="#get.currency#" size="10" maxlength="10" readonly>
    </TD>
	</TR>
		
	<TR>
    <TD class="labelmedium"><cf_tl id="Description">:</TD>
    <TD>
  	    <cfinput type="Text" class="regularxl" name="Description" value="#get.description#" message="Please enter the description of your currency" required="No" size="30" maxlength="30">
    </TD>
	</TR>
		
    <TR>
    <TD class="labelmedium"><cf_tl id="Effective">:</TD>
    <TD>
	
		<cf_calendarscript>
	
		  <cf_intelliCalendarDate9
		FieldName="EffectiveDate" 
		Default="#Dateformat(now(), CLIENT.DateFormatShow)#"
		class="regularxl"
		AllowBlank="False">	
	
	</TD>
	</TR>	
	
	<TR>
    <TD class="labelmedium"><cf_tl id="Exchange rate">:</TD>
    <TD>
	<table cellspacing="0" cellpadding="0">
		<tr>
		<td>
  	   	    <cfinput type="Text" class="regularxl" name="ExchangeRate" value="#get.ExchangeRate#" message="Please enter the exchangerate to the base currency" validate="float" required="Yes" size="10" maxlength="20" style="text-align: right;">
		</td>
		<td style="padding-left:5px" class="labelmedium">= equivalent to 1 <cfoutput>#application.BaseCurrency#</cfoutput></td>
		</tr>
		</table>
		
	
     </TD>
	</TR>
	
	
	<TR>
    <TD class="labelmedium"><cf_UItooltip tooltip="Allow this currency to be used for procurement series">Procurement:</cf_UItooltip></TD>
    <TD>
	<input type="checkbox" class="radiol" name="EnableProcurement" value="1" <cfif get.EnableProcurement eq "1">checked</cfif>>
	
	</TD>
	</TR>	
	
	<TR>
    <TD class="labelmedium"><cf_tl id="Operational">:</TD>
    <TD>
	<input type="checkbox" class="radiol" name="Operational" value="1" <cfif get.operational eq "1">checked</cfif>>
	
	</TD>
	</TR>	
			
	<TR>
    <TD class="labelmedium"><cf_tl id="Default AP tax">:</TD>
    <TD>
	
		<table cellspacing="0" cellpadding="0">
		<tr><td>
		    <input type="Text" name="glaccount1" id="glaccount1" size="6" value="#get.GLAccountInvoiceTax#" class="regularxl" readonly>
		    </td>
			<td style="padding-left:2px">
		    <input type="text" name="gldescription1" id="gldescription1" value="#get.InvoiceTax#" class="regularxl" size="50" readonly>
			</td>
		    <input type="hidden" name="debitcredit1" id="debitcredit1" value="" class="regularxl" size="6" readonly>
		    <td>
		    <img src="#SESSION.root#/Images/search.png" alt="Select account" name="img3" 
				  onMouseOver="document.img3.src='#SESSION.root#/Images/contract.gif'" 
				  onMouseOut="document.img3.src='#SESSION.root#/Images/search.png'"
				  style="cursor: pointer;" alt="" width="20" height="20" border="0" align="absmiddle" 
				  onClick="selectaccountgl('','','','','applyinvoice')">
			</td>
		</tr>
		</table>   
	
	</TD>
	</TR>
	
	<TR>
    <TD style="min-width:300px" class="labelmedium"><cf_tl id="Default AR tax">:</TD>
    <TD>
  			<table cellspacing="0" cellpadding="0">
			<tr><td>			
			    <input type="Text" name="glaccount2" id="glaccount2" value="#get.GLAccountSalesTax#" size="6" class="regularxl" readonly>
				</td>
			   <td style="padding-left:2px">
	    	   <input type="text" name="gldescription2" id="gldescription2" value="#get.SalesTax#" class="regularxl" size="50" readonly>
			   <input type="hidden" name="debitcredit2" id="debitcredit2" value="" class="regularxl" size="6" readonly>
			   </td>
		   	<td>
		    <img src="#SESSION.root#/Images/search.png" alt="Select account" name="img5" 
				  onMouseOver="document.img5.src='#SESSION.root#/Images/contract.gif'" 
				  onMouseOut="document.img5.src='#SESSION.root#/Images/search.png'"
				  style="cursor: pointer;" alt="" width="20" height="20" border="0" align="absmiddle" 
				  onClick="selectaccountgl('','','','','applysale')">
			</td>
			</tr>
			</table>	
	</TD>
	</TR>	
	
	</cfoutput>
		
	<tr><td colspan="2" class="line"></td></tr>
	
	<tr><td colspan="2" height="35" align="center">
			
		<input type="button" class="button10g" name="Cancel" value=" Cancel " onClick="window.close()">
				
		<cfif APPLICATION.BaseCurrency neq Get.Currency>
		    <input type="submit" class="button10g" name="Delete" value=" Delete " onclick="return ask()">
		</cfif>
		<input type="submit" class="button10g" name="Update" value="Update">
		
		</td>
	</tr>	
	
</TABLE>
	
</CFFORM>

