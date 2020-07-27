
<!--- ajax return --->
<cfparam name="url.refresh"       default="0">
<cfparam name="url.box"           default="">
<cfparam name="url.mission"       default="">
<cfparam name="url.orgunit"       default="">
<cfparam name="url.journal"       default="">
<cfparam name="url.source"        default="">
<cfparam name="url.sourceno"      default="">
<cfparam name="url.sourceid"      default="">
<cfparam name="url.debitcredit"   default="Debit">
<cfparam name="url.label"         default="Cost">
<cfparam name="url.editmode"      default="View">
<cfparam name="url.fun"           default="">

<!--- coldfusion componenent --->
<cfparam name="attributes.Box"                 default="ledgerobject">
<cfparam name="attributes.Mission"             default="#url.mission#">
<cfparam name="attributes.OrgUnit"             default="#url.orgunit#">
<cfparam name="attributes.Journal"             default="#url.journal#">
<!--- filter for the context --->
<cfparam name="attributes.TransactionSource"   default="#url.source#">
<cfparam name="attributes.TransactionSourceNo" default="#url.sourceno#">
<cfparam name="attributes.TransactionSourceId" default="#url.sourceid#">
<cfparam name="attributes.editMode"            default="#url.editmode#">
<cfparam name="attributes.debitcredit"         default="#url.debitcredit#">
<cfparam name="attributes.label"               default="#url.label#">
<cfparam name="attributes.function"            default="#url.fun#">
<!--- determine the orgunit owner --->

