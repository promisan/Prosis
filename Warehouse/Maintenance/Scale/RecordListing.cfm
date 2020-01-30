
<cf_divscroll>

<cfajaximport tags="cfform">

<cfoutput>

	<script>
	
		function recordadd() {
		   ColdFusion.navigate('RecordListingDetail.cfm?idmenu=#url.idmenu#&id2=new','listing');
		}
		
		function save(code) {
		   document.forms['mytopic'].onsubmit();
			if( _CF_error_messages.length == 0 ) {
		       ColdFusion.navigate('RecordListingSubmit.cfm?idmenu=#url.idmenu#&id2='+code,'listing','','','POST','mytopic');
			 }   
		 }
	 
	
	</script>
	
</cfoutput>
	
<cfset Page         = "0">
<cfset add          = "1">
<cfinclude template = "../HeaderMaintain.cfm"> 		
	
<table width="99%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding">

    <tr><td height="4"></td></tr>				
	<tr>
	
	    <td width="100%" id="listing">
		<cfinclude template="RecordListingDetail.cfm">
		</td>
		
	</tr>		
	<tr><td height="5"></td></tr>				

</table>	
				
</cf_divscroll>

