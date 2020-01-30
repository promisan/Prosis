
<cfoutput>

<script>

var root = "#session.root#";

w = 0
h = 0
if (screen) 
{
w = #CLIENT.width# - 60
h = #CLIENT.height# - 110
}

function showdocument(vacno,candlist,actionid) {
	    window.open(root + "/Vactrack/Application/Document/DocumentEdit.cfm?ID=" + vacno + "&IDCandlist=" + candlist + "&ActionId=" + actionid, "_blank", "left=20, top=20, width=" + w + ", height= " + h + ", status=yes, toolbar=no, scrollbars=no, resizable=yes");
}

function showdocumentcandidate(vacno,persno) {
        w = screen.width - 80;
        h = screen.height - 130;
	    window.open(root + "/VacTrack/Application/Candidate/CandidateEdit.cfm?ID=" + vacno + "&ID1=" + persno, "_blank", "left=30, top=30, width=" + w + ", height= " + h + ", status=yes, toolbar=no, scrollbars=no, resizable=yes");
}

function listing(box,ent,code,act) {

	icM  = document.getElementById("d"+box+"Min")
    icE  = document.getElementById("d"+box+"Exp")
	se   = document.getElementById("d"+box);
	frm  = document.getElementById("i"+box);
	 		 
	if (se.className == "hide") {
	 		 
     	 icM.className = "regular";
	     icE.className = "hide";
		 se.className  = "regular";
		// ColdFusion.navigate("ControlListingResultGradeDetail.cfm?now=#now()#&Box="+box+"&EntityCode="+ent+"&Code="+code, "i"+box)
		
	 } else {
   	 icM.className = "hide";
     icE.className = "regular";
	 se.className  = "hide"
	 
	 }
		 		
  }
  
</script>  
</cfoutput>

<table width="100%" border="0" cellspacing="0" cellpadding="0">

<cfoutput query = "Summary">
	    					
	 <cfif counted gt "0">
	
	  <tr class="line labelmedium"><td colspan="1" height="30" width="5%" align="center">
	 
		<img src="#SESSION.root#/Images/arrowright.gif" alt="" 
			id="d#URL.Mission##PostOrderBudget#Exp" border="0" class="show" 
			align="middle" style="cursor: pointer;" 
			onClick="listing('#URL.Mission##PostOrderBudget#','#URL.Entity#','#PostOrderBudget#','show')">
			
			<img src="#SESSION.root#/Images/arrowdown.gif" 
			id="d#URL.Mission##PostOrderBudget#Min" alt="" border="0" 
			align="middle" class="hide" style="cursor: pointer;" 
			onClick="listing('#URL.Mission##PostOrderBudget#','#URL.Entity#','#PostOrderBudget#','hide')">
			
		</td>
		<td colspan="2">#PostGradeBudget# [#counted#]</td>
		</tr>
	  			
	<tr><td></td>
	    <td colspan="3" align="center" class="hide" id="d#URL.Mission##PostOrderBudget#">	
			<cfset url.code = PostOrderBudget>
			<cfinclude template="ControlListingResultGradeDetail.cfm">	
			<!---
			<cfdiv id="i#URL.Mission##PostOrderBudget#"/>
			--->
    	</td>
	</tr>
				
	</cfif> 
						   			
</cfoutput>
	
</table>	