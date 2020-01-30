
<cf_screentop height="100%" scroll="Yes" html="No">

<table width="96%" cellspacing="0" cellpadding="0" align="center" class="formpadding">

<tr><td height="16"></td></tr>
<tr><td colspan="2" class="labellarge">Accounting Schema Validation for <cfoutput><font size="7">#URL.Mission#</cfoutput></td></tr>

<!--- validate system accounts --->

<cfquery name="Check" 
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   *
	FROM     Ref_Account
	WHERE    Operational = 1 
	AND      AccountClass = 'Result'
	AND      GLAccount IN
                    (SELECT     GLAccount
                     FROM       Ref_AccountMission
                     WHERE      Mission = '#url.mission#')
 			 
</cfquery>

<cfif Check.recordcount eq "0">

		<tr><td height="7"></td></tr>
		<tr><td colspan="2" class="labellarge">Accounts structure</td></tr>
		<tr><td></td><td class="labellarge"><font color="red">&nbsp;&nbsp;No Result accounts have been declared.</td></tr>
		
</cfif>		

<tr><td height="7"></td></tr>
<tr><td colspan="2" class="labellarge">Standard GL accounts</td></tr>

<!--- validate system accounts --->

<cfquery name="SystemAccount" 
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   *
	FROM     Ref_SystemAccount
	WHERE    Operational = 1 
	AND      Code NOT IN
                    (SELECT     SystemAccount
                     FROM          Ref_AccountMission
                     WHERE      Mission = '#url.mission#')
 			 
</cfquery>

<cfif SystemAccount.recordcount eq "0">

	<tr><td width="2%"></td><td height="20" class="labellarge"><font color="#008000">&nbsp;Good, all standard GL accounts have been declared:</font></td></tr>

<cfelse>

	<tr><td width="2%"></td><td class="labellarge"><font color="red">The following GL Accounts must be declared:</font></td></tr>
	
	<tr><td></td><td>
	<table>
	<cfoutput query="SystemAccount">
		<tr><td style="padding-left:40px"></td><td class="labelmedium">#Description# (#Code#)</td></tr>	
	</cfoutput>
	</table>
	</td></tr>

</cfif>


<!--- validate system accounts --->

<cfquery name="Journal" 
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   *
	FROM     Journal
	WHERE    Operational = 1 
	AND      Mission = '#Mission#' 
 			 
</cfquery>

<cfif Journal.recordcount eq "0">

		<tr><td height="7"></td></tr>
		<tr><td colspan="2" class="labellarge">Journals</td></tr>	
		<tr><td></td><td class="labellarge"><font color="red">&nbsp;&nbsp;No journals have been declared.</td></tr>
		
</cfif>		

<cfquery name="Currency" 
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   DISTINCT currency
	FROM     Journal
	WHERE    Operational = 1
	AND      Mission = '#url.Mission#'
	 
</cfquery>

<cfoutput query="Currency">

	
	<tr><td height="7"></td></tr>
	<tr><td colspan="2" class="labellarge"><font color="0080C0">#Currency# Integration Journals</td></tr>
	
	<cfquery name="SystemJournal" 
		datasource="AppsLedger" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT   *
		FROM     Ref_SystemJournal		
		WHERE    Area NOT IN
	                    (SELECT     SystemJournal
	                     FROM       Journal
						 WHERE      Currency = '#currency#'
						 AND        Operational = 1
						
	                     AND        Mission = '#url.mission#')
		 <cfif currency neq APPLICATION.BaseCurrency>
						 AND        SystemModule != 'Accounting'
		 </cfif>				 
		AND     SystemModule IN (SELECT SystemModule FROM Organization.dbo.Ref_MissionModule WHERE Mission = '#url.mission#')	 			 
	</cfquery>
	
	<cfif SystemJournal.recordcount eq "0">
	
		<tr><td></td><td class="labellarge"><font color="008000">&nbsp;&nbsp;Required Journals were declared</font></td></tr>
	
	<cfelse>
	
		<tr><td></td><td style="padding-left:20px" class="labellarge"><font color="red">The following Journal(s) should be declared:</font></td></tr>
		
		<tr><td></td><td>
		<table cellspacing="0" cellpadding="0">
		<cfloop query="SystemJournal">
			<tr><td style="padding-left:40px"></td><td class="labelmedium">#Description# (#Area#)</td></tr>	
		</cfloop>
		</table>
		</td></tr>
	
	</cfif>

</cfoutput>


</table>



<!--- validate system journals --->

			 