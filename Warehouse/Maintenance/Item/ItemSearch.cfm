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
<cf_screentop html="no" jquery="yes" scroll="yes">

<cfset Page         = "0">
<cfset add          = "0">
<cfinclude template = "../HeaderMaintain.cfm">

<cfquery name="Mis" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT T.*
	FROM   Ref_ParameterMission T
	WHERE	Mission IN (SELECT M.Mission 
	                    FROM   Organization.dbo.Ref_MissionModule M
						WHERE  T.Mission = M.Mission
						AND    SystemModule = 'Warehouse')
</cfquery> 		

<cfoutput>
<script>
	function recordedit(id,mis) {
        ptoken.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID=" + id + "&fmission=#Mis.Mission#", "EditItem"+id);
	}	
</script>
</cfoutput>	

<!--- initially populate ItemUoMMission 

<cfquery name="MissionList" 
		datasource="appsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT * FROM Ref_ParameterMission
</cfquery>

<cfloop query="MissionList">		
	
	<cfquery name="Insert" 
			datasource="appsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			INSERT INTO ItemUoMMission
				(ItemNo, 
				 UoM, 
				 Mission,
				 OfficerUserId, 
				 OfficerLastName,
				 OfficerFirstName)
			SELECT ItemNo, UoM, '#mission#','#SESSION.acc#','#SESSION.last#','#SESSION.first#'
			FROM   ItemUoM UoM
			WHERE  ItemNo NOT IN (SELECT ItemNo 
			                      FROM   ItemUoMMission 
								  WHERE  UoM = UoM.UOM
								  AND    Mission = '#mission#')			
	</cfquery>

</cfloop>

--->

<cfoutput>

<cfinvoke component = "Service.Language.Tools"  
	   method           = "LookupOptions" 
	   returnvariable   = "SelectOptions">	

