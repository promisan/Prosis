
<cf_screentop jquery="Yes" html="No">

<cfparam name="url.id1" default="">
<cfparam name="url.id2" default=""> 	   	
<cfparam name="url.id3" default="">
<cfparam name="url.id4" default="">

<cfoutput>
	
	<cfif url.id eq "org">
	
		<script>
		var vl = parent._SELECTED_ITEMS.length;
		for (var i = vl-1; i >= 0; i--) {
			console.log(parent._SELECTED_ITEMS[i].id);
			console.log(parent._SELECTED_ITEMS[i].value);
			console.log('----');
		}

		//var id_tree = "mandatetreecontent";
		//var tree = parent.ColdFusion.objectCache[id_tree+"collection"];
		//var element  = parent.ColdFusion.DOM.getElement(tree.prevspanid,id_tree);
		//element.style.backgroundColor=tree.prevspanbackground;
		// parent._cf_loadingtexthtml='';	
		// parent.ptoken.navigate('setTree.cfm?mission=#url.id2#&mandate=#url.id3#','mandatetree')	
			
		</script>
				
	<cfelse>

		<script>
		//parent.document.getElementById('selectedfilter').value = '#url.id#'
		//parent.document.getElementById('selectedfiltervalue').value = '#url.id1#'
		var vl = parent._SELECTED_ITEMS.length;
		for (var i = vl-1; i >= 0; i--) {
			console.log(parent._SELECTED_ITEMS[i].id);
			console.log(parent._SELECTED_ITEMS[i].value);
			console.log('----');
		}
		</script>
		
	</cfif>	
	
	<cfif URL.ID eq "Locate">
	
		<script language="JavaScript">
		   ptoken.location('MandateViewView.cfm?ID=#URL.ID#&ID2=#URL.ID2#&ID3=#URL.ID3#')
		</script>
		
	<cfelse>
		
		<script language="JavaScript">	 
			unitcode = parent._SELECTED_ITEMS[0].value;
		   	ptoken.location('MandateViewGeneral.cfm?org='+unitcode+'&ID=#URL.ID#&ID1=#URL.ID1#&ID2=#URL.ID2#&ID3=#URL.ID3#&ID4=#URL.ID4#&selectiondate=' + parent.document.getElementById('selectiondate').value)
		</script>
	
	</cfif>

</cfoutput>


