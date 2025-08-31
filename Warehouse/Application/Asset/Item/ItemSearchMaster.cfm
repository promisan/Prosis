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
<cfparam name="url.mode" default="manual">

<cf_tl id="Select Item" var="1">
<cfset lbl = lt_text>

<cf_screentop height="100%" label="#lbl#" 
   html="Yes" layout="webapp" 
   systemmodule="Warehouse" functionclass="Window" functionName="Select Asset item"
   banner="gray" bannerforce="Yes" line="no" jquery="Yes">

<CFOUTPUT>		

	<script>

	function Selected(code,uom) {        
		ptoken.location("../AssetEntry/ReceiptParentEntry.cfm?Mission=#URL.Mission#&Mode=#url.mode#&ItemNo="+code+"&ItemUoMId="+uom)		
	}
	</script>

</CFOUTPUT>

<cfparam name="URL.FormName" default="">
<cfparam name="URL.fldassetno" default="">
<cfparam name="URL.fldassetdescription" default="">

<cfoutput>
	<INPUT type="hidden" name="FormName" id="FormName"          value="#URL.FormName#">
	<INPUT type="hidden" name="assetno" id="assetno"           value="#URL.fldassetno#">
	<INPUT type="hidden" name="assetdescription" id="assetdescription"  value="#URL.fldassetdescription#">
</cfoutput>

<table width="98%" height="100%" border="0" cellspacing="0" cellpadding="0" align="center">
<tr><td height="6"></td></tr>
<tr><td valign="top">

<CFFORM style="height:100%" name="formloc">

<cfinvoke component = "Service.Language.Tools"  
	   method           = "LookupOptions" 
	   returnvariable   = "SelectOptions">	
	   
<table width="100%" height="100%" cellspacing="0" cellpadding="0" align="center" class="formpadding">

<tr><td valign="top" style="padding-left:10px" align="left">

    <table border="0" cellspacing="0" cellpadding="0" class="formpadding">
 			
	<!--- Field: Item.ItemDescription=CHAR;100;FALSE --->
	<INPUT type="hidden" name="Crit1_FieldName" id="Crit1_FieldName" value="I.ItemDescription">
	
	<INPUT type="hidden" name="Crit1_FieldType" id="Crit1_FieldType" value="CHAR">
	<TR>
	<TD class="labelit"><cf_tl id="Description">:</TD>
	<TD class="regularxl"><SELECT name="Crit1_Operator" id="Crit1_Operator" class="regularxl">
			<cfoutput>
				#SelectOptions#
			</cfoutput>
		</SELECT>
	</TD>
	<TD>
    <INPUT type="text" name="Crit1_Value" id="Crit1_Value" size="20" class="regularxl">	
	</TD>
	</TR>
		
	<!--- Field: Item.ItemColor=CHAR;20;FALSE --->
	<INPUT type="hidden" name="Crit4_FieldName" id="Crit4_FieldName" value="C.Description">
	
	<INPUT type="hidden" name="Crit4_FieldType" id="Crit4_FieldType" value="CHAR">
	<TR>
	<TD class="labelit"><cf_tl id="Category">:</font>
	<TD width="30%" class="regularxl">
		<SELECT name="Crit4_Operator" id="Crit4_Operator" class="regularxl">
			<cfoutput>
				#SelectOptions#
			</cfoutput>	
		</SELECT> 
	</TD>
	<TD>
		
	<INPUT type="text" name="Crit4_Value" id="Crit4_Value" size="20" class="regularxl">
	
	</TD>
	</TR>
	
	<!--- Field: Item.ItemDescription=CHAR;100;FALSE --->
	<INPUT type="hidden" name="Crit2_FieldName" id="Crit2_FieldName" value="I.Make">
	
	<INPUT type="hidden" name="Crit2_FieldType" id="Crit2_FieldType" value="CHAR">
	<TR>
	<TD class="labelit"><cf_tl id="Make">:</TD>
	<TD class="regularxl"><SELECT name="Crit2_Operator" id="Crit2_Operator" class="regularxl">
			<cfoutput>
				#SelectOptions#
			</cfoutput>
		</SELECT>
	</TD>
	<TD class="regularxl">

    <INPUT type="text" name="Crit2_Value" id="Crit2_Value" size="20" class="regularxl">
	
	</TD>
	</TR>
	
	<!--- Field: Item.ItemDescription=CHAR;100;FALSE --->
	<INPUT type="hidden" name="Crit3_FieldName" id="Crit3_FieldName" value="I.Model">
	
	<INPUT type="hidden" name="Crit3_FieldType" id="Crit3_FieldType" value="CHAR">
	<TR>
	<TD class="labelit"><cf_tl id="Model">:</TD>
	<TD class="regularxl"><SELECT name="Crit3_Operator" id="Crit3_Operator" class="regularxl">
			<cfoutput>
				#SelectOptions#
			</cfoutput>

		</SELECT>
	</TD>
	<TD class="regularxl">
    <INPUT type="text" name="Crit3_Value" id="Crit3_Value" size="20" class="regularxl">	
	</TD>
	</TR>
			
	
	</table>	

	</TD></TR>	
	
	<tr><td height="1" colspan="3" class="linedotted"></td></tr>	
	<tr valign="top"><td height="19" colspan="3" align="center">
		
	<cf_tl id="Search" var="1">
	
		<cfoutput>
		<input type="button"
			value       = "#lt_text#" 	
			onClick     = "ColdFusion.navigate('#SESSION.root#/warehouse/application/asset/item/ItemSearchMasterResult.cfm?Mission=#URL.Mission#','result','','','POST','formloc')"					
			id          = "Search"	
			class       = "button10g"				
			width       = "190px">   
		</cfoutput>
	
	</td></tr>

		
	<TR>
		<TD width="99%" align="center" height="100%" valign="top" style="padding:6px" >
		<cf_divscroll style="height:100%" id="result"></cf_divscroll>
		</TD>
	</TR>

</table>

</CFFORM>

</td></tr>

</table>

<cf_screenbottom layout="webapp">

