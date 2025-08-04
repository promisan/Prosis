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

<cfquery name="Item" 
datasource="appsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT 	*
	FROM 	Item
	WHERE 	ItemNo = '#URL.ID#'
</cfquery>

<table width="99%" align="center">

	 <cfoutput>

    <cfif url.mode eq "workflow">
	
		<cfquery name="Cls" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT  *
			FROM    Ref_ItemClass
			WHERE 	Code = '#Item.ItemClass#'
		</cfquery>
		
		<TR class="labelmedium2">
	    <td height="20" width="140"><cf_tl id="Class">:</b></td>
	    <TD style="font-size:17px" width="80%">#Cls.Description#
	    </td>
	    </tr>
		
	    <TR class="labelmedium2">
	    <TD height="20"><cf_tl id="Code">:</TD>
	    <TD style="font-size:17px">#item.ItemNoExternal#</TD>
		</TR>
		
		<TR class="labelmedium2">
	    <TD height="20"><cf_tl id="Description">:</TD>
	    <TD style="font-size:17px">#item.ItemDescription#</TD>
		</TR>	
			
		<tr><td class="line" colspan="2"></td></tr>
	
	</cfif>
		
	<tr><td colspan="2" style="height:30px" class="labelit">
	
		<cf_tl id="The UoM defined for supply item represent the the actual level of the item as it kept in stock" class="message">.
		<cf_tl id="The standard cost of an item is defined for each entity" class="message">.
	
	</td></tr>
		
	<tr><td height="1" colspan="2" class="line"></td></tr>	
	<tr><td colspan="2" align="center">	
	
		<cf_securediv bind="url:#session.root#/Warehouse/Maintenance/Item/UoM/ItemUoMList.cfm?id=#url.id#&uomselected=" id="uomlist">		
				
	</td></tr>
		
	<tr><td colspan="2" id="uomedit"></td></tr>
	
	</cfoutput>	

</TABLE>
