	
<cf_screentop height="100%" 
    band="no" 
	scroll="No" 	
	banner="gray" 
	layout="webapp" 
	label="#url.mission# #url.period# Commitment analysis">
		
		<iframe name="invokedetail"
		        id="invokedetail"
		        width="100%"
		        height="100%"
		        scrolling="no"
		        frameborder="0"></iframe>
	
	<cfinvoke component="Service.Analysis.CrossTab"  
		  method      = "ShowInquiry"
		  buttonName  = "Analysis"						  
		  reportPath  = "Procurement\Application\Requisition\Portal\"
		  SQLtemplate = "RequisitionFactTable.cfm"
		  queryString = "mission=#URL.Mission#&period=#url.period#"
		  dataSource  = "appsQuery" 
		  module      = "Procurement"
		  reportName  = "Facttable: Requisition"
		  olap        = "1"						 
		  table1Name  = "Requisitions"	
		  invoke      = "YES"						
		  filter      = "0"> 		
			
<cf_screenbottom layout="webdialog">
	