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

<cf_screenTop height="100%"
    title="#URL.Mission# Non Expendable Administration" 
    border="0" 
	MenuAccess="Yes"
	html="No" 	
	jQuery="yes"
	ValidateSession="Yes"
	TreeTemplate= "Yes"
	scroll="no">
	
<cfinclude template="ControlScript.cfm">

<cf_layoutScript>

<cfset attrib = {type="Border",name="container",fitToWindow="Yes"}>
<cf_layout attributeCollection="#attrib#">
				
	<cf_layoutarea  
	      position="header" 
		  overflow="hidden"		
		  name="controlmenu"	
		  size="50"		    	  
		  source="ControlMenu.cfm?mission=#url.mission#&systemfunctionid=#url.systemfunctionid#"/>	 
		
	<cf_layoutarea 
          position="left"
          name="controltree"
          source="ControlTree.cfm?mission=#url.mission#"  
		  minsize="10"
          maxsize="390" 
		  size="270"       		 
          overflow="auto"
          collapsible="true"
          splitter="true"/>
	
	<cf_layoutarea  
	      position="center" 
		  overflow="hidden"	 
		  name="controllistC">
		    <cf_divScroll id="controllist">
		    <table height="100%" width="100%">
				<tr>
					<td valign="middle">
						<cfinclude template="../../../../Tools/Treeview/TreeViewInit.cfm">
					</td>
				</tr>
			</table> 
		    </cf_divScroll>	
	</cf_layoutarea>	 
		  
	<cf_layoutarea 	       
          position="bottom"
          name="controldetail"          
          size="250"
		  maxsize="390" 
		  source="ControlDetail.cfm?mission=#url.mission#"		 
          collapsible="true"
          initcollapsed="true"
          splitter="true"/>	

</cf_layout>