<cfquery name="Param" 
 datasource="AppsLedger" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
	 SELECT *
	 FROM  Ref_ParameterMission
     WHERE Mission = '#attributes.mission#'
 </cfquery>		

 <cfif Param.AdministrationLevel eq "Tree">
 	
	 <cfparam name="getOwner.OrgUnit" default="">
	  
 <cfelse>
  
 <cfquery name="getOrg" 
 datasource="AppsLedger" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
	 SELECT *
	 FROM  Organization.dbo.Organization
     WHERE OrgUnit = '#attributes.OrgUnit#'
 </cfquery>		
  
 <cfquery name="getOwner" 
 datasource="AppsLedger" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
	 SELECT *
	 FROM  Organization.dbo.Organization
     WHERE Mission   = '#getOrg.Mission#'
	 AND   MandateNo = '#getOrg.MandateNo#'
	 AND   OrgUnit   = '#getOrg.HierarchyRootUnit#'
 </cfquery>		
      
 </cfif>
  
 <cfset accountPeriod = Param.CurrentAccountPeriod>
 
 <table width="100%">
   
  <cfoutput> 
  <cfif url.refresh eq "0">
  <tr class="hide">
	  <td>
	   <input type="button" id="apply" onclick="_cf_loadingtexthtml='';ColdFusion.navigate('#session.root#/Tools/FinanceObject/Transaction/LedgerTransaction.cfm?refresh=1&fun=#attributes.function#&label=#attributes.label#&debitcredit=#attributes.debitcredit#&editmode=edit&mission=#attributes.mission#&OrgUnit=#attributes.OrgUnit#&Journal=#attributes.journal#&source=#attributes.TransactionSource#&sourceno=#attributes.TransactionSourceno#&sourceid=#attributes.TransactionSourceid#&box=#attributes.box#','#attributes.box#')">		   					
	  </td>
  </tr>
  </cfif>
  </cfoutput>

  <tr><td id="ledgerobject">		

	 <table width="100%" class="navigation_label" align="center" style="padding-right:10px;padding:0px">
	 
	 <cfif attributes.journal neq "">
	 
	 	<cfset jrn = attributes.journal>
	 
	 <cfelse>
		 
		 <cfquery name="getJournal" 
		   datasource="AppsLedger" 
		   username="#SESSION.login#" 
		   password="#SESSION.dbpw#">
			 SELECT Journal
			 FROM  Journal
			 WHERE Journal IN (SELECT Journal 
			                   FROM   TransactionHeader 
							   WHERE  Mission = '#attributes.mission#'
							   AND    RecordStatus = 1
							   <cfif attributes.TransactionSourceNo neq "">
								AND TransactionSourceNo  = '#attributes.TransactionSourceNo#'									
							   <cfelse>
								AND TransactionSourceId  = '#attributes.TransactionSourceId#'	
							   </cfif>
							   )		 		
		   </cfquery>		
		   
		   <cfset jrn = valueList(getJournal.Journal)>
		      
	  </cfif> 
	  
	  <cfloop index="jrn" list="#jrn#">
	    
	   <cfquery name="getJournal" 
	   datasource="AppsLedger" 
	   username="#SESSION.login#" 
	   password="#SESSION.dbpw#">
		 SELECT *
		 FROM   Journal
		 WHERE  Journal = '#jrn#'		
	   </cfquery>		
	 
		<cfoutput>
		 			
		   <tr class="line">
		   
		   <td colspan="8">
		   <table cellspacing="0" cellpadding="0">
		   <tr>
		   <td class="labelmedium" style="font-size:16px">#getJournal.Description#</td>
		   <td style="padding-left:8px" class="labelmedium">
		   
		    <!--- allow to add in several journals --->
			   <cfif attributes.editmode eq "edit">
			   
				   <cfoutput>	   
				   <a href="javascript:addledgertransaction('#attributes.mission#','#accountperiod#','#getOwner.orgunit#','#jrn#','#attributes.TransactionSource#','#attributes.TransactionSourceNo#','#attributes.TransactionSourceId#','#attributes.box#','#attributes.debitcredit#','#attributes.label#','#attributes.function#','0')">
				   <font color="0080C0">[<cf_tl id="add transaction">]</font>
				   </a>	  
				   
				   <cfif attributes.transactionSource eq "ReceiptSeries" and (getJournal.currency eq Application.BaseCurrency)>
				   
				    <cfquery name="getCost" 
					   datasource="AppsPurchase" 
					   username="#SESSION.login#" 
					   password="#SESSION.dbpw#">
						 SELECT *
						 FROM  ReceiptCost
						 WHERE ReceiptNo = '#attributes.TransactionSourceNo#'	
						 AND CostId IN (SELECT CostId 
						                FROM PurchaseLineReceiptCost)	
				    </cfquery>		
					
					<cfloop query="getCost">
					
						<cfquery name="CostTotal" 
							datasource="AppsPurchase" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
								SELECT   SUM(AmountCost) as AmountCost
								FROM     PurchaseLineReceiptCost
								WHERE    ReceiptId IN (SELECT ReceiptId 
								                       FROM   PurchaseLineReceipt
													   WHERE  ReceiptNo = '#attributes.TransactionSourceNo#'
													   AND    ActionStatus != '9')				
								AND      CostId = '#CostId#'			
						  </cfquery>
					
					  <a href="javascript:addledgertransaction('#attributes.mission#','#accountperiod#','#getOwner.orgunit#','#jrn#','#attributes.TransactionSource#','#attributes.TransactionSourceNo#','#costId#','#attributes.box#','#attributes.debitcredit#','#attributes.label#','#attributes.function#','#costTotal.amountCost#')">
					   <font color="0080C0">[<cf_tl id="add #description#">]</font>
					   </a>	  
					
					</cfloop>
							   
				   
				   </cfif>
				 
				   </cfoutput>
			 
			   </cfif>
			   
		   </td>
		   </tr>
		   </table>
		   
		   </td>
		  	 
		   </td>   
		   
		   </tr>
		   
		</cfoutput>
	  
	    <!--- add the header for that journal --->
	   		   
	    <tr class="labelmedium line">
		 <td width="30"></td>
		 <td><cf_tl id="TransactionNo"></td>
		 <td><cf_tl id="description"></td>
		 <td><cf_tl id="Account"></td>
		 <td><cf_tl id="Currency"></td>
		 <td align="right"><cf_tl id="Amount"></td>
		 <!---
		 <td class="labelsmall" align="right">Debit</td>
		 <td class="labelsmall" align="right">Credit</td>
		 --->
		 <td align="right" style="padding-right:0px"><cfoutput>#application.BaseCurrency# Tax</cfoutput></td>
		 <td align="right" style="padding-right:0px"><cfoutput>#application.BaseCurrency# #url.label#</cfoutput></td>
		
	   </tr>
	  
	   <cfquery name="LedgerTransactionData" 
		 datasource="AppsLedger" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
		 
		    SELECT     H.Journal,
					   H.JournalSerialNo,
					   R.GLAccount, 
			           R.Description, 
					   H.Description AS TransactionDescription, 
					   H.JournalTransactionNo, 
					   H.TransactionSourceId,
					   L.Currency, 
					   R.TaxAccount,
					   L.TransactionAmount, 
					   L.AmountDebit, 
					   L.AmountCredit, 
					   L.AmountBaseDebit, 
	                   L.AmountBaseCredit, 
					   H.ReferenceNo AS TransactionReference, 
					   H.Reference
		    FROM       TransactionHeader H INNER JOIN
	                   TransactionLine L ON H.Journal = L.Journal AND H.JournalSerialNo = L.JournalSerialNo INNER JOIN
	                   Ref_Account R ON L.GLAccount = R.GLAccount
					   
			WHERE      H.Mission        = '#attributes.mission#'
		    AND        H.Journal        = '#jrn#'
			AND        H.TransactionSource    = '#attributes.TransactionSource#'
			<cfif attributes.TransactionSourceNo neq "">
			AND        H.TransactionSourceNo  = '#attributes.TransactionSourceNo#'									
			<cfelse>
			AND        H.TransactionSourceId  = '#attributes.TransactionSourceId#'	
			</cfif>
			AND        H.ActionStatus  <> '9' 		
			AND        H.RecordStatus  = '1' <!--- excludedvoided --->
			AND        L.TransactionSerialNo != '0'  
			<!--- exclude tax bookings 
			AND        R.TaxAccount    = '0'
			--->
			ORDER BY   JournalTransactionNo,Taxaccount
			
					
	   </cfquery>	
	   
	   <cfif LedgerTransactionData.recordcount eq "0">
	   
	   		<tr><td class="labelit" style="padding-top:5px" align="center" colspan="8"><font color="808080"><cf_tl id="There are no records to show in this view"></td></tr>
	   
	   <cfelse>
	   
	  		<cfset prior = "">
	       										 
		   <cfoutput query="LedgerTransactionData">	
		   		 			
			 <tr class="navigation_row labelmedium line">
			 
					  			   
			   <cfif prior eq journaltransactionNo>
			     <td colspan="3"></td>
			   <cfelse>	 
			   
			    <td style="height:20;padding-left:20px">
			   <cfif attributes.editmode eq "view">
			   <cf_img icon="select" class="navigation_action" onclick="ShowTransaction('#journal#','#journalserialno#','source')">
			     <!--- ensure that the transaction is closed --->
			   <cfelse>
			   <cf_img icon="edit" class="navigation_action" onclick="ShowTransaction('#journal#','#journalserialno#','source')">			   
			   </cfif>
			   
			   </td>
			   <td>#JournalTransactionNo#</td>
			   <td>#TransactionDescription#</td>
			   </cfif>
			   
			   <td>#Description#</td>
			   <td>#Currency#</td>
			   <td align="right" style="padding-right:0px"><cfif taxaccount eq "0">#numberformat(TransactionAmount,',.__')#</cfif></td>
			   
			   <cfif taxaccount eq "1">
			   
			    <cfif url.debitcredit eq "Debit">
			     <td align="right" style="<cfif transactionSourceId neq ''>background-color:FFCAFF</cfif>;padding-right:4px;border-left:0px solid silver">#numberformat(AmountBaseDebit-AmountBaseCredit,',.__')#</td>
			   <cfelse>
			     <td align="right" style="<cfif transactionSourceId neq ''>background-color:FFCAFF</cfif>;padding-right:4px;border-left:0px solid silver">#numberformat(AmountBaseCredit-AmountBaseCredit,',.__')#</td>
			   </cfif>
			   <td></td>
			   
			   <cfelse>
			   
			   <td></td>
			   <cfif url.debitcredit eq "Debit">
			     <td align="right" style="<cfif transactionSourceId neq ''>background-color:FFCAFF</cfif>;padding-right:4px;border-left:0px solid silver">#numberformat(AmountBaseDebit-AmountBaseCredit,',.__')#</td>
			   <cfelse>
			     <td align="right" style="<cfif transactionSourceId neq ''>background-color:FFCAFF</cfif>;padding-right:4px;border-left:0px solid silver">#numberformat(AmountBaseCredit-AmountBaseCredit,',.__')#</td>
			   </cfif>
			   
			   </cfif>
			  
			 </tr>	
			 
			 <cfset prior = journaltransactionno>		
			 		 		 
		   </cfoutput>	 
		   
		 </cfif>  
	   
	</cfloop> 
	 
	</table>

</td>
</tr>
</table>	

<cfif jrn neq "">
	
	<cfif url.debitcredit eq "Debit">
		
		<cfquery name="Gledger" dbtype="query">
				 SELECT sum(AmountBaseDebit-AmountBaseCredit) as Total
				 FROM  LedgerTransactionData
		</cfquery>
	
	<cfelse>
	
			
		<cfquery name="Gledger" dbtype="query">
				 SELECT sum(AmountBaseCreidt-AmountBaseDebit) as Total
				 FROM  LedgerTransactionData
		</cfquery>
	
	</cfif>
	
<cfset caller.transactionTotal = Gledger.total>

</cfif>

<cfoutput>

<cfif url.fun neq "">
	<script language="JavaScript">
	#attributes.function#()
	</script>
</cfif>

</cfoutput>

