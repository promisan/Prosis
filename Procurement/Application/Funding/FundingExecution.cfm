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
<cfoutput>
	
<cf_tl id="Budget Execution Overview" var="1">

<cf_screenTop height="100%" 
              title="#lt_text#" 
			  html="No" 	
			  validateSession="Yes"		  
			  border="0"
			  JQuery="yes">

<!--- disabled 
			  
<script>

function facttable1(controlid,format,filter,qry) {
					
	w = #CLIENT.widthfull# - 80;
    h = #CLIENT.height# - 110;			
	window.open("#SESSION.root#/component/analysis/CrossTabLaunch.cfm?fileno=1&controlid="+controlid+"&"+qry+"&filter="+filter+"&data=1&format="+format, "_blank"); 
	}
	
</script>

--->

<cf_layoutScript>	

			  
<cfajaximport tags="cfdiv,cfchart">
 			 
<cfset attrib = {type="Border",name="mybox",fitToWindow="Yes"}>

<cf_layout attributeCollection="#attrib#">
	
	<cf_layoutarea 
          position  = "header"
          name      = "reqtop"
		  splitter  = "true"		  
		  overflow  = "hidden"
		  collapsible="false">	
		
			<cfinclude template="FundingExecutionMenu.cfm">
			  
	</cf_layoutarea>
				  
	<cf_layoutarea 
	    position = "left" 
		name     = "treebox" 
		maxsize  = "260" 				
		size     = "210" 
		minsize  = "210"
		collapsible="true"		
		state	= "open" 
		splitter ="true">
				
			<cf_divscroll>
				<cfinclude template="FundingExecutionTree.cfm">
			</cf_divscroll>
	
	</cf_layoutarea>	
			
	<cf_layoutarea position="center" name="box" overflow="hidden">
			
			<iframe 
				src="#SESSION.root#/Tools/Treeview/TreeViewInit.cfm"
		        name="content" 
				id="content"
		        width="100%" 
				height="100%" 				
		        scrolling="no" 
				frameborder="0">				
			</iframe>
					
	</cf_layoutarea>		
	
	<cf_layoutarea 
	    position	="right" 
		name		="propertybox" 
		maxsize		="390" 		
		size		="390" 
		minsize		="390" 
		initcollapsed="true"
		collapsible	="true" 
		splitter	="true"
		state		= "closed">
	</cf_layoutarea>
			
</cf_layout>

</cfoutput>
