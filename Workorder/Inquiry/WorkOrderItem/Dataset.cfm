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
		  reportPath  = "WorkOrder/Inquiry/WorkOrderItem"
		  SQLtemplate = "Transaction.cfm"
		  Data        = "1"
		  queryString = ""
		  dataSource  = "appsQuery" 
		  module      = "WorkOrder"
		  reportName  = "Facttable: Workorder Sale Items"
		  olap        = "1"
		  table1Name  = "WorkOrderSale"
		  table1Class = "Table"
		  table1      = "vwWorkOrderSaleItem"
		  table1drill = "WorkOrder/Application/WorkOrder/ServiceDetails/ServiceLineView.cfm"		  
		  invoke      = "YES" <!--- directly runs the request --->
		  filter      = "0"> 	
		 

</td></tr></table>
	