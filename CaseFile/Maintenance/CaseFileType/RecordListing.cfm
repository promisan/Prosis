<cfajaximport tags="cfform,cfdiv">

<cf_screentop jquery="Yes" html="No">

<table width="97%" align="center" height="100%">

<cfset Page         = "0">
<cfset add          = "1">
<cfset save         = "0"> 
<cfset Header       = "Case file type">
<tr style="height:10px"><td><cfinclude template="../HeaderCaseFile.cfm"> </td></tr>

<cfoutput>
	
	<script>
	
	function recordadd_(grp) {
	     ptoken.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width=550, height= 300, toolbar=no, status=yes, scrollbars=no, resizable=no");
	}
	
	function typeedit(id1) {
	     ptoken.open('RecordEdit.cfm?idmenu=#url.idmenu#&ID1=' + id1, id1+'Edit');
	}
	
	function recordadd() {
	     ptoken.navigate('RecordListingDetail.cfm?idmenu=#url.idmenu#&code=new','listing')
	}
	
	function save(code) {
	
	   document.mytopic.onsubmit() 
		if( _CF_error_messages.length == 0 ) {
	       ptoken.navigate('RecordListingSubmit.cfm?idmenu=#url.idmenu#&code='+code,'listing','','','POST','mytopic')
		 }   
	 }
	 
	function show(cde) {
	
		se = document.getElementById(cde)	
		if (se.className == "hide") {
			se.className  = "regular" 
			ptoken.navigate('List.cfm?claimtype='+cde,cde+'_list')
		} else {
			se.className  = "hide"		
		}
	}
	
	</script> 

</cfoutput>

<tr><td valign="top">
	
<table width="95%" height="100%" align="center">
 		
	<tr>
	    <td height="100%" width="100%" id="listing" valign="top">
			<cfinclude template="RecordListingDetail.cfm">
		</td>
	</tr>			

</table>	

</td></tr>

</table>
				

