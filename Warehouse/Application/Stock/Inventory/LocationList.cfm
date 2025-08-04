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

<cfif url.filteroperator eq "">
	<cfset search = "like '%#trim(url.item)#%'">	
<cfelseif url.filteroperator eq "contains">
	<cfset search = "like '%#trim(url.item)#%'">
<cfelseif url.filteroperator eq "BEGINS_WITH">	
	<cfset search = "like '#trim(url.item)#%'">
<cfelseif url.filteroperator eq "ENDS_WITH">	
	<cfset search = "like '%#trim(url.item)#'">	
<cfelseif url.filteroperator eq "EQUAL">	
	<cfset search = "= '#trim(url.item)#'">		
</cfif>

<cfquery name="LocationList"
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT    Location, 
              WL.StorageCode+' '+WL.Description as Description, 
              R.Description as Class
    FROM      WarehouseLocation WL LEFT OUTER JOIN Ref_WarehouseLocationClass R
    ON        WL.LocationClass = R.Code
    WHERE     WL.Warehouse     = '#URL.Warehouse#'
    AND       Operational      = 1
    <cfif trim(url.item) neq "">
        AND EXISTS
            (
                SELECT  'X'
                FROM    ItemWarehouseLocation Lx INNER JOIN Item Ix ON Lx.ItemNo = Ix.ItemNo    
                WHERE   Lx.Warehouse = WL.Warehouse
                AND     Lx.Location  = WL.Location
                AND     (
				        Ix.ItemDescription #preserveSingleQuotes(search)# 
				        OR Ix.ItemNo #preserveSingleQuotes(search)# 
						OR Ix.ItemNoExternal #preserveSingleQuotes(search)#
						)
            )
    </cfif>
    ORDER BY  R.Description
</cfquery>	

<cfform name="inventoryform" id="inventoryform" style="height:99.5%">
        
    <!--- search option --->
        
    <cfselect id="location" name="location"
            onchange="_cf_loadingtexthtml=''; stockinventoryload('n','#url.systemfunctionid#'); $('##filtersearchsearch').val(''); $('.clsLocToggler').addClass('fa-folder').removeClass('fa-folder-open');" 
            query="LocationList" 
            value="Location" 
            queryposition="below"
            display="Description" 
            multiple="Yes"
            style="background-color:ffffff;width:100%;height:100%;border:0px"
            group="Class" 
            class="regularxl">
                                            
        <option value=""><cf_tl id="View all locations"></option>            
            
    </cfselect>	
    
</cfform>	