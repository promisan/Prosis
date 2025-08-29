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
<cfquery name="Item"
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">	
	SELECT   DISTINCT IW.ItemNo, 
	         IW.UoM, 
			 I.ItemDescription, 
			 U.UoMDescription, 
			 C.Description as CategoryDescription
	FROM     Item I INNER JOIN
	         ItemWarehouseLocation IW ON I.ItemNo = IW.ItemNo INNER JOIN
	         ItemUoM U ON I.ItemNo = U.ItemNo AND U.UoM = IW.UoM INNER JOIN
	         Warehouse W ON IW.Warehouse = W.Warehouse INNER JOIN
			 Ref_Category C ON I.Category = C.Category
	WHERE    W.Mission = '#url.mission#' 
	AND      IW.Operational = 1
	AND      I.ItemNo IN
	                 (
					  SELECT  ItemNo
	                  FROM    ItemTransaction
	                  WHERE   Warehouse      = W.Warehouse 
					  AND     Location       = IW.Location 
					  AND     ItemNo         = IW.ItemNo 
					  AND     TransactionUoM = IW.UoM
					  GROUP BY ItemNo
					  HAVING  SUM(TransactionQuantity) > 100
					     
					 )
	AND      I.ItemClass = 'Supply'
	ORDER BY C.Description, I.ItemDescription
</cfquery>	

<table width="100%" height="100%" cellspacing="0" cellpadding="0">

	<tr><td colspan="2" height="5px"></td></tr>
	
	<cfoutput>	
	
	<tr onclick="menuselect(this); showstock('#url.mission#')" id="opt" name="opt" class="menuselected">
		<td width="10px" align="center" valign="middle"></td>
		<td style="height:35" class="labellarge">Stock Summary</td>
	</tr>
	
	<tr><td colspan="2" height="3px"></td></tr>
	<tr><td colspan="2" style="border-top: dotted silver 1px"></td></tr>
	<tr><td colspan="2" height="3px"></td></tr>
	
	<tr onclick="menuselect(this); showstatus('#url.mission#')" id="opt" name="opt">
		<td width="10px" align="center" valign="middle"></td>
		<td style="height:35" class="labellarge">Metrics</td>
	</tr>		
	
	<tr><td colspan="2" height="3px"></td></tr>
	<tr><td colspan="2" style="border-top: dotted silver 1px"></td></tr>
	<tr><td colspan="2" height="3px"></td></tr>
	
	</cfoutput>		
	
		<tr>
			<td width="10px" align="center" valign="middle"></td>
			<td height="30" style="padding-top:3px">
						
			<cfif client.googleMAP eq "1">
			
			<input type="hidden" id="viewmode" value="map">
			
			<cfelse>
			
			<input type="hidden" id="viewmode" value="list">
			
			</cfif>
			
			<table cellspacing="0" cellpadding="0">
				<tr>
				    <cfif client.googleMAP eq "1">
					<td><input type="radio" onclick="document.getElementById('viewmode').value='map';showdetails('<cfoutput>#url.mission#</cfoutput>')" checked name="mode" value="map"></td>
					<td style="padding-left:3px" class="labelit">MAP</font></td>
					</cfif>
					<td style="padding-left:5px">
					<input onclick="document.getElementById('viewmode').value='list';showdetails('<cfoutput>#url.mission#</cfoutput>')"  <cfif client.googleMAP eq "0">checked</cfif> 
					type="radio" name="mode" value="list">
					</td>
					<td style="padding-left:3px" class="labelit">Listing</font></td>
					<td style="padding-left:5px"><input onclick="document.getElementById('viewmode').value='rolap';showdetails('<cfoutput>#url.mission#</cfoutput>')" type="radio" name="mode" value="rolap"></td>
					<td style="padding-left:3px" class="labelit">ROLAP</font></td>
				</tr>
			</table>
			
			</td>
		</tr>
		<tr><td colspan="2" height="6px"></td></tr>
		
		<tr><td colspan="2" height="100%" width="100%">
		
		<cf_divscroll>
		
		<table width="100%" cellspacing="0" cellpadding="0" class="formpadding">
		
		<input type="hidden" id="itemnoselect" value="">
		<input type="hidden" id="uomselect"    value="">
		
		<cfoutput query="Item" group="CategoryDescription">
		
		<tr><td height="4"></td></tr>
		<tr>
			<td width="10px" align="center" valign="middle"></td>
			<td style="padding-left:3px;height:30" class="labelmedium">
				#CategoryDescription#
			</td>
		</tr>
		
		<cfoutput>
			   	
		<tr onclick="menuselect(this); document.getElementById('itemnoselect').value='#ItemNo#';document.getElementById('uomselect').value='#UoM#';showdetails('#url.mission#')" id="opt" name="opt" class="menuregular">
			<td width="10px" align="center" valign="middle"></td>
			<td style="padding-left:9px">
				<font face="Verdana" color="808080">#left(ItemDescription,25)#</font> <font face="Verdana" size="1">#UoMdescription#</font>
			</td>
		</tr>
		
		</cfoutput>
			
		</cfoutput>		
		
		</table>
				
		</cf_divscroll>
		
		</td></tr>
	
	
	<tr><td colspan="2" height="10"></td></tr>
	
</table>
