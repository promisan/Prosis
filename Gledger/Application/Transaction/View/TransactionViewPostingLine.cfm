
<cfparam name="url.summary" default="0">

<cfif color neq "ffffdf">
	<cfset cnt = cnt+1>
</cfif>

<cfif Lines.recordstatus eq "9" or Lines.actionstatus eq "9">
	<cfset color = "FED7CF">
</cfif>

<cfoutput>

<tr class="line labelmedium regular <cfif color neq 'ffffdf'>navigation_row</cfif> fixlengthlist" bgcolor="#color#" style="height:26px" 
       onMouseOver="earmark('b#journal#_#journalserialNo#_#glaccount#','highlight')"
	   onMouseOut="earmark('b#journal#_#journalserialNo#_#glaccount#','regular')">   	 	
	   	     
   <td align="center"><cfif color neq "ffffdf">#cnt#</cfif></td>
   <td><cfif color neq "ffffdf"><cfif Lines.AccountClass eq "Result">#Lines.TransactionPeriodLine#<cfelse>#Lines.TransactionPeriodHeader#</cfif></cfif></td>
   <td>#DateFormat(TransactionDate, CLIENT.DateFormatShow)#</td>
   <td>#DateFormat(Created, CLIENT.DateFormatShow)#</td>   
   <td>#Reference#</td>   
   <td name="b#parentjournal#_#parentjournalserialNo#_#glaccount#">
   
  		<cfparam name="AccountLabel" default="">
		   
	    <cfif accountLabel neq "">
		   <cfset sl = accountLabel>
		<cfelse>
		   <cfset sl = glaccount>
		</cfif>
   
       <a title="#sl# #GLDescription#" href="javascript:showledger('#mission#','#orgunitowner#','#accountperiod#','#glaccount#')">#sl# #GLDescription#</a>
   
   </td>  
   
   <td bgcolor="f4f4f4" style="border-left:1px solid silver;font-size:10px;padding-top:5px" align="right"><cfif transactionserialno neq "0">#TransactionCurrency#</cfif></td>
   <td bgcolor="f4f4f4" style="border-left:0px solid e3e3e3" align="right"><cfif transactionserialno neq "0">#NumberFormat(DocumentAmount,',.__')#</cfif></td>

   <td align="right"    style="border-left:1px solid silver;font-size:10px;padding-top:5px">#currency#</td>
   <td align="right"    style="border-left:0px solid e3e3e3">
      
	<cfif amountdebit gt "0">
		<cfset act = "Credit">
		<cfset amt = amountdebit>
	<cfelse>
		<cfset act = "Debit">
		<cfset amt = amountcredit>
	</cfif>

   <cfif AmountDebit is not "">
   <cfif AmountDebit eq "0"><font color="C0C0C0"></cfif>
   #NumberFormat(AmountDebit,',.__')#</cfif></td>
   <td style="padding-right:3px;border-left:1px solid silver" align="right">
   <cfif #AmountCredit# is not "">
   <cfif AmountCredit eq "0"><font color="C0C0C0"></cfif>
   #NumberFormat(AmountCredit,',.__')#</cfif></td>
   
	<cfif access neq "READ">
	   
	   <td style="border-left:1px solid silver;background-color:##ffffaf80" align="right">
	   <cfif AmountBaseDebit is not "">
	   <cfif AmountDebit eq "0"><font color="C0C0C0"></cfif>
	   #NumberFormat(AmountBaseDebit,',.__')#</cfif></td>
	   <td style="border-left:1px solid silver;background-color:##ffffaf80" align="right">
	   <cfif AmountBaseCredit is not "">
	   <cfif AmountCredit eq "0"><font color="C0C0C0"></cfif>
	   #NumberFormat(AmountBaseCredit,',.__')#</cfif></td>  
	          
	   <td align="center" style="border-left:1px solid silver">
	       
	   <!--- transaction journal is the parent journal --->  
	        
	   <cfif journal eq url.journal>
	   
	        <!--- 25/3/2015 
			  check if this line was already distributed, in that case we do not cater for this --->
	     	 
			<cfquery name="CheckDis"
			    datasource="AppsLedger" 
			    username="#SESSION.login#" 
			    password="#SESSION.dbpw#">
		    	   SELECT   * 
				   FROM     TransactionLine	G		
				   WHERE    Journal             = '#journal#'
					 AND    JournalSerialNo     = '#Journalserialno#'
					 AND    TransactionSerialNo = '#transactionSerialNo#'
					 AND    (
				 				TransactionLineId IN (SELECT ParentLineId 
								                      FROM   TransactionLine 
													  WHERE  ParentLineId = G.TransactionLineId)
								OR				
								ParentLineId is not NULL
							)				  
		   </cfquery>	
		   	   	   	      
		   <cfif actionstatus eq "1">
		   			
					<cfif (access eq "EDIT" or Access eq "ALL") 
					     and TransactionSerialNo neq "0" 		
						 and CheckDis.recordcount eq "0">		
						 
						  <cfif url.summary neq "1">
						 				     				 				 
					  	    <img src="#SESSION.root#/Images/reconcile.gif"
					    	 alt="Process"
						     border="0"
						     style="cursor: pointer;" 
							 onclick="ContinueTransaction('#Journal#','#JournalSerialNo#','#TransactionSerialNo#','#GLAccount#')">
							 
						 </cfif>	 
						 
					 <cfelseif CheckDis.recordcount gte "1">					
					
					      <cf_UItooltip  tooltip="Amount of this lines has been further distributed or was reconciled">
						  
						  ...
						  <!---
					   	  <img src="#SESSION.root#/Images/senddown2.gif"
						     border="0"		
						     style="cursor: pointer;">
							 --->
							
						 </cf_UItooltip> 
						 
					 </cfif>
			 
			 </cfif>
		 
		</cfif>
			 
		 </td>
		 
	 </cfif>
  </TR>
  
  <cfif url.summary neq "1">
  
	  <cfif (ReferenceName neq "" AND ReferenceName neq "Credit" AND ReferenceName neq "Contra-account") or ReferenceNo neq "" or Reference neq "">
	   
	     <tr class="line navigation_row_child" style="border-top:1px solid silver">
		 
		 <td colspan="1"></td>	 
		 <td colspan="12" bgcolor="EfEfEf" style="border-right:1px solid silver">
			 <table cellspacing="0" cellpadding="0">
				 <tr>
				 <td><img src="#SESSION.root#/images/join.gif" alt="" border="0"></td>			
				 <td style="padding-left:4px" class="labelit"><font color="804000">
				 
				       <cfif transactiontype eq "Contra-account">#Memo#&nbsp;</cfif>
				       <cfif (ReferenceName neq "" AND ReferenceName neq "Credit" AND ReferenceName neq "Contra-account")>#ReferenceName#&nbsp;</cfif> 
				       <cfif ReferenceNo neq "">#ReferenceNo#&nbsp;</cfif> 
					   <cfif Reference neq "">#Reference#&nbsp;</cfif>					   
					   <cfif WarehouseItemNo neq "">
		   
						   <cfquery name="Item" 
							datasource="AppsMaterials" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
							SELECT   *
							FROM     Item
							WHERE    ItemNo =  '#WarehouseItemNo#' 	
							</cfquery>
				
							#Item.ItemDescription#&nbsp;
							
					   </cfif>	
					   
					   <cfif OrgUnit neq "">
					   					   
						   <cfquery name="Org" 
							datasource="AppsOrganization" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
							SELECT   *
							FROM     Organization
							WHERE    OrgUnit = '#OrgUnit#' 	
							</cfquery>
							
							#Org.OrgunitName#
					  
					   </cfif>
											   
					   </td>
				 </tr>
			 </table>
		 </td>
		 </tr>  
		 
	  </cfif>
	       
	  <cf_filelibraryCheck
	    	DocumentURL="Ledger"
			DocumentPath="Ledger"
			SubDirectory="#Transaction.TransactionId#" 
			Filter="#TransactionSerialNo#">

	  <cfif files gte "1">		
	
		<tr class="navigation_row_child">
		
			<td colspan="12">
				   
			<cf_filelibraryN
				DocumentPath= "Ledger"
				SubDirectory= "#TransactionId#" 
				Filter      = "#TransactionSerialNo#"
				LoadScript  = "false"
				Insert      = "no"
				Remove      = "no"
				reload      = "false">	
		   
		   </td>
		   
		</tr>
	
	  </cfif>	
  
  </cfif>   
  
</cfoutput>  
