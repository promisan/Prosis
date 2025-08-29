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
<cfparam name="criteria"      default="">
<cfparam name="form.category" default="">

<cfif form.category neq "">

	<cfset criteria = "ItemNo IN (SELECT ItemNo FROM Item WHERE Category = '#form.category#')">

</cfif>

<cfif url.filter2 eq "Warehouse">
	
	<cfquery name="Category" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT * FROM Ref_Category
		WHERE Category = '#form.category#'
	</cfquery>	
							 
	<cfif Category.DistributionFilter eq "1">
	
	        <cfsavecontent variable="warehousefilter">
				<cfoutput>
				AND      A.AssetId IN (
	                         SELECT AssetId 
	                         FROM   AssetItemSupplyWarehouse 
							 WHERE  AssetId      = A.Assetid
							 AND    Warehouse    = '#url.filter2value#' 
							 ) 
				</cfoutput>			 
			</cfsavecontent>		
			
			<cfset criteria = "#criteria# #warehousefilter#">
			
	</cfif>		
		
</cfif>	

<cfloop index="itm" list="0,2">

	<cfparam name="Form.Crit#itm#_Value_#url.box#" default="">
	<cfset val = evaluate("Form.Crit#itm#_Value_#url.box#")>
	
	<cfif val neq "">	
		
		<cfset nme = evaluate("Form.Crit#itm#_FieldName_#url.box#")>	
		<cfset ope = evaluate("Form.Crit#itm#_Operator_#url.box#")>
		<cfset tpe = evaluate("Form.Crit#itm#_FieldType_#url.box#")>
	
		<CF_Search_AppendCriteria
		    FieldName="#nme#"
		    FieldType="#tpe#"
		    Operator="#ope#"
		    Value="#val#">
		
	</cfif>	

</cfloop>


<cfparam name="Form.Crit4_Value_#url.box#" default="">

<cfset val = evaluate("Form.Crit4_Value_#url.box#")>

<cfif val neq "">	

   <cfset tpe = evaluate("Form.Crit4_FieldType_#url.box#")>
   <cfset ope = evaluate("Form.Crit4_Operator_#url.box#")>

   <CF_Search_AppendCriteria
		    FieldName="AssetBarCode,SerialNo,AssetDecalNo"
		    FieldType="#tpe#"
		    Operator="#ope#"
		    Value="#val#">

</cfif>

<cfparam name="Form.Crit3_Value_#url.box#" default="">

<cfset val = evaluate("Form.Crit3_Value_#url.box#")>

<cfif val neq "">	

    <cfif criteria eq "">
	<cfset criteria = " Assetid IN (SELECT Assetid FROM AssetItemOrganization WHERE OrgUnit IN (SELECT OrgUnit FROM Organization.dbo.Organization WHERE OrgUnitName LIKE '%#val#%'))">	
	<cfelse>
	<cfset criteria = " #criteria# AND Assetid IN (SELECT Assetid FROM AssetItemOrganization WHERE OrgUnit IN (SELECT OrgUnit FROM Organization.dbo.Organization WHERE OrgUnitName LIKE '%#val#%'))">
	</cfif>

</cfif>

<cfset link    = replace(url.link,"||","&","ALL")>
   


<!--- Query returning search results --->

<cfquery name="Total" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT count(*) as Total
    FROM   AssetItem A
	WHERE  1=1
	
	<cfif criteria neq "">	
	AND   #preserveSingleQuotes(criteria)# 	
	</cfif>
	
	<cfif filter1 eq "mission">
	AND Mission = '#filter1value#'
	</cfif>
		
	<cfif filter1 eq "ServiceItem" or filter2 eq "ServiceItem">
		AND   A.ItemNo IN (SELECT ItemNo 
		                 FROM   Item 
						 WHERE  Operational = 1
						 AND    Category IN (SELECT MaterialsCategory 
						                     FROM   WorkOrder.dbo.ServiceItemMaterials
											 <cfif filter1 eq "ServiceItem">
											 WHERE  ServiceItem = '#filter1value#'
											 <cfelse>
											 WHERE  ServiceItem = '#filter2value#'
											 </cfif>
											 AND    MaterialsClass = 'Asset'))
	</cfif>
	
	<cfif filter4 eq "supply">
		
		<!--- filter of the item is indeed to be supplied this type of supply item --->
		AND     (   
	            
				A.AssetId IN (SELECT S.AssetId 
	                         FROM   AssetItemSupply S
							 WHERE  S.AssetId      = A.Assetid
							 AND    S.SupplyItemNo = '#url.filter4value#'
							 AND    S.Operational = 1) 
				
				OR
				
				A.ItemNo IN (SELECT S.ItemNo 
	                         FROM   ItemSupply S
							 WHERE  S.ItemNo       = A.ItemNo
							 AND    S.SupplyItemNo = '#url.filter4value#'
							 AND    S.Operational = 1) 
							 
			)	
	
	</cfif>
	
	<!--- added 3/4/2012 --->	
	AND    Operational = 1		
	
