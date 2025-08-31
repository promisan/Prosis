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
<cf_tl id="General Ledger Entity" var="1">

<cf_screenTop jQuery="Yes" height="100%" border="0" html="No" title="#lt_text#  #URL.Mission#" scroll="no" MenuAccess="Yes" validateSession="Yes"> 

<cfoutput>

<cf_layoutscript>

<cfset attrib = {type="Border",name="mybox",fitToWindow="Yes"}>

<cf_layout attributeCollection="#attrib#">

	<cf_layoutarea 
          position="header"		  
          name="controltop">			 		  
		
		<cf_ViewTopMenu background="gray" label="#lt_text# #URL.Mission#">
		  		 
	</cf_layoutarea>		 

	<cf_layoutarea 
	    position="left" name="left" minsize="400" maxsize="400" size="400" overflow="yes" collapsible="true" splitter="true">
	
		<cfinclude template="JournalViewTree.cfm">
		
	</cf_layoutarea>

	<cf_layoutarea  position="center" name="box">
	
		<table style="width:100%;height:100%"><tr><td>
	
			<iframe name="right"
		        id="right"
		        width="100%"
		        height="100%"
		        align="middle"
		        scrolling="no"
		        frameborder="0"
				src="#SESSION.root#/Tools/Treeview/TreeViewInit.cfm"></iframe>		
				
				</td></tr></table></tr>
		
	</cf_layoutarea>			
		
</cf_layout>
	
</cfoutput>


