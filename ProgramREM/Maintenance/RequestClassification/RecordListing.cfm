<!--
    Copyright © 2025 Promisan B.V.

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