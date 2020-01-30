
<cfoutput>

<cfset root = "#SESSION.root#">

<script>
	
	var root = "#root#";
	
	w = 0
	h = 0
	
	if (screen) {
		w = #CLIENT.width# - 60
		h = #CLIENT.height# - 110
	}
	
	function showdocument(vacno,candlist) {	
	//	window.open(root + "/Vactrack/Application/Document/DocumentEdit.cfm?ID=" + vacno + "&IDCandlist=" + candlist, "_blank", "left=20, top=20, width=" + w + ", height= " + h + ", status=yes, toolbar=no, scrollbars=no, resizable=yes");
	    ptoken.open(root + "/Vactrack/Application/Document/DocumentEdit.cfm?ID=" + vacno + "&IDCandlist=" + candlist, "track"+vacno);
	}
	
	function showdocumentcandidate(vacno,persno) {	
	    w = screen.width - 80;
	    h = screen.height - 130;
		ptoken.open(root + "/VacTrack/Application/Candidate/CandidateEdit.cfm?ID=" + vacno + "&ID1=" + persno, persno);
	}
	
	function searchview(vacno,id) {  
	   ptoken.open(root + "/Roster/RosterGeneric/RosterSearch/ResultListing.cfm?back=0&docno=&ID=GEN&ID1="+id+"&ID2=B&ID3=GEN&height=#client.height-160#", "_blank", "left=30, top=30, width=" + w + ", height= " + h + ", status=yes, toolbar=no, scrollbars=no, resizable=yes");
	}

</script>

</cfoutput>