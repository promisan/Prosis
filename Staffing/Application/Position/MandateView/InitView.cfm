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

<cf_tl id="Workforce Administration" var="1">

<cfoutput>

<cf_submenuleftscript>
<cfajaximport tags="cfform">
<cf_screenTop height="100%" jquery="Yes"order="0" html="No" title="#lt_text# #URL.Mission#" scroll="no" TreeTemplate="Yes">
<cf_layoutscript>
<cf_calendarscript>

<cfset session.mandateorg         = "">
<cfset session.mandatefilter      = "">
<cfset session.mandatefiltervalue = "">

	 
<cfset attrib = {type="Border",name="mybox",fitToWindow="Yes"}>

	<cf_layout attributeCollection="#attrib#">
		
		<cf_layoutarea position="top" name="header" overflow="hidden" splitter="true">			
			  <cf_ViewTopMenu label="#lt_text# #URL.Mission#" layout="webapp" background="blue">
		</cf_layoutarea>
			
		<cf_layoutarea position="left" name="tree" maxsize="360" size="320" collapsible="true" splitter="true">
		       
		        <cfset url.id = 0>			
	
			<cfinclude template="MandateViewTree.cfm">		
					
		</cf_layoutarea>
		
		<cf_layoutarea  position="center" name="box">
	
					<iframe name="right"
			        id="right"
			        width="100%"
					src="#SESSION.root#/Tools/Treeview/TreeViewInit.cfm"
			        height="100%"
					scrolling="no"
			        frameborder="0"></iframe>		
							
		</cf_layoutarea>			
			
	</cf_layout>
		
</cfoutput>

