
<cfoutput>

<script>

var root = "#SESSION.root#";

function email(to,subj,att,filter,src,srcid) {
	window.open(root + "/Tools/Mail/Mail.cfm?ID=" + to +"&ID1=" + subj + "&source=" + src + "&sourceid=" + srcid, "_blank", "width=800, height=635, status=yes, toolbar=no, scrollbars=no, resizable=no");
}

function excelformat(id,tables) {
     window.open(root + "/Tools/CFReport/Analysis/SelectSource.cfm?ControlId="+id+tables,"excelformat", "width=800, height=800, status=yes, toolbar=no, scrollbars=no, resizable=no");   
}

</script>

</cfoutput>
