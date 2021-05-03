

<!--- this view is only for invoice transactions that need a full processing --->

<cfparam name="URL.ID1" default="ReferenceName">
<cfparam name="URL.search" default="">

<cfquery name="HeaderSelect"
datasource="AppsQuery" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM   #SESSION.acc#GledgerHeader_#client.sessionNo#_#session.mytransaction#
</cfquery>

<cfquery name="Journal"
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT * 
	FROM Journal 
	WHERE Journal = '#url.journal#'
</cfquery>	

<!--- ----------------------- --->
<!--- Select pending payables --->
<!--- ----------------------- --->

<cfquery name="SearchResult"
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">

	 SELECT    P.*, 
	 		   CASE WHEN ActionBefore < getDate() THEN ActionDiscount ELSE 0 END as ApplyDiscount,					
	           L.GLAccount, 
			   J.AccountType, 
			   J.Description as JournalName  			        
			    
	 FROM      TransactionHeader P 
	           INNER JOIN TransactionLine L ON P.Journal = L.Journal AND P.JournalSerialNo = L.JournalSerialNo AND TransactionSerialNo = 0 
			   INNER JOIN Ref_Account A ON L.GlAccount  = A.GlAccount
	           INNER JOIN Journal J     ON P.Journal    = J.Journal 			  
			   
	 WHERE     P.Mission       = '#HeaderSelect.Mission#'		
	 
	 <!--- there is a balance for this payment invoice --->
	 AND       P.AmountOutstanding   > 0.01 
	 AND       P.RecordStatus        = '1'
	 AND       P.TransactionCategory = 'Payables'
	 AND       J.Currency            = '#Journal.Currency#' <!--- you can make a payment order in the same currency --->
	 
	 <!--- already selected transactions for payment in memory of this entry transaction  --->
	 AND       P.TransactionId NOT IN (SELECT ParentTransactionId 
	                                  FROM    userQuery.dbo.#SESSION.acc#GledgerLine_#client.sessionNo#_#session.mytransaction#
								      WHERE   ParentTransactionId IS NOT NULL)
									  
	 AND       P.ActionStatus = '1'		
	 AND 	   A.AccountClass = 'Balance'
	 
	 <cfif url.search neq "">
	 AND      (
	 		   P.ReferenceName           LIKE '%#url.search#%' 
	      	   OR P.JournalTransactionNo LIKE '%#url.search#%'
			   OR P.Description          LIKE '%#url.search#%'
			   OR P.ReferenceNo          LIKE '%#url.search#%'
			   OR P.TransactionReference LIKE '%#url.search#%'
			  )		   
	 </cfif>					 
	 ORDER BY  P.#URL.ID1# 
		 
</cfquery>

