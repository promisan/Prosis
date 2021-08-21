<cfoutput>

	<script>
	
	    function searchcriteria() {
	
			if (document.getElementById('criteriabox').className == "regular") {
				  document.getElementById('critMax').className="regular"
				  document.getElementById('critMin').className="hide"
				  document.getElementById('criteriabox').className='hide'	  
			} else {	
				  document.getElementById('critMax').className='hide'
				  document.getElementById('critMin').className='regular'
				  document.getElementById('criteriabox').className='regular'
				  ptoken.navigate('ResultCriteria.cfm?id=#URL.ID1#','searchcriteria')	
			}
			
		}
		
		function printfulllist() {
		  ptoken.open("ResultListing.cfm?print=1&#CGI.QUERY_STRING#", "resultprint", "status=yes, height=765px, width=960px, scrollbars=no, toolbar=no, resizable=yes");
		}
	
		function broadcast() {	
		  ptoken.open("#SESSION.root#/Tools/Mail/Broadcast/BroadCastRoster.cfm?searchid=#url.id1#", "broadcast", "status=yes, height=850px, width=990px, scrollbars=no, toolbar=no, resizable=yes");
		}
		
		function php() {
		  ptoken.open("#SESSION.root#/Roster/RosterGeneric/RosterSearch/ResultListingPHP.cfm?url.id1=#url.id1#", "broadcast", "width=900, height=700, status=yes,toolbar=no, scrollbars=no, resizable=yes");
		}
	
		function selected(pers,st) {
			
		if (st == true) {
		url = "#SESSION.root#/Roster/RosterGeneric/RosterSearch/ResultListingSelect.cfm?status=1&searchid=#url.id1#&personno="+pers;
		} else {
		url = "#SESSION.root#/Roster/RosterGeneric/RosterSearch/ResultListingSelect.cfm?status=0&&searchid=#url.id1#&personno="+pers;
		}	
		ptoken.navigate(url,'selectbox')
			 
		}
	
		function list(page) {	
		    Prosis.busy('yes')    
			srt = document.getElementById("sort").value		
			lay = document.getElementById("layout").value
			src = document.getElementById("searchid").value
	        ptoken.location("#SESSION.root#/roster/rostergeneric/RosterSearch/ResultListing.cfm?docno=#url.docno#&mode=#url.mode#&ID=#URL.ID#&ID1=#URL.ID1#&ID2=#URL.ID2#&ID3=#URL.ID3#&height="+document.body.offsetHeight+"&Page=" + page + "&Sort=" + srt + "&Lay=" + lay + "&SearchId=" + src)
		}
	
		w = 0
		h = 0
		if (screen) {
		w = #CLIENT.width# - 60
		h = #CLIENT.height# - 110
		}
	
		function ShowFunction(AppNo,FunId) {
	    	w = #client.width# - 100;
		    h = #client.height# - 140;
			ptoken.open("../../RosterSpecial/RosterProcess/ApplicationFunctionEdit.cfm?mode=Process&ID=" + AppNo + "&ID1=" + FunId + "&IDFunction=" + FunId, "_blank", "left=50, top=50, width=" + w + ", height= " + h + ", status=yes, toolbar=no, scrollbars=yes, resizable=no");
		}
	
		function showdocument(vacno) {
			ptoken.open("#SESSION.root#/Vactrack/Application/Document/DocumentEdit.cfm?ID=" + vacno, "_blank", "left=20, top=20, width=" + w + ", height= " + h + ", status=yes, toolbar=no, scrollbars=yes, resizable=yes");
		}
	
		function info(action) {
	
		if (confirm("Do you want to " + action +" ?"))  {
			  ptoken.navigate('#SESSION.root#/roster/rostergeneric/rostersearch/ResultShortListAdd.cfm?mode=#url.mode#&docno=#url.docno#&id1=#url.id1#','selectbox','','','POST','resultlist')       		 
	   	} else {
			  return false
		}
	}
	
	ie = document.all?1:0
	ns4 = document.layers?1:0
	
	function hl(itm,fld){
	
	     if (ie){
	          while (itm.tagName!="TR")
	          {itm=itm.parentElement;}
	     }else{
	          while (itm.tagName!="TR")
	          {itm=itm.parentNode;}
	     }	 
		 	 		 	
		 if (fld != false){		
		 itm.className = "highLight4";	 
		 }else{itm.className = "regular";		
		 }
	  }
	  
	function selall(itm,fld) {
	
	     sel = document.getElementsByName('select')	 
		 count = 0
		 
		 while (sel[count]) {
		 	 	 	 		 	
		 if (fld != false){
			
		 sel[count].checked = true
		 itm = sel[count]
		 
		 if (ie){
	          while (itm.tagName!="TR")
	          {itm=itm.parentElement;}
	     }else{
	          while (itm.tagName!="TR")
	          {itm=itm.parentNode;}
	     }
		 
		 // itm.className = "highLight2";	 
		 
		 }else{
		 
			 sel[count].checked = false
			 
			 itm = sel[count]
			 
			 if (ie){
		          while (itm.tagName!="TR")
		          {itm=itm.parentElement;}
		     }else{
		          while (itm.tagName!="TR")
		          {itm=itm.parentNode;}
		     }		 
			 // itm.className = "regular";		 
			 }
			 count++
			 
		 }
		
	  }
	  
	  function searchdel(id) {
	     parent.ptoken.location('SearchDelete.cfm?id='+id) 
	  }
	  
	  function back() {  
	     parent.ptoken.location('Search4.cfm?docno=#url.docno#&ID=#URL.ID1#&mode=new')  
	  }
	  
	</script>	

</cfoutput>

<cf_dialogStaffing>