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
<cfparam name="url.mode" default="standard">
<cfparam name="mode" default="#url.mode#">

<cfif mode eq "standard">
	
	<cfinvoke component = "Service.Process.Program.Program"  
	   method           = "SyncProgramBudget" 
	   ProgramCode      = "#url.Program#" 
	   Period           = "#url.Period#"
	   EditionId        = "#url.Edition#">	
   
</cfif>   

<cfquery name="Allotment" 
  datasource="AppsProgram" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
	  SELECT     *
	  FROM       ProgramAllotment
	  WHERE      ProgramCode = '#URL.Program#'
	  AND        Period      = '#url.period#'
	  AND        EditionId   = '#URL.Edition#'	   
</cfquery>
  
<cfquery name="Edit" 
  datasource="AppsProgram" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
	  SELECT     *
	  FROM       Ref_AllotmentEdition
	  WHERE      EditionId = '#URL.Edition#'	   
</cfquery>
 
<cfquery name="Parameter" 
  datasource="AppsProgram" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
	  SELECT     *
	  FROM       Ref_ParameterMission
	  WHERE      Mission = '#edit.Mission#'	   
</cfquery>
 
<cfif allotment.SupportPercentage gte "1" and allotment.SupportObjectCode neq "">
 
 		<cfset support = "1">
		
<cfelse>
 
 		<cfset support = "0">
 
</cfif>

<cfquery name="EditionFund" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT   EditionId, 
		         ltrim(rtrim(Fund)) as Fund,
				 (SELECT TOP 1 ProgramCode 
				  FROM ProgramAllotmentDetail WHERE EditionId = F.EditionId and Fund = F.Fund AND ProgramCode = '#url.program#') as Used
		FROM     Ref_AllotmentEditionFund F
		WHERE    EditionId = '#URL.edition#'		
		ORDER BY EditionId,Fund
</cfquery>

<cf_tl id="Pending"  var="1">
<cfset vPending=#lt_text#>

<cf_tl id="Clear"  var="1">
<cfset vClear=#lt_text#>

<cf_tl id="Revoke"  var="1">
<cfset vRevoke=#lt_text#>

