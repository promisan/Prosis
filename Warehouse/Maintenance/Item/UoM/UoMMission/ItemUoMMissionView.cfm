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
<table width="100%" align="center" class="formpadding2">	
		
	<cfoutput>
	
	<tr><td height="3"></td></tr>
	
	<tr class="labelmedium2">
	<td colspan="2" style="font-size:17px;padding-left:30px;padding-right:30px;padding-top:5px;padding-bottom:5px">
	<font color="808080">
	Enabling an item/uom for an entity, will generate a record for that item for any active Warehouse/Facility
	enabling the definition of both the sale price schedule as well as definition of max/min stock 
	for this item (dbo.ItemWarehouse). <br><br>
	Attention: <br>
	
	<font color="FF0000">
	1.	It will not generate a record in each storage location for that item, unless the location
	is actually used in transactions.<br>
	
	2.	Standard Cost price will be updated automatically if a BOM is defined for the item
	</font>
	</font>
	</td></tr>
	
	<tr><td height="13"></td></tr>
	
	<tr><td colspan="2" align="center" width="90%" style="padding:4px">	
		<cf_securediv bind="url:UoMMission/ItemUoMMissionListing.cfm?id=#url.id#&UoM=#URL.UoM#" id="itemUoMMissionlist">				
	</td></tr>
	
	<tr><td colspan="2">
		<cfdiv id="itemUoMMissionedit">
	</td></tr>
	
	</cfoutput>	

</TABLE>
