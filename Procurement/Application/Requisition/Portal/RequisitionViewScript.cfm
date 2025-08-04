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
	 
	<cf_tl id="No lines were selected" var="1">
	<cfset tNoLines="#lt_text#">

	<script language="JavaScript">
	
	function printme() {
	    w = 830;
	    h = #CLIENT.height# - 200;
	   	ptoken.open('../Requisition/RequisitionEntryListing.cfm?print=1&add=0&Mission=#URL.Mission#&Period=#URL.Period#&Mode=Entry&ID='+document.getElementById('reqno').value, "print", "unadorned:yes; edge:raised; status:yes; dialogHeight:"+h+"px; dialogWidth:"+w+"px; help:no; scroll:yes; center:yes; resizable:no");
	}	
		
	function requisitionrefresh(id) {	
	    _cf_loadingtexthtml='';	
 		ptoken.navigate('../Requisition/RequisitionEntryListing.cfm?add=0&Mission=#URL.Mission#&Period=#URL.Period#&Mode=Entry&'+'&id='+id,'contentbox1')												
	}
	
	function process(id) {
	    ptoken.open("#SESSION.root#/ActionView.cfm?id=" + id, id);	   
	}
	
	function add() {
		ptoken.navigate('RequisitionContainer.cfm?mode=Portal&ID=new&Mission=#URL.Mission#&Period=#URL.Period#&context=#url.Context#&requirementid=#url.Requirementid#&PersonNo=#url.PersonNo#&orgunit=#url.OrgUnit#&itemmaster=#url.ItemMaster#','contentbox2')
	}	
		
	function mail2(mode,id) {
		window.open("#SESSION.root#/Tools/Mail/MailPrepareOpen.cfm?id="+mode+"&ID1="+id+"&ID0=#Parameter.RequisitionTemplate#","_blank", "left=30, top=30, width=800, height=600, toolbar=no, menubar=no, status=yes, scrollbars=no, resizable=no")
	}	
	
	function togglesel() {
		
		if 	(document.getElementById("selectall").value == "Invert") {
			document.getElementById("selectall").value = "Select All" } else {
			document.getElementById("selectall").value = "Invert"
			}	   
			
		se = document.getElementsByName("RequisitionNo")
		cnt = 0;	
		while (se[cnt]) {
			se[cnt].click();
			cnt++
		}					
	}
	
	function hl(itm,fld,reqno) {
		  
	     ln1 = document.getElementById(reqno+"_1");
		 // ln2 = document.getElementById(reqno+"_2");
		 // ln3 = document.getElementById(reqno+"_3");
		 document.getElementById("PostData").className = "button10g"
		 	 	 		 	
		 if (fld != false){				 
			 ln1.className = "highLight labelmedium";			 
			// ln2.className = "highLight2 labelmedium";			 
			// ln3.className = "highLight2 labelmedium";
		 }else{
		 ln1.className = "header labelmedium";		
		 // ln2.className = "header labelmedium";
		 // ln3.className = "header labelmedium";
		 }
	  }
			
	function submitdata(per) {	
	
	    sta  = document.getElementById("status").value				
		val  = $('.chk_requisition');
		cnt  = 0
		
		lis  = ''
		console.log(val);
		
		while (val[cnt]) {
		      if (val[cnt].checked) {
		        lis = lis+'|'+val[cnt].value
			   }  cnt++  
		 }  
		 
		if (lis == "") {
		
			alert("#tNoLines#.")
		
		} else {
					
			parent.ProsisUI.createWindow('mysubmit', 'Submit', '',{x:100,y:100,height:parent.document.body.clientHeight-80,width:parent.document.body.clientWidth-80,modal:true,resizable:false,center:true})    
			parent.ptoken.navigate('#session.root#/Procurement/Application/Requisition/Process/RequisitionCreate.cfm?req='+lis+'&status='+sta+'&mission=#URL.Mission#&period='+per,'mysubmit') 	

		}	
	}	
	
	function submitrefresh() {
	    sta  = document.getElementById("status").value			
	    ptoken.navigate('#session.root#/Procurement/Application/Requisition/Process/RequisitionCreatePending.cfm?mission=#URL.Mission#&period=#URL.Period#&status='+sta,'contentbox3')
	}
	
	function search(itm) {	   	      
		 if (window.event.keyCode == "13") {	
	    	reqsearch()	
			try {
			document.getElementById(itm).onkeyup=new Function("return false")  } catch(e) {} 		
	     } 	
	}
	 
	function reqsearch() {  
	
	  Prosis.busy('yes')
	  pag   = document.getElementById('page').value	  
	  sta   = document.getElementById('status').value
	  per   = document.getElementById('periodsel').value       
	  unit  = document.getElementById('pending_unit').value
	  val   = document.getElementById('pending_search').value	  
	  ann   = document.getElementById('annotationsel').value	
	  fun   = document.getElementById('fundsel').value			 
	  fund  = document.getElementById('fundcode').value		
	  _cf_loadingtexthtml='';	   	 
	  ptoken.navigate('../Process/RequisitionCreatePending.cfm?status='+sta+'&page='+pag+'&annotationid='+ann+'&mission=#url.mission#&period='+per+'&search='+val+'&unit='+unit+'&fun='+fun+'&fund='+fund,'contentbox3')	 
	}  
	
		
	function log(id) {
	
	se = document.getElementById("blog"+id)
	if (se.className == "regular") {
		se.className = "hide"
		} else {	
		se.className = "regular"
		ptoken.navigate('../requisition/RequisitionActionLog.cfm?id='+id,'log'+id)
	}
	}
	
	function copyRequisition(requisitionNo){
		if (confirm('Are you sure that you want to clone this requisition?')){
		    _cf_loadingtexthtml='';	
			Prosis.busy('yes');
			ptoken.navigate('../Requisition/applyActionRequisition.cfm?action=copy&requisitionNo='+requisitionNo,'copyRequisitionDiv');
		}
	}
	
	function deleteRequisition(requisitionNo){
		if (confirm('Are you sure that you want to remove this requisition?')){
		    _cf_loadingtexthtml='';	
			Prosis.busy('yes');
			ptoken.navigate('../Requisition/applyActionRequisition.cfm?action=delete&requisitionNo='+requisitionNo,'copyRequisitionDiv');
		}
	}
		
	</script>

</cfoutput>