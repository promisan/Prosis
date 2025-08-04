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
	