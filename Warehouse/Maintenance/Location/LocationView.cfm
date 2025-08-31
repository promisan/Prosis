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

<cfajaximport tags="cfform">

<script language="JavaScript1.2">

w = 0
h = 0
if (screen) {
w = #CLIENT.width# - 80
h = #CLIENT.height# - 160
}

function refreshTree() {
	ptoken.navigate('LocationTree.cfm?id2=#url.mission#','tree')
}

function orgaccess() {
    ptoken.open("../Access/OrganizationView.cfm","_top")   
}

</script>

<cf_tl id="Tree Builder" var="1">

<cf_screenTop height="100%" banner="gray" label="#lt_text# #URL.Mission#" html="no" scroll="no" jQuery="Yes" MenuAccess="Yes" validateSession="Yes" treetemplate="Yes">

<cf_layoutScript>

<cfset attrib = {type="Border",name="mybox",fitToWindow="Yes"}>	

<cf_layout attributeCollection="#attrib#">		

	<cf_tl id="Physical Locations" var="1">
	
	<cf_layoutarea 
          position="top"
          name="controltop"
          minsize="40"
          maxsize="40"  
		  size="40"  
		  overflow="hidden"      
          splitter="true">	
				
			<cf_ViewTopMenu background="gray" label="&nbsp;#lt_text#  #URL.Mission#&nbsp;"> 
		 
	</cf_layoutarea>		 	

	<cf_layoutarea 
          position="left"
          name="tree"
          source="LocationTree.cfm?id2=#url.mission#"          
          size="230"
		  minsize="230"
          collapsible="true"
          splitter="true"
          maxsize="340"/>
	
	<cf_layoutarea overflow="hidden" position="center" name="box">		
	
			<!---src="LocationListing.cfm?ID2=#URL.Mission#"--->
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