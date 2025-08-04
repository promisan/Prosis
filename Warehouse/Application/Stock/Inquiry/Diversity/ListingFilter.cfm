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


<cfparam name="URL.ID2" default="SAT">

<!--- Search form --->
<table width="100%" cellspacing="0" cellpadding="0" style="padding-bottom:1px;padding:0px">

<tr><td>

<cfform method="POST" name="filterform" onsubmit="return false">

<table width="100%" border="0" cellspacing="0" cellpadding="0">

	<tr>
	
	<!--- select categories that have a record for this warehouse in any transaction --->
	
	<cfquery name="CategoryList" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT * 
		FROM  Ref_Category R
		WHERE R.Category  IN (SELECT ItemCategory 
		                    FROM   ItemTransaction
							WHERE  Warehouse = '#url.warehouse#'
							AND    ItemCategory = R.Category)	
	</cfquery>
	
	<cfquery name="LocationList" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT * 
		FROM  WarehouseLocation L
		WHERE Warehouse = '#URL.Warehouse#'
		AND   L.Location IN (SELECT Location
		                     FROM ItemTransaction
						     WHERE Warehouse = L.Warehouse
							 AND   Location = L.Location)	
	</cfquery>
	
	<cfquery name="LotList" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT TransactionLot, 
		       SUM(TransactionQuantity)
		FROM   ItemTransaction T
		WHERE  Warehouse = '#URL.Warehouse#'
		GROUP BY TransactionLot
		HAVING 	ABS(SUM(TransactionQuantity)) >= 1	
	</cfquery>
	
	<td>		
	
	<table width="99%" cellspacing="0" cellpadding="0" align="center">
	
	
		<TR>
		<TD style="height:30;padding-left:20px" width="100" class="labelit"><cf_tl id="Storage Location">:</TD>
				
			<td align="left" style="padding-left:6px">
			
				<table cellspacing="0" cellpadding="0">
					<tr><td>			
					<select name="Location" id="Location" size="1" style="font:14px;">
					    <option value="" selected>Any</option>
					    <cfoutput query="LocationList">
						<option value="#Location#">#Location# #Description# #StorageCode#</option>
						</cfoutput>
				    </select>
					</td></tr>
				</table>
				
			</td>	
			
			<TD style="padding-left:16px" height="22" class="labelit"><cf_tl id="Lot">:</TD>
				
			<td align="left" style="padding-left:6px">
			
				<table cellspacing="0" cellpadding="0">
					<tr><td>	
					<select name="TransactionLot" id="TransactionLot" size="1" style="font:14px;">
				    <option value="" selected><cf_tl id="Any"></option>
				    <cfoutput query="LotList">
					<option value="#TransactionLot#">#TransactionLot#</option>
					</cfoutput>
				    </select>
					</td></tr>
				</table>
				
			</td>	
					
			<TD style="padding-left:16px" height="20" class="labelit"><cf_tl id="Category">:</TD>
				
			<td align="left" style="padding-left:6px">
			
				<table cellspacing="0" cellpadding="0">
					<tr><td>	
			    <select name="category" id="category" size="1" style="font:14px;">
				<option value="" selected><cf_tl id="All"></option>
			    <cfoutput query="CategoryList">
					<option value="#Category#">#Description#</option>
				</cfoutput>
			    </select>			
					</td></tr>
				</table>
				
			</td>	
				
		</tr>
						
		<tr><td height="1" colspan="6" class="linedotted"></td></tr>
			
	</TABLE>
	
	</td></tr>
	
	<cfoutput>
	
		<tr>
		<td align="center" style="padding-left:0px;padding-top:2px">
					
		<input type   = "button" 
		       name   = "Submit" 
			   id     = "Submit"
			   value  = "Prepare data" 
			   class  = "button10s" 
			   style  = "width:180px" 
			   onclick= "onhandfiltermain('#URL.Mission#','#URL.Warehouse#','#url.systemfunctionid#')">
	
		</td>
		</tr>
		
	</cfoutput>
	
	<tr><td height="2"></td></tr>

</table>

</cfform>

</td></tr>

</table>
