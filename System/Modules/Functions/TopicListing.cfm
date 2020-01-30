<cf_screentop 
	 height="100%"
     scroll="Yes" 
	 html="Yes" 
	 label="Portal Topics" 	 
	 layout="webdialog" 
	 banner="blue">

<script>
	function addtopicline(id) {
		window.showModalDialog("TopicEdit.cfm?id=" + id + "&ts="+new Date().getTime(), window, "unadorned:yes; edge:raised; status:no; dialogHeight:300px; dialogWidth:650px; help:no; scroll:no; center:yes; resizable:yes");	
		ColdFusion.navigate('TopicListingDetail.cfm','divTopicListing');
	}
	
	function purgetopicline(id) {
		ColdFusion.navigate('TopicPurge.cfm?id=' + id,'divTopicListing');
	}
</script>
	 
<table width="90%" align="center">
	<tr>
		<td>
			<cfdiv id="divTopicListing" bind="url:TopicListingDetail.cfm">
		</td>
	</tr>
</table>