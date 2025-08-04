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
<cfoutput>

<cfparam name="exe" default="0">
<cfparam name="scp" default="">
<cfparam name="url.ajaxload" default="0">

<cfset val = 0>
		 		 
<table cellpadding="0" cellspacing="0" width="100%" border="0">
	 <tr>
	 	 	
	  	<cfset fundlist = "#evaluate('list_#Edition#')#">
		 <cfif find(",", fundlist)>
		    <cfset fundlist = "#fundlist#,Total">
		 </cfif>  
		 
		 <cfset col = "0">
		 
		  <cfloop index="Fund" list="#fundlist#" delimiters=",">
		    
			  <cfset col = col+1>
			  
			  <cfif col eq "1"> 				  
			    <cfset pad = "3">
			  <cfelse>			  
			  	<cfset pad = "1">
			  </cfif>
			  
			  <td align="right" style="padding-right:#pad#px" class="labelit">
			  
			  	<cfif par eq "1">			
			 						  
				   <cfquery name="Subtotal" dbtype="query">
				      SELECT  sum(Edition_#Edition#_#Fund#) as amount, 
					          sum(Total) as total
				      FROM    Searchresult
					  <cfif scp eq "Category">
					  WHERE   Category = '#Category#'
					  </cfif>
		      	   </cfquery>
					
				   <cfset all = subtotal.amount>
		
				<cfelse>	
			        
				    <cfset all = evaluate("SearchResult.Edition_#Edition#_#Fund#")>
		 
				</cfif>  					  				  	
								
				  <cfif fund eq "total">
				      <!--- <b> --->
				  </cfif>
				  																		
				  <cfif Parameter.BudgetAmountMode eq "0">
				         <cf_space spaces="24"> 
						 <cfif all neq "" and all neq "0">
							  <cf_numbertoformat amount="#all#" present="1" format="number">
						<cfelse>
							  <cfset val = 0>
						</cfif>
				  <cfelse>
				         <cf_space spaces="19">
						 <cfif all neq "" and all neq "0">
							  <cf_numbertoformat amount="#all#" present="1000" format="number1">
						<cfelse>
							  <cfset val = 0>
						</cfif>
				  </cfif> 
				  #val#			  				  
				  
			  </td>	 
			  
			  <!--- --------------------- --->
			  <!--- execution to be shown --->
			  <!--- --------------------- --->
			  
			  <cfif exe eq "1">
			  
				    <cfif par eq "1">		
					
						<!--- only used for inquiry --->	
				 						  
					   <cfquery name="Execution" dbtype="query">
					      SELECT  sum(Requisition_#Edition#_#Fund#) as Requisition, 
								  sum(Obligation_#Edition#_#Fund#) as Obligation, 
								  sum(Requisition_#Edition#_#Fund#+Obligation_#Edition#_#Fund#) as Expenditure, 
								  sum(Disbursement_#Edition#_#Fund#) as Disbursement
					      FROM    Searchresult
						  <cfif scp eq "Category">
						  WHERE   Category = '#Category#'
						  </cfif>						  
			      	   </cfquery>
					   
					    <cfset req = Execution.requisition>
						<cfset obl = Execution.obligation>
						<cfset exp = Execution.expenditure>
						<cfset dis = Execution.disbursement>
									
					<cfelse>	
					
						<!--- get from the query ajax --->
						
						<cfparam name="searchresult.Requisition_#Edition#_#fund#" default="0">	
						<cfparam name="searchresult.Obligation_#Edition#_#fund#" default="0">
						<cfparam name="searchresult.Disbursement_#Edition#_#fund#" default="0">
										        
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
								  			 
			  	    <td name="Exec#edition##fund#" 
					   class="#md# labelit" 
					   align="right" 					  			   
					   bgcolor="<cfif exp gt all and exp neq 0>FF8080</cfif>">
														
						<cfif Parameter.BudgetAmountMode eq "0">
						
						    <cf_space spaces="24">
							<cfif exp neq "" and exp neq "0">
							    <cf_numbertoformat amount="#exp#" present="1" format="number">
							<cfelse>
							     <cfset val = 0>
							</cfif> 	
							 
					  	<cfelse>
						
						    <cf_space spaces="20">
							<cfif exp neq "" and exp neq "0">
								<cf_numbertoformat amount="#exp#" present="1000" format="number1">
							<cfelse>
							    <cfset val = 0>
							</cfif>	
							
						</cfif> 				
			  	  		#val#
					
					</td>
			  
				    <td name="Exec#edition##fund#"
					   class="#md# labelit" 
					   align="right" 					 
					   bgcolor="<cfif dis gt all and exp neq 0>FF8080</cfif>">
					   					  			  
				  		<font color="379BFF">				  
					    <cfif Parameter.BudgetAmountMode eq "0">
						
							<cf_space spaces="24">
							<cfif dis neq "" and dis neq "0">
								<cf_numbertoformat amount="#dis#" present="1" format="number">
							<cfelse>
							     <cfset val = 0>
							</cfif>
							
					  	  <cfelse>
						  
						    <cf_space spaces="20">
							<cfif dis neq "" and dis neq "0">
								<cf_numbertoformat amount="#dis#" present="1000" format="number1">
							<cfelse>
							     <cfset val = 0>
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
		 