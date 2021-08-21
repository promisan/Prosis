
<cfparam name="form.contributionlineid"  default="">

<cfparam name="url.mode"          default="select">
<cfparam name="url.requirementid" default="">
<cfparam name="url.fund"          default="">
<cfparam name="url.programcode"   default="">


 <!--- 
				 
				 show FUND contributions on the fly, and filter visible contributions based on the
				 
				 - we show contribution select box based on the setting of the fund
				 - contribution earmarked for program or not earmarked
				 - Expiry date gte TODAY's date (if expired we do not show it 			 
				 
				 --->

<cfquery name="get" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   *
	FROM     ProgramAllotmentRequest
	<cfif url.requirementid neq "">
	WHERE    RequirementId = '#url.requirementid#'	
	<cfelse>
	WHERE    0 = 1
	</cfif>
</cfquery>

<cfquery name="Period" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   *
	FROM     Ref_Period
	WHERE    Period = '#url.period#'	
</cfquery>

<cfquery name="Fund" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   *
	FROM     Ref_Fund
	WHERE    Code = '#url.fund#'	
</cfquery>

<cfif Fund.fundingMode neq "Donor">

	<script>
		try {
		document.getElementById('contributionbox').className = "hide"
		} catch(e) {}
	</script>


<cfelse>

	<script>
	    
		try {
		document.getElementById('contributionbox').className = "regular"		
		document.getElementById('contributionselect').className = "hide"
		} catch(e) {}
		
	</script>
	
	<!--- get contributions --->

	<!--- donor is enabled for the fund so we show it --->
	
	<cfquery name="Program" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT   *
		FROM     Program
		WHERE    ProgramCode = '#url.programcode#'	
	</cfquery>
	
	<cfsavecontent variable="contrib">
		<cfoutput>
		    SELECT   O.OrgUnitName, 
			         C.Reference, 
					 CL.Reference AS Tranche, 
					 CL.ContributionLineId,
					 CL.Currency, 
					 CL.Amount, 
					 CL.AmountBase,
					 
					 ( SELECT ISNULL(SUM(AmountBase),0)
					   FROM   ContributionLinePeriod
					   WHERE  ContributionLineId = CL.ContributionLineId 
					   AND    Period IN (SELECT Period 
									     FROM   Ref_Period
					                     WHERE  DateExpiration <= '#period.dateExpiration#')
					  ) as AmountBaseAdditional,	
					 
					 ( SELECT  ISNULL(SUM(TL.AmountBaseDebit - TL.AmountBaseCredit),0) as Amount 		
					   FROM    Accounting.dbo.TransactionHeader TH, Accounting.dbo.TransactionLine TL
					   WHERE   TH.Journal = TL.Journal
					   AND     TH.JournalSerialNo = TL.JournalSerialNo
					   AND     TH.Mission = '#Program.Mission#'
					   AND     TH.ActionStatus != '9' and TH.RecordStatus != '9'
					   AND     TL.TransactionSerialNo <> 0
					   AND     TL.ContributionLineId = CL.ContributionLineId ) as Used,
					   					 
					 C.Earmark, 
					 CL.DateReceived
			FROM     ContributionLine AS CL INNER JOIN
		             Contribution AS C ON CL.ContributionId = C.ContributionId INNER JOIN
		             Organization.dbo.Organization AS O ON C.OrgUnitDonor = O.OrgUnit
			 
			WHERE    CL.Fund = '#url.fund#' 
			<cfif url.mode eq "select">
			AND      (CL.DateExpiration > GETDATE() or CL.DateExpiration is NULL)								
			AND      CL.ActionStatus   <> '9' 			
			AND      C.ActionStatus    = '1'
			</cfif>
			AND      C.Mission         = '#program.mission#'
			
			
		</cfoutput>
	</cfsavecontent>
	
	<cfif url.mode eq "select">
	
		<cfquery name="Contribution" 
			datasource="AppsProgram" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			#preservesingleQuotes(contrib)#
					
			<!--- not earmarked --->
			
			AND      CL.ContributionLineId NOT IN (SELECT ContributionLineId 
			                                       FROM   ContributionLineProgram 
							 					   WHERE  ContributionLineId = CL.ContributionLineId)
		    		
			UNION
			
				#preservesingleQuotes(contrib)#					
				<!--- earmarked for program, need to adjust in hierarchy --->			
				AND      CL.ContributionLineId IN (SELECT ContributionLineId 
				                                   FROM   ContributionLineProgram 
												   WHERE  ContributionLineId = CL.ContributionLineId
												   AND    ProgramCode = '#url.programCode#')
			
			<cfif url.requirementId neq "">
			
			UNION
				
				#preservesingleQuotes(contrib)#
				AND      CL.ContributionLineId IN (SELECT ContributionLineId 
				                                   FROM   ProgramAllotmentRequestContribution 
												   WHERE  RequirementId = '#url.requirementid#') 		
			
			</cfif>				
			
			ORDER BY O.OrgUnitName, C.Reference, Tranche
			
		</cfquery>
		
	<cfelse>
	
		<!--- selected values --->
			
		<cfquery name="Contribution" 
			datasource="AppsProgram" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			#preservesingleQuotes(contrib)#			
			<cfif form.contributionLineId neq "">
			AND CL.ContributionLineId IN (#preservesingleQuotes(form.contributionlineid)#) 		
			<cfelseif url.requirementid neq "">			
			AND CL.ContributionLineId IN (SELECT ContributionLineId FROM ProgramAllotmentRequestContribution WHERE RequirementId = '#url.requirementid#')			
			<cfelse>
			AND 1= 0
			</cfif>
		</cfquery>
	
	</cfif>
		
	<cfif url.mode eq "select">
		<cfset pad = "15">
	<cfelse>
		<cfset pad = "1">	
	</cfif>	

	<cfif url.mode neq "select" and contribution.recordcount eq "0">
	
	    <cfoutput>
	    <table><tr><td style="padding-top:2px" class="labelmedium">
		<a href="javascript:getcontribution('#url.requirementid#','#url.fund#','#url.programcode#','#url.period#')">
		<font color="0080C0"><cf_tl id="No contribution selected"></font>
		</a>
		</td></tr></table>
		</cfoutput>
		
	
	<cfelse>

		<script>
			try {
			document.getElementById('contributionselect').className = "regular"
			} catch(e) {}
		</script>
		
		<cfif url.mode eq "select">
		
			<table height="100%" width="100%" bgcolor="FFFFFF">
			
			<tr><td height="90%">
					
				<cf_divscroll>
			
					<form method="post" name="contributionform" id="contributionform">
						<cfinclude template="getContributionDetail.cfm">
					</form>
				
				</cf_divscroll>
			
			</td></tr>
			
			<cfif url.mode eq "select">
			
			<tr><td align="center" style="padding-bottom:10px">
			
			   <cfoutput>
			
					<input class="button10g" 
					style="width:200px" 
					type="button" 
					name="Select" 
					value="Select"
					onclick="ptoken.navigate('#session.root#/ProgramREM/Application/Budget/Request/getContributionSelect.cfm?requirementid=#url.requirementid#&programcode=#url.programcode#&fund=#url.fund#&period=#url.period#','contributionresult','','','POST','contributionform')">
					
				</cfoutput>
			
			</td></tr>
			
			</cfif>
			
			</table>		
		
		<cfelse>
				
			<cfinclude template="getContributionDetail.cfm">
		
		</cfif>
		
	</cfif>

</cfif>

<cfset ajaxOnload("doHighlight")>
	
