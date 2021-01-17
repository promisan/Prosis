<cf_screentop html="No" jquery="Yes">
<cf_divscroll>

<cfajaximport tags="cfform">

<cfoutput>

	<script>
	
		function recordadd() {
		   ptoken.navigate('RecordListingDetail.cfm?idmenu=#url.idmenu#&id2=new','listing');
		}
		
		function save(code) {
		   document.forms['mytopic'].onsubmit();
			if( _CF_error_messages.length == 0 ) {
		       ptoken.navigate('RecordListingSubmit.cfm?idmenu=#url.idmenu#&id2='+code,'listing','','','POST','mytopic');
			 }   
		 }
	 
	
	</script>
	
</cfoutput>
	
<cfset Page         = "0">
<cfset add          = "1">
<cfinclude template = "../HeaderMaintain.cfm"> 		
	
<table width="99%" align="center" class="formpadding">

    <tr><td height="4"></td></tr>				
	<tr>
	
	    <td width="100%" id="listing">
		<cfinclude template="RecordListingDetail.cfm">
		</td>
		
	</tr>		
	<tr><td height="5"></td></tr>				

</table>	
				
</cf_divscroll>

