
<cfquery name="Function" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT  *
		FROM    Ref_ModuleControl
		WHERE   SystemFunctionId = '#URL.idmenu#' 
	</cfquery>
	
<cf_screentop height="100%" 
    band="no" 
	scroll="No" 	
	banner="blue" 
	layout="webapp" 
	label="Exceptions Analysis #Function.FunctionName#">
		
		<iframe name="invokedetail"
		        id="invokedetail"
		        width="100%"
		        height="100%"
		        scrolling="no"
		        frameborder="0"></iframe>
			
		<cfinvoke component="Service.Analysis.CrossTab"  
		  method      = "ShowInquiry"	  
		  reportPath  = "System/Monitor/"
		  SQLtemplate = "Error.cfm"
		  queryString = ""
		  dataSource  = "appsQuery" 
		  module      = "System"
		  reportName  = "Facttable: System Error"
		  olap        = "1"
		  table1Name  = "Exceptions"
		  table1Class = "Table"
		  table1      = "vwUserError"
		  table1drill = "System/Access/User/Audit/ListingErrorDetail.cfm"		  
		  invoke      = "YES"
		  filter      = "0"> 	
	
<cf_screenbottom layout="webdialog">
	