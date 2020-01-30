
<!--- container for topic maintenance object --->

<cf_divscroll>

<cfset add          = "1">
<cfset Header       = "Application topics/questions">
<cfinclude template = "../HeaderRoster.cfm"> 
	
<table width="96%"  cellspacing="0" cellpadding="0" align="center" class="formpadding">

    <tr><td height="4"></td></tr>				
	<tr>
	
	    <td width="100%" id="listing">
		
		  <cf_TopicListingView 
		       systemmodule       = "Roster"
		       alias              = "AppsSelection"
			   Language           = "Yes"
			   
			   topictable1        = "ApplicantBackgroundDetail"
			   topictable1name    = "Experience"			     			   
   			   topicfield1        = "Topic"
			   topicscope1        = "Background"
			   
			   topictable2        = "ApplicantSubmissionTopic"
			   topictable2name    = "Miscellaneous"			     			   
   			   topicfield2        = "Topic"
			   topicscope2        = "Miscellaneous"
			   
			   topictable3        = "ApplicantSubmissionTopic"
			   topictable3name    = "Skills"			     			   
   			   topicfield3        = "Topic"
			   topicscope3        = "Miscellaneous"
			   
			   topictable4        = "ApplicantSubmissionTopic"
			   topictable4name    = "Medical"			     			   
   			   topicfield4        = "Topic"
			   topicscope4        = "Miscellaneous" >		
			   
		</td>
		
	</tr>		
	<tr><td height="5"></td></tr>				

</table>	

</cf_divscroll>