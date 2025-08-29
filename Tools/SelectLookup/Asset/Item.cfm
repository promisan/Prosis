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
<!---

<cf_screentop label="Search"  
   height  = "100%" 
   scroll  = "no" 
   banner  = "gray"
   layout  = "webapp" 
   line    = "no"
   close   = "ColdFusion.Window.hide('dialog#url.box#')">
   
   --->
   

<table align="center" bgcolor="FFFFFF" width="100%" height="100%">

<tr><td valign="top">

<cfoutput>

<table width="95%" align="center" align="center">

<tr><td>

<form name="select_#url.box#" id="select_#url.box#" method="post">

<table width="100%" class="formpadding" onkeyup="if (window.event.keyCode == '13') { document.getElementById('search').click() }">

<cfinvoke component = "Service.Language.Tools"  
	   method           = "LookupOptions" 
	   returnvariable   = "SelectOptions">		   

	<!--- if the category is passed we do no longer have to show it --->

	<cfif url.filter3 eq "Category">
	
		<input type="hidden" name="Category" value="#url.filter3value#">	
	
	<cfelseif url.filter4 eq "Category">
	
		<input type="hidden" name="Category" value="#url.filter4value#">			
	
	<cfelse>
      
		<TR class="labelmedium2">
		<TD width="70">Category:</TD>
		<TD colspan="3">
				
		<cfquery name="CategoryList" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT * FROM Ref_Category
		WHERE 1 = 1
		AND   Category IN (
		                   SELECT Category 
		                   FROM   Item 
						   WHERE  ItemClass = 'Asset'
						   <cfif filter1 eq "mission">
						   AND    ItemNo IN (SELECT ItemNo 
						                     FROM   AssetItem 
											 WHERE  Mission = '#filter1value#') 
						   </cfif>
						   )
		<cfif filter1 eq "mission">
		<!---
		AND    Category IN 
		                (SELECT Category 
		                 FROM   WarehouseCategory WC, Warehouse W 
						 WHERE  WC.Warehouse = W.Warehouse
						 AND    W.Mission = '#filter1value#')
						 --->
		</cfif>
		
		
		<cfif filter2 eq "ServiceItem">
		AND    Category IN (SELECT MaterialsCategory 
			                FROM   WorkOrder.dbo.ServiceItemMaterials
						    WHERE  ServiceItem = '#filter2value#'
						    AND    MaterialsClass = 'Asset')
		</cfif>
		</cfquery>
		
		<cfif categoryList.recordcount eq "0">
		
			<cfquery name="CategoryList" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT * 
				FROM   Ref_Category	
			</cfquery>
		
		</cfif>
		
		   <SELECT name="Category" id="Category" style="width:160" class="regularxxl">
					
			<cfloop query="categoryList">		
			<option value="#Category#">#Description#</option>
			</cfloop>
			
			</SELECT>
			
		</TD>
		
		</TR>
	
	</cfif>
	
	<!--- Field: UserNames.LastName=CHAR;40;FALSE --->
	<INPUT type="hidden" name="Crit2_FieldName_#url.box#" id="Crit2_FieldName_#url.box#" value="Make">
	
	<INPUT type="hidden" name="Crit2_FieldType_#url.box#" id="Crit2_FieldType_#url.box#" value="CHAR">
	<TR class="labelmedium2">
	<TD>Make:</TD>
	<TD><SELECT name="Crit2_Operator_#url.box#" id="Crit2_Operator_#url.box#" class="hide regularxxl">
			#SelectOptions#
		</SELECT>
		
	<INPUT type="text" name="Crit2_Value_#url.box#" id="Crit2_Value_#url.box#" size="14" class="regularxxl"> 
	
	</TD>
			
	<INPUT type="hidden" name="Crit3_FieldName_#url.box#" id="Crit3_FieldName_#url.box#" value="OrgUnit">	
	<INPUT type="hidden" name="Crit3_FieldType_#url.box#" id="Crit3_FieldType_#url.box#" value="CHAR">
	
	<TD>Unit:</TD>
	<TD><SELECT name="Crit3_Operator_#url.box#" id="Crit3_Operator_#url.box#" class="hide regularxxl">
			#SelectOptions	#
		</SELECT>
		
	<INPUT type="text" name="Crit3_Value_#url.box#" id="Crit3_Value_#url.box#" size="14" class="regularxl"> 
	
	</TD>
	
	</tr>
	
	<tr class="labelmedium2">
		
	<INPUT type="hidden" name="Crit4_FieldName_#url.box#" id="Crit4_FieldName_#url.box#" value="AssetBarCode">	
	<INPUT type="hidden" name="Crit4_FieldType_#url.box#" id="Crit4_FieldType_#url.box#" value="CHAR">
	
	<TD width="100" style="padding-right:20px">Barc/Plate/Serial:</TD>
	<TD><SELECT name="Crit4_Operator_#url.box#" id="Crit4_Operator_#url.box#" class="hide regularxxl">
			#SelectOptions#
		</SELECT>
		
	<INPUT type="text" name="Crit4_Value_#url.box#" id="Crit4_Value_#url.box#" size="14" class="regularxxl"> 
	
	</TD>
	
	<TD>Description:</TD>
	<TD>
	
	<INPUT type="hidden" name="Crit0_FieldName_#url.box#" id="Crit0_FieldName_#url.box#" value="Description">
	<INPUT type="hidden" name="Crit0_FieldType_#url.box#" id="Crit0_FieldType_#url.box#" value="CHAR">
	
	<SELECT name="Crit0_Operator_#url.box#" id="Crit0_Operator_#url.box#" class="hide regularxxl">
			#SelectOptions#
	</SELECT>
		
	<INPUT type="text" name="Crit0_Value_#url.box#" id="Crit0_Value_#url.box#" size="24" class="regularxxl"> 
	
	</TD>
	</TR>
	
	<!---
	
	<tr>
		
	<INPUT type="hidden" name="Crit5_FieldName_#url.box#" id="Crit5_FieldName_#url.box#" value="AssetDecalNo">
	<INPUT type="hidden" name="Crit5_FieldType_#url.box#" id="Crit5_FieldType_#url.box#" value="CHAR">
	
	<TD width="140" class="labelit">Plate No:</TD>
	<TD><SELECT name="Crit5_Operator_#url.box#" id="Crit5_Operator_#url.box#" style="font:10px">
			#SelectOptions#
		</SELECT>
		
	<INPUT type="text" name="Crit5_Value_#url.box#" id="Crit5_Value_#url.box#" size="15" class="regular"> 
	
	</TD>
	
	 <!--- Field: UserNames.Account=CHAR;40;FALSE --->
	<INPUT type="hidden" name="Crit1_FieldName_#url.box#" id="Crit1_FieldName_#url.box#" value="SerialNo">
	
	<INPUT type="hidden" name="Crit1_FieldType_#url.box#" id="Crit1_FieldType_#url.box#" value="CHAR">
	
	<TD width="100" class="labelit">SerialNo:</TD>
	<TD><SELECT name="Crit1_Operator_#url.box#" id="Crit1_Operator_#url.box#" style="font:10px">
			#SelectOptions#
		</SELECT>
		
	<INPUT type="text" name="Crit1_Value_#url.box#" id="Crit1_Value_#url.box#" size="15" class="regular"> 
	
	</TD>
		
	</TR>
	
	--->
			
