
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