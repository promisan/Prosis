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
<cfinclude template = "../HeaderMaintain.cfm"> 		
	
<table height="100%" width="96%" align="center" class="formpadding">
	   	
	<tr>
	
	    <td height="100%" width="100%" id="listing">
						
		   <cf_TopicListingView 
		       systemmodule      = "Accounting"
		       alias             = "appsLedger"
			   Language          = "Yes"
			   
			   topictable1       = "TransactionHeaderTopic"
			   topictable1name   = "Header"
			   topicfield1       = "Topic"
			   topicscope1       = "Ref_SpeedtypeTopic"
			   topicscope1table  = "Ref_SpeedType"
			   topicscope1field  = "Speedtype"
			   
			   topictable2       = "TransactionLineTopic"
			   topictable2name   = "Line"	
   			   topicfield2       = "Topic"
			   topicscope2       = "Ref_SpeedtypeTopic"
			   topicscope2table  = "Ref_SpeedType"
			   topicscope2field  = "Speedtype"
			   
			   topictable3       = "Ref_AccountTopic"
			   topictable3name   = "Account"		
   			   topicfield3       = "Topic"		  
			   topicscope3       = "Ref_SpeedtypeTopic"
			   topicscope3table  = "Ref_SpeedType"
			   topicscope3field  = "Speedtype">					   
			  			   
		</td>
		
	</tr>		
	<tr><td height="5"></td></tr>				

</table>	

				




