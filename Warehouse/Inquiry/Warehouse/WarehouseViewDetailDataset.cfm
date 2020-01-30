	
		
	<cfinvoke component="Service.Analysis.CrossTab"  
	  method      = "ShowInquiry"	  
	  reportPath  = "Warehouse/Inquiry/Warehouse"
	  SQLtemplate = "FactTableStock.cfm"
	  queryString = "mission=#url.mission#&itemno=#url.itemno#&uom=#url.uom#"
	  dataSource  = "appsQuery" 
	  module      = "Warehouse"
	  reportName  = "Facttable: Warehouse Transactions"
	  olap        = "1"
	  table1Name  = "Transactions"	 
	  table2Name  = "Billable"	 
	  invoke      = "YES"
	  filter      = "0"> 	
	