
<cfparam name="url.OrgUnitOwner"    default="">
<cfparam name="url.PurchaseNo"      default="">

<cfparam name="url.InvoiceJournal"  default="">

<cfquery name="PO" 
	  datasource="AppsOrganization" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	  SELECT   *
	  FROM     Purchase.dbo.Purchase
	  WHERE    PurchaseNo = '#url.PurchaseNo#' 
</cfquery>

<cfparam name="url.Mission"         default="#PO.Mission#">

<cfquery name="Param" 
	  datasource="AppsLedger" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	  SELECT   *
	  FROM     Ref_ParameterMission
	  WHERE    Mission = '#url.Mission#'
</cfquery>

<cfparam name="url.currency"        default="#PO.Currency#">

<cfquery name="PostJournals" 
	  datasource="AppsLedger" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	      SELECT   *
	      FROM     Journal
	   	  WHERE    Mission     			= '#url.mission#'
		  AND	   Currency				= '#url.Currency#'
		  <cfif Param.AdministrationLevel eq "Parent">
		  AND      OrgUnitOwner = '#url.owner#'
		  </cfif>
		  AND	   TransactionCategory 	= 'Payables'
		  AND      (<cfif PO.OrgUnitVendor neq 0>
		  				SystemJournal = 'Procurement' 
		  			<cfelse>
		  				SystemJournal = 'Employee' 
		  			</cfif>
		  			or SystemJournal is NULL)
		  ORDER BY Journal ASC		  
</cfquery>

<cfif PostJournals.recordCount eq 0>

	<cfquery name="PostJournals" 
	  datasource="AppsLedger" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	      SELECT   *
	      FROM     Journal
	   	  WHERE    Mission     			= '#url.mission#'
		  AND	   Currency				= '#PO.Currency#'
		  <cfif Param.AdministrationLevel eq "Parent">
		  AND      OrgUnitOwner = '#url.owner#'
		  </cfif>
		  AND	   TransactionCategory 	= 'Payables'
		  AND      (<cfif PO.OrgUnitVendor neq 0>
		  					SystemJournal = 'Procurement' 
		  				<cfelse>
		  					SystemJournal = 'Employee' 
		  			</cfif>
		  			or SystemJournal is NULL)
		  ORDER BY Journal ASC 		  
	</cfquery>
		
</cfif>

<cfif trim(url.InvoiceJournal) neq "">

	<cfif PostJournals.recordCount lte 0>
		<table>
			<tr>
				<td align="center" class="labelmedium" height="70%"><cf_tl id="Attention no journal selected"></td>
			</tr>
		</table>
	<cfelse>
		<select name="PostingJournal" id="PostingJournal" class="enterastab regularxxl">	
			<cfoutput query="PostJournals">
	    	  <option value="#Journal#" <cfif URL.InvoiceJournal eq PostJournals.Journal>selected</cfif>>#Journal# - #Description#</option>				
			</cfoutput>  		
		</select>		
	</cfif>

<cfelse>

	<!--- obtain the detault --->
	
	<cfif PO.OrgUnitVendor neq 0>
	
		<cfquery name="Journal" 
			    datasource="AppsLedger" 
			    username="#SESSION.login#" 
			    password="#SESSION.dbpw#">
					SELECT    TOP 1  
					          J.Journal,
					          J.OrgUnitOwner,
							  J.Currency,
							  JA.GLAccount
					FROM      Journal J INNER JOIN JournalAccount JA ON J.Journal = JA.Journal
					WHERE     Mission       = '#url.Mission#' 
					AND       SystemJournal = 'Procurement'					
					<cfif Param.AdministrationLevel eq "Parent">
					AND       OrgUnitOwner = '#url.owner#'
					</cfif>
					AND       Currency      = '#url.Currency#' 		
					ORDER BY  J.Journal ASC
		</cfquery>
		
	<cfelse>
	
		<cfquery name="Journal" 
			    datasource="AppsLedger" 
			    username="#SESSION.login#" 
			    password="#SESSION.dbpw#">
					SELECT    TOP 1 J.Journal,
					          J.OrgUnitOwner,
							  J.Currency,
							  JA.GLAccount
					FROM      Journal J INNER JOIN JournalAccount JA ON J.Journal = JA.Journal
					WHERE     Mission       = '#url.Mission#' 
					AND       SystemJournal = 'Employee'
					<cfif Param.AdministrationLevel eq "Parent">
					AND       Owner = '#url.owner#'
					</cfif>
					AND       Currency      = '#url.Currency#' 		
					ORDER BY J.Journal ASC	
		</cfquery>
		
	</cfif>
		<cfif PostJournals.recordCount lte 0>
			<table>
				<tr>
					<td align="center" class="labelmedium" height="70%">
					<cf_tl id="Attention no journal selected! -#url.InvoiceJournal#-">
					</td>
				</tr>
			</table>
		<cfelse>
			<select name="PostingJournal" id="PostingJournal" class="enterastab regularxxl">
				<cfoutput query="PostJournals">		
		    	  <option value="#Journal#"	<cfif PostJournals.Journal eq Journal.Journal>selected</cfif>>#Journal# - #Description#</option> 			
				</cfoutput>  
			</select>	
		
		</cfif>
	
</cfif>
