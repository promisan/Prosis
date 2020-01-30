<cfajaximport tags="cfform,cfdiv">

<cfoutput>

<script>

function recordadd_(grp) {
     window.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width= 450, height= 300, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

function typeedit(id1) {
     window.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "Edit", "left=80, top=80, width=1024, height=800, toolbar=no, status=yes, scrollbars=no, resizable=yes");
}

function recordadd() {
   ColdFusion.navigate('RecordListingDetail.cfm?idmenu=#url.idmenu#&code=new','listing')
}

function save(code) {

   document.mytopic.onsubmit() 
	if( _CF_error_messages.length == 0 ) {
       ColdFusion.navigate('RecordListingSubmit.cfm?idmenu=#url.idmenu#&code='+code,'listing','','','POST','mytopic')
	 }   
 }
 
function show(cde) {

	se = document.getElementById(cde)	
	if (se.className == "hide") {
		se.className  = "regular" 
		ColdFusion.navigate('List.cfm?claimtype='+cde,cde+'_list')
	} else {
		se.className  = "hide"		
	}
}

</script> 

</cfoutput>

<cf_screentop scroll="Yes" html="No">
	
<cfset Page         = "0">
<cfset add          = "1">
<cfset Header       = "Award">
<cfinclude template = "../HeaderCaseFile.cfm"> 
	
<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" >
 		
	<tr>
	    <td width="100%" id="listing">
			<cfinclude template="RecordListingDetail.cfm">
		</td>
	</tr>			

</table>	
				

