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

<cfif url.dateEffective neq "">
	<cfset vyear = mid(url.dateEffective, 1, 4)>
	<cfset vmonth = mid(url.dateEffective, 6, 2)>
	<cfset vday = mid(url.dateEffective, 9, 2)>
	<cfset vEffectiveDate = createDate(vyear, vmonth, vday)>
</cfif>

<cfquery name="getHeader" 
    datasource="AppsMaterials" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">		 		 	  
		 SELECT    	V.*,		 			
		 			(
						SELECT 	OrgUnitName 
						FROM 	Organization.dbo.Organization
						WHERE	Mission = (SELECT TreeVendor FROM Purchase.dbo.Ref_ParameterMission WHERE Mission = '#url.mission#')
						AND 	OrgUnit = V.OrgUnitVendor
					) as VendorName,
					(SELECT UoMDescription FROM ItemUoM WHERE ItemNo = '#url.itemno#' AND UoM = V.UoM) as UoMDescription,
					(SELECT ItemDescription FROM Item WHERE ItemNo = '#url.itemno#') as ItemDescription
		 FROM      	ItemVendor V
		 WHERE     	V.ItemNo = '#url.itemno#'		 
		 AND		V.OrgUnitVendor = #url.orgunitvendor#		
</cfquery>

<!--- not needed in dialog 
<cfif url.dateEffective neq "">	
	<cf_screentop height="100%" scroll="Yes" html="No" label="Vendor Offer" option="Maintain Vendor Offer" layout="webapp" banner="blue" user="no">
<cfelse> 
	<cf_screentop height="100%" scroll="Yes" html="No" label="Vendor Offer" option="Add Vendor Offer" layout="webapp" user="no">
</cfif>
--->

<table class="hide">
	<tr><td><iframe name="processeditvendoroffer" id="processeditvendoroffer" frameborder="0"></iframe></td></tr>
</table>

<cfform name="frmeditvendoroffer" method="POST" target="processeditvendoroffer" action="#SESSION.root#/Warehouse/Maintenance/ItemMaster/vendors/vendorOfferPerDateSubmit.cfm?itemno=#url.itemno#&mission=#url.mission#&uom=#url.uom#&orgunitvendor=#url.orgunitvendor#&dateEffective=#url.dateEffective#">

<table width="95%" align="center" class="formpadding">
	<tr><td height="5"></td></tr>
	
	<cfoutput>
	<tr>
		<td style="height:25px" class="labelmedium" width="25%" height="20">Item:</td>
		<td class="labelmedium">#getHeader.ItemDescription# (#getHeader.UoMDescription#)</td>
	</tr>	
	<tr>
		<td style="height:25px" class="labelmedium"><cf_tl id="Vendor">:</td>
		<td class="labelmedium">
			<a href="javascript: showVendorInfo('#url.orgUnitVendor#');">
				<font color="0080FF">
					#getHeader.VendorName#
				</font>
			</a>
		</td>
	</tr>
	<tr>
	</cfoutput>
	<tr>
		<td style="height:25px" class="labelmedium"><cf_tl id="Effective">:</td>
		<td style="z-index:99; position:relative; padding-left:0px;padding-top:3px;">
			
			<cfset vActualDateEffective = url.dateEffective>
			<cfif vActualDateEffective eq "">
				<cfset vActualDateEffective = dateFormat(now(), "yyyy-mm-dd")>
			</cfif>
		
			<cf_intelliCalendarDate9
				FieldName="DateEffective"
				class="regularxl"
				Message="Select a valid Effective Date"
				Default="#dateformat(vActualDateEffective, CLIENT.DateFormatShow)#"
				AllowBlank="False">
			
			<cfajaxproxy bind="javascript:getDataByDate('DateEffective',{DateEffective},'#url.offerid#','#url.itemno#','#url.mission#','#url.uom#','#url.orgunitvendor#')"> 
					
		</td>
	</tr>
	<tr>
		<td colspan="2">
			<cfdiv id="divLocationList" bind="url:#SESSION.root#/Warehouse/Maintenance/ItemMaster/vendors/vendorOfferEditPerDate_LocationList.cfm?offerid=#url.offerid#&itemno=#url.itemno#&mission=#url.mission#&uom=#url.uom#&orgunitvendor=#url.orgunitvendor#&dateEffective=#vActualDateEffective#&ts=#getTickCount()#">
		</td>
	</tr>
	
</table>

</cfform>

<cfset ajaxonload("doCalendar")> 