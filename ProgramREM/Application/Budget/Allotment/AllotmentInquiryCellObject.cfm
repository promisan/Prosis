
<cfparam name="exe" default="0">
<cfparam name="url.ajaxload" default="0">
<cfparam name="planperiod" default="#url.period#">

<cfset val = 0>

<cfoutput>

  <table cellspacing="0" border="0"  cellpadding="0" width="100%">
  
	  <tr> 
	  	  
	  	<cfset fundlist = "#evaluate('list_#Edition#')#">
		 <cfif find(",", fundlist)>
		    <cfset fundlist = "#fundlist#,Total">
		 </cfif>  
		 <cfset row = 0>
					
		<cfloop index="Fund" list="#fundlist#" delimiters=",">
		
			<cfset row = row+1>
													
			<td align="right" style="padding-right:2px" class="labelit"
			    onclick="allotdetail('#url.program#','#planperiod#','#edition#','#fund#','#code#','#edition#','#par#')" #stylescroll#>			
															
				 <cfparam name="e#edition#mode" default="1">									 							
				 <cfif evaluate("e#edition#mode") eq "0">						 
				    <cfif row eq "1">
				 	<cf_space spaces="19">	
					</cfif><font color="C0C0C0">#vNoRights#</font>					 
 				 <cfelse>					 
					 <cfset blc = "0"> 								 				 
					 <cfif par eq "1">				 				 
					    <cfquery name="Subtotal" dbtype="query">
					      	  SELECT  SUM(Edition_#Edition#_#Fund#) as amount, 
							          SUM(Total) as total
						      FROM    Searchresult
						      WHERE   ParentCode = '#Code#' OR Code = '#Code#'
						</cfquery>					
						<cfset all = subtotal.amount>										
				 <cfelse>	   	  	        
				   <cfset all = evaluate("SearchResult.Edition_#Edition#_#Fund#")>
				   <cftry>
				   		<cfset blc = evaluate("SearchResult.Blocked_#Edition#_#Fund#")>
						<cfcatch></cfcatch>
				   </cftry>				   
				 </cfif>  				   							  			   				
				 <cfif Parameter.BudgetAmountMode eq "0">					 
					     <cf_space spaces="24">							 
						 <cfif all neq "0" and all neq "">								 								
						 	<cf_numbertoformat amount="#all#" present="1" format="number">
						 <cfelse>
						    <cfset val = "0">
						 </cfif>
	 			 <cfelse>			
						   				
					     <cf_space spaces="18">						
						 <cfif all neq "0" and all neq "">						
						    <cf_numbertoformat amount="#all#" present="1000" format="number1">
						 <cfelse>
						    <cfset val = "0">
						 </cfif>													
				 </cfif> 					 
				 <cfif blc gte "1">
				    <font color="red">#val#	
				 <cfelse>
				    <font color="a0a0a0">#val#	
				 </cfif>										 								
				 </cfif>	
				 							 
			</td>
			  
			<!--- --------------------- --->
			<!--- execution to be shown --->
			<!--- --------------------- --->			  		 		  
					 			  
			<cfif exe eq "1">
			  			  			  
				    <cfif par eq "1">		
					
						<!--- only used for inquiry on the fly subtotal --->	
				 			  
					   <cfquery name="Execution" 
					   dbtype="query">
					      SELECT  sum(Requisition_#Edition#_#Fund#) as Requisition, 
								  sum(Obligation_#Edition#_#Fund#) as Obligation, 
								  sum(Requisition_#Edition#_#Fund#)+sum(Obligation_#Edition#_#Fund#) as Expenditure, 
								  sum(Disbursement_#Edition#_#Fund#) as Disbursement
					      FROM    Searchresult
						  WHERE   ParentCode = '#Code#' OR Code = '#Code#'				  
			      	   </cfquery>
					   
					    <cfset req = Execution.requisition>
						<cfset obl = Execution.obligation>
						<cfset exp = Execution.expenditure>
						<cfset dis = Execution.disbursement>
																						
					<cfelse>	
					
						<!--- get from the query : listing or ajax  --->
				        						
					    <cfset req = evaluate("SearchResult.Requisition_#Edition#_#Fund#")>
						
						<cfset obl = evaluate("SearchResult.Obligation_#Edition#_#Fund#")>
						<cfset exp = 0>
						<cfif req neq "">
						   <cfset exp = req>						   
						</cfif>
						<cfif obl neq "">
						   <cfset exp = exp+obl>
						</cfif>		
									
						<cfset dis = evaluate("SearchResult.Disbursement_#Edition#_#Fund#")>									
									 
					</cfif>  						
															
					<cfparam name="client.execution#Edition#_#fund#" default="hide">
					
					<cfif url.ajaxload eq "1">
					    <cfset md = "#evaluate('client.execution#Edition#_#fund#')#">
					<cfelse>
						<cfset md = "hide">
					</cfif>		
					
					<!--- content for obligation --->					
																																	  			 
			  	    <td align="right" class="#md# labelit" name="Exec#edition##fund#" 
					 bgcolor="<cfif exp gt all and exp neq 0>FF8080</cfif>" style="border-right:1px dotted silver;border-left:1px dotted silver"
					 onclick="obligdetail('#url.program#','','#edition#','#fund#','#code#','#edition#','#par#','','','determine')" #stylescroll#>
																												
						<font color="green">
						<cfif Parameter.BudgetAmountMode eq "0">												
						
						    <cf_space spaces="24">															
							
							<cfif exp neq "0">
							 <cf_numbertoformat amount="#exp#" present="1" format="number">										
							<cfelse>
							 <cfset val = "0">
							</cfif>
							
					  	<cfelse>
											
							<cf_space spaces="19">
							
							<cfif exp neq "0">
							 <cf_numbertoformat amount="#exp#" present="1000" format="number1">										
							<cfelse>
							 <cfset val = "0">
							</cfif>
														
						</cfif> 	
						#val#						  	  		
						</font>								
																						
					</td>						
					
					<!--- content for disbursement --->										
					
				    <td name="Exec#edition##fund#" class="#md# labelit" align="right" bgcolor="<cfif dis gt all and exp neq 0>FF8080</cfif>" style="border-right:1px dotted silver;border-left:1px dotted silver"										  
					  onclick="disbursdetail('#url.program#','','#edition#','#fund#','#code#','#edition#','#par#','','','determine')" #stylescroll#>
					  			  			  
				  		<font color="379BFF">
				  				  								
					    <cfif Parameter.BudgetAmountMode eq "0">
						     
							 <cf_space spaces="24">							 
							 <cfif dis neq "0">
							    <cf_numbertoformat amount="#dis#" present="1" format="number">
							 <cfelse>
							    <cfset val = "0">
							 </cfif>	
														
					  	<cfelse>
						
							<cf_space spaces="19">
						 
							 <cfif dis neq "0">
							    <cf_numbertoformat amount="#dis#" present="1000" format="number1">
							 <cfelse>
							    <cfset val = "0">
							 </cfif>	
														
						</cfif>						  
							#val#					  	 
						 </font>
								
		 			</td>
							  						  
		   </cfif>	
			 						 
		</cfloop>
	
	</tr>
  </table>
   
  </cfoutput>  
  