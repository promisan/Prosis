
<cfoutput>

<table style="width:100%">
		
	<tr><td valign="top" style="padding-top:5px;width:100%;padding-top:7px">
	
		<table style="width:100%">
						
		  <tr class="line"><td align="center" colspan="3" 
		  style="background-color:0A72AF;height:50px;width:100%;font-size:15px;font-weight:normal;color:white">#FunctionDescription#</td></tr>
		  
		  <tr style="background-color:88C4EC;height:32px;width:30%">
		  
		  <td colspan="1" style="width:30%;padding-left:4px">#SourcePostNumber# #PostGrade# </td>
		  
	      <!--- check if there is an active classification flow --->			  
		  <cfset url.ajaxid = "class_#PositionParentId#">
		   
		  <input type="hidden" 
		   name="workflowlink_#url.ajaxid#" 
		   id="workflowlink_#url.ajaxid#" 		   
		   value="StaffingPositionClassificationWorkflow.cfm">		
		   
		  <input type="hidden" 
		   name="workflowcondition_#url.ajaxid#" 
		   id="workflowcondition_#url.ajaxid#" 		   
		   value="?positionparentid=#PositionParentid#&ajaxid=#url.ajaxid#">	
		  
		  <td colspan="2" style="width:100%;height:23px;padding:4px;padding-right:6px" id="#url.ajaxid#">		  
		  
		  <cfif ApprovalPostGrade neq PostGrade and ApprovalPostGrade neq "">
		  
			  #ApprovalPostGrade#
		  
		  <cfelse>
		  			 
			   <cfinclude template="StaffingPositionClassificationWorkflow.cfm">			
					  
		  </cfif>	  
		  	  
		  </td>
		  </tr>
		  
		  <tr class="line" style="background-color:C1E0FF"><td colspan="3" style="padding-left:4px;width:100%">#PostType#/#PostClass#</td></tr>
		  <tr style="background-color:f1f1f1"><td style="padding-left:4px;min-width:90px"><cf_tl id="Assignment">:</td>
		      <td style="width:100%">#DateFormat(DateExpiration,client.dateformatshow)#</td>
			  <td style="background-color:yellow;padding:4px" align="center">Extension</td>
		  </tr>
		</table>
		
	</td></tr>
	
	<cfquery name="AssignDetail" dbtype="query">
		SELECT     *
		FROM       Assignment
		WHERE      PositionNo = '#PositionNo#' 
		ORDER BY   Incumbency DESC		
    </cfquery>	
	
	<cfif AssignDetail.recordcount eq "0">
	
		<tr><td style="height:110px;width:100%">
			     <table style="width:100%;height:100%">
				 <tr>
				 <td valign="top" style="text-align:center;background-color:##ffffaf50;border:1px solid silver;width:100%"><cf_tl id="Vacant"></td>		  								 
				 </tr>
				 </table>
			</tr>	 
	
	<cfelse>
		
		<cfloop query="AssignDetail" startrow="1" endrow="2">
		
			<cfquery name="getContract" 
				datasource="AppsEmployee" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT     *
					FROM       PersonContract
					WHERE      PersonNo = '#PersonNo#' 	
					AND        Mission IN ('UNDEF','#url.mission#')	
					AND        ActionStatus IN ('0','1')
					AND        DateEffective <= '#url.selection#'
					ORDER BY DateEffective DESC					
			  </cfquery>	
			
			<tr><td style="height:110px;width:100%">
			     <table style="width:100%;height:100%">
				 <tr>
				 <td valign="top" style="border:1px solid silver;width:100%;padding:2px">
					 <table style="width:100%">
					 <tr class="line">
					  <td valign="top" style="width:85px;padding-left:4px">
					  <cfif Gender eq "Female">
						  <cfset vPhoto = "#session.root#/Images/Logos/no-picture-female.png">
					  <cfelse>
						  <cfset vPhoto = "#session.root#/Images/Logos/no-picture-male.png">
					  </cfif>
					  <img src='#vPhoto#' class="img-circle clsRoundedPicture" style="height:85px; width:80px;">	
					  </td>
					  <td valign="top" style="padding:3px">
					  	<table style="width:100%">
						   <tr style="height:25px"><td colspan="1">#IndexNo#</td><td>#LastName#, #FirstName#</td></tr>		
						   <tr style="height:20px"><td></td><td colspan="1">#Nationality#</td></tr>				   
						   <tr style="height:25px">
						   <td>#getContract.ContractLevel#/#getContract.ContractStep#</td>
						   
						   <cfset url.ajaxid = "spa_#PositionParentId#">
	
							 <input type="hidden" 
								   name="workflowlink_#url.ajaxid#" 
								   id="workflowlink_#url.ajaxid#" 		   
								   value="StaffingPositionEventWorkflow.cfm">		
								   
							 <input type="hidden" 
								   name="workflowcondition_#url.ajaxid#" 
								   id="workflowcondition_#url.ajaxid#" 		   
								   value="?personno=#Personno#&positionparentid=#PositionParentid#&ajaxid=#url.ajaxid#&mde=spa">	
						   
						   <td align="center" id="#url.ajaxid#">
						   <cfset mde = "spa">
						   <cfinclude template="StaffingPositionEventWorkflow.cfm">	
						   </td>
						   </tr>
						   <tr style="height:25px">
						   <td>#dateformat(getContract.DateExpiration,client.dateformatshow)#</td>
						   
						   <cfset url.ajaxid = "ctr_#PositionParentId#">
	
							 <input type="hidden" 
								   name="workflowlink_#url.ajaxid#" 
								   id="workflowlink_#url.ajaxid#" 		   
								   value="StaffingPositionEventWorkflow.cfm">		
								   
							 <input type="hidden" 
								   name="workflowcondition_#url.ajaxid#" 
								   id="workflowcondition_#url.ajaxid#" 		   
								   value="?personno=#Personno#&positionparentid=#PositionParentid#&ajaxid=#url.ajaxid#&mde=ctr">	
						   
						   <td align="center" id="#url.ajaxid#">
						   <cfset mde = "ctr">
						   <cfinclude template="StaffingPositionEventWorkflow.cfm">	
						   </td>
						   </tr>
						   
						 </table>
					  </td>		  
					  </tr>	 
					 </table> 
				 </td>
				 
				 </tr>
				 </table>
			</td></tr>
				
		</cfloop>
				
	</cfif>	
			
	<cfset url.ajaxid = "recruit_#PositionParentId#">
	
	 <input type="hidden" 
		   name="workflowlink_#url.ajaxid#" 
		   id="workflowlink_#url.ajaxid#" 		   
		   value="StaffingPositionRecruitmentWorkflow.cfm">		
		   
	 <input type="hidden" 
		   name="workflowcondition_#url.ajaxid#" 
		   id="workflowcondition_#url.ajaxid#" 		   
		   value="?positionparentid=#PositionParentid#&ajaxid=#url.ajaxid#">	
	
	<tr class="line labelmedium">
	<td align="center" style="height:50px;padding:6px;width:100%;background-color:88C4EC;" id="#url.ajaxid#">
	
		<cfinclude template="StaffingPositionRecruitmentWorkflow.cfm">	
	
	</td>
	</tr>
	
</table>
</cfoutput>