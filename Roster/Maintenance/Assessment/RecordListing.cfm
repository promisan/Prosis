

<cfset Page         = "0">
<cfset add          = "1">
<cfset Header       = "Candidate Class">

<cf_screentop html="No" jquery="Yes">

<table width="98%" height="100%">

<tr style="height:10px"><td><cfinclude template = "../HeaderRoster.cfm"></td></tr>

<cfajaximport tags="cfform">

<script>

function recordadd() {
   ptoken.navigate('RecordListingDetail.cfm?code=new','listing')
}

function save(code) {

   document.mytopic.onsubmit() 
	if( _CF_error_messages.length == 0 ) {
       ptoken.navigate('RecordListingSubmit.cfm?code='+code,'listing','','','POST','mytopic')
	 }   
 }
 
</script>

<tr><td>

	<cf_divscroll>
	<table width="97%" align="center">	 
	
	    <tr><td class="labelmedium2">This table contains the elements to be used in order to classify a candidate's assessment</td></tr> 		
		<tr>		
		    <td width="100%" id="listing">
			<cfinclude template="RecordListingDetail.cfm">
			</td>			
		</tr>		
		<tr><td height="5"></td></tr>					
	</table>	
	</cf_divscroll>

</td></tr>

