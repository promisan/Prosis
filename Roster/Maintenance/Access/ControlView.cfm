
<cf_tl id="Roster Bucket Accessg" var="1">

<cf_screenTop height="100%" 
    title="#lt_text#" 
	bannerheight="4" 
	border="0" 
	html="No" 
	jQuery="Yes"
	scroll="no" 
	layout="webapp">
	
<cf_layoutscript>		

<cfset attrib = {type="Border",name="mybox",fitToWindow="Yes"}>	

<cf_layout attributeCollection="#attrib#">			

<cf_layoutarea 
          position="top"
          name="controltop"
          minsize="55"
          maxsize="55"  
		  size="55"       
          splitter="true"
		  overflow = "hidden">	
				
		 <cfinclude template="ControlMenu.cfm">	
		 
</cf_layoutarea>		 
	
<cf_layoutarea position="left" name="treebox" maxsize="400" size="280" collapsible = "true" 
		splitter    = "true"
		overflow    = "scroll">

    <cfinclude template="ControlTree.cfm">
	
</cf_layoutarea>

<cf_layoutarea  position="center" name="box">
	
	<iframe name="right" id="right" src="#SESSION.root#/Tools/Treeview/TreeViewInit.cfm" width="100%" height="100%" scrolling="no"
	    frameborder="0"></iframe>				
			
</cf_layoutarea>			
		
</cf_layout>


</html>

