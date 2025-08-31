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
<cfquery name="GetHeader" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM Requisition P
WHERE Reference = '#URL.ID1#'
</cfquery>

<cfquery name="GetLines" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM RequisitionLine
WHERE Reference = '#URL.ID1#'
AND ActionStatus != '9'
</cfquery>

<cfquery name="GetOrganization" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT TOP 1 *
FROM Organization
WHERE OrgUnit = '#GETLines.OrgUnit#'
</cfquery>

<cfquery name="GetOrganizationAddress" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT TOP 1 *
FROM vwOrganizationAddress
WHERE OrgUnit = '#GETLines.OrgUnit#'
AND   AddressType = 'Shipping'
</cfquery>

<cfquery name="GetAddressInvoice" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM vwOrganizationAddress
WHERE OrgUnit = '#GETLines.OrgUnit#'
AND   AddressType = 'Invoice'
</cfquery>

<cfdocumentitem type="header">
 <cfoutput> 
 <table width="98%" border="1" cellspacing="0" cellpadding="0" align="center" bordercolor="gray" rules="cols">
 <tr>
    <td width="100%" height="54" colspan="2" align="center" valign="middle">
    <b><font size="4">REQUISTION FOR EQUIPMENT, SUPPLIES OR SERVICES</font></b>
    </td>
 </tr>
 <tr>
    <td width="100%" class="top3n" height="26" colspan="2" align="center" valign="middle"> 
	<b><font face="Trebuchet MS" size="1">IMPORTANT: Mark all 
    packages and papers with requisition numbers</font></b></td>
 </tr>
 </table>
 
  </cfoutput>
</cfdocumentitem>

<cfdocumentitem type="footer">
 <cfoutput> <table width="100%">
            <tr><td align="center">
			<font size="1" face="Trebuchet MS">Page #cfdocument.currentpagenumber# or #cfdocument.totalpagecount# </font>
			</td></tr>
			</table>
  </cfoutput>
</cfdocumentitem>

<table width="98%" border="1" cellspacing="0" cellpadding="0" align="center" bordercolor="gray" rules="cols">
<tr>
    <td width="50%" valign="top">
    <table width="100%" border="0" cellspacing="0" cellpadding="0" class="formpadding">
	   <tr>
        <td width="100%" height="20">
        <table border="0" cellpadding="0" cellspacing="0" width="100%">
          <tr>
            <td width="36%" valign="absmiddle"><font size="1" face="Trebuchet MS">DATE OF REQUISITION:</td>
            <td width="64%" valign="absmiddle"><b><font size="2" face="Trebuchet MS">
				<cfoutput query="GetHeader">
				#Dateformat(Created, CLIENT.DateFormatShow)#
				</cfoutput> 
                  </font></b></td>
          </tr>
        </table>
        </td>
      </tr>
	  <tr><td bgcolor="gray"></td></tr>
      <tr>
        <td width="100%" height="20">
        <table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#C0C0C0" frame="hsides" rules="rows" width="100%">
          <tr>
            <td width="36%"><font face="Trebuchet MS" size="1">PERIOD:</font></td>
            <td width="64%"><b><font face="Trebuchet MS" size="2">
			<cfoutput query="GetHeader">#Period#</cfoutput>
			</font></b></td>
          </tr>
        </table>
        </td>
      </tr>
	   <tr><td bgcolor="gray"></td></tr>
      <tr>
        <td width="100%" height="20" valign="top">
        <table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="100%" height="21">
          <tr>
            <td width="36%" valign="top" height="21"><font face="Trebuchet MS" size="1">ORGANIZATION:</font></td>
            <td width="64%" height="21"><b><font face="Trebuchet MS" size="2">
			 
				<table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="100%">
		        
				   <tr>
		   		    <td width="5%" height="16">
		            <td width="95%" height="16"><b><font face="Trebuchet MS" size="2">
					<cfoutput query="GetOrganization">#OrgUnitName#</cfoutput>
					</font></b></td>
		          </tr>
		          <tr>
		   		    <td width="5%" height="16">
		            <td width="95%" height="16"><b><font face="Trebuchet MS" size="2">
					<cfoutput query="GetOrganizationAddress">#Address1# #Address2#</cfoutput>
					</font></b></td>
		          </tr>
		          <tr>
				    <td width="5%" height="16">
		            <td width="95%" height="16"><b><font face="Trebuchet MS" size="2">
					<cfoutput query="GetOrganizationAddress">#City# #PostalCode#</cfoutput>
					</b></td>
		          </tr>
		          <tr>
				    <td width="5%" height="29">
		            <td width="95%" height="29"><b><font face="Trebuchet MS" size="2">
					<cfoutput query="GetOrganizationAddress">#TelephoneNo#</cfoutput>
					</font></b></td>
		          </tr>
		        </table>
           </td>
			
          </tr>
        </table>
        </td>
      </tr>	 
	        
    </table>
    </td>
      	
    <td width="50%" height="304" valign="top">
    <table width="100%" border="0" cellspacing="0" cellpadding="0" class="formpadding" style="border-collapse: collapse">
	   <tr>
        <td width="100%" height="20">
        <table border="0" cellpadding="0" cellspacing="0" width="100%">
          <tr>
            <td width="50%"><font size="1" face="Trebuchet MS">REQUISITION NO:</font></td>
            <td width="50%"><b><font face="Trebuchet MS" size="2">
			<cfoutput query="GetHeader">#Reference#</cfoutput>
			
			</font></b></td>
          </tr>
        </table>
        </td>
      </tr>
	  <tr><td bgcolor="gray"></td></tr>
     <tr>
        <td width="100%" height="79" valign="top">
		<table width="100%" cellspacing="0" cellpadding="0">
		<tr>
		
		  <td width="26%" valign="top"><font face="Trebuchet MS" size="1">PURPOSE:</td>
		  
		  <td width="74%">  
				<table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="100%">
		            <tr>
		   		    <td width="5%" height="16">
		            <td width="95%" height="16"><b><font face="Trebuchet MS" size="2">
					<cfoutput query="GetHeader">#RequisitionPurpose#</cfoutput>
					</font></b></td>
		          </tr>
		        </table>
           </td>
        </tr>
		</table>
		</td>
	  </tr>	
	  <tr><td bgcolor="gray"></td></tr>
          <td width="100%" height="28" valign="top">
        <table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="100%" height="24">
          <tr>
            <td width="50%" valign="top" height="24"><font face="Trebuchet MS" size="1">
            OFFICER:</font></td>
            <td width="50%" height="24"><b>
			<table width="100%">
			<cfoutput query="GetHeader">
			<tr><td>
            <font size="2" face="Trebuchet MS">#OfficerFirstName# #OfficerLastName#</font>
			</td></tr>
			</cfoutput>
			</table> 
			</b></td>
          </tr>
        </table>
        </td>
      </tr>
	
    </table>
    </td>
  </tr>
  
