
<cfoutput>

<script>

	function orgunit(org,tpe) {
	
		se = document.getElementById("r"+org)
		
		if (se.className = "hide") {
			se.className = "regular"
			ColdFusion.navigate('#SESSION.root#/System/Organization/Application/Address/UnitAddressInfo.cfm?orgunit='+org+'&addresstype='+tpe,org)		
		} else { se.className = "hide" }		
		}
	
	function listing(id,box,mode) {
		window.location = "../Claim/ClaimDetailView.cfm?id=#url.id#&mode="+mode+"&claimid="+id	
	}
					
	function maximize(itm) {
	 	
	 se   = document.getElementsByName(itm)
	
	 icM  = document.getElementById(itm+"Min")
	 icE  = document.getElementById(itm+"Exp")
	 count = 0
		 
	 if (icM.className == "regular") {
		
	 icM.className = "hide";
	 icE.className = "regular";
	 
	 while (se[count]) {
	   se[count].className = "hide"
	   count++ }
	 
	 } else {
	 	 
	 while (se[count]) {
	 se[count].className = "regular"
	 count++ }
	 icM.className = "regular";
	 icE.className = "hide";			
	 }	
		 
  } 
  
 function attopen(itm,ent,obj,doc,box) {
	 	
	 se   = document.getElementById(itm)	
	 icM  = document.getElementById(itm+"Min")
	 icE  = document.getElementById(itm+"Exp")
			 
	 if (icM.className == "regular") {
		
	    icM.className = "hide";
    	icE.className = "regular";
        se.className = "hide"
		 
	 } else {
	 
	    se.className = "regular"
		ColdFusion.navigate('ClaimDetailAttachment.cfm?box='+box+'&entitycode='+ent+'&objectid='+obj+'&documentcode='+doc,itm+'_content')
		
	    icM.className = "regular";
   	    icE.className = "hide";			
		
	 }	 
	 
	 }
  
 function drill(itm,object,topic,mode){
 
 	 icM  = document.getElementById(itm+"Min")
	 icE  = document.getElementById(itm+"Exp")	  
	 
	 if (icM.className == "hide") {
	 
	 	 icM.className = "regular";
		 icE.className = "hide";	
		 
		  if (topic == "action") {
		 document.getElementById("r"+object).className = "regular"
		 ColdFusion.navigate('#SESSION.root#/CaseFile/Application/Claim/CaseView/DetailWorkflow.cfm?mode='+mode+'&ajaxid='+object,object)
		 }
		 
		  if (topic == "note") {
		 document.getElementById("rnote"+object).className = "regular"		
		 ColdFusion.navigate('#SESSION.root#/tools/entityaction/details/notes/NoteList.cfm?box=note'+object+'&mode='+mode+'&objectid='+object,'note'+object)
		 }	
	 
		 if (topic == "expense") {
		 document.getElementById("rexpense"+object).className = "regular"
		 ColdFusion.navigate('#SESSION.root#/tools/entityaction/details/cost/CostList.cfm?box=expense'+object+'&mode='+mode+'&objectid='+object,'expense'+object)
		 }	
		 
		 if (topic == "activity") {
		 document.getElementById("ract"+object).className = "regular"
		 ColdFusion.navigate('ClaimDetailActivity.cfm?box=act'+object+'&mode='+mode+'&objectid='+object,'act'+object)
		 }	
		  
	 } else {	
	 
		 icE.className = "regular";
		 icM.className = "hide";			
			
		 if (topic == "action") {
		 document.getElementById("r"+object).className = "hide"
		 }
		 
		  if (topic == "note") {
		 document.getElementById("rnote"+object).className = "hide"
		 }
		 
		 if (topic == "expense") {
		 document.getElementById("rexpense"+object).className = "hide"
		 }
		 
		  if (topic == "activity") {
		 document.getElementById("ract"+object).className = "hide"
		 }
	 
	 }
	 
	 }
	 
</script>	 
  
  
</cfoutput>		  
 