
<CF_DateConvert Value="#Form.dateSubmitted#">
<cfset date     = dateValue>
<cfset sReference = "#Form.Reference#">

<cfquery name="Parameter" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
    SELECT *
    FROM Ref_ParameterMission
	WHERE Mission = '#URL.Mission#' 
</cfquery>

<cfif Parameter.ContributionAutoNumber eq "1" and sReference eq "">

		<!---  2. define reference No  --->
		<cflock timeout="30" throwontimeout="No" name="SerialNo" type="EXCLUSIVE">
			
			<cfset No = Parameter.ContributionSerialNo+1>
				
			<cfquery name="Update" 
			datasource="AppsProgram" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    UPDATE Ref_ParameterMission
				SET    ContributionSerialNo = '#No#'				
				WHERE  Mission = '#URL.Mission#'
			</cfquery>
		</cflock>
					
	
	<cfset sReference = "#Parameter.Mission#-#Parameter.ContributionPrefix#-#No#">
</cfif>	 

<cfquery name="qCheck"
    datasource="AppsProgram" 
	username="#SESSION.login#"
	password="#SESSION.dbpw#">
	SELECT *
	FROM   Contribution
	WHERE  Mission       = '#URL.Mission#'
	AND    OrgUnitDonor  = '#URL.ID1#'
	AND    Reference     = '#sReference#'
	AND    ActionStatus != '9'
</cfquery>

<cfif qCheck.recordcount eq 0>

	<cfquery name="qFund" datasource="AppsProgram">
		SELECT TOP 1 *
		FROM   Ref_Fund
		WHERE  Code in (SELECT Fund FROM Ref_AllotmentEditionFund)
	</cfquery>
	
	<cfquery name="qCurrency" datasource="AppsLedger">
		SELECT TOP 1 *
		FROM   Currency
		WHERE  Currency IN 
		(
		SELECT Currency
		FROM   CurrencyMission
		WHERE  Mission = '#URL.Mission#'
		)
	</cfquery>
	
	<cftransaction>
	
	
	<!--- check for amount as --->
	
	<cfset amt = replaceNoCase(form.amount,",","","ALL")> 
	
	<cfif not LSIsNumeric(amt)>
		
		<script>
		    alert('Incorrect amount')
		</script>	 		
		<cfabort>
		
	</cfif>
	
	<cfquery name="qContributionAdd" 
	    datasource="AppsProgram" 
		username="#SESSION.login#"
		password="#SESSION.dbpw#">
		INSERT INTO Contribution
		           (ContributionId,
				   Mission,
		           OrgUnitDonor,
				   PersonNo,
		           Reference,
		           ContributionClass,
		           Earmark,
		           ActionStatus,
		           DateSubmitted,
				   Currency,
				   Amount,
				   AmountBase,
		           Description,
		           Contact,
				   ContributionMemo,
		           OfficerUserId,
		           OfficerLastName,
		           OfficerFirstName)
		     VALUES
		           ('#URL.contributionId#',
				   '#URL.Mission#',
		           '#URL.ID1#',
				   '#Form.PersonNo#',
		           '#sReference#',
		           '#FORM.ContributionClass#',
		           '#FORM.EarMark#',
		           0,
		           #date#,
				   '#Form.Currency#',
				   '#amt#',
				   0,
		           '#FORM.Description#',
		           '#FORM.Contact#',
				   '#FORM.ContributionMemo#',
		           '#SESSION.acc#',
		           '#SESSION.last#',
		           '#SESSION.first#')
	</cfquery>
	
	<cfinclude template="ContributionCustomFieldsSubmit.cfm">
	
	</cftransaction>
	
	<!--- we also create the line, usually this information is premature at the moment of the pledge and will change
	--->
	
	<!--- now we also trigger/create the workflow to reflect the pledge as part of the submit  --->
	
	<cfset link = "ProgramREM/Application/Program/Donor/Contribution/ContributionWorkflow.cfm?id=#URL.ContributionId#">
		
	<cf_ActionListing 
		EntityCode       = "EntDonor"	
		EntityGroup      = "" 
		EntityClass      = "#FORM.EntityClass#"	
		EntityStatus     = "0"			
		ObjectReference  = "#sReference#"
		ObjectReference2 = "[name of the donor]"
		ObjectKey4       = "#URL.ContributionId#"
		ObjectURL        = "#link#"
		AjaxId           = "#URL.ContributionId#"
		Show             = "No" 
		Toolbar          = "Yes"
		Framecolor       = "ECF5FF"
		CompleteFirst    = "No">
	
		<cfoutput>
		<script>
			window.location = "ContributionView.cfm?drillid=#URL.ContributionId#";
		</script>
		</cfoutput>
	
<cfelse>
	<cfoutput>
	<script>
		alert('An existing pledge has been defined for the mission #URL.mission# donor and reference #sReference#')
	</script>
	</cfoutput>

</cfif>







