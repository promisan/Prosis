
<cfquery name="Function" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT * FROM Ref_ReportControl
	WHERE Controlid = '#URL.ControlId#'
</cfquery>
	
<cf_screentop height="100%" 
   scroll="No" 
   layout="webapp"  banner="gray"
   title="BI Analysis: #Function.FunctionName#"
   label="BI Analysis: <b>#Function.FunctionName#</b>">
		
	<iframe name="invokedetail" id="invokedetail" width="100%" height="100%" marginwidth="10" marginheight="10" scrolling="no" frameborder="0"></iframe>
							
	<cfinvoke component="Service.Analysis.CrossTab"  
		  method      = "ShowInquiry"	  
		  reportPath  = "System/Modules/Reports/"
		  SQLtemplate = "DistributionDataSet.cfm"
		  queryString = "id=#url.controlid#"
		  dataSource  = "appsQuery" 
		  module      = "System"
		  reportName  = "Facttable: Report Distribution"
		  olap        = "1"
		  table1Name  = "Distribution"
		  table1Class = "Variable"
		  table1      = "table1"
		  invoke      = "YES"
		  filter      = "0"> 	
	
<cf_screenbottom layout="webapp">