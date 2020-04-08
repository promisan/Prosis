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
	    ColdFusion.navigate('../Application/OrganizationTree.cfm?class=#url.class#&mission=#url.mission#','treebox')  
		parent.right.location = "../Application/OrganizationViewHeader.cfm";
	}
	
	function orgaccess() {
	    window.open("../Access/OrganizationView.cfm","_top")   
	}
	
	function mission() {
	    parent.right.location = "OrganizationListing.cfm?Mission=#Mission#&ID4=#URL.class#"
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

<cf_layoutarea  position="left" name="tree" size="300" collapsible="true" splitter="true" maxsize="400">
     		
		<cfinclude template="OrganizationTree.cfm">
					
</cf_layoutarea>

<cf_layoutarea  position="center" name="box">

			<iframe name="right" scr="#SESSION.root#/Tools/Treeview/TreeViewInit.cfm"" id="right" width="100%" height="100%" scrolling="no"
	    frameborder="0"></iframe>
														
</cf_layoutarea>			
		
</cf_layout>

</cfoutput>


