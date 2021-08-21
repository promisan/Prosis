
<cf_calendarScript>

<cfparam name="URL.Mission" default="SAT">

<!--- Search form --->
<cfform name="formlocate" onsubmit="return false">

<table width="99%" border="0" align="center" class="formpadding">
			
	<tr><td height="3"></td></tr>
	
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
	
	<cfquery name="Period" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT DISTINCT Period
	    FROM Purchase
		WHERE Mission = '#URL.Mission#'
	</cfquery>
	
	<cfquery name="OrderStatus" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT DISTINCT S.Status as ActionStatus, S.Description 
	    FROM   Purchase P RIGHT OUTER JOIN Status S ON P.ActionStatus = S.Status AND  P.Mission = '#URL.Mission#'
		WHERE  S.StatusClass = 'Purchase'
		AND S.Status NOT IN ('1f','7')
		ORDER BY S.Status		
	</cfquery>
	
	<cfquery name="Class" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
	    SELECT DISTINCT P.OrderClass, S.Description 
	    FROM   Purchase P, Ref_OrderClass S
		WHERE  P.OrderClass = S.Code
		AND    P.Mission = '#URL.Mission#'
		
		<cfif getAdministrator(url.mission) eq "1">
	
		<!--- no filtering --->
		
		<cfelse>
		
		AND     P.OrderClass IN (SELECT ClassParameter 
		                         FROM Organization.dbo.OrganizationAuthorization
								 WHERE Mission = P.Mission
								 AND   ClassParameter = P.OrderClass
								 AND   Role = 'ProcRI'
								 AND   UserAccount = '#SESSION.acc#')	
	   </cfif>		
		
	</cfquery>
		
	<cfquery name="OrderType" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT DISTINCT P.OrderType 
	    FROM   Purchase P
		WHERE  P.Mission = '#URL.Mission#'
	</cfquery>	
	
<tr><td>

	<table width="100%" class="formpadding">
		
		<cfquery name="tPeriod" 
	     datasource="AppsProgram" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	      SELECT  R.*, M.MandateNo 
	      FROM    Ref_Period R, Organization.dbo.Ref_MissionPeriod M
	      WHERE   IncludeListing = 1
	      AND     M.Mission      = '#URL.Mission#'
	      AND     R.Period       = M.Period 
		</cfquery>
	
		<tr>
		<TD class="labelmedium2"><cf_tl id="Period">:</TD>
				
		<td align="left">
		<select name="Period" id="Period" size="1" class="regularxxl">
		    <option value="" selected><cf_tl id="Any"></option>
		    <cfoutput query="tPeriod">
			<option value="#Period#" <cfif URL.Period eq Period>selected</cfif> >#Period#</option>
			</cfoutput>
		    </select>
		</td>	
		<TD class="labelmedium2"><cf_tl id="Requisition">/<cf_tl id="WorkOrder">:</TD>
		<TD>	
		<input type="text" class="regularxxl" name="reference" id="reference" value="" size="15" style="text-align: left;">
		
		</TD>
		</tr>
			
		<TR>
		<TD class="labelmedium2"><cf_tl id="Order No">:</TD>
		<td colspan="1">	
		<input type="text" class="regularxxl" name="purchaseno" id="purchaseno" value="" size="10">
		</td>
		<TD class="labelmedium2"><cf_tl id="Issued after">:</TD>
		<TD>	
		 <cf_intelliCalendarDate9
			FieldName="orderdate" 
			Default=""
			class="regularxxl"
			AllowBlank="True">	
		</TD>
		</tr>
		
		</TR>
			
		<TR>
		<TD class="labelmedium2"><cf_tl id="Order type">:</TD>
				
		<td align="left" valign="top">
		<select name="ordertype" id="ordertype" size="1" class="regularxxl">
		    <option value="" selected>All</option>
		    <cfoutput query="ordertype">
			<option value="#Ordertype#">#Ordertype#</option>
			</cfoutput>
	    </select>
		</td>	
			
		<TD class="labelmedium2"><cf_tl id="Order Class">:</TD>
				
		<td align="left" valign="top">
		<select name="orderclass" id="orderclass" size="1" class="regularxxl">
		    <option value="" selected><cf_tl id="Any"></option>
		    <cfoutput query="class">
			<option value="#OrderClass#">#Description#</option>
			</cfoutput>
		    </select>
		</td>	
		<TD>
		
		</TR>
		
		<!--- Field: Pur_head.VendorName=CHAR;80;FALSE --->
		<TR>
		<TD class="labelmedium2"><cf_tl id="Vendor code">:</TD>
				
		<td align="left" valign="top">
		<cfinput type="Text" name="orgunit" message="Please enter a valid vendor code (999999) " class="regularxxl" validate="integer" required="No" size="10">
		</td>	
		<TD class="labelmedium2"><cf_tl id="Name">:</TD>
				
		<td align="left" valign="top">
		    <select name="orgunitvendor" id="orgunitvendor" size="1" style="width:300px" class="regularxxl">
			<option value="" selected><cf_tl id="All"></option>
		    <cfoutput query="Vendor">
				<option value="#OrgUnit#">#OrgUnitName#</option>
			</cfoutput>
		    </select>
		</td>	
			
		</tr>
		
		<TR>
		<TD class="labelmedium2"><cf_tl id="Order amount"> <cfoutput>#APPLICATION.BaseCurrency#</cfoutput>:</TD>
		<TD><table><tr><td>
		<SELECT name="amountoperator" id="amountoperator" class="regularxxl">
				<option value=">=" selected><cf_tl id="greater than">
				<OPTION value="<="><cf_tl id="smaller than">
			</SELECT>
			</td>
			<td style="padding-left:3px">
			<input type="text" name="amount" id="amount" value="0" size="10" class="regularxxl" style="width:70px;text-align:right;padding-right:3px">	
			</td></tr></table>		
		</TD>
		
		<TD class="labelmedium2"><cf_tl id="Item">:</TD>
		<TD>	
		<input type="text" name="orderitem" id="orderitem" class="regularxxl" value="" style="width:300px" size="40">
		</TD>
		
		</TR>
			
		<TR>
		<TD class="labelmedium2"><cf_tl id="Purchase status">:</TD>
		<td align="left" valign="top">
		    <select name="actionstatus" id="actionstatus" size="1" class="regularxxl">
			<option value=""><cf_tl id="All"></option>
		    <cfoutput query="OrderStatus">
				<option value="#ActionStatus#" <cfif ActionStatus eq "3">selected</cfif>>#Description#</option>
			</cfoutput>
		    </select>
		</td>	
		<TD class="labelmedium2"><cf_tl id="Delivery status">:</TD>
		<TD>
		    <SELECT name="deliverystatus" id="deliverystatus" class="regularxxl">
		        <OPTION value="0" selected><cf_tl id="Outstanding">
				<OPTION value="3"><cf_tl id="Completed">
			</SELECT>		
		</TD>
		</tr>
		
		<tr><td height="4"></td></tr>
	
	</TABLE>
	
</td></tr>

<tr><td height="1" class="line"></td></tr>

<tr><td align="center" height="34">
		
       <!---
		<cf_tl id="Reset" var="1">
		<cf_button type="reset"  class="button10g" value="#lt_text#">
		--->
		<cf_tl id="Find" var="1">
		<cfinput type="button" 
		   name="search" 
		   id="search" 
		   value="#lt_text#" 
		   class="button10g" 
		   onclick="filter()" 
		   style="width:180px;height:28px">		

	</td>
</tr>

</table>


</cfform>