<table width="99%" class="navigation_table">
				
	<tr class="line labelmedium">
		<td width="100"><cf_tl id="Requirement"></td>
		<td width="20%"><cf_tl id="Officer"></td>
		<td width="11%"><cf_tl id="Date"></td>
		<td width="10%"><cf_tl id="Org"></td>
		<td width="6%"><cf_tl id="Currency"></td>
		<td width="13%" align="right"><cf_tl id="Amount"></td>
		<td width="10%" align="right"><cf_tl id="Ex. Rate"></td>
		<td width="13%" align="right"><cf_tl id="#Parameter.BudgetCurrency#"></td>
	</tr>
				
		<cfloop query="EditionFund">				
				
			<cfif used neq "">
				
					<cfquery name="SearchResult" 
					datasource="AppsProgram" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT   A.ObjectCode as Code,
						         R.CodeDisplay,
						         R.ParentCode,
								 R.Description,
						         R.ListingOrder, 
								 R.Resource, 
								 A.TransactionType,
								 S.Description AS Category,
								 SUM(A.Amount) AS Amount
						FROM     ProgramAllotmentDetail A INNER JOIN
	                    		 Ref_Object R ON A.ObjectCode = R.Code INNER JOIN
				                 Ref_Resource S ON R.Resource = S.Code		
						WHERE    EditionId   = '#url.edition#' 
						AND      ProgramCode = '#url.program#' 
						AND      Period      = '#url.period#' 
						AND      Fund        = '#fund#' 
						AND      ABS(A.Amount) > 1
						
						AND      A.Status IN ('0','1')   <!--- neq '9' --->
						
						GROUP BY S.Description,
						         S.ListingOrder, 
								 R.CodeDisplay,
						         R.ListingOrder, 
								 A.ObjectCode, 
								 A.TransactionType,
								 R.Description, 
								 R.Resource, 
								 R.ParentCode											
						
						ORDER BY A.TransactionType, S.ListingOrder, R.ListingOrder		
					</cfquery>						
				
															
					<cfquery name="Subtotal" dbtype="query">
						      SELECT  SUM(Amount) as amount
						      FROM    Searchresult
			        </cfquery>
					
					<cfquery name="Pending" 
					datasource="AppsProgram" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT   SUM(A.Amount) AS Amount
						FROM     ProgramAllotmentDetail A 
						WHERE    EditionId   = '#url.edition#' 
						AND      ProgramCode = '#url.program#' 
						AND      Period      = '#url.period#' 
						AND      Fund        = '#fund#' 
						AND      ABS(A.Amount) > 1						
						AND      A.Status IN ('0')   <!--- neq '9' --->																				
					</cfquery>					
											
					<cfif subtotal.recordcount gte "1">
								
						<cfoutput>						
						
							<tr class="line">
							  <td height="24" style="padding-top:8px" colspan="5" class="labellarge">#Fund#</td>
							
							  <td align="right" style="padding-top:8px" colspan="3">
							  <table cellspacing="0" cellpadding="0">
							  	<tr><td class="labellarge" style="padding-left:7px;padding-right:0px;height:40px;font-size:25px">
								  #NumberFormat(subtotal.amount,",")#&nbsp;
								  <cfif pending.amount gte "1">
									  <font color="green">(#NumberFormat(Pending.amount,",")#)</font>
								  </cfif>
								  </b>
								  
								  </td>
								</tr>
							  </table>
							  </td>		
							  					 
							</tr> 
													
						</cfoutput>			
												
						<cfset fd = fund>
						
						<!--- <tr><td colspan="7" style="height:31" class="labelmedium"><font color="008040"><b>* Financial Requirements</td></tr> --->
						
							 <cfquery name="SearchResultList" dbtype="query">
						      	  SELECT  *
							      FROM    Searchresult
								  WHERE TransactionType = 'Standard'
						       </cfquery>		
						
							  <cfoutput query="SearchResultList" group="Category">	
														
								
								<tr>
								  <td colspan="7" style="height:33;padding-left:5px;font-size:20px" class="labelmedium">#Category#</b></td>
								  
								    <cfquery name="LineTotal" dbtype="query">
								      SELECT  SUM(amount) as amount
								      FROM    Searchresult
								      WHERE   Category = '#Category#'
									</cfquery>
								      
								    <td align="right" style="padding-right:10px;font-size:20px" class="labelmedium">#NumberFormat(LineTotal.amount,",")#</b>
									</td>
									
								</tr> 		
								
								<tr><td colspan="8" class="line"></td></tr>			
								 
									<cfoutput group="ListingOrder">
									
										<cfoutput group="Code">										
																				
											 <cfquery name="Parent" 
											datasource="AppsProgram" 
											username="#SESSION.login#" 
											password="#SESSION.dbpw#">
												SELECT     *
												FROM       #CLIENT.LanPrefix#Ref_Object
												WHERE      ParentCode = '#Code#'	   
											</cfquery>
										
										   <cfif Parent.recordCount eq "0">
										
										   <cfif ParentCode eq "">
										
											   <tr class="line">
											     <td colspan="7" class="labelit"  style="height:19;padding-left:4px">#CodeDisplay# #Description#</td>
												 
											     <td class="labelit" style="padding-right:20px" align="right">						    	 
												  #NumberFormat(amount,",.__")#</td>
												 </tr> 												 
																																   
											 	<cfinclude template="AllotmentViewLines.cfm">
												
										   <cfelse>
										
											   <tr class="line">
											     <td colspan="7" class="labelit" style="height:19;padding-left:10px">#CodeDisplay# #Description#</td>
												 <td align="right" class="labelit" style="padding-right:20px">										   	  
												  #NumberFormat(amount,",.__")#
												 </td>
											   </tr> 		
											    										
											   <cfinclude template="AllotmentViewLines.cfm">
											   											 
										   </cfif>
										
										<cfelse>
										
										  <tr>
										  <td colspan="7" class="labelit" style="padding-left:10px;height:19">#CodeDisplay# #Description#</td>
										    
										    <cfquery name="Objecttotal" dbtype="query">
										      SELECT   sum(amount) as amount
										      FROM     Searchresult
										      WHERE   (ParentCode = '#Code#' or Code = '#Code#')
											</cfquery>
										      
										    <td align="right" class="labelit" style="padding-right:20px">
										    	<b>#NumberFormat(ObjectTotal.amount,",.__")#
											</td>
										  </tr> 	
										  										  
										  <cfinclude template="AllotmentViewLines.cfm">
										
										</cfif>
										
										</cfoutput>
										
									</cfoutput>
																					
							</cfoutput>	
			
							<!--- -------------------------------------------- --->
							<!--- ------Support cost overhead box per fund---- --->
							<!--- -------------------------------------------- --->							
														
							<cfif allotment.SupportPercentage gte "1" 
							     and allotment.SupportObjectCode neq "">	
																
								<cfquery name="Subtotal" dbtype="query">
						      	  SELECT  SUM(Amount) as amount
							      FROM    Searchresult
								  WHERE   TransactionType = 'Support'
						        </cfquery>							
							    					
								<tr><td colspan="7" style="padding-left:5px;height:40px;font-size:20px" class="labelmedium"><font color="008040">Calculated Program Support</td>
								    <td align="right" style="padding-right:10px;height:40px;font-size:20px" class="labelmedium"><cfoutput>#NumberFormat(subtotal.amount,"___,___.__")#</cfoutput></td>	
								</tr>
								<tr><td colspan="8" class="line"></td></tr>
								
								<cfquery name="SupportList" dbtype="query">
						      		SELECT  *
							        FROM    Searchresult
									WHERE   TransactionType = 'Support'
						        </cfquery>
								
								 <cfquery name="Objects" 
									datasource="AppsProgram" 
									username="#SESSION.login#" 
									password="#SESSION.dbpw#">
						      		SELECT  *
							        FROM    Ref_Object
									WHERE   Code IN (#quotedValueList(SearchResult.Code)#)
									AND     SupportEnable = 1
						        </cfquery>
								
								<cfif supportList.recordcount eq "0" and Objects.recordcount gte "1">
								
									<script>
									 alert("There is a problem with the form being loaded. Please close this screen and open it again")
									 window.close()
									</script>
								
								<cfelse>
																										 
							    <cfoutput query="SupportList">
																		
									 <tr>
									  
									    <td colspan="7" style="height:21;padding-left:20px" class="labelit">#Code#/#CodeDisplay# #Description#</td>		
										
										   <cfquery name="Subtotal" dbtype="query">
												      SELECT  sum(amount) as amount
												      FROM    Searchresult
												      WHERE   (ParentCode = '#Code#' or Code = '#Code#')
											</cfquery>
														  
									    <td align="right" id="#fd#_support" style="padding-right:40px"><u>#NumberFormat(subtotal.amount,"___,___.__")# </u></td>
										
									 </tr> 													
									
									 <cfinclude template="AllotmentViewLines.cfm">
								 								  
								</cfoutput> 	
								
								</cfif>				
							
							</cfif>			
					
					</cfif>
					
				</cfif>		
				
		</cfloop>		

	</td></tr>

</table>
