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

<cf_tl id="Employee Personnel Action and Entitlement Inquiry" var="1">

<cf_screenTop height="100%" title="#URL.Mission# #lt_text#" 
    jQuery="Yes" html="No" border="0" scroll="no" MenuAccess="Yes" validateSession="Yes">
	 
<cf_LayoutScript>
<cfajaximport tags="cfform">	
	 
<cfset attrib = {type="Border",name="mybox",fitToWindow="Yes"}>

<cf_layout attributeCollection="#attrib#">
	
	<cf_layoutarea 
	      type="Border"
          position="header"
          name="controltop">	
				
		 <cf_ViewTopMenu label="#URL.Mission# #lt_text#" background="gray">
				 
	</cf_layoutarea>		

	<cf_layoutarea 
	    type="Border" position="left" name="treebox" maxsize="400" size="270" overflow="hidden" style="height:100%" collapsible="true" splitter="true">
		
	       <cfinclude template="EntitlementViewTree.cfm">			
										
	</cf_layoutarea>

	<cf_layoutarea type="Border" position="center" name="box" style="height:100%" overflow="hidden">		

		   <iframe src="#SESSION.root#/Tools/Treeview/TreeViewInit.cfm" name="right" id="right" width="100%" height="100%" scrolling="0" frameborder="0"></iframe>
									
	</cf_layoutarea>			
		
</cf_layout>		

</cfoutput>


