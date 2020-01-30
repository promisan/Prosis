
<cfparam name="URL.Mission" default="SAT">
<cfparam name="URL.Period"  default="SAT">

<cf_calendarscript>

<cf_tl id="All" var="1">
<cfset vAll=lt_text>

<cf_tl id="Reset" var="1">
<cfset vReset=lt_text>

<cf_tl id="Search" var="1">
<cfset vSearch=lt_text>

<cfquery name="Vendor" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT OrgUnit, OrgUnitName
	FROM  Organization
	WHERE OrgUnit IN (SELECT OrgUnitVendor 
	                  FROM   Purchase.dbo.Purchase 
	                  WHERE  Mission='#URL.Mission#'
					  AND    Period = '#URL.Period#')
    ORDER BY OrgUnitName
</cfquery>

<cfquery name="Officer" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT DISTINCT OfficerUserid, OfficerLastName, OfficerFirstName
	FROM  Invoice
	WHERE Mission = '#URL.Mission#'
</cfquery>

<cfquery name="Curr" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT DISTINCT DocumentCurrency
	FROM  Invoice
	WHERE Mission = '#URL.Mission#'
</cfquery>

<cfquery name="tStatus" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT Status sCode,Description sDescription
	FROM Status
	WHERE StatusClass='Invoice'
</cfquery>

<cfquery name="tPeriod" 
     datasource="AppsProgram" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
      SELECT R.*, M.MandateNo 
      FROM   Ref_Period R, Organization.dbo.Ref_MissionPeriod M
      WHERE  IncludeListing = 1
      AND    M.Mission = '#URL.Mission#'
	  AND    R.Period IN (SELECT Period FROM Purchase.dbo.Invoice WHERE Mission = '#URL.Mission#')
      AND    R.Period = M.Period 
</cfquery>

<cfform target="detail" name="formlocate" onsubmit="return false">
	
<table width="100%" align="center" border="0" cellspacing="0" cellpadding="0">
<tr><td style="padding:5px">

<table width="98%" cellspacing="0" cellpadding="0" align="center" class="formpadding">
			
	<TR>

	<TD class="labelmedium"><cf_tl id="Period">:</TD>
			
	<td align="left" valign="top">
	<select name="Period" id="Period" size="1" class="regularxl">
	    <option value="" selected><cf_tl id="All"></option>
	    <cfoutput query="tPeriod">
		<option value="#Period#" <cfif URL.Period eq Period>selected</cfif> >#Period#</option>
		</cfoutput>
	    </select>
	</td>	

		
	<TD class="labelmedium"><cf_tl id="Currency">:</TD>
			
	<td align="left" valign="top">
	<select name="currency" id="currency" size="1" class="regularxl">
	    <option value="" selected><cf_tl id="All"></option>
	    <cfoutput query="curr">
		<option value="#DocumentCurrency#">#DocumentCurrency#</option>
		</cfoutput>
	    </select>
	</td>	
	<TD>
	
	</TR>
	
	<!--- Field: Pur_head.VendorName=CHAR;80;FALSE --->
	<TR>
	<TD class="labelmedium"><cf_tl id="Vendor">:</TD>
			
	<td align="left" valign="top">
	
	    <cfdiv bind="url:getVendor.cfm?mission=#url.mission#&period={Period}" id="vendor">
		
			
	</td>	
		
	<TD class="labelmedium"><cf_tl id="Status">:</TD>
			
	<td align="left" valign="top">
		 <select name="actionstatus" id="actionstatus" size="1" class="regularxl">
			 <option value="" selected><cf_tl id="All"></option>
			 <cfoutput query="tStatus">
		 		<option value="'#sCode#'">#sDescription#</option>
			 </cfoutput>
		 </select>
	</td>	
		
	</tr>
			
	<TR>
	<TD class="labelmedium"><cf_tl id="Invoice No">:</TD>
	<TD>	
	<input type="text" name="invoiceNo" id="invoiceNo" class="regularxl" value="" size="20">
	</TD>
	<TD class="labelmedium"><cf_tl id="Purchase">:</TD>
	<TD>	
	<input type="text" name="PurchaseNo" id="Purchaseno" class="regularxl" value="" size="20">
	</TD>
			
	</tr>
	
	<TR>
	<TD class="labelmedium"><cf_tl id="Requisition">:</TD>
	<TD>	
	<input type="text" name="requisitionno" id="requisitionno" class="regularxl" value="" size="20">
	</TD>
	
	<td class="labelmedium"><cf_tl id="Officer">:</td>
	<td>
	
	<select name="officer" id="officer" size="1" class="regularxl">
		 <option value="" selected><cf_tl id="All"></option>
		 <cfoutput query="Officer">
	 		<option value="#OfficerUserId#">#OfficerLastName# #OfficerFirstName#</option>
		 </cfoutput>
	 </select>
	
	</td>
				
	</tr>
		
	<!--- Field: Pur_head.AmountUSD=FLOAT;8;FALSE --->
	
	<TR>
	<TD class="labelmedium" style="padding-right:10px"><cf_tl id="Received during">:</TD>
	<TD colspan="1">
		
			 <cf_intelliCalendarDate9
			FieldName="datestart" 
			Default=""
			Class="regularxl"
			AllowBlank="True">	
			
		<TD style="padding-left:3px;padding-right:3px" class="labelmedium"><cf_tl id="until">:</TD>		
		<TD>
			<cf_intelliCalendarDate9
			FieldName="dateend" 
			Default=""			
			Class="regularxl"
			AllowBlank="True">	
		</td>
	</tr>	
	
	
	</tr>
		
	<TR>
	<TD class="labelmedium"><cf_tl id="Payable">:</TD>
	<TD>
	<table cellspacing="0" cellpadding="0"><tr><td>
	<SELECT name="amountoperator" id="amountoperator" class="regularxl">
			<OPTION value="="><cf_tl id="is">
			<option value=">=" selected><cf_tl id="greater than">
			<OPTION value="<="><cf_tl id="smaller than">
		</SELECT>
		</td>
		<td style="padding-left:3px">
		<input type="text" name="amount" id="amount" class="regularxl" value="0" size="10" style="text-align: right;">
		</td></tr></table>
		
	</TD>
	
	<TD class="labelmedium"><cf_tl id="Descriptive">:</TD>
	<TD>	
	<input type="text" name="Description" id="Description" class="regularxl" value="" size="30">
		
	</TD>
	
	</TR>
	
	<tr><td height="1"></td></tr>

</TABLE>
</td></tr>
<tr><td class="linedotted"></td></tr>
<tr><td align="center" height="30">
<cfoutput>
<input type="reset"  class="button10g" style="font-size:12px;width:130px;height:25" value="#vReset#">
<input type="button" name="Submit" id="Submit" value="#vSearch#" class="button10g" style="font-size:12px;width:130px;height:25" onclick="filter()">
</cfoutput>
</td></tr>
<tr><td class="linedotted"></td></tr>

</table>

</CFFORM>

