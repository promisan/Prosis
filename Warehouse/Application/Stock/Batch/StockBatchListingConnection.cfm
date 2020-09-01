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
		   delay            = "12">	  
		   