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
<cf_tl id = "Item Search" var = "vTitle">

<!---
<cf_screentop 
   label="#vTitle#"    
   height="100%" 
   scroll="no" 
   line="no"
   html="Yes"
   user="No"
   layout="webapp" 
   banner="gray" 
   close="ColdFusion.Window.hide('dialog#url.box#')">
   
   --->

<table align="center" bgcolor="FFFFFF" width="100%" height="100%">

	<tr><td valign="top" height="100%" style="padding:5px">
	
	<cfoutput>
	
		<table width="98%" height="100%" border="0" align="center" cellspacing="0" cellpadding="0">
		
		<tr><td height="20">
		
			<form name="select_#url.box#" id="select_#url.box#" style="height:100%" method="post">
		
			<table width="100%" border="0" class="formspacing" 			   
				align="center" 
				onkeyup="if (window.event.keyCode == '13') { document.getElementById('search').click() }">
			
			<cfinvoke component = "Service.Language.Tools"  
				   method           = "LookupOptions" 
				   returnvariable   = "SelectOptions">	
			
			<cfoutput>		
			  
			    <!--- Field: UserNames.Account=CHAR;40;FALSE --->
				<INPUT type="hidden" name="Crit1_FieldName_#url.box#" id="Crit1_FieldName_#url.box#" value="ItemDescription">		
				<INPUT type="hidden" name="Crit1_FieldType_#url.box#" id="Crit1_FieldType_#url.box#" value="CHAR">
				
				<TR class="labelmedium">
				<TD width="100"><cf_tl id="Name">:</TD>
				<TD><table cellspacing="0" cellpadding="0" class="formspacing">
					<tr><td>		
				    <SELECT name="Crit1_Operator_#url.box#" id="Crit1_Operator_#url.box#" class="regularxl">
						#SelectOptions#
					</SELECT>
					</td>
					<td>	
					<INPUT type="text" class="regularxl" name="Crit1_Value_#url.box#" id="Crit1_Value_#url.box#" size="20">
					</td>
					</tr>
					</table>
				
				</TD>
				</TR>
				
				<!--- Field: UserNames.LastName=CHAR;40;FALSE --->
				<INPUT type="hidden" name="Crit2_FieldName_#url.box#" id="Crit2_FieldName_#url.box#" value="ItemNo">		
				<INPUT type="hidden" name="Crit2_FieldType_#url.box#" id="Crit2_FieldType_#url.box#" value="CHAR">
				<TR class="labelmedium">
				<TD><cf_tl id="Code">:</TD>				
				<TD>
					<table cellspacing="0" cellpadding="0" class="formspacing">
					<tr><td>	
					<SELECT name="Crit2_Operator_#url.box#" id="Crit2_Operator_#url.box#" class="regularxl">
						#SelectOptions#
					</SELECT>
					</td><td>			
					<INPUT type="text" class="regularxl" name="Crit2_Value_#url.box#" id="Crit2_Value_#url.box#" size="20"> 
					</td>
					</tr>
					</table>				
				</TD>
				</TR>	
				
				<cfif url.filter1 eq "Warehouse">			
						
					<cfquery name="getMode" 
					    datasource="AppsMaterials" 
					    username="#SESSION.login#" 
					    password="#SESSION.dbpw#">
					       SELECT    W.*, P.LotManagement
					       FROM      Warehouse W, Ref_ParameterMission P
					       WHERE     W.Warehouse = '#url.filter1value#'		 				 
						   AND       W.Mission = P.Mission 
					</cfquery>
					 
					<cfif getMode.LotManagement eq "1">
					  
						<!--- Field: UserNames.LastName=CHAR;40;FALSE --->
						<INPUT type="hidden" name="Crit3_FieldName_#url.box#" id="Crit3_FieldName_#url.box#" value="TransactionLot">		
						<INPUT type="hidden" name="Crit3_FieldType_#url.box#" id="Crit3_FieldType_#url.box#" value="CHAR">
						<TR>
						<TD class="labelit"><cf_tl id="Lot">:</TD>
						
						<TD>
							<table cellspacing="0" cellpadding="0" class="formspacing">
							<tr><td>	
							<SELECT name="Crit3_Operator_#url.box#" id="Crit3_Operator_#url.box#" class="regularxl">
								#SelectOptions#
							</SELECT>
							</td><td>			
							<INPUT type="text" class="regularxl" name="Crit3_Value_#url.box#" id="Crit3_Value_#url.box#" size="20"> 
							</td>
							</tr>
							</table>					
						</TD>
						</TR>
					
					</cfif>
				
						<INPUT type="hidden" name="Crit4_FieldName_#url.box#" id="Crit4_FieldName_#url.box#" value="ItemNoExternal">		
						<INPUT type="hidden" name="Crit4_FieldType_#url.box#" id="Crit4_FieldType_#url.box#" value="CHAR">
						<TR>
						<TD class="labelit"><cf_tl id="External code">:</TD>
						
						<TD>
							<table cellspacing="0" cellpadding="0" class="formspacing">
							<tr><td>	
							<SELECT name="Crit4_Operator_#url.box#" id="Crit4_Operator_#url.box#" class="regularxl">
								#SelectOptions#
							</SELECT>
							</td><td>			
							<INPUT type="text" class="regularxl" name="Crit4_Value_#url.box#" id="Crit4_Value_#url.box#" size="20"> 
							</td>
							</tr>
							</table>					
						</TD>
						</TR>		
						
						<INPUT type="hidden" name="Crit5_FieldName_#url.box#" id="Crit5_FieldName_#url.box#" value="ItemBarcode">		
						<INPUT type="hidden" name="Crit5_FieldType_#url.box#" id="Crit5_FieldType_#url.box#" value="CHAR">
						<TR>
						<TD class="labelit"><cf_tl id="Barcode">:</TD>
						
						<TD>
							<table cellspacing="0" cellpadding="0" class="formspacing">
							<tr><td>	
							<SELECT name="Crit5_Operator_#url.box#" id="Crit4_Operator_#url.box#" class="regularxl">
								#SelectOptions#
							</SELECT>
							</td><td>			
							<INPUT type="text" class="regularxl" name="Crit5_Value_#url.box#" id="Crit5_Value_#url.box#" size="20"> 
							</td>
							</tr>
							</table>					
						</TD>
						</TR>					
				
				</cfif>
						
			</TABLE>
				
			</form>
		
			</td>
		
		</tr>	
		
		</cfoutput>
		
		</tr>
						
		<tr><td colspan="2" align="center">
			
			<cf_tl id="Search" var="1">
		
			<input type    = "button" 
			  	   name    = "search"
				   id      = "search"
				   class   = "button10g"
				   style   = "font-size:12px"
				   value   = "<cfoutput>#lt_text#</cfoutput>" 
				   onclick = "ptoken.navigate('#SESSION.root#/tools/selectlookup/Item/ItemResult.cfm?stock=#url.stock#&page=1&close=#url.close#&box=#box#&link=#link#&des1=#des1#&filter1=#filter1#&filter1value=#filter1value#&filter2=#filter2#&filter2value=#filter2value#','result#url.box#','','','POST','select_#url.box#')">
				   
		</td></tr>
		
		<tr>
			<td colspan="2" align="center"  width="100%" height="100%">
			
			<cfif url.stock eq "1">
				<cfset width="70%">
			<cfelse>
				<cfset width="100%">
			</cfif>
			
			<table height="100%"  width="100%">
			 <tr><td width="#width#" height="100%">
				<cf_divscroll style="height:100%">
					<cfdiv id="result#url.box#" style="padding-right:5px">		
				</cf_divscroll>
				</td>
				<cfif url.stock eq "1">
				   <td height="100%" width="400" valign="top" id="dlist" style="border-left:1px solid silver"></td>
				<cfelse>
				   <td width="1" valign="top" id="dlist"></td>
				</cfif>
				</tr>
			</table>
			
			</td>
		</tr>
	
	</table>

</cfoutput>

</td></tr>

</table>

<cf_screenbottom layout="webdialog">
