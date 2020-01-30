
<cfajaximport tags="cfform,cfwindow">

<script>

function recordadd() {
   ColdFusion.navigate('RecordListingDetail.cfm?id2=new','listing')
}

function save(code) {

   document.mytopic.onsubmit() 
	if( _CF_error_messages.length == 0 ) {
       ColdFusion.navigate('RecordListingSubmit.cfm?id2='+code,'listing','','','POST','mytopic')
	 }   
 }

</script>

<cf_divscroll>

<cfset Page         = "0">
<cfset add          = "1">
<cfinclude template = "../HeaderMaintain.cfm"> 		
	
<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" >

    <tr><td height="4"></td></tr>				
	<tr>
	
	    <td width="100%" id="listing">
		<cfinclude template="RecordListingDetail.cfm">
		</td>
		
	</tr>		
	<tr><td height="4"></td></tr>				

</table>	
				
</cf_divscroll>