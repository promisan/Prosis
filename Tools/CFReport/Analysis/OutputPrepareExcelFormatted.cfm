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
<cf_screentop html="no">

<cfset FileNo = round(Rand()*20)>

<cfquery name="Pivot" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT * 
		FROM   UserPivot
		WHERE  ControlId = '#URL.ID#'
</cfquery>
	 	 
<cfinvoke component="Service.Analysis.CrossTab" method="Filter"
	  controlid           = "#URL.id#"
	  returnVariable       = "condition">			

<cfinvoke component="Service.Analysis.CrossTab" method="Basic"
	  CrossTabName        = "Pivottable"
	  sourceid            = ""
	  controlid           = "#URL.id#"
	  fileNo              = "#FileNo#"
	  node                = "#Pivot.Node#"
	  alias               = "#Pivot.DataSource#"
	  table               = "#URL.Table#"
	  format              = "Excel"
	  condition           = "#condition#"
	  SummaryColor        = "ffffdf"
	  colHeaderHeight     = "19"
	  hideYaxNULL         = "1">
	  

