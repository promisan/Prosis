<!--- Prosis template framework --->
<cfsilent>
	<proUsr>jmazariegos</proUsr>
	<proOwn>Jorge Mazariegos</proOwn>
	<proDes>Translated</proDes>
	<proCom></proCom>
</cfsilent>

<cf_tl id="split line" var="1">
<cfset vSplit=#lt_text#>

<cf_tl id="splitted" var="1">
<cfset vSplitted=#lt_text#>

<!--- End Prosis template framework --->

    <cfset col = "10">

	<table width="100%" class="formpadding">
	    
	  <tr>
	    <td width="100%" style="padding:10px;border-top:1px solid silver;border-bottom:1px solid silver">
		
	    <table border="0" width="100%" class="navigation_table">
			
	    <TR class="labelmedium2 line">
		   <td width="4%" height="19">&nbsp;</td>
		   <td width="4%" height="19">&nbsp;</td>
		   <td width="40%"><cf_tl id="Description"></td>
		   <td></td>
		   <td><cf_tl id="Qty"></td>
		   <td align="center"><cf_tl id="UoM"></td>
		   <td align="right" style="min-width:100px"><cf_tl id="Price"></td>
		   <td align="right" style="min-width:100px"><cf_tl id="Amount"></td>
		   <td align="right" style="min-width:100px"><cf_tl id="Tax"></td>
		   <td align="right" style="min-width:100px"><cf_tl id="Purchase"></td>		  
	    </TR>
		
		<cfoutput>
					
		<cfif Requisition.recordcount eq "0">			
			<tr><td height="6" colspan="#col#"></td></tr>
			<tr class="labelmedium2"><td colspan="#col#" align="center"><font color="gray"><cf_tl id="REQ068"></td></tr>			
			<tr><td height="1" colspan="#col#" class="line"></td></tr>
		</cfif>	
		</cfoutput>
		
		<cfoutput query="Requisition" group="Mission">
		<cfoutput group="RequestType">				
			
		<cfoutput group="HierarchyCode">
			
			<cfif RequestType neq "Purchase">
			
			<tr><td colspan="#col#" class="labelmedium2">#OrgUnitName#</td></tr>
					
			</cfif>
		
			<cfoutput>
			
			<!--- check if this line has any quote recorded already --->
				
			<cfquery name="CheckQuotes" 
				datasource="AppsPurchase" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT    TOP 1 *
				FROM      RequisitionLineQuote
				WHERE     RequisitionNo = '#RequisitionNo#' 			
			</cfquery>
			
			<tr><td colspan="#col#" class="line"></td></tr>
			
			<cfif ActionStatus lt "2k">
			 <cfset cl = "FFD5BF">
			<cfelse>
			 <cfset cl = "ffffff"> 
			</cfif>
									
			<tr id="#requisitionno#_1" bgcolor="#cl#" class="line labelmedium2">
			
			   <td colspan="2" style="padding-left:4px">
			   
				   <table>
				   <tr class="labelmedium2">
				   
				   <td align="center" style="padding-top:4px">
	
					    <cfif access eq "ALL" or workflow eq "1">
						
					      <cfif PurchaseNo eq "" and (ActionStatus is "2k" or (ActionStatus eq "2q" and CheckQuotes.recordcount eq "0"))>
						  
								   <cfif RequestType eq "Purchase">						   
								       <cf_img icon="select" onClick="ProcReqAdd('#Job.JobNo#')">						   	
								   <cfelse>						   
								   	   <cf_img icon="select" onClick="ProcReqEdit('#requisitionno#','dialog')">			
								   </cfif>
							 
							<cfelse>
								
								<cf_img icon="select"  onClick="ProcReqEdit('#requisitionno#','dialog')">
							 
						  </cfif>	 
						 
						</cfif> 
				   		 		   
				   </td>
				   <td style="padding-left:4px">#currentrow#</td>			   
				   </tr>
				   </table>
			   
			   </td>				   
	    	  	  
			   <td style="padding-left:3px">#RequestDescription#</td>
			   
			   <cfif details eq "0">
			   
				   <td align="right"></td>		   
		    	   <td>#RequestQuantity#</td>
				   <td align="center">#QuantityUoM#</td>
				   <td align="right">#NumberFormat(RequestCostprice,",.__")#</td>
				   
			   <cfelse>
			   
			       <td colspan="4">
				   
			   </cfif>	   		   
			  		   
			   <td align="right">#NumberFormat(RequestAmountBase,",.__")#</td>
			   <td></td>		   
			  		   
			   <td align="right" valign="middle" style="padding-top:2px">
			   
			    <cfif access eq "ALL">
				
				 <cfif PurchaseNo eq "" and (ActionStatus is "2k" or (ActionStatus eq "2q" and CheckQuotes.recordcount eq "0"))>
				 
					  <cfif RequestType eq "Purchase">				  
					  	  <cf_img icon="delete"  onClick="delline('#RequisitionNo#','#url.workflow#','#job.period#','#url.id1#')">				  			  
					  <cfelse> 					  
					  	  <cf_img icon="delete"  onClick="delline('#RequisitionNo#','#url.workflow#','#job.period#','#url.id1#')">			 									 
					  </cfif>	 	  
				
				 </cfif> 
				 
			   </cfif>	 		
									   
			   </td>
			</tr>
			
		    <cfif Topics neq 0>
			<tr class="line">
			<td></td>
			<td colspan="9">
			   	<cf_getRequisitionTopic RequisitionNo="#RequisitionNo#" TopicsPerRow="3">					
			</td>
			</tr>
			</cfif>
			
			<tr id="#requisitionno#_2" bgcolor="#cl#" class="line">	
			
			<td></td>	
						
			 <cfif details eq "0">
			 
			 <td colspan="4" style="padding-left:4px">#Description#</td>
			 
			 <cfelse>		
			
			   <cfquery name="myDetails" 
				  datasource="AppsPurchase" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
				      SELECT *
				      FROM   RequisitionLineService
					  WHERE RequisitionNo  = '#requisitionno#' 
				</cfquery>		
				
				<td colspan="4" style="padding-left:4px">
				
				<table class="formpadding" style="width:100%">
							
					<cfloop query="myDetails">
						
					   	<tr class="labelmedium2 navigation_row">
						<td>#ServiceDescription#</td>					
						<td width="40">#Quantity#</td>
						<td>#UoM#</td>					
						<td align="right">#numberformat(uomRate,',.__')#</td>							
						<td align="right">#numberformat(Amount,',.__')#</td>	
						</tr>	
						
					</cfloop>
								
				</table>	
				</td>
				
			</cfif>	
						
			</td>
			
			<td style="padding-left:4px"><a href="javascript:ProcReqEdit('#requisitionno#','dialog')">#Reference#</a></td>
			
			<td class="labelmedium2">#RequestPriority# <cfif ParentRequisitionNo neq ""><font color="gray">#vSplitted#</font></cfif> 	
			
			<td align="right" style="padding-right:4px" class="labelmedium">	
			
			    <cfif ParentRequisitionNo eq "">
																		   	
				<cfif ActionStatus eq "2k" or (ActionStatus eq "2q" and CheckQuotes.recordcount eq "0")>					   
					   
					<cfif Fun eq "Job" 
					      AND WarehouseItemNo eq "" 
						  AND ParentRequisitionNo eq ""
						  AND PurchaseNo eq "" 
						  AND RequestType eq "Regular"> <!--- don't split already processed lines --->
						  				
					   <cfif access eq "ALL" and (workflowEnabled eq "0" or flowdefined.recordcount eq "0")>
						   	 <a href="javascript:ProcReqSplit('#RequisitionNo#');">[#vSplit#]</a>
					   <cfelseif workflow eq "1">				 
						     <a href="javascript:ProcReqSplit('#RequisitionNo#');">[#vSplit#]</a>
					   <cfelse>		
					       <!--- no actionenabled --->							 				 
					   </cfif>		   		
				  	
					<cfelseif fun eq "Job" and RequestType eq "Warehouse">
									
					   <cfif access eq "ALL" and (workflowEnabled eq "0" or flowdefined.recordcount eq "0")>
						     <a href="javascript:ptoken.navigate('#SESSION.root#/procurement/application/quote/create/AddDummyLine.cfm?id1=#url.id1#&id=#RequisitionNo#','dialog')">[#vSplit#]</a>													 
					   <cfelseif workflow eq "1">				 
						     <a href="javascript:ptoken.navigate('#SESSION.root#/procurement/application/quote/create/AddDummyLine.cfm?id1=#url.id1#&id=#RequisitionNo#','dialog')">[#vSplit#]</a>													 
					   <cfelse>		
					       <!--- no actionenabled --->							 				 
					   </cfif>			
				
					<cfelse>
				
					   #OfficerLastName# 
					   
					</cfif>
				
				<cfelse>
				
					#OfficerLastName#
				
				</cfif>
				
				</cfif>
				
			</td>
			
			<cfif ActionStatus lt "2k">
			
				<td colspan="2" bgcolor="yellow" align="center"><cf_tl id="Under review"></td>
							
			<cfelse>
						
				<cfif RequestType eq "Purchase">
					<td colspan="1" align="center" bgcolor="lime">
					<cf_tl id="Added by Buyer">
					</td>
				<cfelse>
					<td colspan="1"></td>	
				</cfif>
						
				<!--- check if already create as PO --->
				
				<cfquery name="Check" 
				datasource="AppsPurchase" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				   SELECT    *
				   FROM      PurchaseLine
				   WHERE     RequisitionNo = '#RequisitionNo#' 			
				</cfquery>
				
				<td align="right">
				
				<cfif check.recordcount eq "1">			
				   <a href="javascript:ProcPOEdit('#Check.PurchaseNo#','view')" title="View Purchase Order">#Check.PurchaseNo#</a>			
		   		</cfif>		
				</td>
			
			
			</cfif>	
								
			</tr>
			
			<!--- check if already create as PO --->
			
			<cfquery name="Check" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			   SELECT    *
			   FROM      PurchaseLine
			   WHERE     RequisitionNo = '#RequisitionNo#' 			
			</cfquery>
			
			<cfif check.recordcount eq "1" and JobOpen.recordcount gte "1">
			
				<tr class="regular">
					<td colspan="10" class="labelit" bgcolor="ffffaf" align="center">
					<b><cf_tl id="Attention">:</b>&nbsp;<cf_tl id="This requirement has been obligated already under Purchase No">: 
					   <a href="javascript:ProcPOEdit('#Check.PurchaseNo#','view')" title="View Purchase Order"><font color="red">#Check.PurchaseNo#</font></a>			
					</td>
				</tr>			
			
			</cfif>		
			
				<tr id="blog#requisitionNo#" class="hide">
					<td></td>
					<td colspan="10"><cfdiv id="log#RequisitionNo#"></td>
				</tr>						
								
			<cfswitch expression="#fun#">
	
				<cfcase value="funding"></cfcase>
				
				<cfcase value="job">
							
					<cfquery name="Vendor" 
						datasource="AppsPurchase" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						SELECT    Q.*, 
						          Org.OrgUnitName,
								  (SELECT Description FROM Ref_Award WHERE Code = Q.Award) as Description							  
						FROM      RequisitionLineQuote Q, 
		                	      Organization.dbo.Organization Org
						WHERE     Q.RequisitionNo = '#RequisitionNo#'	
						AND       Q.OrgUnitVendor = Org.OrgUnit					
						ORDER BY  Q.QuoteAmountBase 										
							
					</cfquery>					
										
					<cfset row   = currentrow>
					<cfset purno = PurchaseNo>				
					
					<cfloop query="Vendor">
					
					<cfif QuoteAmountBase lte "0" and QuoteZero eq "0">
									
					<tr class="labelmedium2 line navigation_row" bgcolor="ffffcf" id="#requisitionno#_4">
					
					<cfelse>
					
						<cfif Selected eq "1">
							<tr class="labelmedium2 line navigation_row" bgcolor="ffffaf" id="#requisitionno#_4">
						<cfelse>
							<tr class="labelmedium line navigation_row" bgcolor="ffffff" id="#requisitionno#_4">
						</cfif>
					
					</cfif>
					
					<td style="padding-top:1px;padding-left:5px" align="center">
					
						<cfif Selected eq "1">				
						<img src="#SESSION.root#/Images/check.png" height="12" width="13" alt="Selected for purchase" border="0">
							<cfif purNo eq "">
								<cfset po = 1>
							</cfif>					
						</cfif>
						
					</td>	  
							        				
					<cfif access eq "ALL" and (workflowEnabled eq "0" or flowdefined.recordcount eq "0")>
					
					 <td align="center" style="padding-top:1px"><cf_img icon="open" onClick="ProcQuoteEdit('#quotationid#');"></td>
					 <td>#OrgUnitName#</td>
						
				   <cfelseif workflow eq "1">		
				   
					    <td align="center"><cf_img icon="open" onClick="javascript:ProcQuoteEdit('#quotationid#');"></td>
						<td>#OrgUnitName#</td>
					 	 
				   <cfelse>	
				   
					   	<td align="center">				
							<cf_img icon="open" onClick="javascript:ProcQuoteEdit('#quotationid#','view');">							
						</td>					
						<td><a href="javascript:ProcQuoteEdit('#quotationid#','view');">#OrgUnitName#</a></td>   			
											 				 					
				   </cfif>					
					
					<td></td>
					
					<cfif QuoteAmountBase lte "0" and QuoteZero eq "0">
						<td colspan="6" align="right" bgcolor="FFFF80" style="padding-right:4px">Not submitted</td>
					<cfelse>
				        <td style="border:1px solid silver;padding-left:3px">#QuotationQuantity#</td>
				    	<td align="center" style="border:1px solid silver;padding-left:3px">#QuotationUoM#</td>
				        <td align="right" style="border:1px solid silver;padding-right:3px">#NumberFormat(QuoteAmountBase/QuotationQuantity,",.__")#</td>
						<td align="right" style="border:1px solid silver;padding-right:3px">#NumberFormat(QuoteAmountBaseCost,",.__")#</td>					
				        <td align="right" style="border:1px solid silver;padding-right:3px">#NumberFormat(QuoteAmountBaseTax,",.__")#</td>
						<td align="right" style="border:1px solid silver;padding-right:3px"><b>#NumberFormat(QuoteAmountBase,",.__")#</b></td>
					    <!--- 
		     		    <td rowspan="1" align="center">		      		
					       <input type="checkbox" name="QuotationId" value="#QuotationId#" onClick="javascript:hl(this,this.checked,'#QuotationId#')">							 				   
				         </td>
						--->
					</cfif>
					
	            	</tr>
									
					<cfif selected eq 1 and PurNo neq "">
					<tr bgcolor="EAFBFF" class="labelit">
						<td colspan="9" align="right" style="height:30">			
							<cf_tl id="Assigned Purchase Order"> :
							<a href="javascript:ProcPOEdit('#PurNo#','view')" title="View Purchase Order">#PurNo#</a>
						</td>
					</tr>					
					</cfif>
									
					<cfif Award neq "">						
						<tr class="line">
						   <td></td>
						   <td></td>
						   <td class="labelmedium" colspan="8"><img src="#session.root#/images/join.gif" alt="" border="0"><b>#Description# #AwardRemarks#</td>
						</tr>											
					</cfif>
												
					</cfloop>
							
				</cfcase>
				
			</cfswitch>			
					
			</cfoutput>
		
		</cfoutput>
		
		</cfoutput>
		
		</cfoutput>
				
		</table>
		
		</td>
	</tr>
		
	</table>		

	<cfset ajaxOnLoad("doHighlight")>