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
<cfquery name="validate" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
   SELECT  C.*,
				(SELECT COUNT(*) FROM ItemTransactionCollection WHERE CollectionId = C.CollectionId) as CountItems
   FROM   WarehouseBatchCollection C
   WHERE  C.BatchNo = '#url.batchno#'
   AND    Collectionid = '#url.collectionid#'
</cfquery> 

<cfif validate.recordCount gt 0 and validate.CountItems eq 0>
    <cfquery name="remove" 
    datasource="AppsMaterials" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
    DELETE
    FROM   WarehouseBatchCollection
    WHERE  BatchNo = '#url.batchno#'
    AND    Collectionid = '#url.collectionid#'
    </cfquery> 
</cfif>

<cfquery name="getBoxes" 
    datasource="AppsMaterials" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
    SELECT  *
    FROM   WarehouseBatchCollection
    WHERE  BatchNo = '#url.batchno#'
</cfquery>

<cf_tl id="Could not delete, the box has items." var="lblBoxHasItems">
<cfoutput>
    <script>
        <cfif validate.CountItems gt 0>alert('#lblBoxHasItems#');</cfif>
        ColdFusion.navigate('#session.root#/warehouse/application/salesorder/picking/box/BoxEdit.cfm?batchno=#url.batchno#', 'modalBody');
        refreshBoxes('#url.batchno#');
        <cfif getBoxes.recordCount eq 0>refreshBatch('#url.batchno#');</cfif>
    </script>
</cfoutput>