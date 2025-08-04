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
<cfquery name="HS" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">	 
	SELECT    RIN.*, I.ItemDescription, I.ItemClass
    FROM      WorkOrderLineResource RIN INNER JOIN Materials.dbo.Item I
    	ON I.ItemNo = RIN.ResourceItemNo 
    WHERE     ResourceId = '#URL.drillId#'    									  
</cfquery>

<cfquery name="qResource" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">	 
	SELECT    *
    FROM      Ref_ResourceMode
    ORDER BY  Code     									  
</cfquery>

<cf_tl id="Maintain resources" var="1">
	
<cf_screentop label="#HS.ItemDescription#" html="yes" layout="webapp" banner="blue" user="no">

<cfoutput>

<cfform id="fResource">	

	<table width="100%" cellpadding="0" cellspacing="0">
	<tr>
	<td width="5%"></td>	
	<td>
	<table width="100%" cellpadding="0" cellspacing="0">
		
		<tr height="40px">	
			<td class="labelmedium" width="40%">
				<cf_tl id="Resource Mode">:	
			</td>
			<td align="right">
				<select id="resourcemode" name="resourcemode" class="regularxl">
					<cfloop query="qResource">
						<option value="#qResource.code#" <cfif qResource.code eq HS.resourcemode>selected</cfif>>#qResource.description#</option>
					</cfloop>
				</select>
				
			</td>
		</tr>
		
		<tr height="40px">
			<td class="labelmedium">
				<cf_tl id="Quantity">:
			</td>
			<td class="labelmedium" align="right">
				<input type="text" id="quantity" name="quantity" type="number" value="#Trim(NumberFormat(HS.Quantity,',.__'))#" class="regularxl" size="10" style="text-align:right">	
			</td>	
		</tr>
		
		<tr height="40px">
			<td class="labelmedium">
				<cf_tl id="Estimated Price">:
			</td>
			<td class="labelmedium" align="right">
				<input type="text" id="price" name="price" type="number" value="#Trim(NumberFormat(HS.Price,',.__'))#" class="regularxl" size="10" style="text-align:right">	
			</td>	
		</tr>
	
		<tr height="40px">
			<td class="labelmedium">
				<cf_tl id="Estimated Total">:
			</td>
			<td class="labelmedium" align="right">
				<input type="text" id="total" name="total" type="number" value="#Trim(NumberFormat(HS.Price*HS.Quantity,',.__'))#" class="regularxl" size="10" style="text-align:right;border:0" readonly>	
			</td>	
		</tr>
						
	
		<tr>
			<td class="labelmedium" colspan="2">
				<cf_tl id="Remarks">:
			</td>
		</tr>
	
		<tr>
			<td class="labelmedium" colspan="2">
				<cf_textarea height="250" name="remarks" init="no" toolbar="Basic" color="ffffff">#HS.Memo#</cf_textarea>
			</td>
		</tr>	
		
		<tr>
			<td colspan="2" align="center" style="padding-top:10px">
					<table>
					<tr>
						<td>	
					   		<cf_tl id="Close" var="1">
					   		<input type="button" 
							    name="close"  
								id="close"
								value="#lt_text#" 
								style="width:100px;height:25" 
								class="button10g" 
								onClick="javascript:ColdFusion.Window.hide('adddetail');">
						</td>
						
						<td style="padding-left:1px">
		
							<cfif HS.ItemClass eq "Service">
						   		<cf_tl id="Delete" var="1">
						   		<input type="button" 
								    name="delete"  
									id="delete"
									value="#lt_text#" 
									style="width:100px;height:25" 
									class="button10g" 
									onClick="javascript:doDeleteResource('#URL.drillId#');">
							</cfif>	
							
						</td>
						
						<td style="padding-left:1px">	
						
					   		<cf_tl id="Update" var="1">
					   		<input type="button" 
							    name="update"  
								id="update"
								value="#lt_text#" 
								style="width:100px;height:25" 
								class="button10g" 
								onClick="javascript:updateTextArea();doUpdateResource('#URL.drillId#');">
								
						</td>	
							
					</tr>		
					</table>
			</td>
		</tr>
		
	</table>
	</td>
	<td width="5%"></td>
	</tr>
	</table>
	
</cfform>
</cfoutput>

<cfset AjaxOnLoad("initTextArea")>
<cfset AjaxOnLoad("initializeAmounts")>
	
<div id="resulths">