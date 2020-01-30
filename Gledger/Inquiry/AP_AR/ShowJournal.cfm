
<cfparam name="CLIENT.payables" default="">
<cfparam name="URL.Mission" default="CMP">

<cfquery name="CurPeriod"
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   Ref_ParameterMission
	WHERE  Mission = '#URL.Mission#'
</cfquery>

<cfquery name="Accounts"
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
		SELECT     R.GLAccount
				   
		FROM       Ref_Account R  INNER JOIN
				   Ref_AccountMission M ON R.GLAccount = M.GLAccount
							   
		WHERE      M.Mission       = '#url.mission#' 
		
		AND        R.BankReconciliation = 1  
		AND        R.AccountClass       = 'Balance' <!--- balance --->
			
		<cfif url.mode eq "AR">  
		AND        R.AccountType        = 'Debit'   
		AND        (R.BankReconciliation = 1 OR R.AccountCategory = 'Vendor')
		<cfelse>	
		AND        R.AccountType        = 'Credit' 
		AND        R.AccountCategory    = 'Customer'
		</cfif>	
								 		   
</cfquery>		

<cfset selaccount = quotedvalueList(Accounts.GLAccount)> 

<cfif selaccount eq "">
	<cfif url.mode eq "AR">  
		<cf_tl id="Accounts Receivable: Please define Debit-BankReconciliation-Vendor accounts" var="lbAccountError">
	<cfelse>	
		<cf_tl id="Accounts Payable: Please define Credit-Customer accounts" var="lbAccountError">
	</cfif>	
	<cf_tl id="Please contact your administrator" var="lbAccountErrorAdmin">
	<cfoutput>
		<script>
			Prosis.alert('#lbAccountError#.<br><br>#lbAccountErrorAdmin#.', function(){ window.close(); });
		</script>
	</cfoutput>
</cfif>

<!--- GL and journal matrix 

<cfquery name="Matrix" 
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT        DT.GLAccount, DT.Journal, DT.Amount, Journal.Description

FROM            (SELECT    L.GLAccount, 
                 CASE WHEN L.ParentJournal IS NULL THEN L.Journal ELSE L.ParentJournal END AS Journal, 
                                                    ROUND(SUM(L.AmountBaseDebit - L.AmountBaseCredit), 2) AS Amount
                 FROM            TransactionLine AS L INNER JOIN
                                TransactionHeader AS H ON L.Journal = H.Journal AND L.JournalSerialNo = H.JournalSerialNo
                 WHERE        L.GLAccount IN (#preserveSingleQuotes(selaccount)#) 
				 AND      H.ActionStatus IN ('0', '1') 
				 AND      H.RecordStatus <> '9'
                 GROUP BY L.GLAccount, 
				          CASE WHEN L.ParentJournal IS NULL THEN L.Journal ELSE L.ParentJournal END) AS DT 
						  
		  INNER JOIN Journal ON DT.Journal = Journal.Journal
		  
		  WHERE   GLCategory = 'Actuals'	
ORDER BY DT.Journal 
</cfquery>

--->

<!--- create query table --->

<cfinclude template="InquiryData.cfm">

<cfquery name="JournalList" 
datasource="AppsQuery" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT   D.Journal,
	         J.Description,
		     D.Currency, 
		     Count(*) as Document,
		     ROUND(SUM(AmountOutstanding),2) as Amount
    FROM     Inquiry_#url.mode#_#session.acc# D, Accounting.dbo.Journal J	
	WHERE    D.Journal = J.Journal
	
	<cfif getAdministrator(url.mission) eq "0">
	 AND    D.Journal IN (SELECT ClassParameter 
	                      FROM   Organization.dbo.OrganizationAuthorization
	                      WHERE  UserAccount = '#SESSION.acc#' 
                          AND    Role        = 'Accountant'
					      AND    Mission     = '#url.Mission#'
						  )
    </cfif>		
		
	GROUP BY D.Journal,J.Description,D.Currency   			
	ORDER BY D.Currency, D.Journal 
	    	
</cfquery>

<!---

<cfquery name="Vendor" 
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT DISTINCT ReferenceName 
    FROM   TransactionHeader P
	WHERE  Mission = '#URL.Mission#'	
	AND    abs(AmountOutstanding) > 0.05
 	AND    TransactionCategory IN (#preservesinglequotes(journalfilter)#)
    	
	<!--- has a base booking on the accounts with AR or AP --->
	AND    Journal IN (SELECT Journal 
	                   FROM   TransactionLine 
				       WHERE  Journal         = P.Journal 
    				   AND    JournalSerialNo = P.JournalSerialNo 
					   <!----- AND    GLAccount IN (#preserveSingleQuotes(selaccount)#) ---->
					   <cfif TRIM(selaccount) neq "">
	   		    		   AND    GLAccount IN (#preserveSingleQuotes(selaccount)#)
					   </cfif>
			    	   AND    TransactionSerialNo = '0')
	
	AND    ActionStatus IN ('0','1')		
	AND    RecordStatus != '9'
		
	AND    Journal IN (SELECT Journal FROM Journal WHERE GLCategory = 'Actuals')	
	  
</cfquery>

--->

<form name="myaccountingform">
	
<table border="0" width="100%" cellspacing="0" cellpadding="0" align="center" class="formspacing">
     
	<tr>
	<td colspan="4">
	<table width="100%">
		<tr>
		<td colspan="1" height="20" class="labelmedium"><cf_tl id="Journal filter"></td>
		<!---
		<td class="labelit" align="right"><cf_tl id="Use SHIFT or CTRL-key to select several"></td>
		--->
		</tr>	
	</table>
	</td>
		
	<tr>
			
		<td colspan="4" align="left" valign="top" style="padding-right:10px">
		
		<table width="100%">
		
		<cfoutput query="JournalList">
		<tr class="labelit line">
			<td style="height:13px;padding-left:9px">
			<input type="checkbox" id="Journal" name="Journal" value="'#Journal#'"
				onclick="reload()">
			</td>
			<td>#Currency#</td>
			<td>#Description#</td>
			<td align="right">#Document#</td>
			<td align="right">#numberformat(amount,",.__")#</td>			
		</tr>
		</cfoutput>
		
		</table>
		
		<!---
		<select name="Journal" size="10" style="border-radius:1px;font-size:13px;width:234;height:194"
		   onchange="_cf_loadingtexthtml='';ColdFusion.navigate('InquiryQuery.cfm?<cfoutput>mode=#url.mode#&mission=#url.mission#&systemfunctionid=#url.systemfunctionid#</cfoutput>','result','','','POST','myform')" multiple>
		    <cfoutput query="Journal">
				<option value="'#Journal#'">#Currency# : #Description#</option>
			</cfoutput>
		    </select>
			--->
			
	    </td>
		
		<!---
		
		<td align="left" valign="top">
		<select name="ReferenceName" style="border-radius:1px;font-size:13px;width:255;height:194" size="10" multiple 
		onchange="_cf_loadingtexthtml='';ColdFusion.navigate('InquiryQuery.cfm?<cfoutput>mode=#url.mode#&mission=#url.mission#&systemfunctionid=#url.systemfunctionid#</cfoutput>','result','','','POST','myform')">
		    <cfoutput query="Vendor">
			<option value="'#ReferenceName#'">#left(ReferenceName,60)#</option>
			</cfoutput>
		    </select>
		</td>	
		--->	   
	
	</tr>	
		
</TABLE>

</FORM>