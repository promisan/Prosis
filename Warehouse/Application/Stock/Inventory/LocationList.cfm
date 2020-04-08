<cfquery name="LocationList"
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT    Location, 
                WL.StorageCode+' '+WL.Description as Description, 
                R.Description as Class
    FROM      WarehouseLocation WL LEFT OUTER JOIN Ref_WarehouseLocationClass R
    ON        WL.LocationClass = R.Code
    WHERE     WL.Warehouse = '#URL.Warehouse#'
    AND       Operational = 1
    <cfif trim(url.item) neq "">
        AND EXISTS
            (
                SELECT  'X'
                FROM    ItemWarehouseLocation Lx
                        INNER JOIN Item Ix  
                            ON Lx.ItemNo = Ix.ItemNo    
                WHERE   Lx.Warehouse = WL.Warehouse
                AND     Lx.Location = WL.Location
                AND     (Ix.ItemDescription like '%#trim(url.item)#%' OR Ix.ItemNo like '%#trim(url.item)#%' OR Ix.ItemNoExternal like '%#trim(url.item)#%')
            )
    </cfif>
    ORDER BY  R.Description
</cfquery>	

<cfform name="inventoryform" id="inventoryform" style="height:99.5%">
        
    <!--- search option --->
        
    <cfselect id="location" name="location"
            onchange="_cf_loadingtexthtml='';stockinventoryload('n','#url.systemfunctionid#')" 
            query="LocationList" 
            value="Location" 
            queryposition="below"
            display="Description" 
            multiple="Yes"
            style="background-color:ffffff;width:240px;height:100%;border:0px"
            group="Class" 
            class="regularxl">
                                            
        <option value=""><cf_tl id="View all locations"></option>
            
            
    </cfselect>	
    
</cfform>	