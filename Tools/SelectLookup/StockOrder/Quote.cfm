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
<cf_tl id = "Quote" var="1">

<!---
<cf_screentop label="#lt_text#" height="100%" scroll="no" layout="webapp" banner="blue" close="ColdFusion.Window.hide('dialog#url.box#')">
--->

<cfquery name="Warehouse" 
	 datasource="appsMaterials" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	   SELECT    *
	   FROM      Warehouse
	   WHERE     Mission = '#url.mission#'
	   -- AND       Warehouse IN (SELECT Warehouse FROM itemTransaction)
	   AND       Operational = 1  	   
</cfquery>

<table align="center" width="100%" height="100%">

<tr><td valign="top" height="100%">

	<cfoutput>
	
		<table width="98%" height="100%" align="center">
		
			<tr class="line" style="height:50px">
			
			   <td valign="top">
				
				<form name="selectsale" id="selectsale" style="height:100%">
				
				<table width="100%" align="center"  class="formpadding"
				   onkeyup="if (window.event.keyCode == '13') { document.getElementById('salesearch').click();};">
				
				<cfinvoke component = "Service.Language.Tools"  
				   method           = "LookupOptions" 
				   returnvariable   = "SelectOptions">	
				   				   
					<tr>
					
					<td>
						<table>
							
						    <tr><td style="padding-top:16px;font-size:11px"><cf_tl id="Store"></td></tr>							
							<tr class="labelmedium">							
							<!--- Field: UserNames.LastName=CHAR;40;FALSE --->
							
							<TD class="hide"><SELECT name="Crit3_Operator" id="Crit3_Operator" style="height:25px;width:100;font:18px">
									#SelectOptions#
								</SELECT>
							</td>							
							<td>		
							<select name="Crit3_Value" id="Crit3_Value" style="height:35px;width:160px;font:25px" class="regularxxl" onchange="document.getElementById('salesearch').click()">
							<option value="">Any</option>
							<cfloop query="Warehouse">
						     	<option value="#Warehouse#">#WarehouseName#</option>
							</cfloop>	
							</select>
							<INPUT type="hidden" name="Crit3_FieldName" id="Crit3_FieldName" value="Warehouse">	
							<INPUT type="hidden" name="Crit3_FieldType" id="Crit3_FieldType" value="CHAR">
							</TD>										
													
							</tr>
						</table>
					</td>
										
					<td>
						<table>
						
						    <tr><td style="padding-top:16px;font-size:11px"><cf_tl id="Quote No"></td></tr>								
							<tr>
							<TD class="hide">
							      <SELECT name="Crit4_Operator" id="Crit4_Operator" style="height:25;width:60px;font:18px">
									#SelectOptions#
								</SELECT>
							</td>
							<cf_tl id="Quote No" var="1">
							<td title="#lt_text#" style="cursor:pointer">			
							<INPUT type="text" name="Crit4_Value" id="Crit4_Value"  class="regularxxl" style="text-align:center;padding-left:7px;width:80px;height:35px;font-size:25px;"> 	
							<INPUT type="hidden" name="Crit4_FieldName" id="Crit4_FieldName" value="RequestNo">			
							<INPUT type="hidden" name="Crit4_FieldType" id="Crit4_FieldType" value="CHAR">	
							</TD>
							
							</tr>
						
						</table>
					</td>					
					
                    <td>
						<table>
						<tr><TD style="padding-top:16px;font-size:11px"><cf_tl id="Customer"></TD></tr>
						<tr>
						<TD class="hide"><SELECT name="Crit1_Operator" id="Crit1_Operator" style="height:25;font:18px">
								#SelectOptions#
							</SELECT>
						</td>
						<cf_tl id="Customer" var="1">
						<td title="#lt_text#" style="cursor:point">			
						<INPUT type="text" name="Crit1_Value" id="Crit1_Value" size="25" class="regularxxl" style="padding-left:7px;height:35px;font-size:25px">	
						<INPUT type="hidden" name="Crit1_FieldName" id="Crit1_FieldName" value="CustomerName">			
						<INPUT type="hidden" name="Crit1_FieldType" id="Crit1_FieldType" value="CHAR">
						</TD>													
						</tr>
						</table>
					</td>
				
				    <td>
						<table>
						<tr><td style="padding-top:16px;padding-left:5px;font-size:11px"><cf_tl id="Officer"></TD></tr>
						<tr>
						<TD class="hide"><SELECT name="Crit2_Operator" id="Crit2_Operator" style="height:25;font:18px">
								#SelectOptions#
							</SELECT>
						</td>
						<td>			
						<INPUT type="text" name="Crit2_Value" id="Crit2_Value" value="#session.last#" size="15" class="regularxxl"
						  style="padding-left:7px;height:35px;font-size:25px"> 
						  
						  <INPUT type="hidden" name="Crit2_FieldName" id="Crit2_FieldName" value="OfficerLastName">
					      <INPUT type="hidden" name="Crit2_FieldType" id="Crit2_FieldType" value="CHAR">
						</TD>
						</tr>
						</table>
					</td>
															
					<td  align="center" style="padding:4px">
		
						<cf_tl id="Search" var="1">
										
						<cf_button2
							text		= "#lt_text#" 
							id			= "salesearch"  
							textsize	= "18px" 
							width		= "120px"
							height		= "35px"
							borderRadius= "3px" 
							onclick		= "_cf_loadingtexthtml='';ptoken.navigate('#SESSION.root#/tools/selectlookup/StockOrder/QuoteResult.cfm?page=1&close=#url.close#&box=#box#&link=#link#&des1=#des1#&filter1=#filter1#&filter1value=#filter1value#&filter2=#filter2#&filter2value=#filter2value#','#url.box#result','','','POST','selectsale')">		   
						   
					</td>
							
					</TR>
							
				</TABLE>
				
				</FORM>
			
			</td>
		
		</tr>
		
		<tr style="height:1px"><td id="#url.box#"></td></tr>
		<tr>
		<td style="height:100%" colspan="6" align="center" id="#url.box#result">
		<cfset url.page = "1">			
		<cfinclude template="QuoteResult.cfm">		
		</td></tr>
		<tr><td height="5"></td></tr>
		
		</table>
	
	</cfoutput>

</td></tr>

</table>