<TR>

<td height="500" colspan="2" valign="top">

    <table width="100%" border="0" cellspacing="0" cellpadding="0" class="formpadding">
	
	<tr bgcolor="E8E8CE">
      <td height="22"><font face="Trebuchet MS" size="1">&nbsp;No</font></td>
      <TD><font face="Trebuchet MS" size="1">Item or service</font></TD>
      <TD align="right"><font face="Trebuchet MS" size="1">Quantity</font></TD>
      <TD align="right"><font face="Trebuchet MS" size="1">Unit</font></TD>
	  <TD align="center"><font face="Trebuchet MS" size="1">Curr</font></TD>
      <TD align="right"><font face="Trebuchet MS" size="1">Unit Price</font></TD>
	  <TD align="right"><font face="Trebuchet MS" size="1">Amount&nbsp;</font></TD>
	  <Td>&nbsp;</TD>
    </TR>
	<tr><td colspan="8" bgcolor="gray"></td></tr>
    <cfset subtotal = "0">
    <cfset tax      = "0">
    <cfset total    = "0">
    			
    <CFOUTPUT query="GetLines">
	    <cfset total     = #total# + #RequestAmountBase#>
	    <cfset tax       = #tax# + 0>
		<cfset subtotal  = #subtotal# + #RequestAmountBase#>
		
	   	
	    <TR bgcolor="#IIf(CurrentRow Mod 2, DE('ffffff'), DE('ffffcf'))#">
	    <td height="22" align="left"><font face="Trebuchet MS" size="1">&nbsp;#CurrentRow#</A></font></td>
	    <td align="left"><font face="Trebuchet MS" size="1">#RequestDescription#</A></font></td>
	    <TD align="right"><font face="Trebuchet MS" size="1">#NumberFormat(RequestQuantity,'______._')#</font></TD>
	    <td align="right"><font face="Trebuchet MS" size="1">#QuantityUoM#</font></td>
	    <td align="center"><font face="Trebuchet MS" size="1">#APPLICATION.BaseCurrency#</font></td>
	    <td align="right"><font face="Trebuchet MS" size="1">#NumberFormat(RequestCostPrice,'_____.__')#</font></td>
	    <td align="right"><font face="Trebuchet MS" size="1">#NumberFormat(RequestAmountBase,'__,____.__')#</font></td>
		<td>&nbsp;</td>
	    </TR>
		
		<cfquery name="GetFunding" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT *
			FROM RequisitionLineFunding, Program.dbo.Ref_Object O
			WHERE RequisitionNo = '#RequisitionNo#'
			AND  ObjectCode = O.Code
			</cfquery>
						
		<tr>  
		    <td></td>
			<td colspan="7">
		    <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
		
		    <TR bgcolor="f2f2f2">
				<td height="18" width="15%"><font face="Trebuchet MS" size="1">&nbsp;Fund</b></font></td>
			    <TD><font face="Trebuchet MS" size="1">Program</font></TD>
			    <TD><font face="Trebuchet MS" size="1">Object</TD>
			    <TD><font face="Trebuchet MS" size="1">Percentage</TD>
			  
			</TR>
			
			<tr><td colspan="4" class="line"></td></tr>
				
		    <CFLOOP query="GetFunding">
		
		    <TR>
			<td height="17" align="left"><font face="Trebuchet MS" size="1">&nbsp;#Fund#</A></font></td>
		    <td align="left"><font face="Trebuchet MS" size="1">#ProgramCode#</A></font></td>
		    <td align="left"><font face="Trebuchet MS" size="1">#ObjectCode# #Description#</font></td>
		    <TD align="left"><font face="Trebuchet MS" size="1">#NumberFormat(Percentage*100,'_._')#%</font></TD>
		    </TR>
		
		    </CFLOOP>
				
		    </TABLE>
			</td>
		</tr>  	  
		
		<tr><td colspan="8" class="line"></td></tr>
    </CFOUTPUT>
		
	</table>
	</td>
