
<cfoutput>

<script>

var root = "#SESSION.root#";

function email(to,subj,att,filter,src,srcid) {
	ptoken.open(root + "/Tools/Mail/Mail.cfm?ID=" + to +"&ID1=" + subj + "&source=" + src + "&sourceid=" + srcid, "_blank", "width=1000, height=735, status=yes, toolbar=no, scrollbars=no, resizable=no");
}

function excelformat(id,tables) {
     ptoken.open(root + "/Tools/CFReport/Analysis/SelectSource.cfm?ControlId="+id+tables,"excelformat", "width=800, height=800, status=yes, toolbar=no, scrollbars=no, resizable=no");   
}

</script>

</cfoutput>