<table width="100%">

	<tr><td id="lineentry">
	
	<table width="100%" align="center">
	
	<cfif Searchresult.recordcount eq "0">
	 
	 	<cftry>
		
			<cfif Line.recordCount eq "0">
			<tr><td height="20" colspan="2" bgcolor="f4f4f4" align="center"><b><cf_tl id="There are no items to show in this view"></td></tr>
			</cfif>
			<cfabort>
			
		<cfcatch></cfcatch>
		</cftry>
	
	</cfif>
		
	<tr>
	
	<td colspan="3">
			
		<table width="100%" align="center" class="navigation_table">
						
		<tr class="line labelmedium2 fixrow">
		    <TD style="min-width:30px"></TD>
		    <TD style="min-width:120px"><cf_tl id="Transaction"></TD>
			<TD style="min-width:150px"><cf_tl id="InvoiceNo"></TD>
			<cfif url.id1 neq "ReferenceName">
		    	<TD style="min-width:120px"><cf_tl id="Vendor"></TD>
			<cfelse>
				<TD style="min-width:80px"><cf_tl id="Due"></TD>
			</cfif>
			<TD style="width:100%"><cf_tl id="Description"></TD>	
			<TD style="min-width:80px"><cf_tl id="Date"></TD>
			
		    <TD style="min-width:40px"><cf_tl id="Curr"></TD>
			<td style="min-width:100px"><cf_tl id="Payment"></td>
			<td style="min-width:100px;padding-right:4px" align="right"><cf_tl id="Pending"></td>
			<td style="min-width:100px;padding-right:4px" align="right"><cf_tl id="Discounted"></td>
		</TR>
		
		<cfif searchresult.recordcount eq "0">
		
			<tr>
			     <td height="40" class="labelmedium" style="padding-top:7px" align="center" colspan="9">
			    <cf_tl id="There are no pending account payables in #journal.currency#">
				 </td>
			</tr>
			
		<cfelse>
		  
			<tr class="line fixrow2">
			<td height="34" colspan="10" align="center">		
						
				<table width="100%">				
				  <tr style="background-color:e6e6e6">
				   <td style="padding-left:10px"></td>
				   <td align="right" id="total" style="padding-right:2px" class="labelmedium2"></td>					   
				  </tr>				   
			   </table>
					   
			</td>
			</tr>	
				
		</cfif>		
		
		<cfif searchresult.recordcount gte "50">
			<cfset cl = "hide">
		<cfelse>
		    <cfset cl = "regular">
		</cfif>
				
		<cfset vGroupId = 1>
		
		<cfoutput query="SearchResult" group="#URL.ID1#">
					   
	   		<cfswitch expression = "#URL.ID1#">
		     <cfcase value = "Journal">						     
				 <cfset val = "#journal#">
		     </cfcase>
		     <cfcase value = "ReferenceName">
		    	 <cfset val = "#referencename#">
		     </cfcase>	 
		     <cfcase value = "TransactionDate">
		   		 <cfset val = "#TransactionDate#">
		     </cfcase>
		     <cfcase value = "ActionBefore">
		    	 <cfset val = "#ActionBefore#">
		     </cfcase>
		     <cfdefaultcase>
		        <cfset val = "#journal#">
		     </cfdefaultcase>
		   </cfswitch>		
		   
		    <cfif url.id1 eq "ReferenceName">
	   
		   		<cfquery name="Total" dbtype="query">
					SELECT    ReferenceOrgUnit,
					          Currency,
					          SUM(AmountOutstanding) as Amount,
					          SUM((1-ApplyDiscount)*AmountOutstanding) as AmountDiscounted
					FROM      SearchResult
					WHERE     #URL.ID1# = '#val#'
					GROUP BY  Currency, 
					          ReferenceOrgUnit
				</cfquery>
				
				<cfelse>
				
				<cfquery name="Total" dbtype="query">
					SELECT    Currency,
					          SUM(AmountOutstanding) as Amount,
					          SUM((1-ApplyDiscount)*AmountOutstanding) as AmountDiscounted
					FROM      SearchResult
					WHERE     #URL.ID1# = '#val#'
					GROUP BY  Currency
				</cfquery>
						
			</cfif>
				
			<cfloop query="Total">
			
				<cfset color = "transparent">
			
				<tr class="line labellarge navigation_row" style="background-color:##ffffcf;font-size:19px;height:32px">
				
				   <cfif currentrow eq "1">	
				   
					   <td style="padding-left:5px;cursor:pointer" onclick="toggleGroup('.clsGroup_#url.id1#_#vGroupId#');">						   
						   <cfif cl eq "hide">[+]</cfif>						   
					   </td>	
					   		  
					   <cfswitch expression = "#URL.ID1#">
					     <cfcase value = "Journal">
					     	<td colspan="7" style="padding-left:5px">#SearchResult.Journal# #SearchResult.JournalName#</td>							
					     </cfcase>
					     <cfcase value = "ReferenceName">
					     	<td colspan="6" style="padding-left:5px">#SearchResult.ReferenceName#</td>									
					     </cfcase>	 
					     <cfcase value = "TransactionDate">
					     	<td colspan="7" style="padding-left:5px">#Dateformat(SearchResult.TransactionDate, "#CLIENT.DateFormatShow#")#</td>							
					     </cfcase>
					     <cfcase value = "ActionBefore">
					     	<td colspan="7" style="padding-left:5px">#Dateformat(SearchResult.ActionBefore, "#CLIENT.DateFormatShow#")#</td>							
					     </cfcase>
					     <cfdefaultcase>
					     	<td colspan="7" style="padding-left:5px">#SearchResult.Journal# #SearchResult.JournalName#</td>
					     </cfdefaultcase>
					   </cfswitch>		
									
				   </cfif>					   
				   
				   <cfif url.id1 eq "ReferenceName">
				   
				   	   <cfif currentrow gt "1">
					   	   <td colspan="7"></td>
					   </cfif>
				   				   	  				   
				       <td colspan="1" align="right" style="padding-right:30px">
											
					    <!--- show the threshold --->
						
					    <cfif referenceorgunit neq "0" and referenceorgunit neq "">
					
							<cfquery name="Threshold"
								datasource="AppsLedger" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">								
								SELECT   TOP 1 AmountThreshold 
						    	FROM     Organization.dbo.OrganizationThreshold
								WHERE    OrgUnit        = '#referenceorgunit#'
								AND      ThresholdType  = 'Payable'
								AND      Currency       = '#currency#'  
								AND      DateEffective  <= getDate()
								ORDER BY DateEffective DESC										
							</cfquery>							
																		 							
							<table width="100%">
							<tr class="labelmedium">
							    <td width="100%"></td>
								<td><cf_tl id="Threshold">:<cf_space spaces="20"></td>
								<td align="right">
								
								<cfif Total.AmountDiscounted gt Threshold.AmountThreshold and Threshold.AmountThreshold gt "0">
								    <cfset color = "red">
									<font color="FF0000">#NumberFormat(Threshold.AmountThreshold,',.__')# <cf_space spaces="20">
								<cfelse>
									#NumberFormat(Threshold.AmountThreshold,',.__')# <cf_space spaces="20">
								</cfif>																													
							</tr>
							</table>
						
						</TD>
						
						</cfif>					
					
					<cfelse>
					
					  <cfif currentrow neq "1">
					   	   <td colspan="7"></td>
					   </cfif>
							
				   </cfif>		
				   
				   <cfif color neq "red">  
				 		     											
						 <td style="padding-right:5px" align="right">#NumberFormat(Total.Amount,',.__')#</td>	
						 <td align="right" style="padding-right:5px">#NumberFormat(Total.AmountDiscounted,',.__')#</td>					   
				 
				   <cfelse>				 
						 	 						 
						 <td style="background-color:red;color:white;padding-right:5px" align="right">#NumberFormat(Total.Amount,',.__')#</b></td>	
						 <td style="background-color:red;color:white;padding-right:5px" align="right">#NumberFormat(Total.AmountDiscounted,',.__')#</b></td>		
					 
				   </cfif>
			   
			   </tr>
			   
			 </cfloop>  
			  		     
			<cfoutput>
						   
			   <tr class="labelmedium2 navigation_row #cl# clsGroup_#url.id1#_#vGroupId# line" style="height:21px;border-bottom: 1px solid silver">
			   		
					<cfset fld = left(TransactionId,8)>
							
				    <td align="right" style="padding-top:2px;padding-left:20px;padding-right:8px">										
						<input type="checkbox" name="selected" id="selected" 
						  class="radiol" value="#TransactionId#" 
						  onClick="hl(this,this.checked);settotal('PO');$('##off_#fld#').toggle();">
													
					</td>
					<TD><a class="navigation_action" href="javascript:ShowTransaction('#Journal#','#JournalSerialNo#')">#JournalTransactionNo#</a></TD>
					<TD>#TransactionReference#</TD>
					<cfif url.id1 neq "ReferenceName">
					    <TD style="min-width:240px;padding-right:3px;">#ReferenceName#</TD>
					<cfelse>
						<td>#Dateformat(ActionBefore, "#CLIENT.DateFormatShow#")#</td>	
					</cfif>
					<TD>#Description#</TD>
					<TD>#Dateformat(TransactionDate, "#CLIENT.DateFormatShow#")#</TD>					
				    <TD align="left">#Currency#</TD>
					<td align="right" style="padding-right:1px">
										
					<cfset AmtOut =  AmountOutstanding-(AmountOutstanding*ActionDiscount)>		
						
					<input type="text" class="regularxxl" id="off_#fld#" onchange="settotal('PO')"
					    style="display:none;font-size:16px;background-color:ffffff;height:25px;padding-right:4px;border:0px;border-left:1px solid gray;border-right:1px solid gray;text-align:right" 
						value="#NumberFormat(AmtOut,',.__')#" name="off_#fld#">
					</td>	
					
				    <td align="right" style="padding-right:6px">#NumberFormat(AmountOutstanding,',.__')#</td>	
					<td align="right" style="padding-right:6px">#NumberFormat(AmountOutstanding-(AmountOutstanding*ActionDiscount),',.__')#							
						 					
						 <cfif ActionDiscount neq "0" and ActionDiscountDate lt now()><font color="FF0000"><cf_tl id="L"></cfif>
							
					</td>				
										 		
			    </TR>				
												
			</CFOUTPUT> 

			<cfset vGroupId = vGroupId + 1>
				   
		</CFOUTPUT>
				
		</TABLE>
	
	</td>
	</tr>
	
	</table>

	</td>
	</tr>

</table>

<cfset ajaxonload("doHighlight")>

<script>
	Prosis.busy('no')
</script>

