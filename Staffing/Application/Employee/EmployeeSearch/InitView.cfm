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

<cfparam name="URL.Mission" default="All">
<cfparam name="URL.ID" default=""> 
<cfif URL.ID neq "">
  <cfset CLIENT.form = URL.ID>
</cfif>

<cfoutput>

<cfset oSecurity = CreateObject("component","Service.Process.System.UserController")/>
<cfset mid = oSecurity.gethash()/>   

<cf_tl id="Employee Search" var="1">

<cf_screenTop title="#lt_text#" border="0" html="No" JQuery="yes">
<cf_layoutScript>

<cfset attrib = {type="Border",name="mybox",fitToWindow="Yes"}>	

<cf_layout attributeCollection="#attrib#">
	
	<cf_layoutarea 
	   	position  = "header"
	   	name      = "reqtop">	
			  		
		<cf_tl id="Employee Management" var="1">
		<cf_ViewTopMenu label="#lt_text#" banner="yellow">
			 			  
	</cf_layoutarea>			

	<cf_layoutarea  position="left" name="tree" overflow="hidden" maxsize="280" size="280" collapsible="true" splitter="true">
	
		<iframe 
			src="SearchTree.cfm?ID=0&Mission=#URL.Mission#&mid=#MID#"
			name="left"
	        id="left"
	        width="100%"
	        height="100%"
	        scrolling="no"
			class="tree"
	        frameborder="0"></iframe>	
	
	</cf_layoutarea>
	
	<cf_layoutarea  position="center" name="box">
			
			<iframe src="#SESSION.root#/Tools/Treeview/TreeViewInit.cfm?mid=#MID#"
		        name="right" id="right" width="100%" height="100%" scrolling="no" frameborder="0"></iframe>
				
	</cf_layoutarea>			
		
</cf_layout>

</cfoutput>
