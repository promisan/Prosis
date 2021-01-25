
<!--- ------------------------------- --->	
<!--- retrieve the header information --->
<!--- ------------------------------- --->

<cfparam name="editmode" default="Full">
	
<cfquery name="HeaderSelect"
datasource="AppsQuery" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM   #SESSION.acc#GledgerHeader_#client.sessionNo#_#session.mytransaction#
</cfquery>

<cfparam name="url.accountperiod" default="">
<cfparam name="url.pap"           default="">

<cfif url.accountPeriod neq "" and url.pap neq "">

	<cfset dateValue = "">
	<CF_DateConvert Value="#url.pap#">
	<cfset tradte = dateValue>
	
	<cfquery name="apply"
		datasource="AppsQuery" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
	    UPDATE #SESSION.acc#GledgerLine_#client.sessionNo#_#session.mytransaction#
		SET    AccountPeriod    = '#url.accountperiod#',
		       TransactionDate  = #tradte#
		WHERE  GLAccount IN (SELECT GLAccount FROM Accounting.dbo.Ref_Account WHERE AccountClass = 'Balance')
	</cfquery>

</cfif>

<!--- ------------------------------ --->
<!--- retrieve the transaction lines --->
<!--- ------------------------------ --->

<cfquery name="Line"
datasource="AppsQuery" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT   L.*, 
	         O.OrgUnitCode, 
		     O.OrgUnitName, 
		     A.Description,
		     A.AccountLabel
	FROM     #SESSION.acc#GledgerLine_#client.sessionNo#_#session.mytransaction# L LEFT OUTER JOIN 
	         Organization.dbo.Organization O ON L.OrgUnit = O.OrgUnit INNER JOIN
		     Accounting.dbo.Ref_Account A ON A.GLAccount = L.GLAccount
	WHERE    L.TransactionSerialNo != '0' 
	ORDER BY TransactionType   
</cfquery>		

<!--- generate a contra-transaction if ,of-course, defined on the journal --->

<cfquery name="Children"
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM  TransactionLine
	WHERE ParentJournal          = '#HeaderSelect.Journal#'
	AND   ParentJournalSerialNo  = '#HeaderSelect.JournalSerialNo#'	
</cfquery>

<cfquery name="getJournal"
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM  Journal
	WHERE Journal  = '#HeaderSelect.Journal#'	
</cfquery>

<cfparam name="URL.ContraGLAccount" default="#HeaderSelect.ContraGLAccount#">

<cfoutput query="HeaderSelect">
    <cfset glacc  = url.ContraGLAccount>
	<cfset tracat = TransactionCategory>
</cfoutput>

<cfif HeaderSelect.recordCount is 0>
     <cfabort>
</cfif>

<cfquery name="Clear" 
	datasource="AppsQuery" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		DELETE FROM   #SESSION.acc#GledgerLine_#client.sessionNo#_#session.mytransaction# WHERE TransactionSerialNo = '0' 
</cfquery> 

<cfset caggregate = "0">

