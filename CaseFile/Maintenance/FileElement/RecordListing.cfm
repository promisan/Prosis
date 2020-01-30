
<cfajaximport tags="cfform,cfdiv">

<script>

	function recordadd() {
	   ColdFusion.navigate('RecordListingDetail.cfm?code=new','listing')
	}
	
	function save(code) {
	
	   document.myelement.onsubmit() 
		if( _CF_error_messages.length == 0 ) {
	       ColdFusion.navigate('RecordListingSubmit.cfm?code='+code,'listing','','','POST','myelement')
		 }   
	 }
	 
	function show(cde) {
	
		se = document.getElementById(cde)	
		if (se.className == "hide") {
			se.className  = "regular" 
			ColdFusion.navigate('List.cfm?element='+cde,cde+'_list')
		} else {
			se.className  = "hide"		
		}
	}

</script> 

<cf_divscroll>

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
	<tr><td height="5"></td></tr>				

</table>	
				
</cf_divscroll>