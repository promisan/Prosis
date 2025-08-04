<!--
    Copyright © 2025 Promisan

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->

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
 