</TR>

</table>
<br>

<table width="98%" border="1" cellspacing="0" cellpadding="0" align="center" bordercolor="C0C0C0">
  <tr>
    <td width="55%" height="58" valign="top">
		
		<table width="100%" cellpadding="0" cellspacing="0" class="formpadding">
		<tr>
		
		  <td width="26%" valign="top"><font face="Trebuchet MS" size="1">MAIL INVOICE TO:</td>
		  
		  <td width="74%">  
				<table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="100%">
		            <tr>
		   		    <td width="5%" height="16">
		            <td width="95%" height="16"><b><font face="Trebuchet MS" size="2">
					<cfoutput query="GetAddressInvoice">#Address1#</cfoutput>
					</font></b></td>
		          </tr>
		          <tr>
				    <td width="5%" height="16">
		            <td width="95%" height="16"><b><font face="Trebuchet MS" size="2">
					<cfoutput query="GetAddressInvoice">#Address2#</cfoutput>
					</font></b></td>
		          </tr>
		          <tr>
				    <td width="5%" height="16">
		            <td width="95%" height="16"><b><font face="Trebuchet MS" size="2">
					<cfoutput query="GetAddressInvoice">#City# #PostalCode#</cfoutput>
					</b></td>
		          </tr>
		          <tr>
				    <td width="5%" height="29">
		            <td width="95%" height="29"><b><font face="Trebuchet MS" size="2">
					<cfoutput query="GetAddressInvoice">#TelephoneNo#</cfoutput>
					</font></b></td>
		          </tr>
		        </table>
           </td>
        </tr>
		</table>
			
	</td>
    <td width="45%" bgcolor="f4f4f4">
	<table border="0" cellpadding="0" cellspacing="0" width="100%" class="formpadding">
	  <tr><td colspan="2"><font face="Trebuchet MS" size="1">GRAND TOTALS</font></td></tr> 
      <tr>
        <td height="21"><b>
        <font size="1" face="Trebuchet MS">&nbsp;Subtotal</font></b></td>
        <td width="50%" align="right">
		<cfoutput><font size="1" face="Trebuchet MS"><b>#NumberFormat(subtotal,'___,___.__')#</b></font></cfoutput></td>
      </tr>
      <tr>
        <td height="21"><b><font size="1" face="Trebuchet MS">&nbsp;Tax</font></b></td>
        <td width="50%" align="right">
		<cfoutput><font size="1" face="Trebuchet MS"><b>#NumberFormat(tax,'__,____.__')#<b></font></cfoutput></td>
       </td>
      </tr>
      <tr>
        <td height="21"><b><font size="1" face="Trebuchet MS">&nbsp;Total</font></b></td>
        <td width="50%" align="right">
	    <cfoutput><b><font size="1" face="Trebuchet MS">#NumberFormat(total,'_,_____.__')#</font></b></cfoutput></td>
      </td>
      </tr>
    </table>
    </td>
  </tr>
  
  </table>

<CFOUTPUT query="GetLines">

    <cfif #Remarks# neq "">
	<cfdocumentitem type="pagebreak"></cfdocumentitem>
	<table width="90%" align="center">
	<tr><td>#RequestDescription#</td></tr>
	<tr><td bgcolor="E5E5E5"></td></tr>
	<tr><td>
	<font size="1" face="Trebuchet MS">
	#Remarks#
	</font>
	</td></tr></table>
	</cfif>
	
</cfoutput> 

