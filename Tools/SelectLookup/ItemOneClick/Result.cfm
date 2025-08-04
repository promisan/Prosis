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
<cfparam name="criteria" default="">

<CFSET val = evaluate("Form.Crit1_Value_#url.box#")>


<cfif val neq "">

	<CF_Search_AppendCriteria
	    FieldName = "#evaluate('Form.Crit1_FieldName_#url.box#')#"
	    FieldType = "#evaluate('Form.Crit1_FieldType_#url.box#')#"
	    Operator  = "#evaluate('Form.Crit1_Operator_#url.box#')#"
	    Value     = "#evaluate('Form.Crit1_Value_#url.box#')#">
	
</cfif>	

<CFSET val = evaluate("Form.Crit2_Value_#url.box#")>
	
<cfif val neq "">	
	
	<CF_Search_AppendCriteria
	    FieldName = "#evaluate('Form.Crit2_FieldName_#url.box#')#"
	    FieldType = "#evaluate('Form.Crit2_FieldType_#url.box#')#"
	    Operator  = "#evaluate('Form.Crit2_Operator_#url.box#')#"
	    Value     = "#evaluate('Form.Crit2_Value_#url.box#')#">

</cfif>



<cfset link    = replace(url.link,"||","&","ALL")>
   
<table width="100%" border="0" cellspacing="0" cellpadding="0">
 
<td width="100%" colspan="2" valign="top">

<!--- Query returning search results --->

<cfquery name="Total" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT count(*) as Total
    FROM   Item
	WHERE  Operational = 1
	<cfif criteria neq "">
	AND    #preserveSingleQuotes(criteria)# 	
	</cfif>
	<cfif filter1 eq "Warehouse">
	
	   AND   ItemNo IN (
	                     SELECT ItemNo 
						 FROM   Item 
						 WHERE  Category IN (SELECT Category 
	                                         FROM   WarehouseCategory 
										     WHERE  Warehouse = '#filter1value#')
					   )
	<cfelseif filter1 eq "Category">
		AND   ItemNo IN (SELECT ItemNo FROM Item WHERE Category = '#filter1value#') 
	<cfelseif filter1 eq "ItemClass">
		AND   ItemNo IN (SELECT ItemNo FROM Item WHERE Category = '#filter1value#')	
	<cfelseif filter1 eq "ServiceItem">
		AND   Category IN 
							(
								SELECT	MaterialsCategory
								FROM 	WorkOrder.dbo.ServiceItemMaterials
								WHERE	ServiceItem = '#filter1value#'
								AND		MaterialsClass = 'Asset'
							)
	</cfif>
	
	<cfif filter2 eq "Asset">
	<!--- filter based on the asset which is selected to ItemSupply --->
	
	<!--- Kristhian Herrera - 07/11/2011 - For warehouse, items stock levels --->
	<cfelseif filter2 eq "ItemClass">
		AND   ItemClass in ('#filter2value#')
	</cfif>

</cfquery>

	
<cf_pagecountN show="21" 
               count="#Total.Total#">
			   
<cfset counted  = total.total>			   

<cfquery name="SearchResult" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT TOP #last# *
    FROM Item
	WHERE 1=1
	<cfif criteria neq "">
	AND #preserveSingleQuotes(criteria)# 	
	</cfif>
	
	<cfif filter1 eq "Warehouse">
	   AND   ItemNo IN (
	                     SELECT ItemNo 
						 FROM   Item 
						 WHERE  Category IN (SELECT Category 
	                                         FROM   WarehouseCategory 
										     WHERE  Warehouse = '#filter1value#')
	
				   )					   
	<cfelseif filter1 eq "Category">
		AND   ItemNo IN (SELECT ItemNo FROM Item WHERE Category = '#filter1value#')
	<cfelseif filter1 eq "ItemClass">
		AND   ItemNo IN (SELECT ItemNo FROM Item WHERE Category = '#filter1value#')
	<cfelseif filter1 eq "ServiceItem">
		AND   Category IN 
							(
								SELECT	MaterialsCategory
								FROM 	WorkOrder.dbo.ServiceItemMaterials
								WHERE	ServiceItem = '#filter1value#'
								AND		MaterialsClass = 'Asset'
							)
	</cfif>
		
	<cfif filter2 eq "Asset">
	<!--- filter based on the asset which is selected to ItemSupply --->
	
	<!--- Kristhian Herrera - 07/11/2011 - For warehouse, items stock levels --->
	<cfelseif filter2 eq "ItemClass">
		AND   ItemClass in ('#filter2value#')
	</cfif>
	
ORDER BY ItemNo
</cfquery>

	<table border="0" cellpadding="0" cellspacing="0" width="100%" class="navigation_table">
	
	<tr><td height="14" colspan="7">
							 
		 <cfinclude template="Navigation.cfm">
		 				 
	</td></tr>
	
	<cfif searchresult.recordcount eq "0">
		<tr><td height="26" colspan="7" align="center"><font face="Verdana" color="FF0000">No items to show in this view</font></td></tr>
	</cfif>
	
	<tr><td></td>
	    <td class="labelit">Item</td>
		<td class="labelit">Name</td>
		<td class="labelit">UoM</td>
		<td class="labelit" align="right">Standard Cost</td>
	</tr>
	<tr><td colspan="5" class="linedotted"></td></tr>
	
	<cfoutput query="SearchResult">
	
	<cfif currentrow gte first>
	
		<tr class="navigation_row" 
		  onclick="ptoken.navigate('#link#&action=insert&#url.des1#=#itemNo#','#url.box#','','','POST','');<cfif url.close eq 'Yes'>ColdFusion.Window.hide('dialog#url.box#')</cfif>">
		  
		    <td height="18" width="30" style="padding-top:2px">
			
			   <cf_img icon="open">
		
			</td>
			<td width="60" class="labelit">#ItemNo#</td>
			<TD width="55%" class="labelit">#ItemDescription#</TD>
											
			<cfquery name="UoM" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT TOP 3 *
			    FROM   ItemUoM
				WHERE  ItemNo = '#itemno#'	
			</cfquery>
			
			<cfloop query="UoM">
			
				<cfif currentrow neq "1">
				<tr>
				<td></td>
				<td></td>
				<td></td>
				</cfif>
						
				<td class="labelit">#UoMDescription#</td>
				<td class="labelit" align="right">#numberformat(UOM.standardcost,"__,__.__")#</td>		
				</tr>
					
			</cfloop>
			
		</tr>
		
		<tr><td colspan="7" class="linedotted"></td></tr>
		
	</cfif>	
			     
	</CFOUTPUT>
	
	<tr><td height="14" colspan="7">						 
		 <cfinclude template="Navigation.cfm">	 				 
	</td></tr>
	
	</TABLE>

</td>
</tr>
 
</table>

<cfset ajaxonload("doHighlight")>
