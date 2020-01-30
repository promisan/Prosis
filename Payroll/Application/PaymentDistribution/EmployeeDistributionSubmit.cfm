<cf_screentop html="no" jquery="yes">
	
<cfset vLines = url.lines>
<cfset vMessage = "">

<!--- numbers with no commas --->
<cfset vAllNumbersNoComma = 1>
<cfloop from="1" to="#vLines#" index="thisLine">
	<cfset vTestAmount = trim(evaluate("Form.DistributionNumber_#thisline#"))>
	<cfif vTestAmount neq "" and thisLine neq vLines>
		<cfif findNoCase(",", vTestAmount) neq 0>
			<cfset vAllNumbersNoComma = 0>
		</cfif>
	</cfif> 
</cfloop>
<cfif vAllNumbersNoComma eq 0>
	<cf_tl id="The symbol <,> is not allowed in any amount" var="1">
	<cfset vMessage = "#vMessage#  #lt_text#.">		
</cfif>

<!--- validate valid numbers --->
<cfset vAllNumbersGood = 1>
<cfloop from="1" to="#vLines#" index="thisLine">
	<cfset vTestAmount = replace(trim(evaluate("Form.DistributionNumber_#thisline#")), ",", "", "ALL")>
	<cfif vTestAmount neq "" and thisLine neq vLines>
		<cfif not isValid('numeric', vTestAmount)>
			<cfset vAllNumbersGood = 0>
		</cfif>
	</cfif> 
</cfloop>
<cfif vAllNumbersGood eq 0>
	<cf_tl id="All amounts should be valid numbers" var="1">
	<cfset vMessage = "#vMessage#  #lt_text#.">		
</cfif>

<cfif vAllNumbersGood eq 1 and vAllNumbersNoComma eq 1>

	<!--- validate 100% --->
	<cfif form.distributionMethod eq "Percentage">
		<cfset vTotal = 0>
		<cfloop from="1" to="#vLines#" index="thisLine">
			<cfset vTestAmount = replace(trim(evaluate("Form.DistributionNumber_#thisline#")), ",", "", "ALL")>
			<cfif vTestAmount neq "" and thisLine neq vLines>
				<cfset vTotal = vTotal + vTestAmount>
			</cfif> 
		</cfloop>
		<cfif vTotal gt 100>
			<cf_tl id="The sum of percentages should be 100" var="1">
			<cfset vMessage = "#vMessage#  #lt_text#.">
		</cfif>
	</cfif>

	<!--- check accounts used multiple times --->
	<cfset vUsedMultiple = "0">
	<cfloop from="1" to="#vLines#" index="thisLine">

		<cfset thisAcc = evaluate("Form.AccountId_#thisline#")>
		<cfset thisAmount = replace(trim(evaluate("Form.DistributionNumber_#thisline#")), ",", "", "ALL")>

		<cfif thisAmount neq "" and thisAmount neq 0>

			<cfloop from="1" to="#vLines#" index="thisEvalLine">

				<cfset thisEvalAcc = evaluate("Form.AccountId_#thisEvalLine#")>
				<cfset thisEvalAmount = replace(trim(evaluate("Form.DistributionNumber_#thisEvalLine#")), ",", "", "ALL")>

				<cfif thisLine neq thisEvalLine and thisEvalAmount neq "" and thisEvalAmount neq 0 and thisEvalAmount neq url.bigAmount>
					<cfif form.distributionMethod eq "Percentage">
						<cfif vTotal lt 100>
							<cfif thisAcc eq thisEvalAcc>
								<cfset vUsedMultiple = "1">
							</cfif>
						</cfif>
					<cfelse>
						<cfif thisAcc eq thisEvalAcc>
							<cfset vUsedMultiple = "1">
						</cfif>	
					</cfif>
					
				</cfif>

			</cfloop>

		</cfif>

	</cfloop>
	<cfif vUsedMultiple eq "1">
		<cf_tl id="The amounts should be distributed among different accounts" var="1">
		<cfset vMessage = "#vMessage#  #lt_text#.">
	</cfif>

</cfif>

<!--- Show error --->
<cfset vMessage = trim(vMessage)>
<cfif vMessage neq "">
	<cfset vMessage = left(vMessage, len(vMessage)-1)>
	<cfoutput>
		<cf_tl id="Error">: #vMessage#.
	</cfoutput>	
	<cfabort>
</cfif>

<cftransaction>

	<cfset dateValue = "">
	<cf_DateConvert Value="#Form.dateEffective#">
	<cfset vDateEffective = dateValue>

	<cfquery name="clearDelete" 
	     datasource="AppsPayroll" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
			DELETE 	
			FROM 	PersonDistribution
			WHERE 	PersonNo = '#url.id#'
			AND		DateEffective = #vDateEffective#
	</cfquery>

	<cfset vRest = 0>

	<cfloop from="1" to="#vLines#" index="thisLine">

		<cfset vOrder = evaluate("Form.DistributionOrder_#thisline#")>
		<cfset vAccount = trim(evaluate("Form.AccountId_#thisline#"))>
		<cfset vAmount = replace(trim(evaluate("Form.DistributionNumber_#thisline#")), ",", "", "ALL")>
		<cfif form.distributionMethod eq "Percentage">
			<cfif thisLine eq vLines>
				<cfset vAmount = 100 - vRest>
			<cfelse>
				<cfif vAmount neq "">
					<cfset vRest = vRest + vAmount>
				</cfif>
			</cfif>
		</cfif>

		<cfif vAmount eq 0>
			<cfset vAmount = "">
		</cfif>

		<cfif vAmount neq "">

			<cfset vDistCurrency = 'USD'>
			<cfif isDefined("Form.Currency_#thisline#")>
				<cfset vDistCurrency = evaluate("Form.Currency_#thisline#")>
			</cfif>

			<cf_AssignId>
			<cfquery name="insert" 
		     datasource="AppsPayroll" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
		     	INSERT INTO PersonDistribution
		     		(
		     			PersonNo,
		     			DistributionId,
		     			DistributionOrder,
		     			DateEffective,
		     			PaymentMode,
		     			AccountId,
		     			DistributionCurrency,
		     			DistributionMethod,
		     			DistributionNumber,
		     			Operational,
		     			OfficerUserId,
		     			OfficerLastName,
		     			OfficerFirstName
		     		)
		     	VALUES
		     		(
		     			'#url.id#',
		     			'#RowGuid#',
		     			'#vOrder#',
		     			#vDateEffective#,
						<cfif vAccount eq "Cash">
						'Cash',NULL,
						<cfelseif vAccount eq "Check">
						'Check',NULL,
						<cfelse>
						'Transfer',
		     			'#vAccount#',
						</cfif>
		     			'#vDistCurrency#',
		     			'#Form.distributionMethod#',
		     			'#vAmount#',
		     			1,
		     			'#session.acc#',
		     			'#session.last#',
		     			'#session.first#'
		     		)
		     </cfquery>

	     </cfif>
		
	</cfloop>

</cftransaction>

<script>
	reloadDist('view', '');
</script>