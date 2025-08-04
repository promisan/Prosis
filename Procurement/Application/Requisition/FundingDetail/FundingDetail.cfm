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

<cfparam name="URL.access" default="EDIT">

<cfquery name="Requisition" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   RequisitionLine
	WHERE  RequisitionNo = '#URL.ID#'	
</cfquery>

<cfquery name="Funding" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   RequisitionLineFunding
	WHERE  RequisitionNo = '#URL.ID#'
	AND    Fundingid     = '#URL.FundingId#'
</cfquery>

<cfquery name="Detail" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   RequisitionLineFundingDetail 
	WHERE  RequisitionNo = '#URL.ID#'
	AND    Fundingid     = '#URL.FundingId#'
</cfquery>

<cfquery name="AccountInfoList" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   stAccountInfo 	
	WHERE Mission      = '#Requisition.Mission#'
	AND   Period       = '#Requisition.Period#' 
	AND   AccountFund  = '#Funding.Fund#' 
</cfquery>
			
	<cfif Detail.recordcount eq "0">
	   <cfparam name="URL.ID2" default="new">
	<cfelse>
	   <cfparam name="URL.ID2" default="">   
	</cfif>
        
		
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
		    
	  <tr>
	    <td width="100%">
		
	    <table border="0" width="100%" cellspacing="0" cellpadding="0" class="formpadding">
		
			<tr><td height="4"></td></tr>
			
			<cfif detail.recordcount gte "1" or url.access eq "edit">
									
		    <tr class="line labelmedium">
			
			     <td width="30"><cf_tl id="No">.</td> 
			     <td width="120"><cf_tl id="Program"></td>     
			     <td width="150"><cf_tl id="Budget details"></td>
				 <td width="70" align="right"><cf_tl id="Amount"></td>		
				 <td width="100" align="right"><cf_tl id="Officer"></td>     		  
				 <td width="100" align="right"><cf_tl id="Updated"></td>   
			     <td width="30" align="right" style="padding-left:4px">
		         <cfoutput>
				 
				 <cfif url.access eq "Edit">
				 
				 <cfif AccountInfoList.recordcount eq "0">
				 
				 	 <cfif URL.ID2 neq "new">
					     <A href="javascript:ColdFusion.navigate('../FundingDetail/FundingDetail.cfm?id=#url.id#&FundingId=#URL.FundingId#&ID2=new','i#URL.FundingId#')"><font color="0080FF">[add]</font></a>
					 </cfif>
				 
				 <cfelse>
				  					
				     <A href="javascript:staccountfunding('#URL.ID#','#URL.FundingId#')"><font color="6688aa">Maintain</font></a>
										 
				 </cfif>	
				 
				 </cfif> 
				 				 
				 </cfoutput>
			      </td>
			  
		    </TR>	
						
			</cfif>
						
			<cfoutput query="Detail">								
															
			<cfif URL.ID2 eq detailno>
			
				<tr><td height="2"></td></tr>
			    <input type="hidden" name="id" id="id" value="#requisitionNo#">
				<input type="hidden" name="fundingid" id="fundingid" value="#fundingid#">
													
				<TR class="labelmedium line">
				 <td>#DetailNo#</td>
				    <td height="20">
					
					  <select name="accinfo" id="accinfo" class="regularxl" style="width:98">
					   <cfif AccountInfoList.recordcount eq "0">
						    <option value="">n/a</option> 
					   </cfif>
					   <cfloop query="AccountInfoList">
						   <option value="#AccountInfo#" <cfif Detail.AccountInfo eq AccountInfo>selected</cfif>>#AccountInfo#</option>
					    </cfloop>
					   </select>
					
		           </td>
				   <td>
				   	   <input type="Text"
					       name="accmemo"
		                   id="accmemo"
					       value="#AccountMemo#"	
					       required="Yes"
					       size="50"
					       maxlength="50"
						   style="width:200"
					       class="regularxl">
		           </td>
				  				
				    <td>
				   	   <input type="Text"
					       name="accamount"
		                   id="accamount"
						   style="text-align: right;" 
					       value="#numberformat(amount,',.__')#"
					       validate="float"
					       required="Yes"
					       size="7"
					       maxlength="8"
					       class="regularxl">
		           </td>			  	 
				   
				   <td style="padding-left:5px" align="right">
				   
					  <cf_tl id="Save" var="1">
					  
					  <input type="button" 
					    value="#lt_text#" 
						style="width:60;height:25px"
					    class="button10s"
					    onclick="ptoken.navigate('../FundingDetail/FundingDetailSubmit.cfm?ID=#URL.ID#&Fundingid=#url.fundingid#&ID2=#url.id2#&acc='+document.getElementById('accinfo').value+'&memo='+document.getElementById('accmemo').value+'&amount='+document.getElementById('accamount').value,'i#url.fundingid#')">
				
					</td>
			    </TR>	
										
			<cfelse>
			
				<TR class="labelmedium line">
				    <td>#currentrow#.</td>
				    <td height="18">#AccountInfo#</td>
				    <td>#AccountMemo#</td>								
					<td align="right" style="padding-right:4px">#numberformat(Amount,"__,__.__")#</td>				
					<td align="right" style="padding-right:4px">#OfficerLastName#</td>	
					<td align="right" style="padding-right:4px">#dateformat(Created,client.dateformatshow)# #timeformat(Created,"HH:MM")#</td>	
				    <td align="right" style="padding-right:4px">
					
						<cfif url.access eq "Edit">
						
							<table>
							
								<tr>
																
								<td style="padding-left:6px">								
								<cf_img icon="edit" onclick="ColdFusion.navigate('../FundingDetail/FundingDetail.cfm?ID=#URL.ID#&FundingID=#URL.FundingId#&ID2=#detailno#','i#fundingid#')">										  
								</td>
								
								<td style="padding-left:6px">								
								<cf_img icon="delete" onclick="ColdFusion.navigate('../FundingDetail/FundingDetailPurge.cfm?ID=#URL.ID#&FundingID=#URL.FundingId#&ID2=#detailno#','i#fundingid#')">														  
								</td>						  
													
								</tr>
								
							</table>								
						
						</cfif>	  
					
				  </td>
				   
			    </TR>	
				
			</cfif>
					
			</cfoutput>
			
			 <cfquery name="Request" 
				datasource="AppsPurchase" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				    SELECT Percentage * #requisition.RequestAmountBase# as Amount
				    FROM   RequisitionLineFunding
					WHERE  RequisitionNo = '#URL.ID#'
					AND    Fundingid     = '#URL.FundingId#'
			</cfquery>
			
			<cfquery name="Check" 
			  datasource="AppsPurchase" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">
			 	    SELECT ISNULL(SUM(Amount),0) as Total
					FROM   RequisitionLineFundingDetail F
					WHERE  RequisitionNo = '#URL.ID#'
					AND    FundingId     = '#URL.fundingid#'
			</cfquery>		
			
			<cfif check.total gt "0">
			
				<cfset diff = check.total - Request.Amount>
			
				<cfif abs(diff) gte 0.5>
		
					<cfoutput>		
					<tr>
					<td colspan="3" class="labelit">
					<font color="FF0000">
					Request amount (#numberformat(Request.Amount,",.__")#) was not fully funded (#numberformat(check.Total,",.__")#)
					</font>
					</td>
					<td align="right" class="labelit" style="padding-right:4px"><b>#numberformat(Check.Total,",.__")#</td>	
								
					</tr>
					</cfoutput>
					
				<cfelse>
				
					<cfoutput>		
					<tr>
					<td colspan="3" class="labelit"></td>
					<td align="right" class="labelit" style="padding-right:4px"><b>#numberformat(Check.Total,",.__")#</td>				
					</tr>
					</cfoutput>
					
					
				</cfif>
				
				<tr><td height="1" colspan="7" style="border-bottom: 1px dotted Silver;"></td></tr>
				
			</cfif>
																			
			<cfif AccountInfoList.recordcount eq "0" and URL.ID2 eq "new" and url.access eq "Edit">
			
				<cfoutput>
				
			   
				<TR>
				    <td class="labelit"><cfoutput>#detail.recordcount+1#.</cfoutput></td>
				    <td height="20" style="padding-left:3px">
					
					   <select name="accinfo" id="accinfo" class="regularxl" style="width:98">
					    <option value="">n/a</option> 
					   <cfloop query="AccountInfoList">
						   <option value="#AccountInfo#">#AccountInfo#</option>
					    </cfloop>
					   </select>
					   
		           </td>
				   <td style="padding-left:3px">
				   
				   	   <input type="Text"
					       name="accmemo"
		                   id="accmemo"	
					       required="Yes"			      
					       maxlength="50"
						   style="width:200"
					       class="regularxl">
		           </td>	
								
				   		  				
				   <td style="padding-left:3px">
				   				   
					   <cfquery name="Request" 
						datasource="AppsPurchase" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						    SELECT Percentage * #requisition.RequestAmountBase# as Amount
						    FROM   RequisitionLineFunding
							WHERE  RequisitionNo = '#URL.ID#'
							AND    Fundingid     = '#URL.FundingId#'
						</cfquery>
					   
					   <cfquery name="Tot" 
						datasource="AppsPurchase" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						    SELECT SUM(Amount) as Amount
						    FROM   RequisitionLineFundingDetail 
							WHERE  RequisitionNo = '#URL.ID#'
							AND    Fundingid     = '#URL.FundingId#'
						</cfquery>
				    
				       <cfif tot.amount eq "">
						   <cfset p = Request.Amount>
					   <cfelse>
					   	   <cfset p = "#Request.Amount-tot.amount#"> 
					   </cfif>
				   	   
				   	   <input type="Text"
					       name="accamount"
		                   id="accamount"
						   value="#numberformat(p,',.__')#"
						   style="text-align: right;" 			       			       
					       required="Yes"
					       size="7"
					       maxlength="8"
					       class="regularxl">		   
					   
		           </td>			  	 			   
				   <td colspan="1" style="padding-left:4px">
				     			     
					  <cf_tl id="Add" var="1">
					  
					  <input type="button" 
					    value="#lt_text#" 
						style="width:40;height:25px"
				    	class="button10g"
					    onclick="ColdFusion.navigate('../FundingDetail/FundingDetailSubmit.cfm?ID=#URL.ID#&Fundingid=#url.fundingid#&ID2=new&acc='+document.getElementById('accinfo').value+'&memo='+document.getElementById('accmemo').value+'&amount='+document.getElementById('accamount').value,'i#url.fundingid#')">
						
					  </td></tr>
	
			  </cfoutput> 					
			
			</cfif>	
									
		</table>
		</td>
		</tr>
								
	</table>

