<!--
    Copyright © 2025 Promisan B.V.

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