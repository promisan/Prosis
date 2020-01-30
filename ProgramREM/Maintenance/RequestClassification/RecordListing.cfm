
<!--- container for topic maintenance object --->
<cf_divscroll>

<cfset Page         = "0">
<cfset add          = "1">
<cfinclude template = "../HeaderMaintain.cfm"> 		
	
<table width="96%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding">

	<tr><td height="1" class="line"></td></tr>
    <tr><td height="4"></td></tr>				
	<tr height="18">
	
	    <td width="100%" id="listing">
		
		   <cf_TopicListingView 
		       systemmodule      = "Program"
		       alias             = "appsProgram"
			   language          = "Yes"
			   topictable1       = "ProgramAllotmentRequestTopic"
			   topictable1name   = "Program"			  	  
   			   topicfield1       = "Code"
			   topicscope1       = "Ref_Object"
			   topicscope1table  = "Ref_TopicObject"
			   topicscope1field  = "ObjectCode"
			   
			   topictable2       = "ContributionTopic"
			   topictable2name   = "Contribution"			  	  
   			   topicfield2       = "Code"
			   topicscope2       = "Ref_ContributionClass"
			   topicscope2table  = "Ref_TopicContributionClass"
			   topicscope2field  = "ContributionClass">		
			   
		</td>
		
	</tr>		
	<tr><td height="5"></td></tr>				

</table>	
	
</cf_divscroll>