<cfif Line.recordcount neq "0">
   	
	<cfquery name="Contra" 
		datasource="AppsQuery" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT   ParentJournal, 
			     ParentJournalSerialNo,
			     ISNULL(ParentLineId,'00000000-0000-0000-0000-000000000000') as ParentLineId		                 
		FROM     #SESSION.acc#GledgerLine_#client.sessionNo#_#session.mytransaction# 	
		GROUP BY ParentJournal,ParentJournalSerialNo,ParentLineId  	
	</cfquery>	
	
	<!--- correction in case of payment order with several corrections on the contra not to result in debit and credit transaction 
	 : ana 21/11/2021 --->
	
	<cfif Contra.recordcount gt "1">
	
		<cfquery name="CheckManual" dbtype="query">
			SELECT *
			FROM  Contra
			WHERE ParentLineId = '00000000-0000-0000-0000-000000000000'		
		</cfquery>	
	
		<cfif checkManual.recordcount gte "1">
		
			<cfset caggregate = "1">
			
			<!--- we just take one line for posting replace the contra query --->
			
			<cfquery name="Contra" dbtype="query">
				SELECT *
				FROM  Contra
				WHERE ParentLineId = '00000000-0000-0000-0000-000000000000' 	
			</cfquery>	
			
		</cfif>	
		
	</cfif>
	
	<cfset apply = "0">
									
	<cfloop query="Contra">	
						
		<cfif caggregate eq "0">
													
			<cfquery name="Header" 
			datasource="AppsLedger" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT H.*
				FROM   TransactionLine L INNER JOIN TransactionHeader H ON L.Journal = H.Journal AND L.JournalSerialNo = H.JournalSerialNo				      
				WHERE  L.TransactionLineId = '#ParentLineId#' 
				UNION ALL
				SELECT H.*
				FROM   TransactionLine L INNER JOIN TransactionHeader H ON L.Journal = H.Journal AND L.JournalSerialNo = H.JournalSerialNo				      
				WHERE  H.TransactionId = '#ParentLineId#'						
			</cfquery>		
						
			<cfif Header.recordcount eq "0">
			
			    <!--- not found, lets try to detect the correct parentlineid --->
				
				<cfquery name="Check" 
				datasource="AppsLedger" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT TransactionLineId
					FROM   TransactionLine
					WHERE  Journal             = '#ParentJournal#'
					AND    JournalSerialNo     = '#ParentJournalSerialNo#'
					AND    TransactionSerialNo = '0'					
				</cfquery>		
				
				<cfquery name="Header" 
				datasource="AppsLedger" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT H.*
					FROM   TransactionLine L, 
					       TransactionHeader H
					WHERE  L.Journal = H.Journal
					AND    L.JournalSerialNo = H.JournalSerialNo				      
					AND    L.TransactionLineId IN (
					
							SELECT TransactionLineId
							FROM   TransactionLine
							WHERE  Journal             = '#ParentJournal#'
							AND    JournalSerialNo     = '#ParentJournalSerialNo#'
							AND    TransactionSerialNo = '0'	
					
					)
								
				</cfquery>		
							
			</cfif>	
		
		</cfif>
					
		<cfquery name="Total" 
			datasource="AppsQuery" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT SUM(AmountDebit)     - SUM(AmountCredit) as Diff, 
				       SUM(AmountBaseDebit) - SUM(AmountBaseCredit) as DiffB 
				FROM   #SESSION.acc#GLedgerLine_#client.sessionNo#_#session.mytransaction#
				WHERE  1=1
				<cfif caggregate eq "1">
				    <!--- we take all lines in batch --->
				<cfelse>
					<cfif ParentLineId neq "00000000-0000-0000-0000-000000000000">
					AND    ParentLineId        = '#ParentLineId#' 
					<cfelse>
					AND    ParentLineId is NULL
					</cfif>		
				</cfif>				
				AND    TransactionSerialNo != '0'		
									
		</cfquery>
									
		<cfif glacc neq "" and Total.Diff neq "">
		
			<!--- generate a contra-transaction --->
						
			<cfif total.Diff lt "0">
			   <cfset amtD = abs(Total.Diff)>
			   <cfset amtC = 0>
			<cfelse>
			   <cfset amtC = abs(Total.Diff)>
			   <cfset amtD = 0>
			</cfif>
			
			<cfif total.DiffB lt "0">
			   <cfset amtBD = abs(Total.DiffB)>
			   <cfset amtBC = 0>
			<cfelse>
			   <cfset amtBC = abs(Total.DiffB)>
			   <cfset amtBD = 0>
			</cfif>
												
			<cftry>
			<cfset exch = total.Diff/total.DiffB>
			<cfcatch><cfset exch = 1></cfcatch>
			</cftry>
									
			<cfif (Total.Diff neq "" or Total.DiffB neq "") and Total.Diff neq "0" or Total.DiffB neq "0">
									
				<!--- check for reusing the same TransactionLineId to 
				     retain a link where possible to underlying transactions such like payables and reconciliation but
					 this we do only if there is just one line either in the recorded or in the new lines  --->
				
				<cftry>		
								
				<cfquery name="Check" 
				 datasource="AppsLedger" 
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">
						SELECT  *
						FROM    TransactionLine
						WHERE   Journal               = '#HeaderSelect.Journal#'
						AND     JournalSerialNo       = '#HeaderSelect.JournalSerialNo#'	
						<!---   provision added 10/5/2010 based on obsevation kristina to edit 
						        a payment reconciliation record)" ---> 
						<cfif amtD gt 0>
						AND     AmountDebit > 0 
						<cfelse>
						AND     AmountCredit > 0
						</cfif>						  
						AND     TransactionSerialNo   = '0'						
				</cfquery>
				
				<!--- not allowed --->				
				
				<cfif Check.recordcount eq "1" and apply eq "0">
				
				   <!--- provision added 10/5/2010 based on obsevation kristina to edit a payment reconciliation record 
				   adjust a but by hanno to prevent doubles ---> 		
				   		 			  
				   <cfset lineid = Check.TransactionLineId>		
				   <cfset apply = "1">		   
				   
				<cfelse>
				
				   <cf_assignId>
				   <cfset lineid = rowguid>				  
				   
				</cfif>
			
				<cfcatch>	
						
					<cf_assignId>					
				    <cfset lineid = rowguid>
					 
				</cfcatch>
			
			</cftry>
									 											
			<cfquery name="Insert" 
				datasource="AppsQuery" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				INSERT INTO dbo.#SESSION.acc#GLedgerLine_#client.sessionNo#_#session.mytransaction#
					   (Journal, 
					   JournalSerialNo,
					   TransactionSerialNo, 
					   TransactionLineId,
					   ReconciliationPointer,
					   GLAccount,
					   AccountPeriod,
					   TransactionDate,
					   TransactionType,
					   TransactionCurrency, 
					   TransactionAmount,
					   ExchangeRate,
					   Currency,
					   AmountDebit,
					   AmountCredit,
					   ExchangeRateBase,
					   AmountBaseDebit,
					   AmountBaseCredit, 
					   Created,
					   <cfif caggregate eq "1">
					   ParentTransactionId
					   <cfelse>
						   <cfif ParentLineId neq "" and Header.Recordcount gte "1">					   
						   ParentTransactionId,ParentJournal,ParentJournalSerialNo
						   <cfelse>
						   ParentTransactionId
						   </cfif>
					   </cfif>	   
					   )
					VALUES 
					   ('#HeaderSelect.Journal#',
					   '0',
					   '0',
					   '#lineid#', 
					   '0',
					   '#glacc#',
					   '#HeaderSelect.AccountPeriod#',
					   '#HeaderSelect.TransactionDate#',
					   'Contra-Account',
					   '#HeaderSelect.currency#',
					   '#abs(Total.Diff)#',
					   '1',
					   '#HeaderSelect.currency#',
					   '#amtD#',
					   '#amtC#',
					   '#exch#',
					   '#amtBD#',
					   '#amtBC#', 
					   getDate(),
					   <cfif caggregate eq "1">
					        '{00000000-0000-0000-0000-000000000000}'
					   <cfelse>		
						   <cfif ParentLineId neq "" and Header.Recordcount gte "1">
						        '#Header.TransactionId#','#Header.Journal#','#Header.JournalSerialNo#'
						   <cfelse>
						        '{00000000-0000-0000-0000-000000000000}'
							</cfif>
						</cfif>)
			</cfquery>				
						
			</cfif>
			
		</cfif>	
		
								
	</cfloop>	
		
	<!--- correct for base currency --->
		
	<cfquery name="Sum" 
	  datasource="AppsQuery" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	  SELECT SUM(AmountBaseDebit) - SUM(AmountBaseCredit) as DiffB
	  FROM   #SESSION.acc#GLedgerLine_#client.sessionNo#_#session.mytransaction#
	</cfquery>
						
	<!--- Correction --->
				
	<cfif sum.diffB neq "0" and glacc neq "" and sum.diffB neq "">
	
		<cfquery name="Line" 
		  datasource="AppsQuery" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
		    SELECT    TOP 1 *
		    FROM      #SESSION.acc#GLedgerLine_#client.sessionNo#_#session.mytransaction#
		</cfquery>
		
		<cfquery name="Correct" 
		  datasource="AppsQuery" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
		     UPDATE #SESSION.acc#GLedgerLine_#client.sessionNo#_#session.mytransaction#
		     SET    AmountBaseDebit = AmountBaseDebit - #sum.diffB# 
		     WHERE TransactionLineId = '#line.TransactionLineId#'		 
		</cfquery>
										
	</cfif>		
	
	<cfquery name="Check" 
	    datasource="AppsQuery" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT   SUM(AmountDebit) as AmountDebit,
			         SUM(AmountCredit) as AmountCredit,
				     L.GLAccount,
			         A.Description,
				     A.AccountLabel
			FROM     #SESSION.acc#GledgerLine_#client.sessionNo#_#session.mytransaction# L INNER JOIN Accounting.dbo.Ref_Account A ON A.GLAccount = L.GLAccount
			WHERE    TransactionSerialNo = '0'
			GROUP BY L.GLAccount, A.Description,A.AccountLabel
	</cfquery>
	
	<cfif check.amountDebit gt check.amountCredit>
	
		<cfquery name="Contra" 
		    datasource="AppsQuery" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT SUM(AmountDebit-AmountCredit) as AmountDebit,
				       0 as AmountCredit,
					   SUM(AmountBaseDebit-AmountBaseCredit) as AmountBaseDebit,
					   0 as AmountBaseCredit,
					   L.GLAccount,
				       A.Description,
					   A.AccountLabel
				FROM   #SESSION.acc#GledgerLine_#client.sessionNo#_#session.mytransaction# L INNER JOIN Accounting.dbo.Ref_Account A ON A.GLAccount = L.GLAccount					  
				WHERE   TransactionSerialNo = '0'
				GROUP BY L.GLAccount, A.Description,A.AccountLabel
		</cfquery>
		
	<cfelse>	
	
		<cfquery name="Contra" 
		    datasource="AppsQuery" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT SUM(AmountCredit-AmountDebit) as AmountCredit,
				       0 as AmountDebit,
					   SUM(AmountBaseCredit-AmountBaseDebit) as AmountBaseCredit,
					   0 as AmountBaseDebit,
					   L.GLAccount,
				       A.Description,
					   A.AccountLabel
				FROM   #SESSION.acc#GledgerLine_#client.sessionNo#_#session.mytransaction# L INNER JOIN Accounting.dbo.Ref_Account A ON A.GLAccount = L.GLAccount
				WHERE  TransactionSerialNo = '0'
				GROUP BY L.GLAccount, A.Description,A.AccountLabel
		</cfquery>	
	
	</cfif>
		
	<cfquery name="Line"
		datasource="AppsQuery" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT   L.*, 
			         O.OrgUnitCode, 
				     O.OrgUnitName, 
				     A.Description,
					 A.AccountLabel
			FROM     #SESSION.acc#GledgerLine_#client.sessionNo#_#session.mytransaction# L INNER JOIN
                     Accounting.dbo.Ref_Account A ON L.GLAccount = A.GLAccount LEFT OUTER JOIN
                     Organization.dbo.Organization O ON L.OrgUnit = O.OrgUnit	   			
			WHERE    TransactionSerialNo != '0'
			ORDER BY TransactionSerialNo ASC, SerialNo asc , L.Created asc
	</cfquery>	
	
