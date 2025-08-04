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
	