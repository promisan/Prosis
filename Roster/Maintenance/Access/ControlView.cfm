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
This function has moved to within the bucket itself.

<!---

<cf_tl id="Roster Bucket Accessg" var="1">

<cf_screenTop height="100%" 
    title="#lt_text#" 
	bannerheight="4" 
	border="0" 
	html="No" 
	jQuery="Yes"
	scroll="no" 
	layout="webapp">
	
<cf_layoutscript>		

<cfset attrib = {type="Border",name="mybox",fitToWindow="Yes"}>	

<cf_layout attributeCollection="#attrib#">			

<cf_layoutarea 
          position="top"
          name="controltop"
          minsize="55"
          maxsize="55"  
		  size="55"       
          splitter="true"
		  overflow = "hidden">	
				
		 <cfinclude template="ControlMenu.cfm">	
		 
</cf_layoutarea>		 
	
<cf_layoutarea position="left" name="treebox" maxsize="400" size="280" collapsible = "true" 
		splitter    = "true"
		overflow    = "scroll">

    <cfinclude template="ControlTree.cfm">
	
</cf_layoutarea>

<cf_layoutarea  position="center" name="box">
	
	<iframe name="right" id="right" src="#SESSION.root#/Tools/Treeview/TreeViewInit.cfm" width="100%" height="100%" scrolling="no"
	    frameborder="0"></iframe>				
			
</cf_layoutarea>			
		
</cf_layout>


</html>

--->

