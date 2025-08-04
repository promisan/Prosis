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
<cfparam name="url.idmenu" default="">

<cfoutput>

<cf_tl id="Maintain Accounting Schema" var="1">

<cf_screenTop height="100%"              
			  html="Yes" jQuery="Yes" layout="webapp" label="#lt_text#"	bannerforce="gray"		  
			  border="0" menuAccess="Yes" systemfunctionid="#url.idmenu#">			
			  
<cf_layoutscript>			  
		 
<cfset attrib = {type="Border",name="mybox",fitToWindow="Yes"}>

<cf_layout attributeCollection="#attrib#">
					  		  
	<cf_layoutarea 
	    position    = "left" 
		name        = "treebox" 
		maxsize     = "250" 		
		size        = "250" 
		collapsible = "true" 
		style       = "height:100%"
		splitter    = "true">
				
			<cfinclude template="SchemaViewTree.cfm">
			
	
	</cf_layoutarea>
	
	<cf_layoutarea  position="center" name="box" style="height:100%" overflow="hidden">
				
			<iframe src="#SESSION.root#/Tools/Treeview/TreeViewInit.cfm"
		        name="right"
		        id="right"
		        width="100%"
		        height="100%"
				scrolling="no"
		        frameborder="0"></iframe>
				
					
	</cf_layoutarea>			
		
</cf_layout>

</cfoutput>
