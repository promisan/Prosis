<cfoutput>

<cfajaximport tags="cfwindow">
<cfparam name="URL.role"    default="">
<cfparam name="URL.period"  default="">
<cfparam name="URL.ID2"     default="">
<cfparam name="URL.mode"     default="">

<cfquery name="Parameter" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   Ref_ParameterMission
	WHERE  Mission = '#URL.Mission#' 
</cfquery>

<script>
    
	function applyprogram(prg,scope) {
	   ptoken.navigate('setProgram.cfm?programcode='+prg+'&scope='+scope,'processmanual')
	}  
	
	function facttablexls1(control,format,box) {  
	    // here I could capture the client variable if this is better for large selections 
		ptoken.navigate('RequisitionViewSelected.cfm','process','','','POST','formselected')	  			
		ptoken.open("#SESSION.root#/component/analysis/CrossTabLaunch.cfm?box="+box+"&data=1&controlid="+control+"&format="+format, "facttable");
	}	
	
	function search() {
		
		 if (window.event.keyCode == "13")
			{ document.getElementById("findlocate").click() }
							
	}
	
	function reloadForm(page,view,layout,sort,filter,fileno) {
	
	      if (page == "") {
		  pge  = document.getElementById('page').value          
		  } else {
		  pge = page
		  }
		  	  
	      fnd =  document.getElementById("find").value
		  
		  <cfif url.id neq "Loc">
			  prg = document.getElementById("programcode").value
			  ann = document.getElementById("annotationsel").value
		  <cfelse>
		 	  prg = ""
			  ann = ""
		  </cfif>
		  Prosis.busy('yes')
		  _cf_loadingtexthtml='';	
	      ptoken.navigate('#SESSION.root#/Procurement/Application/Requisition/RequisitionView/RequisitionViewGeneral.cfm?FileNo='+fileno+'&Mission=#URL.Mission#&Role=#URL.Role#&Period=#URL.Period#&ID=#URL.ID#&ID1=#URL.ID1#&ID2=#URL.ID2#&Page=' + pge + '&View=' + view + '&Lay=' + layout + '&Sort='+sort + '&Filter='+filter+'&find='+fnd+'&programcode='+prg+'&annotationid='+ann,'detail');
	}
	
	function filter() {
	
		document.formlocate.onsubmit() 
		if( _CF_error_messages.length == 0 ) {
			ptoken.navigate('#SESSION.root#/Procurement/Application/Requisition/RequisitionView/RequisitionViewListingPrepare.cfm?Role=#url.role#&id2=#url.id2#&Period=#URL.Period#&ID=#URL.ID#&ID1=#URL.ID1#&Mission=#URL.Mission#&Mode=#URL.mode#','detail','','','POST','formlocate')
		 }   
	}	 
		
	function mail2(mode,id) {
		  ptoken.open("#SESSION.root#/Tools/Mail/MailPrepareOpen.cfm?id="+mode+"&ID1="+id+"&ID0=#Parameter.RequisitionTemplate#","_blank", "left=30, top=30, width=800, height=600, toolbar=no, menubar=no, status=yes, scrollbars=no, resizable=no")
	}	
	
	function showdetail(req) {
	
	  se = document.getElementById(req+'detail')
	  if (se.className == "hide") { 
	     se.className = "regular"
	  } else {
	     se.className = "hide"  
	  }	 
	
	}
	
	function more(box,req,act,mode) {
				
		icM  = document.getElementById(box+"Min")
		icE  = document.getElementById(box+"Exp")
		se   = document.getElementById(box);
			 		 
		if (se.className == "hide") {		 
	     	 icM.className = "regular";
		     icE.className = "hide";
			 se.className  = "regular";		
			 ptoken.navigate('../../Receipt/ReceiptEntry/ReceiptDetail.cfm?box=i'+box+'&reqno='+req+'&mode='+mode,'i'+box)	    
		 } else {	    
	     	 icM.className = "hide";
		     icE.className = "regular";
	     	 se.className  = "hide"	 
		 }		 		
	  }
	  	
</script>

</cfoutput>