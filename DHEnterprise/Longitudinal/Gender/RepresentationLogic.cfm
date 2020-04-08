<!---- imagine we define a margin of 3, that means, 50 +/- 3 = [ 0.47 - 0.53]
now imagine the scenario for: 3 staff.
Male: 1
Female: 2

there's no way this could be balanced, therefore, we apply a different logic, here the Female is leading and we need a way to:
if the total count is small, the margin must increase. in its ratio. this is to make 'at parity' something achievable.
if the total count is big, the maring must decrease. in its ratio.

so we use, 1/N;  where N= total count.

---->

<cfparam name="RPcurrentTotalCount"	default="0">
<cfparam name="RPCurrentFPerc"		default="0">
<cfset 	LabelToBeDispRep			="undeF">
<cfset 	ColorToBeDispRep			="999966">
<cfset 	localMargin					="#numberformat((1/RPcurrentTotalCount)*100,',._')#">
<!--- totals bigger than 10, we use the old logic, makes sense ---->

<cfif RPcurrentTotalCount lt 10>
	
	<cfif RPCurrentFPerc gt (qTarget.Target - localMargin ) AND RPCurrentFPerc lt (qTarget.Target + localMargin )>
		<cfset ColorToBeDispRep	="a6ff4d">
		<cfset LabelToBeDispRep 	= "At Parity">
	<cfelse>
		<cfif vFPercentage LTE (qTarget.Target - localMargin)>
			<cfset ColorToBeDispRep	="ffff33"><!---- F underrepresented ---->
			<cfset LabelToBeDispRep 	= "F Underrep.">
		<cfelse>
			<cfset ColorToBeDispRep	="33adff"><!---- M underrepresented ---->
			<cfset LabelToBeDispRep 	= "M Underrep.">
		</cfif>
	</cfif>

<cfelse>

	<cfif RPCurrentFPerc gte (qTarget.Target - qTarget.Margin ) AND RPCurrentFPerc lte (qTarget.Target + qTarget.Margin )>
		<cfset ColorToBeDispRep	="a6ff4d">
		<cfset LabelToBeDispRep 	= "At Parity">
	<cfelse>
		<cfif vFPercentage LT (qTarget.Target - qTarget.Margin)>
			<cfset ColorToBeDispRep	="ffff33"><!---- F underrepresented ---->
			<cfset LabelToBeDispRep 	= "F Underrep.">
		<cfelse>
			<cfset ColorToBeDispRep	="33adff"><!---- M underrepresented ---->
			<cfset LabelToBeDispRep 	= "M Underrep.">
		</cfif>
	</cfif>

</cfif>


