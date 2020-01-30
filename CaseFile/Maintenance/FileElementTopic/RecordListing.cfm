
<!--- container for topic maintenance object --->

<cf_divscroll>

<cfset Page         = "0">
<cfset add          = "1">
<cfinclude template = "../HeaderCaseFile.cfm"> 		
	
<table width="96%"  cellspacing="0" cellpadding="0" align="center" class="formpadding">

    <tr><td height="4"></td></tr>				
	<tr>
	
	    <td width="100%" id="listing">
		
		   <cf_TopicListingView 
		       systemmodule      = "Insurance"
		       alias             = "appsCaseFile"
			   language          = "Yes"
			   
			   topictable1       = "ElementTopic"
			   topictable1name   = "Element"			    
   			   topicfield1       = "Code"
			   
			   topicscope1      = "Ref_ElementClass"
			   topicscope1table = "Ref_TopicElementClass"
			   topicscope1field = "ElementClass">		
			   
		</td>
		
	</tr>		
	<tr><td height="5"></td></tr>				

</table>	

</cf_divscroll>