</TABLE>

</tr>

<tr><td colspan="2" class="line"></td></tr>
	
<tr><td colspan="4" style="height:26px">

	<table><tr>
	   <cfoutput>
	   
		   <td class="labelit" style="padding-left:5px"><img src="#SESSION.root#/images/finger.gif" alt="" border="0"></td>
		   <td class="labelit">Press [Search] to view a complete list of items.</td>
	   
	   </cfoutput>
	   
	   <td style="padding-left:4px" width="200">
	
		<cf_tl id="Search" var="1">
		<input type="button" 
		   name="search"
		   id="search"
		   value="<cfoutput>#lt_text#</cfoutput>" 
		   style="height:20px"
		   onclick="ptoken.navigate('#SESSION.root#/tools/selectlookup/Asset/ItemResult.cfm?height='+document.body.clientHeight+'&page=1&close=#url.close#&box=#box#&link=#link#&des1=#des1#&filter1=#filter1#&filter1value=#filter1value#&filter2=#filter2#&filter2value=#filter2value#&filter3=#filter3#&filter3value=#filter3value#&filter4=#filter4#&filter4value=#filter4value#','result#url.box#','','','POST','select_#url.box#')"
		   class="button10g">
	   
	   </td>
	   
	   </tr>
   </table>
   
</td></tr>

<tr><td colspan="4" class="line"></td></tr>

<tr>
	<td style="padding-top:4px" colspan="4" align="center" valign="middle" id="result#url.box#"></td>
</tr>

</table>

</FORM>

</cfoutput>

</td></tr>

</table>

<!---
<cf_screenbottom layout="webdialog">
--->
