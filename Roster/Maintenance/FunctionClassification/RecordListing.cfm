
<cfajaximport tags="cfform,cfdiv">

<script>

function recordadd() {
   ColdFusion.navigate('RecordListingDetail.cfm?code=new','listing')
}

function save(code) {

   document.mytopic.onsubmit() 
	if( _CF_error_messages.length == 0 ) {
       ColdFusion.navigate('RecordListingSubmit.cfm?code='+code,'listing','','','POST','mytopic')
	 }   
 }
 
function show(cde) {

	se = document.getElementById(cde);

	if (se.className == "hide") {
		se.className  = "regular" 
		ColdFusion.navigate('List.cfm?parentcode='+cde,cde+'_list')
	} else {
		se.className  = "hide"				
	}
	
}

</script> 
	
<cfset add          = "1">
<cfinclude template = "../HeaderRoster.cfm"> 		

<cf_divscroll>
<table width="97%" cellspacing="0" cellpadding="0" align="center">
		
	<tr>
	
	    <td width="100%" id="listing">
			<cfinclude template="RecordListingDetail.cfm">
		</td>		
	</tr>		
	<tr><td height="5"></td></tr>				

</table>	
				
</cf_divscroll>
