
<cfoutput>
<script language="JavaScript">

function informationdetail(sf,fc, cc, path, mission, id, cde) {
	if (path)
		window.open('../../../'+path+'?fid='+sf+'&FunctionSection='+fc+'&CellCode='+cc+'&mission='+mission+'&id='+id+'&code='+cde,"_blank", "left=30, top=30, width=800, height=600, toolbar=no, menubar=no, status=NO, scrollbars=no, resizable=no") 
}
</script>
</cfoutput>
