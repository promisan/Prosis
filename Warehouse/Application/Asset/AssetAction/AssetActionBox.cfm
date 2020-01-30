
<cf_screentop height="100%" scroll="No" label="Action" html="Yes" layout="innerbox">

<cfparam name="URL.Assetid" default="">
<cfparam name="URL.List" default="">

<cfajaximport tags="cfform,cfinput-datefield>

<cfoutput>

	<script>
	
	function navigate(assetid) {
	   ColdFusion.navigate('AssetAction.cfm?assetid='+assetid+'&list=#url.list#&assetactionid=new','asset')
	}
		
	function save(assetid,code,id) {
	
	   document.getElementById('action'+code).onsubmit() 
		if( _CF_error_messages.length == 0 ) {
	       ColdFusion.navigate('AssetActionContentSubmit.cfm?assetid='+assetid+'&code='+code+'&assetactionid='+id,'box'+code,'','','POST','action'+code)
		 }   
	 }
	 
	</script> 

</cfoutput>

<!--- asset entry container --->

<table width="100%" cellspacing="0" cellpadding="0" height="100%">
<tr>
<td height="100%">

	<cfdiv bind="url:AssetAction.cfm?assetid=#url.assetid#&list=#url.list#" id="asset">

</td>
</tr>
<tr><td height="5"></td></tr>
</table>

<cf_screenbottom layout="innerbox">