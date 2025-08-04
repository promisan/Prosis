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
<!--- Prosis template framework --->
<cfsilent>
	<proUsr>jmazariegos</proUsr>
	<proOwn>Jorge Mazariegos</proOwn>
	<proDes>Translated</proDes>
	<proCom></proCom>
</cfsilent>

<!--- End Prosis template framework --->


<cf_tl id="All" var="1">
<cfset vAll=#lt_text#>

<cf_tl id="Reset" var="1">
<cfset vReset=#lt_text#>

<cf_tl id="Search" var="1">
<cfset vSearch=#lt_text#>


<cfparam name="URL.Mission" default="SAT">

<!--- Search form --->
<cfform action="PurchaseViewListingPrepare.cfm?Period=#URL.Period#&ID=#URL.ID#&ID1=#URL.ID1#&Mission=#URL.Mission#" method="POST" target="detail" name="locate">

<cfquery name="Vendor" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT OrgUnit, OrgUnitName
	FROM  Organization
	WHERE OrgUnit IN (SELECT OrgUnitVendor 
	                  FROM Purchase.dbo.Purchase 
	                  WHERE Mission='#URL.Mission#')
    ORDER BY OrgUnitName
</cfquery>

<cfquery name="OrderStatus" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT DISTINCT P.ActionStatus, S.Description 
    FROM   Purchase P, Status S
	WHERE  P.ActionStatus = S.Status
	AND    S.StatusClass = 'Purchase'
	AND    P.Mission = '#URL.Mission#'
</cfquery>

<cfquery name="Class" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT distinct P.OrderClass, S.Description 
    FROM Purchase P, Ref_OrderClass S
	WHERE P.OrderClass = S.Code
	AND   P.Mission = '#URL.Mission#'</cfquery>
	
<cfquery name="OrderType" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT distinct P.OrderType 
    FROM Purchase P
	WHERE P.Mission = '#URL.Mission#'</cfquery>	
	
<table width="100%" border="0" cellspacing="0" cellpadding="0" bordercolor="silver" class="formpadding">
<tr><td>
<table width="100%">

    <tr><td height="2"></td></tr>

	<TR>
	<TD><cf_tl id="OrderNo">:</TD>
	<td colspan="1">	
	<input type="text" name="purchaseNo" id="purchaseNo" value="" size="10">
	</td>
	<TD><cf_tl id="Issued after">:</TD>
	<TD>	
	 <cf_intelliCalendarDate
		FieldName="datestart" 
		Default=""
		AllowBlank="True">	
	</TD>
	</tr>
				
	<tr><td height="2"></td></tr>
	
	<TR>
	<TD><cf_tl id="Order type">:</TD>
			
	<td align="left" valign="top">
	<select name="ordertype" id="ordertype" size="1">
	    <option value="" selected>#vAll#</option>
	    <cfoutput query="ordertype">
		<option value="#Ordertype#">#Ordertype#</option>
		</cfoutput>
    </select>
	</td>	
		
	<TD><cf_tl id="Order Class">:</TD>
			
	<td align="left" valign="top">
	<select name="orderclass" id="orderclass" size="1">
	    <option value="" selected><cfoutput>#vAll#</cfoutput></option>
	    <cfoutput query="class">
		<option value="#OrderClass#">#Description#</option>
		</cfoutput>
	    </select>
	</td>	
	<TD>
	
	</TR>
	
	<tr><td height="2"></td></tr>

	<!--- Field: Pur_head.VendorName=CHAR;80;FALSE --->
	<TR>
	
	<TD><cf_tl id="Vendor code">:</TD>
			
	<td align="left" valign="top">
	<cfinput type="Text" name="orgunit" validate="integer" required="No" size="10">
	</td>	
	
	<TD><cf_tl id="Vendor name">:</TD>
			
	<td align="left" valign="top">
		
	    <select name="orgunitvendor" id="orgunitvendor" size="1">
		<option value="" selected><cfoutput>#vAll#</cfoutput></option>
	    <cfoutput query="Vendor">
			<option value="#OrgUnit#">#OrgUnitName#</option>
		</cfoutput>
	    </select>
	</td>	
		
	</tr>
	
	<tr><td height="2"></td></tr>
	
	<!--- Field: Pur_head.AmountUSD=FLOAT;8;FALSE --->
	
	<TR>
	<TD><cf_tl id="REQ051">:</TD>
	<td colspan="3">	
	<input type="text" name="receiptitem" id="receiptitem" value="" size="40">
	</td>
		
	</tr>
	
	
	<tr><td height="2"></td></tr>
	
	<!--- Field: Pur_head.AmountUSD=FLOAT;8;FALSE --->
	
	
</TABLE>
</td></tr>
<tr><td align="center">
<cfoutput>
<input type="reset"  class="button10s" value="#vReset#" style="width:100;height:23">
<input type="submit" name="Submit" id="Submit" value="#vSearch#" class="button10s" style="width:100;height:23">
</cfoutput>
</td></tr>
<tr><td bgcolor="E5E5E5"></td></tr>

</table>

</cfform>
