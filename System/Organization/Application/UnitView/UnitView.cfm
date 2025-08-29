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

	<cfparam name="url.mid" default="">
	
	<cfquery name="Org" 
		datasource="appsOrganization"
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT *
			FROM  Organization
			WHERE Orgunit = '#url.id#'	
	</cfquery>
	
	<cf_tl id="Tree Node/Unit Maintenance" var="1">
	
	<cf_screenTop height="100%" systemmodule="System" layout="webapp" html="No" border="0" label="#lt_text#" jquery="Yes" bannerheight="50" banner="red" scroll="no">
	
	<cf_layoutscript>
	
	<cfset attrib = {type="Border",name="mybox",fitToWindow="Yes"}>
	
	<cf_layout attributeCollection="#attrib#" script="No">
		
			<cf_layoutArea position="header" name="theHeader">
				<cf_tl id="Unit Control" var="1">
				<cf_ViewTopMenu label="#lt_text#" background="gray">
			</cf_layoutArea>
		
		<cf_layoutarea position="left" name="leftmenu" maxsize="220" size="220" collapsible="true" splitter="true">
								  
			  <table width="100%">
	  				 
				  <tr><td height="5"></td></tr>
				  <tr><td valign="top" style="padding-left:8px;padding-top:4px">	  				  
				     <cf_orgUnitTreeData>	  	 		
				  </td>
				  </tr>	
				  <tr><td height="5"></td></tr>		 
			      
			  
			  </table>
			  				
		</cf_layoutarea>
		
		<cf_layoutarea  position="center" name="right" overflow="auto">		
			<iframe src="UnitViewOpen.cfm?ID=#URL.ID#&id1=address&mid=#url.mid#" name="right" id="right" width="100%" height="99%" scrolling="no" frameborder="0"></iframe>			
		</cf_layoutarea>
		
	</cf_layout>		
		
	<cf_screenbottom layout="webapp">

</cfoutput>


