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
	<proUsr>dev</proUsr>
	<proOwn>dev dev</proOwn>
	<proDes>Translated</proDes>
	<proCom></proCom>
</cfsilent>

<!--- End Prosis template framework --->

<cf_calendarScript>

<cf_tl id="All" var="1">
<cfset vAll=lt_text>

<cf_tl id="Reset" var="1">
<cfset vReset=lt_text>

<cf_tl id="Search" var="1">
<cfset vSearch=lt_text>

<cfparam name="URL.Mission" default="SAT">

<cfoutput>

	<cfsavecontent variable="OrderClassAccess">
			 
	 	<cfif getAdministrator(url.mission) neq "1">
			
				 AND    P.OrderClass IN (SELECT ClassParameter 
			                         FROM   Organization.dbo.OrganizationAuthorization
									 WHERE  UserAccount    = '#SESSION.acc#'
									 AND    Mission        = '#URL.Mission#'   
									 AND    ClassParameter = P.OrderClass
									 AND    Role           = 'ProcApprover')
	    </cfif>	
				
	</cfsavecontent>

</cfoutput>

<cfquery name="Vendor" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT OrgUnit, OrgUnitName
	FROM  Organization
	WHERE OrgUnit IN 
		(
			SELECT 	OrgUnitVendor 
	        FROM 	Purchase.dbo.Purchase  P
	        WHERE 	Mission='#URL.Mission#'
			#preserveSingleQuotes(OrderClassAccess)#
		 )		  
	
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
	#preserveSingleQuotes(OrderClassAccess)#
</cfquery>

<cfquery name="Class" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT distinct P.OrderClass, S.Description 
    FROM Purchase P, Ref_OrderClass S
	WHERE P.OrderClass = S.Code
	AND   P.Mission = '#URL.Mission#'
	#preserveSingleQuotes(OrderClassAccess)#
	
</cfquery>
	
<cfquery name="OrderType" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT distinct P.OrderType 
    FROM Purchase P
	WHERE P.Mission = '#URL.Mission#'
	#preserveSingleQuotes(OrderClassAccess)#
</cfquery>	
	
<cfquery name="tPeriod" 
     datasource="AppsProgram" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
      SELECT R.*, M.MandateNo 
      FROM Ref_Period R, Organization.dbo.Ref_MissionPeriod M
      WHERE IncludeListing = 1
      AND M.Mission = '#URL.Mission#'
      AND R.Period = M.Period 
</cfquery>	


<table width="100%" border="0" cellspacing="0" cellpadding="0">
<tr><td style="padding:10px">

<!--- Search form --->
<cfform name="formlocate">

