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