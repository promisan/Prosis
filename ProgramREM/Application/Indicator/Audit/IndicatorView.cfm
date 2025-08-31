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
<cfquery name="Program" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT     *
	FROM  Program
	WHERE ProgramCode = '#URL.Program#'
</cfquery>

<cfparam name="URL.Program" default="">	
<cfparam name="URL.ProgramName" default="">	

<cfif Program.ProgramScope neq "Unit">
 	<cf_message message = "This option is not enabled for categorization programs"
	  return = "">
	<cfabort>
</cfif>

<cfif Program.ProgramClass eq "Project">

	 <cf_message message = "This option is not enabled for projects" return = "">
	 <cfabort>
  
</cfif>

<cfoutput>
	<cf_tl id="Indicator measurement #Program.ProgramName#" var="1">

<cf_screenTop height="100%" layout="webapp" label="#lt_text#" band="No" scroll="yes" jQuery="Yes" >
<cf_layoutScript>

<cf_layout type="border" id="mainLayout">

	<cf_layoutArea 
			name="left" 
			position="left" 
			state="open" 
			collapsible="true"
			size="300px">
			<iframe src="IndicatorViewTree.cfm?ProgramCode=#URL.Program#&Period=#URL.Period#"
       			name="left" id="left" width="100%" height="99%" scrolling="no"
       			frameborder="0"></iframe>
	</cf_layoutArea>	
	
		
	<cf_layoutArea 
			name="center" 
			position="center">
			<iframe src="../../../../Tools/Treeview/TreeViewInit.cfm"
	       		name="right"
       			id="right"
       			width="100%"
       			height="99%"
				scrolling="no"
      			frameborder="0"></iframe>
	</cf_layoutArea>
	
</cf_layout>
<cf_screenbottom layout="innerbox">

</cfoutput>

