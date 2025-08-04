<!--
    Copyright © 2025 Promisan

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->
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