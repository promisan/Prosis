 <!--- check if workflow exists --->
		
 <cfquery name="CheckMission" 
	 datasource="AppsEmployee"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		 SELECT   *
		 FROM     Organization.dbo.Ref_EntityMission 
		 WHERE    EntityCode     = 'ProcPO'  
		 AND      Mission        = '#PO.Mission#' 
 </cfquery>	
 
 <cfoutput> 

 <table width="100%" border="0" cellspacing="0" cellpadding="0" align="right">
  	 	
 <cfif CheckMission.WorkflowEnabled eq "0" or CheckMission.RecordCount eq 0>		 
						 
	   <cfif ActionStatus eq "2" and (ApprovalAccess eq "EDIT" or ApprovalAccess eq "ALL")>
	   
	    <tr>	   
	      <input type="hidden" name="ActionStatusOld" id="ActionStatusOld" value="#ActionStatus#">
		   <td height="26" colspan="4" id="action" class="labelmedium">
	   
	   <cfelse>
	   
	    <tr>
	     <input type="hidden" name="ActionStatusOld" id="ActionStatusOld" value="#ActionStatus#">
	     <td height="30" colspan="4" class="labelmedium" style="padding-left:12px">
	   
	   </cfif>
	  		  	       				   
		      <cfquery name="Status" 
	          datasource="AppsPurchase" 
      		  username="#SESSION.login#" 
        	  password="#SESSION.dbpw#">
      			SELECT * 
        		FROM   Status
      			WHERE  StatusClass = 'Purchase'
				AND    Status      = '#PO.ActionStatus#' 
      		  </cfquery>
			   														  
		       <cfif ActionStatus lte 1 and URL.Mode eq "Edit">
			   
			   <table cellspacing="0" cellpadding="0">
			   <tr><td class="labelmedium">
			   
			   <cf_tl id="Submit for Approval">: 
			   
			   </td>
					
			   <td style="padding-left:2px">		   
			   <cfquery name="Parameter" 
				datasource="AppsPurchase" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				    SELECT *
				    FROM   Ref_ParameterMission
					WHERE  Mission = '#PO.Mission#' 
			   </cfquery>
			   
			   <input type="checkbox" name="ActionStatus" id="ActionStatus" class="radiol" value="2">
			   
			   </td></tr></table>
			   
			   <!--- disabled 
			  	   
			   <cfif Parameter.EnforceProgramBudget eq "1">
			        
			       <!--- mozambique scenario manual funding and not req review --->
				   <input type="checkbox" name="ActionStatus" value="2">					   
				   <!--- go directly to approval, this can be done also for quick PO's (10/7/05) --->
				   
			   <cfelse>			 
			      
			      <input type="checkbox" name="ActionStatus" value="1">
				  
			   </cfif>
			   
			   --->				     
			   
			   <cfelseif ActionStatus eq "2" 
			        and (ApprovalAccess eq "EDIT" or ApprovalAccess eq "ALL")>
										
						<script language="JavaScript">						
						
							function st(s) {
								ColdFusion.navigate('POViewStatusSet.cfm?id1=#url.id1#&st='+s,'action')
							}	
																		
						</script>				
								
					 <cfinclude template="POViewStatusSet.cfm"> 	
					 					 				 						  
			   <cfelse>
			   
			   <table cellspacing="0" cellpadding="0">
				   <tr>
					   <td class="labelmedium" style="padding-left:5px">		
						   <cfif actionStatus eq "9">
						   	   <font size="3" color="FF0000"><b>			  
						   <cfelse>
							   <font color="gray">
						   </cfif>  
					   		#Status.Description# <cfif PO.ActionStatus eq "3">: #DateFormat(PO.OrderDate,CLIENT.DateFormatShow)#</cfif>			   	   
					   </td>
					   <td class="hide"><input type="hidden" name="ActionStatus" id="ActionStatus" value="#ActionStatus#"></td>
					   <td align="right" id="processcancel" class="labelmedium" style="padding-left:20px">
					   			   
						   <cfif Invoice.recordcount eq "0" AND Receipt.recordcount eq "0" AND actionStatus neq "9">
						   
					    	    <cfif ApprovalAccess eq "ALL" or getAdministrator(PO.mission) eq "1">
									    <a href="javascript:_cf_loadingtexthtml='';ptoken.navigate('POCancelSubmit.cfm?purchaseNo=#PO.PurchaseNo#','processcancel')">
										<font color="red">[<cf_tl id="Press here">]</font>
										</a> 
										<cf_tl id="to Cancel this Purchase Order">				
								</cfif>
								
						   </cfif>	
						   					   
					   </td>				   
				   </tr>
			   </table>	
			   </cfif>
		   								   
		   </td>
		</tr>
		
</cfif>		

</table>

</cfoutput>