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
<cf_tl id="Organization Lookup" var="1">

<cfparam name="url.mode" default="modal">

<cfoutput>
	<input type="hidden" id="mode" value="#url.mode#" class="hide">
</cfoutput>

<cf_screenTop height="100%" 
	  html="no" 
	  layout="webapp"
	  label="#lt_text#"
	  scroll="no"
	  close="parent.ColdFusion.Window.destroy('orgunitselectwindow',true)"
	  jQuery="yes"
	  User="Yes">
		  
<cf_LayoutScript>

<cfset attrib = {type="Border",name="myboxOrganizationView",fitToWindow="Yes"}>

<cfoutput>
	
	<cf_layout attributeCollection="#attrib#">
				  
		<cf_layoutarea 
		    position="left" name="treeOrganizationView" size="290" overflow="hidden" collapsible="true" splitter="true">
			
				<iframe name="leftOrganizationView"
				        id="leftOrganizationView"
				        width="100%"
				        height="100%"
						scrolling="no"
				        frameborder="0"
						src="OrganizationTree.cfm?effective=#url.effective#&mission=#url.mission#&mandate=#url.mandate#"></iframe>
				
		</cf_layoutarea>
		
		<cf_layoutarea  position="center" name="boxOrganizationView" overflow="hidden">
				
				<iframe name="rightOrganizationView"
				        id="rightOrganizationView"
				        width="100%"
				        height="100%"
						scrolling="no"
				        frameborder="0"></iframe>
				
		</cf_layoutarea>			
			
	</cf_layout>

</cfoutput>