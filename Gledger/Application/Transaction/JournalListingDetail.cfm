<cfparam name="url.referenceid"          default="">
<cfparam name="url.query"                default="0">  <!--- applies the query --->
<cfparam name="URL.IDSorting"            default="ReferenceNo">
<cfparam name="getTotal.records"         default="0">
<cfparam name="url.page" default="1">
<cfparam name="searchresult.recordcount" default="#getTotal.records#">

<cfif url.query eq "1">
	<cfinclude template="JournalListingQuery.cfm">
</cfif>
	   
<cfset counted  = getTotal.records>	

<cfoutput>
 	   <input type="hidden" id="page" name="page" value="#url.page#">
	   <input type="hidden" id="idstatus" name="idstatus" value="#url.idstatus#">
</cfoutput> 	

<cfif TransactionListing.recordcount eq "0">

	   <table width="100%" style="height:100%"> 
		<tr height="100%"><td colspan="2" class="labelmedium" align="center">There are no records to show in this view.</td></tr>
	   </table>	
				
<cfelse>

  
	<table width="100%" style="height:100%"> 		
			
	<tr style="height:20px">
		<td colspan="2"><cfinclude template="JournalListingNavigation.cfm"></td>
	</tr>		
	
	<tr class="line"><td colspan="2" style="height:100%">
	
	<cf_divscroll overflowy="Scroll">	

		<table width="98%" align="center" class="navigation_table">
		   		
		<cfset amtT    = 0>
		<cfset amtOutT = 0>
		<cfset amtTriDT = 0>
		<cfset amtTriCT = 0>
		
		<cfset amt    = 0>
		   <cfset amtOut = 0>
		<cfset amtTriD = 0>
		<cfset amtTriC = 0>		
		
		<cfset last = "">
		
		<cfset row = 0>
		
		<cfoutput query="TransactionListing" group="Currency" startrow="#first#">
			
			<cfoutput group="#URL.IDSorting#">
						    
				<CFOUTPUT>
								
					<cfparam name="pReferenceNo" default="">
				
					<cfif row gte client.pagerecords>
						
					<cfelse>
						
						<cfset row = row+1>
								
						<cfif (url.idsorting eq "DocumentDate" or url.idsorting eq "TransactionDate") and url.month eq "">				
						
						    <cfset sdate = evaluate(url.idsorting)>
						
							<cfif sdate gt now()-1>
									   
							    <cfif last neq "today">
								
								<tr class="labelmedium">
								<td colspan="14">
								    <table style="width:100%">									
									<cfinclude template="JournalListingSubtotal.cfm">
									</table>
								</td>
								</tr>			
							   
							    <cfset amt    = 0>
							    <cfset amtOut = 0>
								<cfset amtTriD = 0>
								<cfset amtTriC = 0>		
								
								 <cfset last = "today">	
								
							   	<tr class="labelmedium">
								<td style="height:40px;font-size:19px" colspan="14">
							    	  <cf_tl id="Today">
								</td>
							   	</tr>	
											 
							   </cfif>
							       
							<cfelseif sdate gt now()-2>
							
								<cfif last neq "yesterday">
								
								    <tr class="labelmedium"><td colspan="14">
								    <table style="width:100%">									
									<cfinclude template="JournalListingSubtotal.cfm">
									</table>
									</td>
								    </tr>								  	
											
									<cfset amt    = 0>
								    <cfset amtOut = 0>
									<cfset amtTriD = 0>
									<cfset amtTriC = 0>		
										
									<cfset last = "yesterday">
								    <tr class="labelmedium"><td style="height:40px;font-size:19px" colspan="12">
									  <cf_tl id="Yesterday">
									   </td>
									</tr>   	
																
								</cfif>
								
							<cfelseif sDate gt now()-7>
							
								<cfif last neq "thisweek">
								
									 <tr class="labelmedium"><td colspan="14">
								    <table style="width:100%">
									<cfinclude template="JournalListingSubtotal.cfm">
									</table>
									</td>
								 </tr>	
				
									<cfset amt    = 0>
								    <cfset amtOut = 0>
									<cfset amtTriD = 0>
									<cfset amtTriC = 0>		
										
									<cfset last = "thisweek">
								    <tr class="labelmedium"><td style="height:40px;font-size:19px" colspan="12">
									   <cf_tl id="This Week">
									   </td>
									</tr>   	
								
								</cfif>	
								
							<cfelseif sDate gt now()-14>
							
								<cfif last neq "oneweek">
								
									 <tr class="labelmedium"><td colspan="14">
								    <table style="width:100%">
									<cfinclude template="JournalListingSubtotal.cfm">
									</table>
									</td>
								 </tr>	
								
									<cfset amt    = 0>
								    <cfset amtOut = 0>
									<cfset amtTriD = 0>
									<cfset amtTriC = 0>		
				
									<cfset last = "oneweek">									
								    <tr class="labelmedium"><td style="height:40px;font-size:19px" colspan="12">
									   <cf_tl id="One Week Ago">
									   </td>
									</tr>   	
								
								</cfif>		
								
							<cfelseif sDate gt now()-21>
							
								<cfif last neq "twoweek">
								
									<tr class="labelmedium"><td colspan="14">
								    <table style="width:100%">
									<cfinclude template="JournalListingSubtotal.cfm">
									</table>
									</td>
     								</tr>	
								
									<cfset amt    = 0>
								    <cfset amtOut = 0>
									<cfset amtTriD = 0>
									<cfset amtTriC = 0>		
				
									<cfset last = "twoweek">
								    <tr class="labelmedium"><td style="height:40px;font-size:19px" colspan="12">
									   <cf_tl id="Two Weeks Ago">
									   </td>
									</tr>   	
								
								</cfif>		
								
							<cfelseif sDate gt now()-28>
							
								<cfif last neq "threeweek">
								
									<tr class="labelmedium"><td colspan="14">
								    <table style="width:100%">
									<cfinclude template="JournalListingSubtotal.cfm">
									</table>
									</td>
								 	</tr>	
								 								
									<cfset amt    = 0>
								    <cfset amtOut = 0>
									<cfset amtTriD = 0>
									<cfset amtTriC = 0>		
				
									<cfset last = "threeweek">
								    <tr class="labelmedium"><td style="height:40px;font-size:19px" colspan="12">
									   <cf_tl id="Three Weeks Ago">
									   </td>
									</tr>   	
								
								</cfif>			
								
							<cfelse>
							
							    <cfif last neq "older">
								
									<tr class="labelmedium"><td colspan="14">
								    <table style="width:100%">
									<cfinclude template="JournalListingSubtotal.cfm">
									</table>
									</td>
									</tr>	
								
									<cfset amt    = 0>
								    <cfset amtOut = 0>
									<cfset amtTriD = 0>
									<cfset amtTriC = 0>		
									
									<cfset last = "older">
									<tr class="labelmedium"><td style="height:40px;font-size:16px" colspan="12">
									   <cf_tl id="Older">
									   </td>
									</tr>   	
								
								</cfif>
														   
							</cfif>		
						
						</cfif>
						
						<cfif recordstatus eq "9">
						    <cfset color = "FED7CF">
					    <cfelseif actionStatus eq "0">
						    <cfset color = "ffffaf">
						<cfelse>
						    <cfset color = "white">
						</cfif>
														
					    <TR bgcolor="#color#" style="height:19px" class="labelmedium line navigation_row clsSearchClass" id="#journal#_#journalserialno#">
										
					    <td class="navigation_action" style="padding-top:1px;padding-left:4px;padding-right:7px" align="center" onClick="ShowTransaction('#Journal#','#JournalSerialNo#','1','tab')">	
							<div class="clsNoPrint"><cf_img icon="open"></div>								
						</td>
						
						<TD class="clsSearchField" style="padding-right:3px">
						
							<cfif url.find neq "">
								<cfset ref = replaceNoCase(JournalTransactionNo, url.find,"<u><font color='red'>#url.find#</font></u>", "ALL")> 
							<cfelse>
							    <cfset ref = JournalTransactionNo>	
							</cfif>		
							
							<a href="javascript:ShowTransaction('#Journal#','#JournalSerialNo#','1')">#ref#</A>
						
						</TD>
						
						<td class="clsSearchField" style="padding-right:3px">
						 
						 <cfif  ReferenceNo neq ref>
						 
							 <cfif ReferenceNo neq "">					   
							
							    <cfif len(ReferenceNo) gte "2">
								
									
										<cfif url.find neq "">
											<cfset ref = replaceNoCase(ReferenceNo, url.find,"<u><font color='red'>#url.find#</font></u>", "ALL")> 
										<cfelse>
										    <cfset ref = ReferenceNo>	
										</cfif>																				
										#Ref#
									
								
								<cfelse>
									
									<!---					
									<cfif url.find neq "">
										<cfset ref = replaceNoCase(Reference, url.find,"<u><font color='red'>#url.find#</font></u>", "ALL")> 
									<cfelse>
									    <cfset ref = Reference>	
									</cfif>																
									#Ref#
									--->
								
								</cfif>
							
							<cfelseif IndexNo neq "">
							
								<cfif url.find neq "">
									<cfset per = replaceNoCase(IndexNo, url.find,"<u><font color='red'>#url.find#</font></u>", "ALL")> 
								<cfelse>
								    <cfset per = IndexNo>	
								</cfif>
																								
								<A HREF ="javascript:EditPerson('#ReferencePersonNo#')">#FirstName# #LastName#</a>
							
							<cfelse>
							
								#OfficerFirstName# #OfficerLastName#
							
							</cfif>
							
						</cfif>	
						
						</td>
						
						<TD class="clsSearchField" style="padding-right:8px">#Dateformat(JournalBatchDate, "#CLIENT.dateformatshow#")#</TD>					
						<TD class="clsSearchField" style="padding-right:8px">#Dateformat(DocumentDate, "#CLIENT.dateformatshow#")#</TD>						
						<TD class="clsSearchField" style="padding-right:8px">#JournalSerialNo#</TD>
						
						<cfset mem = "">
											
						<cfif url.find neq "">
							<cfset des = replaceNoCase(Description, url.find,"<u><font color='red'>#url.find#</font></u>", "ALL")> 
						<cfelse>
						    <cfset des = description>	
						</cfif>
						
						<cfif des neq "">
						    <cfset mem = des>
						</cfif>
						
						<cfif url.find neq "">
							<cfset nme = replaceNoCase(ReferenceName, url.find,"<u><font color='red'>#url.find#</font></u>", "ALL")> 
						<cfelse>
						    <cfset nme = ReferenceName>	
						</cfif>
												
						<td colspan="2" class="clsSearchField" style="padding-right:4px" title="#mem#">
						
						<cfset memo = "">	
						
						<cfif mem neq "">									
							<cfif len(mem) gte "60">
								<cfset memo = "#left(mem,60)#..">	
							<cfelse>
								<cfset memo = mem>							
							</cfif>
						</cfif>
						
						<cfif memo neq "">
							<cfif FindNoCase(CustomerName,mem) gt 0>
								<cfset vDetails = memo>
							<cfelse>
								<cfset vDetails = "#CustomerName#...">
							</cfif>
							<a HREF ="javascript:editCustomer('#ReferenceId#')">#vDetails#</a>
						</cfif>
		
						<!---
						<cfif IndexNo neq "">
							
							<cfif url.find neq "">
								<cfset per = replaceNoCase(IndexNo, url.find,"<u><font color='red'>#url.find#</font></u>", "ALL")> 
							<cfelse>
							    <cfset per = IndexNo>	
							</cfif>
							
							<cfif mem neq ""><br></cfif>											
							<A HREF ="javascript:EditPerson('#ReferencePersonNo#')">#IndexNo#: #FirstName# #LastName#</a>
													
						</cfif>
						--->
		
						</td>
						
						<TD class="clsSearchField" style="padding-right:6px">#Dateformat(TransactionDate, "#CLIENT.dateformatshow#")#</TD>							
					    <TD class="clsSearchField" style="padding-right:3px" align="center">#Currency#</TD>
						
						<cfif outst eq "1">
						
						    <td align="right" class="clsSearchField" style="min-width:100px;padding-right:3px">#NumberFormat(Amount,',.__')#</td>	
							<td align="right" class="clsSearchField" style="min-width:100px;padding-right:3px">#NumberFormat(AmountOutstanding,',.__')#</td>	
							
							<cfif amountoutstanding neq "">
							   <cfset AmtOut = AmtOut + AmountOutstanding>	
							   <cfset AmtOutT = AmtOutT + AmountOutstanding>	
							</cfif>	
							
							<cfset Amt  = Amt + Amount>  
						    <cfset AmtT = AmtT + Amount>
						
						<cfelse>
						
							<td class="clsSearchField" style="min-width:100px;padding-right:3px" align="right">#NumberFormat(Amount,',.__')#</td>
							
							<cfif journal.glaccount gte "1" and Journal.TransactionCategory neq "Memorial">
							
								<td align="right" class="clsSearchField" style="min-width:100px;padding-right:3px">#NumberFormat(AmountTriggerDebit,',.__')#</td>	
								<td align="right" class="clsSearchField" style="min-width:100px;padding-right:3px">#NumberFormat(AmountTriggerCredit,',.__')#</td>	
								
								<cfif amounttriggerDebit neq "">
								   <cfset AmtTriD = AmtTriD  + AmountTriggerDebit>	
								   <cfset AmtTriDT = AmtTriDT + AmountTriggerDebit>	
								</cfif>	
								<cfif amounttriggerCredit neq "">
								   <cfset AmtTriC = AmtTriC  + AmountTriggerCredit>	
								   <cfset AmtTriCT = AmtTriCT + AmountTriggerCredit>	
								</cfif>	
								
								<cfset Amt  = Amt + Amount>  
					    		<cfset AmtT = AmtT + Amount>
						
							</cfif>	
						
						</cfif>	
										
						 <td style="padding-right:4px" align="center" id="note_#Journal#_#JournalSerialNo#">
								 
							 <cf_annotationshow entity="GLTransaction" 
						         keyvalue4="#TransactionId#"
							     docbox="note_#Journal#_#JournalSerialNo#">						
									 
						 </td>	 
									 			
					    </TR>
											
					</cfif>	
					
					<cfset pReferenceNo = ReferenceNo>
					
				</CFOUTPUT>
			     
			</CFOUTPUT> 
		
		</CFOUTPUT>	 	
		
		<tr style="height:0px">		  
		     <td style="min-width:70" align="left"></TD>			
			 <td colspan="2" style="min-width:250"></td>
			 <TD style="min-width:95"></TD>
			 <TD style="min-width:95"></TD>		
			 <TD style="min-width:95"></TD>
			 <TD style="width:100%" colspan="2"></TD>	
			 <TD style="min-width:95"></TD>
		     <TD style="min-width:30"></TD>						
			 <cfif outst eq "1">			
				<td style="min-width:120" align="right"></td>
				<td style="min-width:120" align="right"></td>						
			 <cfelse>			
			    <td style="min-width:120" align="right"></td>
				<cfif journal.glaccount gte "1" and Journal.TransactionCategory neq "Memorial">
					<td style="min-width:120" align="right"></td>
					<td style="min-width:120" align="right"></td>									
				</cfif>				
			 </cfif>			
		     <td style="min-width:20px"></td>						
		     </tr>
		
		</TABLE>
		
		</cf_divscroll>
				
	</td>
	</tr>
	
	<cf_pagecountN show="#client.pagerecords#" 
          count="#getTotal.records#">
	
	<tr><td colspan="2"><cfinclude template="JournalListingNavigation.cfm"></td></tr>	
	
	<tr class="labelmedium" style="background-color:f1f1f1">
		<td style="padding-left:20px"><cf_tl id="Page totals">:</td>
		<td><table style="width:100%" id="subtotal">		
		<cfinclude template="JournalListingSubtotal.cfm">		
		</table>
		</td>
		</tr>		
	
</table>	

</cfif>

<cfset ajaxonload("doHighlight")>

<script>
	Prosis.busy('no')
</script>