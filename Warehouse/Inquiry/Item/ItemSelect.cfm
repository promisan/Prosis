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
<cfparam name="URL.script" 		default="">
<cfparam name="url.itemclass" 	default="">
<cfparam name="url.itemmaster" 	default="">
<cfparam name="url.mission"    	default="">
<cfparam name="url.mode"       	default="standard">
<cfparam name="url.itmbox" 		default="">
<cfparam name="url.openerbox" 	default="">
<cfparam name="url.close" 		default="yes">

<cfsilent>
	<proUsr>jmazariegos</proUsr>
	<proOwn>Jorge Mazariegos</proOwn>
	<proDes>Translated</proDes>
	<proCom></proCom>
</cfsilent>

<cfajaximport>

<cf_dialogMaterial>

<CFOUTPUT>		
	
	<script>
	
	function Selected(itemno,itemdescription,uom,uomname) {	      
		if ('#url.itmbox#' != '') {
			opener.document.getElementById('#url.itmbox#').value = itemno;											
		}else {
			alert('configuration error');
		}
		
		if ('#url.openerbox#' != '') {
			url = "#SESSION.root#/Warehouse/Inquiry/Item/ItemSelectDisplay.cfm?ts="+new Date().getTime()+"&itemno="+itemno+"&uom="+uom+"&selectuom=0";
			opener.ptoken.navigate(url,'#url.openerbox#');
		}else {
			alert('configuration error');
		}
		
		if (opener.document.getElementById('divAssetItemSupplyWarehouse')) {
			opener.ptoken.navigate('#SESSION.root#/Warehouse/Maintenance/Item/Consumption/AssetItem/AssetItemSupplyWarehouse.cfm?itemno=#url.itemmaster#&supply='+itemno+'&uom='+uom,'divAssetItemSupplyWarehouse');
		}
	 	window.close()		  
	}  
		
	function setvalue(itmuomid) {
	    
	    <cfif url.script neq "">
			
			try {
				parent.#url.script#(itmuomid,'#url.scope#');	
			} catch(e) {}
		
	    </cfif>	
		
		<cfif url.close eq "yes">
			parent.ProsisUI.closeWindow('warehouseitemwindow',true);	
		</cfif>
		
	}		
	
	</script>

</cfoutput>

<cfif url.itemclass eq "undefined">
 <cfset url.itemclass = ""> 
</cfif>

<cfif url.itemmaster eq "undefined">
 <cfset url.itemmaster = "">
</cfif>

<cf_tl id="Item search" var="vSearch">

<cf_screentop bannerheight="55" html="no" label="#vSearch#" jQuery="Yes" banner="gray"  user="No" height="100%" layout="webapp" scroll="no">

<!--- End Prosis template framework --->

<cfoutput>

<table width="98%" height="100%" align="center" class="formpadding">

<tr><td valign="top" height="100%">

	<form name="locform" id="locform" style="height:100%">
	
		<table width="100%" border="0" height="100%">
		
			<tr><td valign="top" height="100%">
			
			    <table width="98%" height="100%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding">
						
				<!--- Field: Item.ItemColor=CHAR;20;FALSE --->
				<cfinvoke component = "Service.Language.Tools"  
				   method           = "LookupOptions" 
				   returnvariable   = "SelectOptions">	
									
				<INPUT type="hidden" name="Crit1_FieldName" id="Crit1_FieldName" value="I.ItemDescription">	
				<INPUT type="hidden" name="Crit1_FieldType" id="Crit1_FieldType" value="CHAR">
				
				<TR>
				<TD class="labelmedium" width="80"><cf_tl id="Product">:</TD>
				<TD width="100">
				     <SELECT name="Crit1_Operator" id="Crit1_Operator" class="regularxl">
						#SelectOptions#				
					</SELECT>
				</TD>
				<TD width="60%">
			    <INPUT type="text" name="Crit1_Value" id="Crit1_Value" size="20" class="regularxl">	
				</TD>
				</TR>
				
				<!--- Field: Item.ItemDescriptionExternal=CHAR;100;FALSE --->
				<INPUT type="hidden" name="Crit2_FieldName" value="U.ItemBarCode">	
				<INPUT type="hidden" name="Crit2_FieldType" value="CHAR">
				<TR>
				<TD class="labelmedium"><cf_tl id="Barcode">:</TD>
				<TD><SELECT name="Crit2_Operator" class="regularxl">		
						#SelectOptions#							
					</SELECT> 
				</TD>
				<TD>		
				<INPUT type="text" name="Crit2_Value" size="20" class="regularxl"> 	
				</TD>
				</TR>
				
				<INPUT type="hidden" name="Crit4_FieldName" id="Crit4_FieldName" value="I.Classification">	
				<INPUT type="hidden" name="Crit4_FieldType" id="Crit4_FieldType" value="CHAR">
				
				<TR>
				<TD class="labelmedium"><cf_tl id="Classification">:</font>
				<TD><SELECT name="Crit4_Operator" id="Crit4_Operator" class="regularxl">		
						#SelectOptions#						
					</SELECT> 
				</TD>
				<TD>		
				<INPUT type="text" name="Crit4_Value" class="regularxl" id="Crit4_Value" size="20">	
				</TD>
				</TR>
				
				<INPUT type="hidden" name="Crit3_FieldName" id="Crit3_FieldName" value="I.Category">	
				<INPUT type="hidden" name="Crit3_FieldType" id="Crit3_FieldType" value="CHAR">
				
				<TR>
				<TD class="labelmedium"><cf_tl id="Category">:</TD>
				<TD class="regular" colspan="2">

					<cfquery name="getCategories" 
						datasource="AppsMaterials" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							SELECT	*
							FROM	Ref_Category
							ORDER BY Description
					</cfquery>
					
					<input type="Hidden" name="Crit3_Operator" id="Crit3_Operator" value="EQUAL">
					<SELECT name="Crit3_Value" id="Crit3_Value" class="regularxl">		
						<option value="">
						<cfloop query="getCategories">
							<option value="#Category#"> #Description#
						</cfloop>			
					</SELECT>
					
				</TD>
				</TR>
				
				<tr><td height="3"></td></tr>
				
				<tr><td colspan="3" align="right" class="linedotted"></td></tr>	
				<tr><td height="3"></td></tr>
				<tr><td height="30" colspan="3" align="center">
					
					<input class="button10g" style="width:140;height:23" type="button" name"Search" ID="Search" value="#vSearch#"
					onclick="ptoken.navigate('ItemSelectDetail.cfm?mission=#url.mission#&mode=#url.mode#&itemmaster=#url.itemmaster#&itemclass=#url.itemclass#','result','','','POST','locform')">
				
				</td></tr>
				
				<tr><td colspan="3" height="100%">
				
					<table width="99%" border="0" height="100%" cellspacing="0" cellpadding="0" align="center">
				
						<TR><TD height="100%">
							<cf_divscroll style="height:100%" id="result"></cf_divscroll>
						</TD></TR>
				
					</table>
			
				</td></tr>
			</table>	
			
			</td></tr>
			
			</table>	
		
		</FORM>
	
	</td></tr>
</table>
	
</cfoutput>

