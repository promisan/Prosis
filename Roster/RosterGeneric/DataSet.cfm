<!--
    Copyright © 2025 Promisan B.V.

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
<cfparam name="url.idmenu" default="">

<cfquery name="Function" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT  *
	FROM    Ref_ModuleControl
	<cfif url.idmenu neq "">
	WHERE   SystemFunctionId = '#URL.idmenu#' 
	<cfelse>
	WHERE 1 = 0
	</cfif>
	</cfquery>
		
<cf_screentop height="100%" scroll="No" html="No" layout="innerbox" title="#Function.FunctionName#" blockevent="rightclick">

<table width="100%" height="100%" cellspacing="0" cellpadding="0">
	
	<tr><td>
					
			<iframe name="invokedetail"
			        id="invokedetail"
			        width="100%"
			        height="100%"
			        scrolling="no"
			        frameborder="0"></iframe>
								
			<cfquery name="System" 
			datasource="AppsSystem">
				SELECT * FROM Parameter
			</cfquery>	
												
												
			<cfinvoke component="Service.Analysis.CrossTab"  
			  method      = "ShowInquiry"	  
			  reportPath  = "Roster/RosterGeneric/"
			  SQLtemplate = "RosterStatus.cfm"
			  queryString = "owner=#url.owner#&header=0"
			  dataSource  = "appsQuery" 
			  module      = "Roster"
			  reportName  = "Facttable: Roster Status"
			  olap        = "1"			 
			  table1Name  = "Roster"
			  table1Class = "variable"		  	
			  table1drill = ""		  
			  invoke      = "Yes"
			  filter      = "0"> 	
			
	</td>
	</tr>

</table>	