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

<!--- container for topic maintenance object --->
<cfset Page         = "0">
<cfset add          = "1">
	
<table height="100%" width="96%" align="center" class="formpadding">

    <tr><td height="4"><cfinclude template = "../HeaderMaintain.cfm"></td></tr>			
    <tr><td height="4"></td></tr>				
	
	<tr>
	
	    <td style="height:100%" width="100%" id="listing">
				
		   <cf_TopicListingView 
		       systemmodule       = "Warehouse"
		       alias              = "appsMaterials"
			   language           = "Yes"
			   
			   <!--- Tables where topics are used --->
			   
			   topictable1        = "AssetItemTopic"
			   topictable1name    = "Asset"			     			   
   			   topicfield1        = "Topic"
			   topicscope1        = "Item"
			   topicscope1table   = "ItemTopic"
			   topicscope1field   = "ItemNo"
			   
   			   topictable2        = "ItemClassification"
			   topictable2name    = "EntryClass"					  
   			   topicfield2        = "Code"
			   topicscope2        = "EntryClass"
			   topicscope2table   = "Ref_TopicEntryClass"
			   topicscope2field   = "EntryClass"		
   			   			   
			   topictable3        = "AssetItemDetailTopic"
			   topictable3name    = "Details"				  
   			   topicfield3        = "Topic"
			   topicscope3        = "Item"
			   topicscope3table   = "ItemTopic"
			   topicscope3field   = "ItemNo"
			   
			   topictable4        = "ItemClassification"
			   topictable4name    = "Category"				  
   			   topicfield4        = "Topic"
			   topicscope4        = "Category"
			   topicscope4table   = "Ref_TopicCategory"
			   topicscope4field   = "Category">		
			   
		</td>
		
	</tr>		
	<tr><td height="5"></td></tr>				

</table>	