
<cfquery name="Function" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT  *
	FROM    Ref_ModuleControl
	WHERE   SystemFunctionId = '#URL.idmenu#' 
	</cfquery>
	
<cf_screentop height="100%" scroll="No" html="Yes" layout="webapp" banner="gray" label="#Function.FunctionName#">

<table width="100%" height="100%" cellspacing="0" cellpadding="0" class="formpadding">

<tr><td height="100%" valign="top" style="padding:10px">
						
		<iframe name="invokedetail"
		        id="invokedetail"
		        width="100%"
		        height="100%"
		        scrolling="no"
		        frameborder="0"></iframe>
			
		<cfinvoke component="Service.Analysis.CrossTab"  
		  method      = "ShowInquiry"	  
		  reportPath  = "GLedger/Inquiry/Transaction"
		  SQLtemplate = "Transaction.cfm"
		  Data        = "1"
		  queryString = ""
		  dataSource  = "appsQuery" 
		  module      = "Accounting"
		  reportName  = "Facttable: Ledger transaction"
		  olap        = "1"
		  table1Name  = "Transactions"
		  table1Class = "Table"
		  table1      = "vwLedger"
		  table1drill = "GLedger/Application/Transaction/View/TransactionViewDetail.cfm"		  
		  invoke      = "YES" <!--- directly runs the request --->
		  filter      = "0"> 	
		 

</td></tr></table>
	