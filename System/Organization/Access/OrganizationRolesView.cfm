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

<cfquery name="Role" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM    Ref_AuthorizationRole
	WHERE   Role = '#URL.Class#' 
</cfquery>

<script language="JavaScript1.2">
	
	ie = document.all?1:0
	ns4 = document.layers?1:0
	
	w = 0
	h = 0
	if (screen) {
	w = #CLIENT.width# - 80
	h = #CLIENT.height# - 160
	}
	
	function orgunit() {
	    ptoken.navigate('../Application/OrganizationTree.cfm?class=#url.class#&mission=#url.mission#','treebox')  
		ptoken.location('../Application/OrganizationViewHeader.cfm', 'parent.right');		
	}
	
	function orgaccess() {
	    ptoken.open("../Access/OrganizationView.cfm","_top")   
	}
	
	function mission() {
	    ptoken.location('OrganizationListing.cfm?Mission=#Mission#&ID4=#URL.class#', 'parent.right');
	   // parent.right.ptoken.location('OrganizationListing.cfm?Mission=#Mission#&ID4=#URL.class#')
	}	

</script>

<cfajaximport tags="cfform">

<cf_screenTop
		height="100%"
		title="Organization User Roles"
		jQuery="yes"
		TreeTemplate="Yes"
		border="0"
		html="No"
		scroll="no">

<cf_layoutscript>

<cfset attrib = {type="Border",name="mybox",fitToWindow="Yes"}>	

<cf_layout attributeCollection="#attrib#">			

<cf_layoutarea 
          position="top"
          name="controltop"
          minsize="45"
          maxsize="45"  
		  size="45"       
		  overflow="hidden" 
          splitter="true">	
		  
		 <cfinclude template="OrganizationRolesMenu.cfm">
		  
</cf_layoutarea>		  

<cf_layoutarea  position="left" name="tree" size="350" collapsible="true" splitter="true" maxsize="400">
     		
		<cfinclude template="OrganizationTree.cfm">
					
</cf_layoutarea>

<cf_layoutarea  position="center" name="box">

			<iframe name="right" scr="#SESSION.root#/Tools/Treeview/TreeViewInit.cfm"" id="right" width="100%" height="100%" scrolling="no"
	    frameborder="0"></iframe>
														
</cf_layoutarea>			
		
</cf_layout>

</cfoutput>


