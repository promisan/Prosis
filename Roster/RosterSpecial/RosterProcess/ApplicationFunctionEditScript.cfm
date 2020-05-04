
<cfparam name="URL.Box"  default="">
<cfparam name="URL.Mode" default="0">

<cfoutput>
<script language="JavaScript">

function gjp(fun,grd) {   
    window.open("<cfoutput>#SESSION.root#</cfoutput>/Roster/Maintenance/FunctionalTitles/FunctionGradePrint.cfm?ID=" + fun + "&ID1=" + grd, "_blank", "toolbar=no, status=yes, scrollbars=no, resizable=yes"); 
}

function st(currentStatus, status, applicantNo, functionId ) {
    
	ptoken.navigate('#SESSION.root#/Roster/RosterSpecial/RosterProcess/ApplicationFunctionEditRule.cfm?currentStatus='+currentStatus+'&status='+status+'&owner=#get.Owner#'+'&applicantNo='+applicantNo+'&functionId='+functionId,'reason')
	document.getElementById("statusnew").value = status;
}

function savePanel(show){
	panel = document.getElementById('savePanel');
	if (show=='show')
		panel.style.display = '';
	else
		panel.style.display='none';
}

function hr(itm,fld){

     if (ie){
          while (itm.tagName!="TR")
          {itm=itm.parentElement;}
     }else{
          while (itm.tagName!="TR")
          {itm=itm.parentNode;}
     }
	 
	 	 		 	
	 if (fld != false){
		
	 itm.className = "highLight2";
	 }else{		
     itm.className = "regular";		
	 }
		 
  }
  
function toggleRemarks(decisionCode,checked){

	s = document.getElementById('td_remarks_'+decisionCode);	
	if (checked == true){
		s.style.display = '';
	}else{
		s.style.display = 'none';
	}
	
}

function saveremarks() {
	  ptoken.navigate('ApplicationFunctionDecision.cfm?id=#url.id#&id1=#url.id1#&process=memo&box=#URL.box#&Owner=#Get.Owner#&Mode=#URL.Mode#&IDFunction=#URL.IDFunction#','saveremarks','','','POST','edit')	
}    
  
function save() {
	  ptoken.navigate('ApplicationFunctionDecision.cfm?id=#url.id#&id1=#url.id1#&process=memo&box=#URL.box#&Owner=#Get.Owner#&Mode=#URL.Mode#&IDFunction=#URL.IDFunction#','processbox','','','POST','edit')	
}  
  
function ask(mde) {
	
	se1 = document.getElementById("statusnew")
	se2 = document.getElementById("statusold")
		
	if (se1.value == se2.value) { 
		 
		   if (confirm("You have not changed the candidate status. Do you want to re-submit and record your comments regardless ?")) {
		      ptoken.navigate('ApplicationFunctionDecision.cfm?id=#url.id#&id1=#url.id1#&process='+mde+'&box=#URL.box#&Owner=#Get.Owner#&Mode=#URL.Mode#&IDFunction=#URL.IDFunction#','processbox','','','POST','edit')
		   } else { 
		   if (mde == "close") {
		     window.close() } else { return false }
		   } 				
	  }		
	
	else {
	
	     if (se1.value == "2" && se1.value != se2.value) { 
		 
		   if (confirm("Please confirm that you want to clear this candidate ?")) { 
		       ptoken.navigate('ApplicationFunctionDecision.cfm?id=#url.id#&id1=#url.id1#&process='+mde+'&box=#URL.box#&Owner=#Get.Owner#&Mode=#URL.Mode#&IDFunction=#URL.IDFunction#','processbox','','','POST','edit')
		    } else {  
			 return false
			} 
				
		  }	else { 
			  ptoken.navigate('ApplicationFunctionDecision.cfm?id=#url.id#&id1=#url.id1#&process='+mde+'&box=#URL.box#&Owner=#Get.Owner#&Mode=#URL.Mode#&IDFunction=#URL.IDFunction#','processbox','','','POST','edit')
		  } 
		  
		 }  
}


function memo(topic,row) {
		icE  = document.getElementById(topic+row+"Min");
		icM  = document.getElementById(topic+row+"Exp");
		se   = document.getElementById(topic+row);
				
		if (se.className =="hide") {
		   	 icM.className = "regular";
		     icE.className = "hide";
			 se.className  = "regular";						 
 		 } else {
		   	 icM.className = "hide";
		     icE.className = "regular";
		   	 se.className  = "hide";
		 }
	 }
		 
</script>

</cfoutput>
