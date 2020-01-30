
<cfoutput>

<script language="JavaScript">

function refreshTree() {
  ColdFusion.navigate('DistributionViewTree.cfm','tree');
}

function batch(mode) {	 
    
   right.location = "#SESSION.root#/tools/cfreport/EngineReport.cfm?ts="+new Date().getTime()+"&mode="+mode;
}

</script>

<cfajaximport tags="cftree,cfform">

<cf_tl id="Reporter distribution log" var="1">

<cf_screenTop height="100%" label="Reporter distribution log" html="No" band="No" jQuery="Yes" scroll="no" MenuAccess="Yes" validateSession="Yes">

<cf_layoutscript>	 
	 
<cfset attrib = {type="Border",name="mybox",fitToWindow="Yes"}>

<cf_layout attributeCollection="#attrib#">

	<cf_layoutarea 
	          position  = "top"
	          name      = "controltop"
	          minsize   = "51"
	          maxsize   = "51"  
			  size      = "51" splitter="true" overflow="hidden">	
			  
			 <cfinclude template="DistributionMenu.cfm">
			  
	</cf_layoutarea>		
			  
	<cf_layoutarea 
          position="left"
          name="tree"
          source="DistributionViewTree.cfm"          
          size="240"
          collapsible="true"
          splitter="true"
          maxsize="400"/>
			
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
