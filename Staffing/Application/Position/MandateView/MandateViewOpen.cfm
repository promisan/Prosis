
<cf_screentop jquery="Yes" html="No">

<cfoutput>
	
	<cfif url.id eq "org">
	
		<script>		
			
		var id_tree = "mandatetreecontent";
		var tree = parent.ColdFusion.objectCache[id_tree+"collection"];
		var element  = parent.ColdFusion.DOM.getElement(tree.prevspanid,id_tree);
		element.style.backgroundColor=tree.prevspanbackground;
		// parent._cf_loadingtexthtml='';	
		// parent.ptoken.navigate('setTree.cfm?mission=#url.id2#&mandate=#url.id3#','mandatetree')		
		</script>
				
	<cfelse>
	
	<!---
		<script>
		parent.document.getElementById('selectedfilter').value = '#url.id#'
		parent.document.getElementById('selectedfiltervalue').value = '#url.id1#'
		</script>
		--->
		
	</cfif>
	
	
	<cfif URL.ID eq "Locate">
	
		<script language="JavaScript">
		   window.location = "MandateViewView.cfm?time=#now()#&ID=#URL.ID#&ID2=#URL.ID2#&ID3=#URL.ID3#"
		</script>
		
	<cfelse>
	
		<cfparam name="url.id4" default="">
	
		<script language="JavaScript">	 
		   unitcode = parent.YAHOO.widget.TreeView.getTree('idtree')._cf_node	   
		   window.location = "MandateViewGeneral.cfm?org="+unitcode+"&ID=#URL.ID#&ID1=#URL.ID1#&ID2=#URL.ID2#&ID3=#URL.ID3#&ID4=#URL.ID4#&selectiondate=" + parent.document.getElementById('selectiondate').value					 	 
		</script>
	
	</cfif>

</cfoutput>


