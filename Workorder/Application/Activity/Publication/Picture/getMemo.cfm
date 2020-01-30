
<cfoutput>

	<input type="Text" 
		id="pictureAttachmentMemo_#AttachmentId#" 	
		class="regularxl clsPictureAttachmentMemo" 
		value="#url.memo#" 
		style="width:375px;" 
		onchange="ColdFusion.navigate('#session.root#/WorkOrder/Application/Activity/Publication/Picture/setMemo.cfm?attachmentId=#url.newattachmentid#&memo='+encodeURIComponent(this.value),'process_#url.AttachmentId#');">																							
		
</cfoutput>	
