
<cf_actionListingScript>
<cf_FileLibraryScript>
<cf_dialogREMProgram>

<cfoutput>

<script language="JavaScript">

function moredetail(bx,act,id) {
	 
		icM  = document.getElementById(bx+"Min")		
	    icE  = document.getElementById(bx+"Exp")		
		se   = document.getElementById(bx);				
		frm  = document.getElementById("i"+bx);		
			 		 
		if (se.className == "hide") {
		    
		   	 icM.className  = "regular";			
		     icE.className  = "hide";			
			 se.className   = "regular";				
			 window.open("#SESSION.root#/ProgramREM/Application/Indicator/Audit/IndicatorAuditGraph.cfm?h=200&ts="+new Date().getTime()+"&id=" + id + "&period=#URL.Period#", "i"+bx)	        
		 
		 } else {
		     
		   	 icM.className = "hide";
		     icE.className = "regular";
			 se.className  = "hide"			
		 }
			 		
	  }	

function maxme(itm) {
	 
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

function hideN(ref,chk)	{
	
	se = document.getElementById("TargetValue"+ref)
	if (chk == true) { 
	  se.className = "disabled" 
	} else { 
	  se.className = "regular" }
	
	}
	
function hideR(ref,chk)	{
	
	se1 = document.getElementById("TargetCount"+ref)
	se2 = document.getElementById("TargetBase"+ref)
	se3 = document.getElementById("TargetValue"+ref)
	if (chk == true){  
	   se1.className = "disabled";
	   se2.className = "disabled"
	   se3.className = "disabled"}
	else { 
	    se1.className = "amount"
		se2.className = "amount"
		se3.className = "amount" 
	}
	
	}

function div(cnt,base,ratio) {

	x = document.getElementById(cnt)
	y = document.getElementById(base)
	z = document.getElementById(ratio)
	if (y.value != "0") {
        z.value = " " + Math.round((x.value/y.value) * 1000)/10 + "%" }
		else
		{
		z.value = "NaN"}

	}

function recordedit() {
	  window.location = "#SESSION.root#/programrem/application/indicator/audit/IndicatorAudit.cfm?ProgramCode=#URL.ProgramCode#&Period=#URL.Period#&Layout=#URL.Layout#&Mode=Edit&AuditId=#URL.AuditId#"
	}

function ppidrill(bx,act,id) {

	icM  = document.getElementById(bx+"Min")
    icE  = document.getElementById(bx+"Exp")
	se   = document.getElementById(bx);
	frm  = document.getElementById("i"+bx);

	if (se.className =="hide") {
	   	 icM.className = "regular";
	     icE.className = "hide";
		 se.className  = "regular";
		 window.open("#SESSION.root#/programrem/application/indicator/audit/IndicatorAuditGraph.cfm?h=#gh#&time=#now()#&id=" + id + "&period=#URL.Period#", "i"+bx,"scrollbars=no")
	 } else {
	   	 icM.className = "hide";
	     icE.className = "regular";
    	 se.className  = "hide"
	 }

  }

</script>

</cfoutput>