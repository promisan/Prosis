
<cfajaximport tags="cfform,cfdiv">

<script>

	function recordadd() {
	   ptoken.navigate('RecordListingDetail.cfm?code=new','listing')
	}
	
	function save(code) {
	
	   document.myelement.onsubmit() 
		if( _CF_error_messages.length == 0 ) {
	       ptoken.navigate('RecordListingSubmit.cfm?code='+code,'listing','','','POST','myelement')
		 }   
	 }
	 
	function show(cde) {
	
		se = document.getElementById(cde)	
		if (se.className == "hide") {
			se.className  = "regular" 
			ptoken.navigate('List.cfm?element='+cde,cde+'_list')
		} else {
			se.className  = "hide"		
		}
	}

</script> 


<cf_screentop html="No" jquery="Yes">

<table width="98%" height="100%">

<cfset Page         = "0">
<cfset add          = "1">
<cfset save         = "0"> 
<cfset Header       = "Element">
<tr style="height:10px"><td><cfinclude template = "../HeaderCaseFile.cfm"> </td></tr>

<tr><td>

	<cf_divscroll>
	
	<table width="100%" align="center">
	  		
		<tr>
		
		    <td width="100%" id="listing">
			<cfinclude template="RecordListingDetail.cfm">
			</td>
			
		</tr>		
		<tr><td height="5"></td></tr>				
	
	</table>	
				
	</cf_divscroll>
	
	</td>
</tr>

</table>	
	