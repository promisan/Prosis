<cfparam name="url.idmenu" default="">

<cfoutput>

<cf_tl id="Maintain Accounting Schema" var="1">

<cf_screenTop height="100%"              
			  html="Yes" jQuery="Yes" layout="webapp" label="#lt_text#"	bannerforce="gray"		  
			  border="0" menuAccess="Yes" systemfunctionid="#url.idmenu#">			
			  
<cf_layoutscript>			  
		 
<cfset attrib = {type="Border",name="mybox",fitToWindow="Yes"}>

<cf_layout attributeCollection="#attrib#">
					  		  
	<cf_layoutarea 
	    position    = "left" 
		name        = "treebox" 
		maxsize     = "250" 		
		size        = "250" 
		collapsible = "true" 
		style       = "height:100%"
		splitter    = "true">
				
			<cfinclude template="SchemaViewTree.cfm">
			
	
	</cf_layoutarea>
	
	<cf_layoutarea  position="center" name="box" style="height:100%" overflow="hidden">
				
			<iframe src="#SESSION.root#/Tools/Treeview/TreeViewInit.cfm"
		        name="right"
		        id="right"
		        width="100%"
		        height="100%"
				scrolling="no"
		        frameborder="0"></iframe>
				
					
	</cf_layoutarea>			
		
</cf_layout>

</cfoutput>
