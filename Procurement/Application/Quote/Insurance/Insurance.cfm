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
<cfsilent>
	<proUsr>dev</proUsr>
	<proOwn>dev dev</proOwn>
	<proDes>Translated</proDes>
	<proCom></proCom>
</cfsilent>
<!--- End Prosis template framework --->

<cfinclude template="InsuranceScript.cfm">

<cf_calendarscript>

<cfparam name="object.objectkeyvalue1" default="">

<cfif object.objectkeyvalue1 neq "">
	
	<cfparam name="jobNo" default="#object.objectkeyvalue1#">
		
	<cfquery name="Vendor" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT DISTINCT O.OrgUnit, O.OrgUnitCode, O.OrgUnitName
	FROM      RequisitionLineQuote Q, Organization.dbo.Organization O
	WHERE     JobNo = '#JobNo#'  
	AND       O.OrgUnit = Q.OrgUnitVendor
    AND      Selected = 1
	</cfquery>
		
	<cfparam name="orgunitVendor" default="#Vendor.OrgUnit#">

<cfelse>

	<cfajaximport tags="CFFORM,CFINPUT-DATEFIELD">
	
	<cf_screentop height="100%" scroll="yes" html="No">

	<cfquery name="Vendor" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM     Organization.dbo.Organization O
		WHERE     (OrgUnit = '#url.orgunit#') 
	</cfquery>
	
	<cfparam name="jobNo" default="#url.jobno#">
	<cfparam name="orgunitVendor" default="#url.orgunit#">

</cfif>

<table width="96%" cellspacing="0" cellpadding="0" align="center" class="formpadding">

<cfif vendor.recordcount gt "1">

<tr><td height="5"></td></tr>
<tr>
	<td>
	<table width="100%" cellspacing="0" cellpadding="0" class="formpadding">
	<cfoutput query="Vendor">
	<tr>
	       <td>
		   
		    <img src="#SESSION.root#/Images/contract.gif" name="img0_#currentrow#" 
					  onMouseOver="document.img0_#currentrow#.src='#SESSION.root#/Images/button.jpg'" 
					  onMouseOut="document.img0_#currentrow#.src='#SESSION.root#/Images/contract.gif'"
					  style="cursor: pointer;" 
					  alt="" 
					  width="13" 
					  height="14" 
					  border="0" 
					  align="absmiddle" 
					  onClick="ColdFusion.navigate('#SESSION.root#/procurement/application/quote/Insurance/InsuranceDetail.cfm?jobno=#jobno#&orgunit=#vendor.orgunit#','detail')">
		   
		   </td>
		   <td>#OrgUnitCode#</td>
		   <td>#OrgUnitName#</td>
		   </tr>
		   <tr><td colspan="3" bgcolor="d4d4d4" height="1"></td></tr>
	</cfoutput>	   
    </table>
	</td>
</tr>
</cfif>

<tr><td>
    
	<cfdiv id="detail" 
	  bind="url:#SESSION.root#/procurement/application/quote/Insurance/InsuranceDetail.cfm?jobno=#jobno#&orgunit=#vendor.orgunit#"/>
	 
</td></tr>

</table>