</cfif>

<cfparam name="url.pap" default="">
  
<cfif url.pap neq "">
	<CF_DateConvert Value = "#url.pap#">
<cfelse>
	<CF_DateConvert Value = "#dateformat(now(),client.dateformatshow)#">
</cfif>			
<cfset pap = dateValue>
   
<cfif line.recordcount eq "0">

<table width="100%" style="max-height:170px;background-color:f1f1f1">

<tr><td style="height:30px;font-size:16px;background-color:f4f4f4;color:gray" class="labelmedium2"" align="center"><cf_tl id="No transactions are set"></td></tr></table>

<cfelseif line.recordcount gte "1" and total.recordcount eq "1">

<table width="100%" style="height:100%" align="center">

<tr><td>

	<!---
	<cf_divscroll overflowy="scroll">
	--->

	<table width="99%" align="center" class="navigation_table">
	   
	   <tr bgcolor="ffffff" class="line labelmedium2" fixrow">
	   
	      <TD style="width:20px" height="20"></TD>
	      <TD style="width:20px"></TD>
		  <td><cf_tl id="PAP"></td>	
	      <TD><cf_tl id="Acc"></TD>		
	      <td><cf_tl id="Name"></td>	
	      <td style="border-right: 1px solid Silver;"><cf_tl id="Reference"></td>		
		  <td align="right" style="border-right: 1px solid Silver;padding-right:2px;"><cf_tl id="Debit"></td>
		  <TD align="right" style=";padding-right:2px;border-right: 1px solid Silver;"><cfoutput>#APPLICATION.BaseCurrency#</cfoutput></TD>
	      <TD align="right" style=";padding-right:2px;border-right: 1px solid Silver;"><cf_tl id="Credit"></TD>   
	      <TD align="right" style="padding-right:2px;"><cfoutput>#APPLICATION.BaseCurrency#</cfoutput></TD>    
		</tr>  	
	  	
	   <cfoutput query="Contra">
	   
		   <cfset color = "f4f4f4">
		         
		   <tr bgcolor="#color#" class="labelmedium2" line navigation_row">
		      
			   <td height="20" align="center" valign="middle"></td>	   
			   <td></td>
			   <td style="padding-left:2px;padding-right:8px">
			   	  #year(pap)#<cfif month(pap) lt 10>0</cfif>#month(pap)#		    		   
			   </td>
			   <td width="80"><cfif accountLabel neq "">#AccountLabel#<cfelse>#GLAccount#</cfif></td>
			   <td width="25%">#Description#</td>
			   <td style="border-right: 1px solid Silver;"></td>
			   <td align="right" style="border-right: 1px solid Silver;;padding-right:2px;">
			   <cfif AmountDebit is not "">#NumberFormat(AmountDebit,',.__')#</cfif></td>
			   <td align="right" bgcolor="fafafa" style=";padding-right:2px;border-right: 1px solid Silver;">
			   <cfif AmountBaseDebit is not ""><font color="C0C0C0">#NumberFormat(AmountBaseDebit,',.__')#</cfif></td>
			   <td align="right" style="border-right: 1px solid Silver;;padding-right:2px;">
			   <cfif AmountCredit is not "">#NumberFormat(AmountCredit,',.__')#</cfif></td>	  
			   <td align="right" bgcolor="fafafa" style="padding-right:2px;">
			   <cfif AmountBaseCredit is not ""><font color="C0C0C0">#NumberFormat(AmountBaseCredit,',.__')#</cfif></td>   
		   
		   </TR>
		         
	   </cfoutput>	
	   
	   <cfset prior = "">
	       
	   <cfoutput query="Line">
		   
		   <tr id="d#TransactionSerialNo#" class="navigation_row labelmedium2" line" style="height:25px">
		      
		   <td width="5%" align="center">  
		  		 
			 <cfif amountbasedebit gt 0>
			     <cfset md = "debit">
			 <cfelse>
			     <cfset md = "credit">
			 </cfif>
			 
			 <!--- do not allow for change of line if the transaction has details already --->
	
			 <cfquery name="ChildrenLine"
				datasource="AppsLedger" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT *
				FROM TransactionLine
				WHERE ParentLineId    = '#TransactionLineId#'
			 </cfquery>		 
				 	    
			 <cfif JournalSerialNo eq "0" or 
			      Children.recordcount eq "0" or (getAdministrator("*") eq "1" and ChildrenLine.recordcount eq "0")>
			 
			     <!--- 20/12/2009 it is not allowed to edit a transaction that was generated from a prior transaction, you would have to remove it --->
				 <!--- old : <cfif TransactionSerialNo neq prior and ParentLineId eq ""> --->
				 
				 <table align="left" width="60" cellspacing="0" cellpadding="0">
				 
				 <tr class="labelmedium2"">
				 
				 <td style="width:20;padding-left:2px;padding-right:1px" onClick="maximize('#serialno#')">		
				 			 									 
			        <img src="#SESSION.root#/Images/arrowright.gif" alt="" 
						id="t_#serialno#_Exp" border="0" class="regular" 
						align="absmiddle" style="cursor: pointer" height="11">
						
					<img src="#SESSION.root#/Images/arrowdown.gif" 
						id="t_#serialno#_Min" alt="" border="0" 
						align="absmiddle" class="hide" height="11" 
						style="cursor: pointer;">														   
					
				</td>
				
				<!--- determine if we can change the lines --->
				
				<cfif HeaderSelect.transactionSource eq "AccountSeries" or OfficerUserId eq "">
				
					<cfset external = "0">
				
				<cfelse>
				
					<cfset external = "1">
				
				</cfif>
				
				<cfif editmode eq "full" and external eq "0">
							 
				   <cfif TransactionSerialNo neq prior>
				 
	 			   <td style="width:20;padding-top:2px;padding-left:2px">
				   			       
				   	   <cfif AmountDebit gt "0">
						   	<cfset debcre = "Debit">
					   <cfelse>
				   			<cfset debcre = "Credit">
					   </cfif>
				   			   
				    	<cf_img icon="edit"	navigation="yes" onClick="editline('#journalserialno#','#accountperiod#','#dateformat(transactiondate,client.dateformatshow)#','#headerselect.transactioncategory#','#transactiontype#','#debcre#','#reference#','#md#','#glaccount#','#transactioncurrency#','#TransactionAmount#','#TransactionTaxCode#','#Memo#','#OrgUnit#','#ProgramCode#','#programCodeProvider#','#contributionlineid#','#TransactionSerialNo#','#fund#','#objectcode#','#warehouse#','#warehouseitemno#','#warehouseitemuom#','#warehousequantity#','#parentlineid#','#parenttransactionid#','#exchangerate#','#exchangeratebase#')">
				     				
					 <cfset prior = TransactionSerialNo>
					 
					</td>  
					
				  <cfelse>
				
					 <td style="width:20;padding-left:4px"></td>	
				
				  </cfif>
				
				  <td style="width:20;padding-top:2px;padding-left:0px;padding-right:2px">				
					<cf_img icon="delete" onClick="deleteline('#TransactionSerialNo#')">				
				   </td>	
				   
				 <cfelse>
				 
				 <!--- no edit mode --->
				 <td></td>  	
				 <td></td>
				 
				 </cfif>
				
				</tr>
				</table>	
					
			<cfelse>
			
				  <img src="#SESSION.root#/images/logon.gif" 			   
					alt="Line distributed, can not be changed" 
					height="13" width="13" 
					name="Lock" id="Lock" 
					border="0" 
					align="absmiddle">
					
			    		
			</cfif>
							 
		   </td>
				
		   <td style="min-width:40px;padding-left:2px;padding-right:2px">#TransactionSerialNo#</td>
		   <td style="padding-left:2px;padding-right:8px">
		   <cfif transactiondate eq "">	   
		   #year(pap)#<cfif month(pap) lt 10>0</cfif>#month(pap)#
		   <cfelse>
		   #year(TransactionDate)#<cfif month(transactiondate) lt 10>0</cfif>#month(TransactionDate)#
		   </cfif>
		   </td>
		   <td style="min-width:100px"><cfif accountLabel neq "">#AccountLabel#<cfelse>#GLAccount#</cfif></td>
		   <td style="width:50%">#Description#</td>
		   <td style="border-right: 1px solid Silver;WIDTH:50%;min-width:100px">
		       <cfif TraCat is "Payment">
			       #Memo#
			       <!---
		           <A HREF ="javascript:ShowVendor('#Reference#','9')">#ReferenceName#</a>
				   --->
			   <cfelse>#ReferenceName# #Memo#
			   </cfif>
		   </td>
		   	   	   	   		
		   <td align="right" style="min-width:100px;border-right: 1px solid Silver;border-bottom: 1px solid Silver;padding-right:2px;">
			   <cfif AmountDebit is not "">#NumberFormat(AmountDebit,',.__')#</cfif></td>
		   <td align="right" style="background-color:##fafafa80;min-width:100px;border-right: 1px solid Silver;border-bottom: 1px solid Silver;padding-right:2px;"><i>
			   <cfif AmountBaseDebit is not ""><font color="C0C0C0">#NumberFormat(AmountBaseDebit,',.__')#</cfif></td>   
		   <td align="right" style="min-width:100px;border-right: 1px solid Silver;border-bottom: 1px solid Silver;padding-right:2px;">
			   <cfif AmountCredit is not "">#NumberFormat(AmountCredit,',.__')#</cfif></td>	  
		   <td align="right" style="background-color:##fafafa80;min-width:100px;border-bottom: 1px solid Silver;;padding-right:2px;"><i>
			   <cfif AmountBaseCredit is not ""><font color="C0C0C0">#NumberFormat(AmountBaseCredit,',.__')#</cfif></td>   
		   </TR>
	
	      <cfif ParentLineId neq "">
		
			   <cfquery name="ParentLine"
				datasource="AppsLedger" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				    SELECT *
				    FROM TransactionLine
		                    WHERE TransactionLineId = '#ParentLineId#'	 
		   	   </cfquery>	
		    
		       <cfif ParentLine.recordcount eq "1">
		
		           <tr class="navigation_row_child labelmedium2"><td colspan="2"></td><td><cf_tl id="Source">:</td>		  
		               <td colspan="7">		
		
		                      <cfif ParentLine.ParentJournal neq "">
		
			                         <cfquery name="ParentHeader"
										datasource="AppsLedger" 
										username="#SESSION.login#" 
										password="#SESSION.dbpw#">
										    SELECT  *
										    FROM    TransactionHeader
								            WHERE   Journal = '#ParentLine.ParentJournal#' 
											AND     JournalSerialNo = '#ParentLine.ParentJournalSerialNo#'						 
								     </cfquery>
		
			                     <table>
								   <tr class="labelmedium2"">
		                           <td>#ParentHeader.ReferenceName# (#ParentHeader.ReferenceNo#)</td>
		                           <td style="padding-left:3px">
		                             <a href="javascript:ShowTransaction('#ParentLine.ParentJournal#','#ParentLine.ParentJournalSerialNo#','1')">
		                                 #ParentLine.ParentJournal#-#ParentLine.ParentJournalSerialNo#
									 </a>
								   </td>
								   </tr>
		                         </table>
		
		                      <cfelse>
		
								  <cfquery name="ParentHeader"
									datasource="AppsLedger" 
									username="#SESSION.login#" 
									password="#SESSION.dbpw#">
									    SELECT *
									    FROM   TransactionHeader
								        WHERE  Journal         = '#ParentLine.Journal#' 
										AND    JournalSerialNo = '#ParentLine.JournalSerialNo#'						 
								  </cfquery>
		
		                         <table><tr class="labelmedium2"">
		                          <td>#ParentHeader.ReferenceName# (#ParentHeader.ReferenceNo#)</td>
		                          <td style="padding-left:3px">
				          	      <a href="javascript:ShowTransaction('#ParentLine.Journal#','#ParentLine.JournalSerialNo#','1')">	
		                                 #ParentLine.Journal#-#ParentLine.JournalSerialNo#</a>
		                          </td></tr>
		                          </table>
		
		                      </cfif>	 
		              
		               </td>
		       
		           </tr>
				   
			  <cfelse>
				   
				    <cfquery name="ParentLine"
					datasource="AppsLedger" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					    SELECT *
					    FROM   TransactionHeader
			            WHERE  TransactionId = '#ParentLineId#'		 
			   	   </cfquery>				   
				   
				     <tr class="labelmedium2""><td colspan="2"></td><td style="padding-left:4px"><cf_tl id="Source">:</td>
					 
		                 <td colspan="6">					
						
	                       <table>
							 <tr class="labelmedium2"">
			                 <td>#ParentLine.ReferenceName# (#ParentLine.ReferenceNo#)</td>
			                 <td style="padding-left:3px">
			          	      <a href="javascript:ShowTransaction('#ParentLine.Journal#','#ParentLine.JournalSerialNo#','1')">	
			                    #ParentLine.Journal#-#ParentLine.JournalSerialNo#</a>
			                 </td>
							 </tr>
	                       </table>			   
						   
						</tr>   
		
		      </cfif>
		
		   </cfif>	   
		   	   
		   <cfif OrgunitName neq "">
			
			   <tr class="navigation_row_child labelmedium2""><td colspan="3"></td>
			       <td colspan="6">#OrgunitName#</td>
			   </tr>
			   
		   </cfif>
		   
		   <cf_verifyOperational module = "Program" Warning = "No">
		   
		   <cfif ModuleEnabled eq "1">
		   
			   <cfif ProgramCode neq "">
			   
				  <cfquery name="Program" 
				  datasource="AppsProgram" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
					  SELECT   *
					  FROM     Program
					  WHERE    Programcode = '#ProgramCode#'
				  </cfquery>
			   
			   	   <tr class="navigation_row_child labelmedium2""><td colspan="3"></td>
				       <td colspan="6">#Program.ProgramName#</td>
				   </tr>
			   
			   </cfif>
		   
		   </cfif>
		   		   	   
		   <tr id="t_#serialno#" class="hide">
		     <td colspan="2"></td>
		     <td colspan="7">		 
			    <cfdiv id="box_#serialno#"> 
				   <cfset url.serialNo = serialNo>
				   <cfinclude template="TransactionDetailLinesEdit.cfm">
				</cfdiv>
		     </td>
		   </tr>
		   	   
		   <tr><td colspan="10" height="1" class="line"></td></tr>
		   	 	
	   </cfoutput>	
	 
	   </table>
	   
	   <!---
	   
	   </cf_divscroll>
	   
	   --->
	   
   </td>
   </tr>
   
   <tr>
   		<td bgcolor="FFFFFF" style="height:30px">    
		<table style="width:100%">	   
		
		<cfquery name="total" 
		    datasource="AppsQuery" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT SUM(AmountDebit) as AmountDebit,
			           SUM(AmountCredit) as AmountCredit,
				       SUM(AmountBaseDebit) as AmountBaseDebit,
				       SUM(AmountBaseCredit) as AmountBaseCredit
				FROM   #SESSION.acc#GledgerLine_#client.sessionNo#_#session.mytransaction# L
				WHERE  TransactionSerialNo <> '0'				
		</cfquery>
		
		<cfif Contra.recordcount eq "0">
		
			<cfset  db = Total.AmountDebit>
			<cfset  cd = Total.AmountCredit>
			<cfset bdb = Total.AmountBaseDebit>
			<cfset bcd = Total.AmountBaseCredit>
		
		<cfelse>
		
			<cfset  db = Total.AmountDebit+Contra.AmountDebit>
			<cfset  cd = Total.AmountCredit+Contra.AmountCredit>
			<cfset bdb = Total.AmountBaseDebit+Contra.AmountBaseDebit>
			<cfset bcd = Total.AmountBaseCredit+Contra.AmountBaseCredit>
		
		</cfif>
		
	    <cfif line.recordcount gte "1">
			
		    <tr style="height:25px" class="labelmedium2"">
		    <td align="center" style="width:100%;padding-right:2px;border-right:0px solid Silver;"></td>
			<cfoutput query="total">
			<td align="right" style="background-color:f1f1f1;font-size:14px;min-width:100px;padding-right:2px;border-left: 1px solid Silver;"><b>#NumberFormat(db,',.__')#</b></td>	
			<td align="right" style="font-size:14px;min-width:100px;padding-right:2px;border-left: 1px solid Silver;"><i>#NumberFormat(bdb,',.__')#</b></td>	
			<td align="right" style="background-color:f1f1f1;font-size:14px;min-width:100px;padding-right:2px;border-left: 1px solid Silver;"><b>#NumberFormat(cd,',.__')#</b></td>		
			<td align="right" style="font-size:14px;min-width:100px;padding-right:2px;border-left: 1px solid Silver;"><i>#NumberFormat(bcd,',.__')#</b></td>	
			</cfoutput>
			<td style="min-width:10px"></td>
	    </TR>	
		
		 <tr style="height:35px" class="labelmedium2"">
		    <td colspan="7" align="center" style="width:100%;padding-top:2px;border-top:1px solid Silver;">
							  		  
				  <cfquery name="Total" 
					datasource="AppsQuery" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					SELECT SUM(AmountDebit) - SUM(AmountCredit) as Diff, 
				           SUM(AmountBaseDebit) - SUM(AmountBaseCredit) as DiffB
					FROM #SESSION.acc#GLedgerLine_#client.sessionNo#_#session.mytransaction#
				  </cfquery>
				  
				  <cfquery name="Verify" 
					datasource="AppsQuery" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					SELECT DISTINCT GLAccount  
					FROM   #SESSION.acc#GLedgerLine_#client.sessionNo#_#session.mytransaction#
				  </cfquery>	
				  
				  <cfif abs(total.diff) lt "0.001" and abs(total.diffB) lt "0.01" and (Verify.recordcount gte "2" or getJournal.SystemJournal eq "Distribution")>			  
				 		  
				  	<table><tr>			
					
					<td align="center" >
				    <button  type="button" value="Post Transaction" onclick="javascript:doSubmit(this)" class="button10g" style="background-color:gray;color:white;font-size:16px;height:34px; width:280px">
						<cf_tl id="Post Transaction">
					</button>			
					</td></tr></table>
				   <cfelse>
				   <table><tr><td align="center" class="labelmedium2"">
				   <font size="2" color="FF0000"><cf_tl id="Alert">:</font><cf_tl id="Transaction NOT in balance or has a zero value"> -> <cfoutput>#numberformat(abs(round(total.diff*10000)/10000),',.__')#</cfoutput></font>  
				   </td></tr></table>
				  </cfif>
	  			
			</td>
			
	    </TR>	
		
		
		</cfif>	
		
		</table>
		
	</td>
   </tr>	
 			
 </table>
</cfif>

<cfset ajaxonLoad("doHighlight")>

<script>
	Prosis.busy('no')
</script>

