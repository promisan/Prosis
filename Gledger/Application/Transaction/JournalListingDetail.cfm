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
 	   <input type="hidden" id="page"     name="page"     value="#url.page#">
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

		<table width="99%" align="left" class="navigation_table">
		
		     <tr style="height:10px" class="fixrow labelmedium2 line fixlengthlist">
				  
			     <td align="left">
			  	  				 
			       <table>
				   <tr>
			 								
					<!--- capture the screen result to allow for identical excel export --->
																										   		    
				    <cfinvoke component="Service.Analysis.CrossTab"  
						  method      		= "ShowInquiry"					 		
						  ButtonWidth 		= "90px" 
						  ButtonHeight 		= "29px" 		
						  buttonclass       = "td"				  		 					 							  					 					 					  
						  buttonText  		= ".xls"						 
						  reportPath  		= "GLedger\Application\Transaction\"
						  SQLtemplate 		= "JournalListingExcel.cfm"
						  querystring 		= "journal=#url.journal#"
						  selectedId  		= "#preserveSingleQuotes(querystatement)#"
						  dataSource  		= "appsQuery" 
						  module     		= "Accounting"						  
						  reportName  		= "Execution Report"
						  table1Name  		= "Journal Transaction Document"		
						  table2Name  		= "Journal Transaction Lines"						 		
						  data        		= "1"
						  ajax        		= "0"				 
						  olap        		= "0" 
						  excel       		= "1"> 	
						  
					</tr>
					</table>	 	
										
			    </td>
				
				<td colspan="2"><cf_tl id="Reference"></td>
				<td><cf_tl id="Batch"></TD>
				<td><cf_tl id="Document"></TD>		
				<td><cf_tl id="Series"></TD>
				<td colspan="2"><cf_tl id="Description"></TD>	
				<td><cf_tl id="Posted"></TD>
			    <td align="center"><cf_tl id="Curr"></TD>							
				<cfif outst eq "1">			
					<td align="right"><cf_tl id="Amount"></td>
					<td align="right"><cf_tl id="Outstanding"></td>			
					<cfset col = 9>			
				<cfelse>			
				    <td align="right"><cf_tl id="Document"></td>
					<cfif journal.glaccount gte "1" and Journal.TransactionCategory neq "Memorial">
						<td align="right"><cf_tl id="Debit"></td>
						<td align="right"><cf_tl id="Credit"></td>
						<cfset col = 11>
					<cfelse>
						<cfset col = 9>
					</cfif>				
				</cfif>				
				<td style="width:20px"></td>								
			</tr>
		   		
		<cfset amtT     = 0>
		<cfset amtOutT  = 0>
		<cfset amtTriDT = 0>
		<cfset amtTriCT = 0>
		
		<cfset amt      = 0>
		<cfset amtOut   = 0>
		<cfset amtTriD  = 0>
		<cfset amtTriC  = 0>		
		
		<cfset last = "">
		
		<cfset row = 0>
		
		<cfoutput query="TransactionListing" group="Currency" startrow="#first#">
			
			<cfoutput group="#URL.IDSorting#">
						    
				<CFOUTPUT>
				
					<cfset mode = "subtotal">	
								
					<cfparam name="pReferenceNo" default="">
				
					<cfif row gte client.pagerecords>
						
					<cfelse>
						
						<cfset row = row+1>
								
						<cfif (url.idsorting eq "DocumentDate" or url.idsorting eq "TransactionDate") and url.month eq "">				
						
						    <cfset sdate = evaluate(url.idsorting)>
						
							<cfif sdate gt now()-1>
									   
							    <cfif last neq "today">
																																							
									<cfinclude template="JournalListingSubtotal.cfm">								  								
									<cfset last = "today">									
								   	<tr class="labelmedium fixrow2">
									<td style="height:40px;font-size:19px" colspan="14">
							    	   <cf_tl id="Today">
									</td>
								   	</tr>	
											 
							   </cfif>
							       
							<cfelseif sdate gt now()-2>
							
								<cfif last neq "yesterday">																   								
									<cfinclude template="JournalListingSubtotal.cfm">															  																														
									<cfset last = "yesterday">
								    <tr class="labelmedium  fixrow2"><td style="height:40px;font-size:19px" colspan="12">
									  <cf_tl id="Yesterday">
									   </td>
									</tr>   																	
								</cfif>
								
							<cfelseif sDate gt now()-7>
							
								<cfif last neq "thisweek">																	
									<cfinclude template="JournalListingSubtotal.cfm">																														
									<cfset last = "thisweek">
								    <tr class="labelmedium fixrow2"><td style="height:40px;font-size:19px" colspan="12">
									   <cf_tl id="This Week">
									   </td>
									</tr>   									
								</cfif>	
								
							<cfelseif sDate gt now()-14>
							
								<cfif last neq "oneweek">																
									<cfinclude template="JournalListingSubtotal.cfm">													
									<cfset last = "oneweek">									
								    <tr class="labelmedium fixrow2"><td style="height:40px;font-size:19px" colspan="12">
									   <cf_tl id="One Week Ago">
									   </td>
									</tr>   								
								</cfif>		
								
							<cfelseif sDate gt now()-21>
							
								<cfif last neq "twoweek">																	
									<cfinclude template="JournalListingSubtotal.cfm">		    																													
									<cfset last = "twoweek">
								    <tr class="labelmedium fixrow2"><td style="height:40px;font-size:19px" colspan="12">
									   <cf_tl id="Two Weeks Ago">
									   </td>
									</tr>   									
								</cfif>		
								
							<cfelseif sDate gt now()-28>
							
								<cfif last neq "threeweek">																	
									<cfinclude template="JournalListingSubtotal.cfm">													
									<cfset last = "threeweek">
								    <tr class="labelmedium fixrow2"><td style="height:40px;font-size:19px" colspan="12">
									   <cf_tl id="Three Weeks Ago">
									   </td>
									</tr>   									
								</cfif>			
								
							<cfelse>
							
							    <cfif last neq "older">								
									<cfinclude template="JournalListingSubtotal.cfm">																			
									<cfset last = "older">
									<tr class="labelmedium fixrow2"><td style="height:40px;font-size:19px" colspan="12">
									   <cf_tl id="Older">
									   </td>
									</tr>   									
								</cfif>
														   
							</cfif>		
						
						</cfif>
						
						<cfif recordstatus eq "9">
						    <cfset color = "FED7CF">
					    <cfelseif actionStatus eq "0">
						    <cfset color = "ffffcf">
						<cfelse>
						    <cfset color = "white">
						</cfif>
														
					    <TR bgcolor="#color#" class="labelmedium line navigation_row clsSearchClass fixlengthlist" id="#journal#_#journalserialno#">
										
					    <td class="navigation_action" 
						   style="padding-top:1px" align="center" onClick="ShowTransaction('#Journal#','#JournalSerialNo#','1','tab')">	
							<div class="clsNoPrint"><cf_img icon="open"></div>								
						</td>
						
						<TD class="clsSearchField">
												
							<cfif url.find neq "">
								<cfset ref = replaceNoCase(JournalTransactionNo, url.find,"<u><font color='red'>#url.find#</font></u>", "ALL")> 
							<cfelse>
							    <cfset ref = JournalTransactionNo>	
							</cfif>		
							
							#ref#
						
						</TD>
						
						<td class="clsSearchField">
												 
						 <cfif ReferenceNo neq ref>
						 
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
						
						<TD class="clsSearchField">#Dateformat(JournalBatchDate, "#CLIENT.dateformatshow#")#</TD>					
						<TD class="clsSearchField">#Dateformat(DocumentDate, "#CLIENT.dateformatshow#")#</TD>						
						<TD class="clsSearchField">#JournalSerialNo#</TD>
						
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
												
						<td colspan="2" class="clsSearchField" title="#mem#">
																											
							<cfif mem neq "">								
								<a HREF ="javascript:editCustomer('#ReferenceId#')"><cfif nme neq "">#nme#&nbsp;</cfif> #mem#</a>
							<cfelse>
								#nme#
							</cfif>
				
						</td>
						
						<TD class="clsSearchField">#Dateformat(TransactionDate, "#CLIENT.dateformatshow#")#</TD>							
					    <TD class="clsSearchField" align="center">#Currency#</TD>
						
						<cfif outst eq "1">
						
						    <td align="right" class="clsSearchField">#NumberFormat(Amount,',.__')#</td>	
							<td align="right" class="clsSearchField">#NumberFormat(AmountOutstanding,',.__')#</td>	
							
							<cfif amountoutstanding neq "">
							   <cfset AmtOut  = AmtOut  + AmountOutstanding>	
							   <cfset AmtOutT = AmtOutT + AmountOutstanding>	
							</cfif>	
							
						<cfelse>
						
							<td class="clsSearchField" align="right">#NumberFormat(Amount,',.__')#</td>
							
							<cfif journal.glaccount gte "1" and Journal.TransactionCategory neq "Memorial">
							
								<td align="right" class="clsSearchField">#NumberFormat(AmountTriggerDebit,',.__')#</td>	
								<td align="right" class="clsSearchField">#NumberFormat(AmountTriggerCredit,',.__')#</td>	
								
								<cfif amounttriggerDebit neq "">
								   <cfset AmtTriD  = AmtTriD  + AmountTriggerDebit>	
								   <cfset AmtTriDT = AmtTriDT + AmountTriggerDebit>	
								</cfif>	
								<cfif amounttriggerCredit neq "">
								   <cfset AmtTriC  = AmtTriC  + AmountTriggerCredit>	
								   <cfset AmtTriCT = AmtTriCT + AmountTriggerCredit>	
								</cfif>	
														
							</cfif>	
						
						</cfif>	
						
						<cfset Amt  = Amt  + Amount>  
					    <cfset AmtT = AmtT + Amount>
										
						 <td style="padding-top:3px" valign="absmiddle" align="center" id="note_#Journal#_#JournalSerialNo#">
								 
							 <cf_annotationshow entity="GLTransaction" 
						         keyvalue4="#TransactionId#" docbox="note_#Journal#_#JournalSerialNo#">						
									 
						 </td>	 
									 			
					    </TR>
											
					</cfif>	
					
					<cfset pReferenceNo = ReferenceNo>
					
				</CFOUTPUT>
			     
			</CFOUTPUT> 
		
		</CFOUTPUT>	 		
		
		</TABLE>
		
		</cf_divscroll>
				
	</td>
	</tr>
	
	<cf_pagecountN show="#client.pagerecords#" 
          count="#getTotal.records#">
		  
	<tr class="labelmedium">
		<td style="padding-left:20px"><cf_tl id="Page totals">:</td>
		<td>
		<table style="width:100%" id="subtotal">	
		<cfset mode = "pagetotal">	
		<cfinclude template="JournalListingSubtotal.cfm">		
		</table>
		</td>
	</tr>		
	
	<!---  	
	<tr><td colspan="2"><cfinclude template="JournalListingNavigation.cfm"></td></tr>	
	--->	
	
</table>	

</cfif>

<cfset ajaxonload("doHighlight")>

<script>
	Prosis.busy('no')
</script>