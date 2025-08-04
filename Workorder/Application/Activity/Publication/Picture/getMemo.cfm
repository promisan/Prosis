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

<cfoutput>

	<input type="Text" 
		id="pictureAttachmentMemo_#AttachmentId#" 	
		class="regularxl clsPictureAttachmentMemo" 
		value="#url.memo#" 
		style="width:375px;" 
		onchange="ColdFusion.navigate('#session.root#/WorkOrder/Application/Activity/Publication/Picture/setMemo.cfm?attachmentId=#url.newattachmentid#&memo='+encodeURIComponent(this.value),'process_#url.AttachmentId#');">																							
		
</cfoutput>	
