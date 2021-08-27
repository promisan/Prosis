
<cfparam name="url.init" default="1">

<cfinvoke component = "Service.Process.Materials.Asset"  
   method           = "AssetList" 
   mission          = "#URL.Mission#"		
   role             = "'AssetHolder','AssetUser'"  
   table            = "#SESSION.acc##URL.Mission#AssetTree"
   disposal         = "0">	
   
<cfif url.init eq "0">
   
	<script language="JavaScript">   
	
		/**** for further testing 
	    WORK IN PROGRESS TO BE REVIEWED BY ARMIN TO DO A RECURSIVE FUNCTION
		var nodeList = [];			
		
		if (node.hasChildren())
		{
		    for (var i = 0; i < node.children.length; i++) {
				nodeList.push(node.children[i]);
			}
		}
		
		for (var i = 0; i < nodeList.length; i++) {
			current_node = nodeList[i];				
		    ColdFusion.Tree.loadNodes([],{'treeid':'tmaterials','parent':current_node});	   			
			current_node = nodeList[i];						
			current_node.expand();
		}		
		*****/
			
	    var oTree     = ColdFusion.Tree.getTreeObject('tmaterials');		
		
		reload(oTree,'Class');
		reload(oTree,'Organization');
		reload(oTree,'Location');		
	
		function reload(oTree, nme)	{
			
			var do_expand = false;
			
			var node      = oTree.getNodeByProperty('id',nme);			
			if (node) {
				if (node.expanded)
					do_expand = true; 					
				ColdFusion.Tree.loadNodes([],{'treeid':'tmaterials','parent':node});	   			
				if (do_expand)	
					node.expand();				
			}	
			
	    }
		
	</script>

</cfif>
   