
<cfparam name="URL.Mission" default="All">
<cfparam name="URL.ID" default=""> 
<cfif URL.ID neq "">
  <cfset CLIENT.form = URL.ID>
</cfif>

<cfoutput>

<cf_tl id="Employee Search" var="1">

<cf_screenTop title="#lt_text#" border="0" html="No" JQuery="yes">
<cf_layoutScript>

<cfset attrib = {type="Border",name="mybox",fitToWindow="Yes"}>	

<cf_layout attributeCollection="#attrib#">
	
	<cf_layoutarea 
	   	position  = "header"
	   	name      = "reqtop">	
			  		
		<cf_tl id="Employee Management" var="1">
		<cf_ViewTopMenu label="#lt_text#" banner="yellow">
			 			  
	</cf_layoutarea>			

	<cf_layoutarea  position="left" name="tree" overflow="hidden" maxsize="240" size="240" collapsible="true" splitter="true">
	
		<iframe 
			src="SearchTree.cfm?ID=0&Mission=#URL.Mission#"
			name="left"
	        id="left"
	        width="100%"
	        height="100%"
	        scrolling="no"
			class="tree"
	        frameborder="0"></iframe>	
	
	</cf_layoutarea>
	
	<cf_layoutarea  position="center" name="box">
			
			<iframe src="#SESSION.root#/Tools/Treeview/TreeViewInit.cfm"
		        name="right" id="right" width="100%" height="100%" scrolling="no"
		        frameborder="0"></iframe>
				
	</cf_layoutarea>			
		
</cf_layout>

</cfoutput>
