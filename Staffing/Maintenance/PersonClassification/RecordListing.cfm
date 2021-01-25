
<cfajaximport tags="cfform,cfdiv">

<cf_screentop html="No" jquery="Yes">

<cfset Page         = "0">
<cfset add          = "1">

<table width="98%" align="center" height="100%">

<tr style="height:10px"><td><cfinclude template = "../HeaderMaintain.cfm"></td></tr>
	
	<script language="JavaScript">
	
	function recordadd() {
	   ptoken.navigate('RecordListingDetail.cfm?id2=new','listing')
	}
	
	function save(code) {
	
	   document.mytopic.onsubmit() 
		if( _CF_error_messages.length == 0 ) {
	       ptoken.navigate('RecordListingSubmit.cfm?id2='+code,'listing','','','POST','mytopic')
		 }   
	 }
	
	</script>

	<tr><td>
	
	<cf_divscroll>
		
	<table width="100%" align="center" >
	
	    <tr><td height="4"></td></tr>				
		<tr>
		
		    <td width="100%" id="listing">
			<cfinclude template="RecordListingDetail.cfm">
			</td>
			
		</tr>		
		<tr><td height="4"></td></tr>				
	
	</table>	
					
	</cf_divscroll>
	
	</td></tr>

</table>