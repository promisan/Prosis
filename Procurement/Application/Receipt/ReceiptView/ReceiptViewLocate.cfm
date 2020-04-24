<cfparam name="URL.ActionStatus" default="1">

<cfquery name="Period" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
		FROM  Program.dbo.Ref_Period
		WHERE Period = '#url.period#'		
	</cfquery>

<cf_calendarScript>

<!--- Search form --->
		
	<table width="98%" border="0" align="center" class="formpadding">
	
	<tr class="line">
		
	<cfquery name="Vendor" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT OrgUnit, OrgUnitName
		FROM  Organization
		WHERE OrgUnit IN (SELECT OrgUnitVendor 
		                  FROM   Purchase.dbo.Purchase 
		                  WHERE  Mission = '#URL.Mission#')
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
	
	<td>	
	
	<cfform name="formlocate" onsubmit="return false">	
		
	<table width="98%" align="center" class="formpadding">
	
		<TR>
		<TD class="labelmedium"><cf_tl id="Receipt No">:</TD>
		<TD>	
		<input type="text" name="receiptNo" id="receiptNo" value="" size="20" class="regularxl">		
		</TD>
		
		<TD class="labelmedium"><cf_tl id="Packingslip No">:</TD>
		<TD>
		<input type="text" name="PackingSlipNo" id="PackingSlipNo" value="" size="20" class="regularxl">		
		</TD>
		</tr>
		
		<TR>
		<TD class="labelmedium"><cf_tl id="Received in period from">:</TD>
		<TD>	
		
		 <cf_intelliCalendarDate9
			FieldName="datestart" 
			Default="01/01/#year(period.DateEffective)#"
			AllowBlank="True"
			Class="regularxl">	
			
		</TD>
		
		<TD class="labelmedium"><cf_tl id="until">:</TD>
		
			<TD>
			
			<cfif period.dateExpiration gte now()>
			
			<cf_intelliCalendarDate9
				FieldName="dateend" 
				Default="#Dateformat(now(), CLIENT.DateFormatShow)#"
				AllowBlank="True"
				Class="regularxl">	
				
			<cfelse>
			
			<cf_intelliCalendarDate9
				FieldName="dateend" 
				Default="#Dateformat(Period.dateExpiration, CLIENT.DateFormatShow)#"
				AllowBlank="True"
				Class="regularxl">	
			
			
			</cfif>	
				
			</TD>
		
		</tr>
			
		<TR>
		<TD class="labelmedium"><cf_tl id="Order type">:</TD>
				
		<td align="left" valign="top">
		<select name="ordertype" id="ordertype" size="1" class="regularxl">
		    <option value="" selected><cf_tl id="All"></option>
		    <cfoutput query="ordertype">
			<option value="#Ordertype#">#Ordertype#</option>
			</cfoutput>
	    </select>
		</td>	
			
		<TD class="labelmedium"><cf_tl id="Order Class">:</TD>
				
		<td align="left" valign="top">
		<select name="orderclass" id="orderclass" size="1" class="regularxl">
		    <option value="" selected><cf_tl id="All"></option>
		    <cfoutput query="class">
			<option value="#OrderClass#">#Description#</option>
			</cfoutput>
		    </select>
		</td>	
				
		</TR>
		
		<TR>
		
		<TD class="labelmedium"><cf_tl id="Vendor">:</TD>
				
		<td align="left" valign="top">
		    <select name="orgunitvendor" id="orgunitvendor" size="1" style="width:250px" class="regularxl">
			<option value="" selected><cf_tl id="All"></option>
		    <cfoutput query="Vendor">
				<option value="#OrgUnit#">#OrgUnitName#</option>
			</cfoutput>
		    </select>
		</td>	
		<td class="labelmedium"><cf_tl id="Status">:</td>
		<td>
		 <select name="actionstatus" id="actionstatus" size="1" class="regularxl">
			<option value="1" selected><cf_tl id="Accepted"></option>
		    <option value="9" <cfif url.actionstatus eq "9">selected</cfif>><cf_tl id="Rejected"></option>
	     </select>
		</td>
			
		</tr>
		
		<TR>
			<TD class="labelmedium"><cf_tl id="Item description matches">:</TD>
			<TD colspan="3">	
			<input type="text" name="receiptitem" id="receiptitem" value="" style="width:90%" size="40" class="regularxl">
			</TD>		
		</tr>
		
		<tr><td colspan="4">
						
		<table>
		<tr>
		<td>
		
		<cfoutput>
		<cf_tl id="Reset" var="1">
		<input type="reset"  style="height:25px" class="button10g" value="#lt_text#">
		</td>
		<td style="padding-left:2px"> 
		<cf_tl id="Find" var="1">
		<input type="button" style="height:25px" onClick="filter()" name="Submit" id="Submit" value="#lt_text#" class="button10g">
		</cfoutput>		
		</td></tr>
		
		</table>

		</td></tr>
	
	</TABLE>
		
	</CFFORM>
	
	</td></tr>
		
	</table>
	

