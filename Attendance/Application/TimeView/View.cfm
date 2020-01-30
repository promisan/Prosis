
<cfinvoke component      = "Service.Process.System.UserController"  
	    method            = "ValidateFunctionAccess"  
		SessionNo         = "#client.SessionNo#" 
		ActionTemplate    = "TimeView/View.cfm"
		ActionQueryString = "#url.mission#">	
	
<cf_tl id="Staff Attendance and Address Management" var="1">

<cfquery name="Parameter" 
  datasource="AppsProgram" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
      SELECT *
      FROM Parameter
  </cfquery>

<cf_screenTop height="100%" border="0" title="#lt_text#" scroll="no" jQuery="Yes" html="No" validateSession="Yes">
  
<cf_listingscript>
  
<cfset CLIENT.Sort = "OrgUnit">

<cf_layoutscript>
	 
<cfset attrib = {type="Border",name="mybox",fitToWindow="Yes"}>

<cf_layout attributeCollection="#attrib#">
	
	<cf_layoutarea 
	          position="header"
	          name="controltop">	
					
		<cf_ViewTopMenu background="gray" backgroundcolor="gray" label="#lt_text#: <b>#URL.Mission#</b>">	  
					 
	</cf_layoutarea>		
	
	<cf_layoutarea position="left" name="treebox" maxsize="400" size="320" collapsible="true" splitter="true">	
			<cfinclude template="ViewTree.cfm">					
	</cf_layoutarea>
			
	<cf_layoutarea  position="center" name="box" style="height:100%">
	
		<cfoutput>
			<iframe name="right" id="right" width="100%" height="100%" scrolling="no" src="#SESSION.root#/Tools/Treeview/TreeViewInit.cfm"
	    	frameborder="0"></iframe>
		</cfoutput>
			
	</cf_layoutarea>			
		
</cf_layout>

<cf_screenbottom layout="innerbox">