<table width="97%" cellspacing="0" cellpadding="0" align="center" class="formpadding">

    <tr><td height="3"></td></tr>
	<TR>

	<TD class="labelmedium"><cf_tl id="Period">:</TD>
			
	<td valign="top">
	<select name="Period" id="Period" size="1" class="regularxxl">
	    <option value="" selected>All</option>
	    <cfoutput query="tPeriod">
		<option value="#Period#">#Period#</option>
		</cfoutput>
	    </select>
	</td>	
	
	<TD class="labelmedium"><cf_tl id="Status">:</TD>
	
	<cfquery name="Status" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM   Status
		WHERE  StatusClass = 'Purchase'
		AND    Status IN (SELECT ActionStatus FROM Purchase WHERE Mission = '#url.mission#')
	</cfquery>	
	
	<td>
	
		<select name="ActionStatus" id="ActionStatus" size="1" class="regularxxl">
	
		    <option value="" selected>All</option>
		    <cfoutput query="Status">
			<option value="#Status#">#Description#</option>
			</cfoutput>
	    </select>
		
	</td>
	
	<TR>
	<TD class="labelmedium"><cf_tl id="OrderNo">:</TD>
	<td colspan="1">	
	<input type="text" name="purchaseNo" id="purchaseNo" class="regularxxl" value="" size="17">
	</td>
	<TD class="labelmedium"><cf_tl id="Issued after">:</TD>
	<TD>	
	
	 <cf_intelliCalendarDate9
		FieldName="datestart" 
		Default=""
		class="regularxxl"
		AllowBlank="True">	
		
	</TD>
	</tr>
		
	
	<TR>
	<TD class="labelmedium"><cf_tl id="Order type">:</TD>
			
	<td align="left" valign="top">
	<select name="ordertype" id="ordertype" size="1" class="regularxxl">
	    <option value="" selected><cfoutput>#vAll#</cfoutput></option>
	    <cfoutput query="ordertype">
		<option value="#Ordertype#">#Ordertype#</option>
		</cfoutput>
    </select>
	</td>	
		
	<TD class="labelmedium"><cf_tl id="Order Class">:</TD>
			
	<td align="left" valign="top">
	<select name="orderclass" id="orderclass" size="1" class="regularxxl">
	    <option value="" selected><cfoutput>#vAll#</cfoutput></option>
	    <cfoutput query="class">
		<option value="#OrderClass#">#Description#</option>
		</cfoutput>
	    </select>
	</td>	
	<TD>
	
	</TR>
	
	<!--- Field: Pur_head.VendorName=CHAR;80;FALSE --->
	<TR>
	
	<TD class="labelmedium"><cf_tl id="Vendor code">:</TD>
			
	<td align="left" valign="top">
	<cfinput type="Text" name="orgunit" class="regularxxl" validate="integer" required="No" size="10">
	</td>	
	
	<TD class="labelmedium"><cf_tl id="Vendor name">:</TD>
			
	<td align="left" valign="top">
		
	    <select name="orgunitvendor" id="orgunitvendor" style="width:180px" size="1" class="regularxxl">
		<option value="" selected><cfoutput>#vAll#</cfoutput></option>
	    <cfoutput query="Vendor">
			<option value="#OrgUnit#">#OrgUnitName#</option>
		</cfoutput>
	    </select>
	</td>	
		
	</tr>
		
	<!--- Field: Pur_head.AmountUSD=FLOAT;8;FALSE --->
	
	<tr>
	<TD class="labelmedium"><cf_tl id="Requisition">:</TD>
	<TD>	
	<input type="text" name="requisitionno" id="requisitionno" class="regularxxl" value="" size="20">
	</TD>
	</tr>
	
	<TR>
	<TD class="labelmedium"><cf_tl id="Order Item">:</TD>
	<td>	
	<input type="text" style="width:200px" name="orderitem" id="orderitem" class="regularxxl" value="" size="40">
	</td>
	<td class="labelmedium"><cf_tl id="Employee">:</td>		
			
		<cfquery name="Person" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT *
			FROM  Person
			WHERE PersonNo IN (SELECT PersonNo 
			                  FROM Purchase.dbo.Purchase 
			                  WHERE Mission='#URL.Mission#')
		    ORDER BY LastName
		</cfquery>
	
	<td>
	
	<select name="personno" id="personno" size="1" class="regularxxl">
		<option value="" selected><cfoutput>#vAll#</cfoutput></option>
	    <cfoutput query="Person">
			<option value="#PersonNo#">#LastName#, #FirstName#</option>
		</cfoutput>
	    </select>
	
	</td>
	
	</tr>
			
</TABLE>

</CFFORM>

</td></tr>

<tr><td height="4"></td></tr>

<tr><td class="line"></td></tr>

<tr><td align="center" style="padding:2px">

<cfoutput>
	<input type="reset"  class="button10g" value="#vReset#" style="width:130;height:23">
	<input type="button" name="Submit" id="Submit" value="#vSearch#" style="width:130;height:23" class="button10g"
			onclick="parent.Prosis.busy('yes');_cf_loadingtexthtml='';ptoken.navigate('PurchaseViewListing.cfm?ID=#URL.ID#&ID1=#URL.ID1#&Mission=#URL.Mission#','detail','','','POST','formlocate')">
</cfoutput>
</td></tr>

</table>


