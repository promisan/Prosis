
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

				




