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

<cf_screentop height="100%" jQuery="Yes" scroll="Yes" html="No" border="0" title="Mandate Transition #URL.ID# #URL.ID1#">
<cf_layoutscript>

<cfset deleted = deleteClientVariable("Sort")>

<cfparam name="URL.ID" default="">	
<cfparam name="URL.ID1" default="">	
<cfparam name="URL.ID4" default="">	

<cfoutput>
<cfset attrib = {type="Border",name="mybox",fitToWindow="Yes"}>	

<cf_layout attributeCollection="#attrib#">	
		  
	<cf_layoutarea 
	    position="left" name="tree" maxsize="400" size="220" collapsible="true" splitter="true">
		
		<cfinclude template="TransformViewTree.cfm">
		
	</cf_layoutarea>		

	<cf_layoutarea  position="center" name="box">
				
			<iframe src="TransformViewInit.cfm"
		        name="right"
		        id="right"
		        width="100%"
		        height="98%"
				scrolling="no"
		        frameborder="0"></iframe>
			
	</cf_layoutarea>			
		
</cf_layout>

</cfoutput>

<cf_screenbottom layout="innerbox">