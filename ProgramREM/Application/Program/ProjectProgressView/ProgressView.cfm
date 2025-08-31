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
<cfparam name="URL.ProgramCode" default="">	
<cfparam name="URL.ProgramName" default="">
<cfparam name="URL.Period" default="">	
<cfset CLIENT.Sort = "OrgUnit">

<cfoutput>

<cf_tl id="ProjectListing" var="1">

<cf_screenTop height="100%" title="#lt_text# #URL.Mission#"	border="0" html="No" scroll="yes" MenuAccess="Yes">	

<cfset attrib = {type="Border",name="mybox",fitToWindow="Yes"}>	

<cflayout attributeCollection="#attrib#">		
	
	<cflayoutarea  position="left" name="tree" title="Folders" maxsize="400" size="280" collapsible="true" splitter="true">
	
		  <iframe name="left" id="left" width="100%" height="100%" scrolling="no" frameborder="0"></iframe>	
					
		   <cf_loadpanel 
			   id="left"
			   template="ProgressViewTree.cfm?ProgramCode=#URL.ProgramCode#&ProgramName=#URL.ProgramName#&Mission=#URL.Mission#&Period=#URL.Period#">	
			
	</cflayoutarea>
	
	<cflayoutarea  position="center" name="box">
			
		<iframe src="#SESSION.root#/Tools/Treeview/TreeViewInit.cfm"
		    name="right" id="right" width="100%" height="100%" scrolling="no"
		    frameborder="0"></iframe>
				
	</cflayoutarea>			
		
</cflayout>

</cfoutput>

<cf_screenbottom html="Yes" layout="innerbox">