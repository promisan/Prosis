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
<cfquery name="searchresult"
		datasource="AppsQuery" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">

		SELECT    *
		FROM      StockBatch_#SESSION.acc# B
		WHERE     1=1
	
	</cfquery>
	
	<cfquery name="warehouse"
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT * FROM Warehouse WHERE Warehouse = '#url.warehouse#' 
	</cfquery>		

	<cfinvoke component = "Service.Connection.Connection"  
		   method           = "setconnection"    
		   object           = "WarehouseBatchCenter" 
		   ScopeMode        = "listing"
		   ScopeId          = "#warehouse.MissionOrgUnitId#"		   
		   ScopeFilter      = "B.Warehouse=''#url.warehouse#'' AND B.BatchClass=''WhsSale'' AND B.ActionStatus=''0''"
		   ControllerNo     = "992"
		   ObjectContent    = "#SearchResult#"
		   ObjectIdfield    = "batchno"
		   delay            = "10">	  
		   