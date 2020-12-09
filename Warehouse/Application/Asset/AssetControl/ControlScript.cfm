
<cfparam name="URL.Mission" default="">

<cfoutput>

<cf_tl id="No items have been selected." var="1" Class="Message">
<cfset tNoItems="#lt_text#">
		
	<cfajaximport tags="cfwindow,cfform,cfdiv,cftree,cfmenu,cfinput-datefield,cfinput-autosuggest">
			
	<cf_dialogAsset>
	<cf_dialogProcurement>
	<cf_dialogStaffing>
	<cf_listingscript>

	<!--- no longer needed as this was replace by the new code 	
	<script src="#SESSION.root#/Tools/DialogHandling/Navigation.js"></script>	  	
	--->
										  	
	<script language="JavaScript">	
	
	function tree_refresh()	{

		var div = document.getElementById('drefresh');
		if (div) {
			ColdFusion.navigate('#SESSION.root#/Warehouse/Application/Asset/AssetControl/TreePreparation.cfm?init=0&mission=#url.mission#','drefresh');
				
		}	
	}	
	
	function selectall() {
	
		  ck = document.getElementById("batch").checked
		  se = document.getElementsByName("AssetId")
		  bx = document.getElementById("actions")	  
			  
		  count = 0
		  while (se[count]) {
		    if (ck == true) {
			  se[count].checked = true		  
			  } else {
			  se[count].checked = false
			  }
			 count++
		  }    
	
		  if (ck == true) {
			  bx.className = "regular"
		  } else {
			  bx.className = "hide"
		  }
	  
	  }	
	  
	function selectthis(ck) {
		     
		  se = document.getElementsByName("AssetId")
		  bx = document.getElementById("actions")
		   
		  show = 0
		  count = 0
		  while (se[count]) {		   
			  if (se[count].checked == true) { 
			  	show = 1;
				asset = se[count].value; 
			   }
			  count++
		  }    
		  		  	  
		  					  
		  			  
		  if (show == 1) {
		    bx.className = "regular"
			showdetail(asset);
		  } else {
		    bx.className = "hide"
		  }
	  
	  }
		
	function depreciation() {
	     ProsisUI.createWindow('dep', 'Depreciation', '',{x:100,y:100,height:300,width:700,modal:true,center:true})	     
	     ptoken.navigate('../Depreciation/DepreciationSet.cfm?mission=#url.mission#','dep') 
	}

	function newreceipt() {		    
	    ptoken.open("#SESSION.root#/Warehouse/Application/Asset/AssetEntry/AssetEntry.cfm?scope=workorder&Mission=#URL.Mission#&ts="+new Date().getTime(), "newasset", "left=40, top=40, width=950, height=860, menubar=no, location=0, status=yes, toolbar=no, scrollbars=no, resizable=yes");								
	}	
	
	function refreshlist() {	
	  document.getElementById('refreshme').click()
	}
					
	function facttable1(controlid,format,filter,qry) {
		w = #CLIENT.widthfull# - 80;
	    h = #CLIENT.height# - 110;				
		ptoken.open("#SESSION.root#/component/analysis/CrossTabLaunch.cfm?"+qry+"&data=1&controlid="+controlid+"&format="+format+"&filter="+filter, "rolapasset");		
	}		
	
	function facttablexls1(controlid,format,filter,qry) {
		w = #CLIENT.widthfull# - 80;
	    h = #CLIENT.height# - 110;				
		ptoken.open("#SESSION.root#/component/analysis/CrossTabLaunch.cfm?"+qry+"&data=1&controlid="+controlid+"&format="+format+"&filter="+filter, "_blank");		
	}		
	
	w = #CLIENT.width# - 70;
	h = #CLIENT.height# - 160;

	function process(id,ass) {	
	    window.open("#SESSION.root#/ActionView.cfm?id=" + id + "&myclentity="+ass, "_blank", "left=30, top=30, width=" + w + ", height= " + h + ", toolbar=no, menubar=no, status=yes, scrollbars=no, resizable=yes");
	}
	
	function listshow(id,id1,id2,id3) {	   	
		ColdFusion.navigate('ControlList.cfm?id='+id+'&id1='+id1+'&id2='+id2+'&id3='+id3,'controllist') 			
	}	
		
	function listfilter(id,id1,id2) {	
	   document.filterform.onsubmit() 
	   if( _CF_error_messages.length == 0 ) {
	       Prosis.busy('yes')
		   _cf_loadingtexthtml='';	
      	   ColdFusion.navigate('ControlListData.cfm?mde=0&id='+id+'&id1='+id1+'&id2='+id2,'listing','','','POST','filterform') 
	   }   
	}	
	
	function listreload(id,id1,id2,page,sort,view,mde) {
	   try {
	   Prosis.busy('yes')
	   _cf_loadingtexthtml='';	
	   ColdFusion.navigate('ControlListData.cfm?mde='+mde+'&id='+id+'&id1='+id1+'&id2='+id2+'&Page='+page+'&Sort='+sort+'&view='+view,'listing','','','POST','filterform') 
	   } catch(e) {
	   Prosis.busy('yes')
	   _cf_loadingtexthtml='';	
	   ColdFusion.navigate('ControlListData.cfm?mde='+mde+'&id='+id+'&id1='+id1+'&id2='+id2+'&Page='+page+'&Sort='+sort+'&view='+view,'listing') 
	   }
	}  
	   		
	function more(bx,nav) {
	    icM  = document.getElementById(bx+"Min")
	    icE  = document.getElementById(bx+"Exp")
		se   = document.getElementById("box"+bx)
			
		if (se.className=="hide") {
			se.className  = "regular";
			icM.className = "regular";
		    icE.className = "hide";
			ColdFusion.navigate(nav,"c"+bx)
		} else {
			se.className  = "hide";
		    icM.className = "hide";
		    icE.className = "regular";
		}
	}
	
	<!--- refresh the detail bottom box --->		
			 
	function maximize(itm) {
	
	 	 se   = document.getElementsByName(itm)
		 count = 0
		 if (se[0].className == 'regular') {
			   while (se[count]) { 
			      se[count].className = 'hide'; 
	  		      count++
			   }		   
			 } else {
			    while (se[count]) {
			    se[count].className = 'regular'; 
			    count++
			 }	
		   }
	 }  	
	 
	 function reqlist(id,id1,mis) {	 
	      ColdFusion.navigate('../Request/RequestListing.cfm?mission='+mis,'controllist') 	 
	 }	
	
					 
	function movelist(id,id1,mis) {	 
	      ColdFusion.navigate('../Movement/MovementListing.cfm?mission='+mis,'controllist') 	 
	}	 
	 
	function disposallist(id,id1,mis) {	 
		  ColdFusion.navigate('../Disposal/DisposalListing.cfm?mission='+mis,'controllist') 	 
	}	 
	
	function observationlist(id,id1,mis) {	 
		  ColdFusion.navigate('../Observation/ObservationViewListing.cfm?context=view&mission='+mis,'controllist') 	 
	}	 			
	 
	function get_selected_assets() {
	    		
		var temps = ''
		$("##t_asset_list tbody :checkbox:checked").each(function() {	
			if ($(this).attr('name') == 'AssetId') {
			  if (temps == '') {  
			    temps = $(this).val();
			  } else {  
			    temps = temps+","+$(this).val()
			  }
			} 
		});		
	    return temps		  		
	 } 
	 
	 function move(tbl,id,id1,id2,page,sort,view,mde) {

	      w = #CLIENT.width# - 100;
	      h = #CLIENT.height# - 155;
		
		  count = 0
		  temps = ''
		  se = document.getElementsByName("AssetId")
		  // check if entry was made 
		  while (se[count] && temps == '') {
		  	  if (se[count].checked == true && se[count].value != "") {
		 	  temps = se[count].value	
		      }		 
			  count++ 
		   }
		  
		   if (temps == "") {		  
		      alert("#tNoItems#")			
		   } else {		    
		   
		   	  ptoken.open("../Movement/MovementEntry.cfm?mission=#url.mission#&tbl="+tbl+"&id="+id+"&id1="+id1+"&id2="+id2+"&page="+page+"&sort="+sort+"&view="+view+"&mde="+mde,"movement","left=40, top=40, width=" + w + ", height= " + h + ", menubar=no, location=0, status=yes, toolbar=no, scrollbars=no, resizable=yes")
			  
		   }	
	 }			
		
	 function disposal(tbl,id,id1,id2,page,sort,view,mde) {
	 	 
	      w = #CLIENT.width# - 100;
		  h = #CLIENT.height# - 155;		
		  count = 0
		  temps = ''
		  se = document.getElementsByName("AssetId")
		  while (se[count]) {
		      
			  if (se[count].checked == true && se[count].value != "") {			  
			  if (temps == '') {  
			    temps = se[count].value
			  } else {  
			    temps = temps+","+se[count].value}
			  }
			 count++ 			 
		  }
		  if (temps == "") {
		    alert("#tNoItems#")
		  } else {
		  		  
		    ptoken.open("../Disposal/DisposalEntry.cfm?mission=#url.mission#&tbl="+tbl+"&id="+id+"&id1="+id1+"&id2="+id2+"&page="+page+"&sort="+sort+"&mde="+mde+"&view="+view+"&assetid="+temps,"disposal","left=40, top=40, width=" + w + ", height= " + h + ", menubar=no, location=0, status=yes, toolbar=no, scrollbars=no, resizable=yes") 
		  	
		  }	
	 }		
		
	 function detail(act) {
	 	
	  bt1 = document.getElementById("DetailShow");
	  bt2 = document.getElementById("DetailHide");
	  if (act == 'show') {
		  bt1.className = "hide";
		  bt2.className = "button10s";
		  expandArea('container','controldetail');
	  } else {
	 	  bt1.className = "button10s";
		  bt2.className = "hide";
		  collapseArea('container','controldetail');
	  }
	 }	 
	 
	 function topicdetail(topic) {
		document.getElementById("topic").value = topic	
		ass = document.getElementById("rowid").value
	    ColdFusion.navigate('../AssetDetail/ItemDetail.cfm?assetid='+ass+'&topic='+topic,'detailbox')		
	 }		
		
     function showdetail(asset) {		   
	       try {
		   vtopic = document.getElementById("topic").value
		   ColdFusion.navigate('../AssetDetail/ItemDetail.cfm?assetid='+asset+'&topic='+vtopic,'detailbox')		
		   } catch(e) {}
	    }	   
	
	// logging 
	function record_actions() {	
	  var temps = get_selected_assets();	
	  if (temps == "") {
	  	alert("#tNoItems#")
	  }
	  else 
	  	window.open("../AssetAction/Logging/AssetActionForm.cfm?mission=#url.mission#&ts=" + new Date().getTime(), '_blank', "left=30, top=30, width=" + w + ", height= " + h + ", toolbar=no, menubar=no, status=yes, scrollbars=no, resizable=yes");	
	}								
	
</script>

</cfoutput>		  