</cfquery>

<cfset show = int((url.height-320)/32)>

<cf_pagecountN show="#show#" 
               count="#Total.Total#">
			   
<cfset counted  = total.total>			   

<cfquery name="SearchResult" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">

	SELECT  TOP #last# A.AssetId, A.AssetDecalNo, A.AssetBarcode, A.Description, A.Make, A.Model, A.SerialNo
    FROM 	AssetItem A
	
	WHERE 	1=1
	
	<cfif criteria neq "">
		AND #preserveSingleQuotes(criteria)# 	
	</cfif>
	
	<cfif filter1 eq "mission">
		AND A.Mission = '#filter1value#'
	</cfif>
	
	<cfif filter1 eq "ServiceItem" or filter2 eq "ServiceItem">
		AND   A.ItemNo IN (SELECT ItemNo 
		                 FROM   Item 
						 WHERE  Operational = 1
						 AND    Category IN (SELECT MaterialsCategory 
						                     FROM   WorkOrder.dbo.ServiceItemMaterials
											 <cfif filter1 eq "ServiceItem">
											 WHERE  ServiceItem = '#filter1value#'
											 <cfelse>
											  WHERE  ServiceItem = '#filter2value#'
											 </cfif>
											 AND    MaterialsClass = 'Asset'))
	</cfif>
	
	<cfif filter4 eq "supply">
		
		<!--- filter of the item is indeed to be supplied this type of supply item --->
		AND     (   
	            
				A.AssetId IN (SELECT S.AssetId 
	                         FROM   AssetItemSupply S
							 WHERE  S.AssetId      = A.Assetid
							 AND    S.SupplyItemNo = '#url.filter4value#'
							 AND    S.Operational = 1) 
				
				OR
				
				A.ItemNo IN (SELECT S.ItemNo 
	                         FROM   ItemSupply S
							 WHERE  S.ItemNo       = A.ItemNo
							 AND    S.SupplyItemNo = '#url.filter4value#'
							 AND    S.Operational = 1) 
							 
			)	
	
	</cfif>
	
	<!--- added 3/4/2012 --->	
	AND    Operational = 1		
	
ORDER BY ItemNo,AssetId
</cfquery>

<table height="100%" width="100%" class="navigation_table">

<tr><td height="14">						 
	 <cfinclude template="ItemNavigation.cfm">	 				 
</td></tr>

<tr><td style="height:100;width:100%">

<cf_divscroll>

	<table width="100%">
	
	<tr>
	
	<tr class="line labelmedium2 fixrow">
	  <td height="20"></td>
	  <td><cf_tl id="Make"></td>
	  <td><cf_tl id="Model"></td>
	  <td><cf_tl id="Barcode"></td>
	  <td><cf_tl id="PlateNo"></td>
	  <td><cf_tl id="SerialNo"></td>
	</tr>		   		
	
	<cfoutput query="SearchResult">
		
		<cfif currentrow gte first>
		
			<tr id="#currentrow#" style="height:17px" class="navigation_row labelmedium2 linedotted">	  
			    <td class="navigation_action" 
					height="15" width="30" style="padding-left:7px;padding-top:3px;padding-right:2px"
					onclick="ptoken.navigate('#link#&cfdebug=true&action=insert&#url.des1#=#assetid#','#url.box#','','','POST','');<cfif url.close eq 'Yes'>ProsisUI.closeWindow('dialog#url.box#')</cfif>">
					<cf_img icon="select">
				</td>		
				<td>#Make#</td>
				<td>#Model#</td>
				<TD><cfif AssetBarCode eq "0">n/a<cfelse>#AssetBarCode#</cfif></TD>		
				<TD>#AssetDecalNo#</TD>	
				<td>#SerialNo#</td>					
			</tr>
			<tr class="navigation_row_child line labelmedium" id="#currentrow#">
			     <td></td>
				 <td colspan="5">#Description#</td>
			</tr>
				
		</cfif>	
			     
	</cfoutput>
	
	</td>
	</tr>
	</table>

</cf_divscroll>

<tr><td colspan="6">						 
	 <cfinclude template="ItemNavigation.cfm">	 				 
</td></tr>

</TABLE>
 
<cfset AjaxOnLoad("doHighlight")>