<cfform action="ItemSearchQuery.cfm?idmenu=#url.idmenu#" method="post">

	<table width="93%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding">
	
	<tr><td height="20"></td></tr>
	<tr class="line">
	   <td class="labelarge" style="font-weight:200;font-size:35px"><cf_tl id="Materials Item Master"></td>
	</tr>
	
	<tr><td style="padding-left:30px">
	
	    <table width="90%" border="0" cellspacing="0" cellpadding="0" class="formpadding">
			
		<INPUT type="hidden" name="Crit5_FieldName" id="Crit5_FieldName" value="ItemClass">		
		<INPUT type="hidden" name="Crit5_FieldType" id="Crit5_FieldType" value="CHAR">
				
		<!--- Field: Item.ItemColor=CHAR;20;FALSE --->
		<INPUT type="hidden" name="Crit6_FieldName" id="Crit6_FieldName" value="Mission">
		
		<INPUT type="hidden" name="Crit6_FieldType" id="Crit6_FieldType" value="CHAR">
		<TR>
		
		<TD class="labelmedium"><cf_tl id="Managing Entity">:</td>
		<TD colspan="3">
		
		    <table><tr><td>
			<INPUT type="hidden" name="Crit6_Operator" id="Crit6_Operator" value="EQUAL">
			<cfquery name="getMission" 
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT 	*
				FROM 	Ref_ParameterMission M
				<!--- has occurency in Item --->
				WHERE	Mission IN
							(
								SELECT DISTINCT Mission
								FROM	Item
								WHERE	Operational = 1
								UNION
								SELECT DISTINCT Mission 
					            FROM   ItemUoMMission 
								WHERE  Operational = 1
							)
				<!--- enabled for this module --->					
				AND     Mission IN (SELECT DISTINCT Mission
				                    FROM   Organization.dbo.Ref_MissionModule
									WHERE  Mission = M.Mission
									AND    SystemModule = 'Warehouse')					
			</cfquery>
			<select name="Crit6_Value" id="Crit6_Value"  class="regularxxl">
			<option value="">--<cf_tl id="Any">--</option>
			<cfloop query="getMission">
				<option value="#Mission#">#Mission#</option>
			</cfloop>
			</SELECT>		
			</td>
			<TD colspan="3" style="padding-left:4px">
			<INPUT type="hidden" name="Crit10_FieldName" id="Crit10_FieldName" value="ProgramCode">		
			<INPUT type="hidden" name="Crit10_FieldType" id="Crit10_FieldType" value="CHAR">
			<INPUT type="hidden" name="Crit10_Operator"  id="Crit10_Operator" value="EQUAL">
				
			<cf_securediv id="bProgram" bind="url:getProgram.cfm?itemNo=&mode=search&FieldName=Crit10_Value&mission={Crit6_Value}">
			</TD>	
			</tr>
			</table>
		</TD>	
		</TR>
		
		<TR>
		
		<TD valign="top" style="padding-top:6px" class="labelmedium"><cf_tl id="Class">:</td>
		<TD colspan="2">
			
			<INPUT type="hidden" name="Crit5_Operator" id="Crit5_Operator" value="EQUAL">
			
				<cfquery name="lookup" 
				datasource="appsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT 	*
					FROM 	Ref_ItemClass
					WHERE   Code != 'Other'
				</cfquery>
				
				<table>
							
				<cfloop query="lookup">
				<tr>
				<td style="height:24px;"><input type="checkbox" style="height:16px;width:16px" name="Crit5_Value" id="Crit5_Value" checked value="#Code#" class="regularxl"></td>
				<td class="labelmedium" style="height:20px;padding-left:4px">#Description# (#code#)</td>
				</tr>
				</cfloop>
				</table>
			
			
			<!---
			<select name="Crit5_Value"
	        id="Crit5_Value"
	        multiple
			class="regularxl"
	        style="height: 60px;">
			<cfloop query="lookup">
				<option value="'#Code#'" selected>#Code# - #Description#</option>
			</cfloop>
			</SELECT>		
			
			--->
			
		</TD>	
		</TR>
		
			
		<!--- Field: Item.Category=CHAR;20;FALSE --->
		<INPUT type="hidden" name="Crit3_FieldName" id="Crit3_FieldName" value="C.Category">	
		<INPUT type="hidden" name="Crit3_FieldType" id="Crit3_FieldType" value="CHAR">
		<TR>
		
		<TD valign="top" style="padding-top:5px" class="labelmedium"><cf_tl id="Category">:</TD>
		<TD colspan="2">
			<INPUT type="hidden" name="Crit3_Operator" id="Crit3_Operator" value="EQUAL">
			<cfquery name="lookup" 
			datasource="appsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT 	*
				FROM 	#CLIENT.LanPrefix#Ref_Category
				ORDER BY Description
			</cfquery>
			<cf_uiSELECT class="regularxxl" query="#lookup#" value="Category" Display="Description" name="Crit3_Value" id="Crit3_Value" style="border:1px solid silver;width:90%" multiple/>
		</TD>	
		</TR>		
		
		<INPUT type="hidden" name="Crit9_FieldName" id="Crit9_FieldName" value="ItemUsed">		
		<INPUT type="hidden" name="Crit9_FieldType" id="Crit9_FieldType" value="CHAR">
		
		<TR>
		
		<TD valign="top" style="padding-top:6px" class="labelmedium"><cf_tl id="Has been used">:</td>
		<TD colspan="2">
			
			<INPUT type="hidden" name="Crit9_Operator" id="Crit9_Operator" value="EQUAL">			
			<input type="checkbox" style="height:19px;width:19px" name="Crit9_Value" id="Crit9_Value" checked value="1" class="regularxl"></td>
							
		</TD>	
		</TR>
				
		<!--- Field: Item.ItemDescription=CHAR;100;FALSE --->
		<INPUT type="hidden" name="Crit1_FieldName" id="Crit1_FieldName" value="ItemDescription">	
		<INPUT type="hidden" name="Crit1_FieldType" id="Crit1_FieldType" value="CHAR">
		<TR>
		
		<TD class="labelmedium" width="20%"><cf_tl id="Description">:</TD>
		<TD><SELECT class="regularxxl" name="Crit1_Operator" id="Crit1_Operator">#SelectOptions#</SELECT></TD>		
		<TD width="80%" style="padding-left:2px">
	    <INPUT type="text" class="regularxxl" style="height:30px" name="Crit1_Value" id="Crit1_Value" size="20">	
		</TD>
		</TR>
	
		<!--- Field: Item.ItemDescriptionExternal=CHAR;100;FALSE --->
		<INPUT type="hidden" name="Crit2_FieldName" id="Crit2_FieldName" value="ItemDescriptionExternal">
		
		<INPUT type="hidden" name="Crit2_FieldType" id="Crit2_FieldType" value="CHAR">
		<TR class="hide">		
		<TD class="labelmedium"><cf_tl id="Description External">:</TD>
		<TD><SELECT class="regularxxl"  name="Crit2_Operator" id="Crit2_Operator">#SelectOptions#</SELECT> 
		</TD>
		<TD style="padding-left:2px">		
		<INPUT type="text" class="regularxxl" style="height:30px" name="Crit2_Value" id="Crit2_Value" size="20" > 	
		</TD>
		</TR>
	
		<!--- Field: Item.ItemColor=CHAR;20;FALSE --->
		<INPUT type="hidden" name="Crit4_FieldName" id="Crit4_FieldName" value="ItemNo">	
		<INPUT type="hidden" name="Crit4_FieldType" id="Crit4_FieldType" value="CHAR">		
		<TR>		
		<TD class="labelmedium"><cf_tl id="ItemNo">:</td>
		<TD><SELECT class="regularxxl" name="Crit4_Operator" id="Crit4_Operator">#SelectOptions#</SELECT> 
		</TD>
		<TD style="padding-left:2px">			
		<INPUT class="regularxxl" type="text" style="height:30px" name="Crit4_Value" id="Crit4_Value" size="20">		
		</TD>
		</TR>
				
		<!--- Field: Item.itemNoExternal=CHAR;20;FALSE --->
		<INPUT type="hidden" name="Crit7_FieldName" id="Crit7_FieldName" value="ItemNoExternal">	
		<INPUT type="hidden" name="Crit7_FieldType" id="Crit7_FieldType" value="CHAR">		
		<TR>		
		<TD style="min-width:190px" class="labelmedium"><cf_tl id="External code">:</td>
		<TD><SELECT class="regularxxl" name="Crit7_Operator" id="Crit7_Operator">#SelectOptions#</SELECT> 
		</TD>
		<TD style="padding-left:2px">			
		<INPUT class="regularxxl" type="text" style="height:30px" name="Crit7_Value" id="Crit7_Value" size="20">		
		</TD>
		</TR>
		
		<!--- Field: Item.itemNoExternal=CHAR;20;FALSE --->
		<INPUT type="hidden" name="Crit8_FieldName" id="Crit8_FieldName" value="ItemBarCode">	
		<INPUT type="hidden" name="Crit8_FieldType" id="Crit8_FieldType" value="CHAR">		
		<TR>		
		<TD style="min-width:190px" class="labelmedium"><cf_tl id="BarCode">:</td>
		<TD><SELECT class="regularxxl" name="Crit8_Operator" id="Crit8_Operator">#SelectOptions#</SELECT> 
		</TD>
		<TD style="padding-left:2px">			
		<INPUT class="regularxxl" type="text" style="height:30px" name="Crit8_Value" id="Crit8_Value" size="20">		
		</TD>
		</TR>


		<tr valign="top"><td height="19"></td></tr>
	
	
	</table>	
	
	</TD></TR>	
	
	<tr><td height="1" class="line"></td></tr>
	<tr><td height="25" align="center" style="padding-bottom:30px;">
		<cf_tl id="Insert" var="vAdd">
		<cf_tl id="Search" var="vSearch">
		<input class="button10g" type="button" style="width:190;height:29" name="Insert" id="Insert" value="#vAdd#" onClick="recordedit('','')">		
		<input class="button10g" type="submit" style="width:190;height:29" name"Search" id="Search" value="#vSearch#">
		</td>
		
		
	</tr>
		
	</TABLE>

</cfform>

</cfoutput>
