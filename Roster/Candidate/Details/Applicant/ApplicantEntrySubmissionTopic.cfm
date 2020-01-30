<cfparam name="url.Source"       default="">
<cfparam name="url.ApplicantNo"  default="">

<cfquery name="Master" 
		datasource="AppsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		
		SELECT    T.*
					   
		FROM      Ref_SourceTopic S INNER JOIN
                  #CLIENT.LanPrefix#Ref_Topic T ON S.Topic = T.Topic
		WHERE     S.Source = '#url.source#' AND  S.Operational = 1 
		ORDER BY S.ListingOrder		
</cfquery>	

<table width="100%" class="formpadding">
			
<cfoutput>		

	<cfloop query="Master">									  	 
		 
		  <tr class="labelit"> 	
		  	 							
			  								  
			  <cfif valueClass eq "List">	
			  
			  <!---
					onclick="showtopiccode('#topic#','#listcode#',document.getElementById('Value_#topic#_selected').value)" --->
										 					  														  				  
				  <td width="250"				     					
				    style="font-size:15px;padding-top:2px;height:14px" align="left">#Question# <cfif ValueObligatory eq "1"><font color="D90000">*</font></cfif>
				  </td>				
				  
			  <cfelse>										  
			  					  
				  <td width="250"	class="ccontent navigation_action" 
				    style="font-size:15px;padding-top:2px;height:14px" align="left">#Question# <cfif ValueObligatory eq "1"><font color="D90000">*</font></cfif>
				  </td>										  
				  										  
			  </cfif>		
			  	  
			  <td style="padding-left:1px;padding-right:5px">
			  			  
			  	   <cfparam name="attributes.value" default="">
				   		  										  										  										
				   <cf_TopicEntry 		
				       Mode="Regularxl"		       								   
				       ApplicantNo="#URL.ApplicantNo#" 
					   Attachment="#Attachment#"
					   Tooltip="1"	
					   Value="#attributes.value#"
			           Topic="#Topic#">
					  			
			  </td>
			 
		  </tr>
								  
		  <cfif QuestionCondition neq "">
			  
			  <tr>
				  <td></td>
				  <td class="labelmedium" colspan="4"><b>Note:&nbsp;</b>#QuestionCondition#</i></td>
			  </tr>
			  
		  </cfif>
													  		  
	</cfloop>		  		
		
</cfoutput>

</table>