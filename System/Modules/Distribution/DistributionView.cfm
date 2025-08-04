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

<cfoutput>

<script language="JavaScript">

function refreshTree() {
      ptoken.navigate('DistributionViewTree.cfm','tree');
}

function batch(mode) {	    
      Prosis.busy('yes') 
      ptoken.open('#SESSION.root#/tools/cfreport/EngineReport.cfm?mode='+mode,'right')
}

</script>

<cf_tl id="Reporter distribution log" var="1">

<cf_screenTop height="100%" label="Reporter distribution log" html="No" band="No" jQuery="Yes" scroll="no" MenuAccess="Yes" validateSession="Yes">

<cf_layoutscript>	 
	 
<cfset attrib = {type="Border",name="mybox",fitToWindow="Yes"}>

<cf_layout attributeCollection="#attrib#">

	<cf_layoutarea 
	          position  = "top"
	          name      = "controltop"
	          minsize   = "51"
	          maxsize   = "51"  
			  size      = "51" splitter="true" overflow="hidden">	
			  
			 <cfinclude template="DistributionMenu.cfm">
			  
	</cf_layoutarea>		
	
	<cfparam name="url.mid" default="">
			  
	<cf_layoutarea 
          position="left"
          name="tree"
          source="DistributionViewTree.cfm?mid=#url.mid#"          
          size="240"
          collapsible="true"
          splitter="true"
          maxsize="400"/>
			
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
