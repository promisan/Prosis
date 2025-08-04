<!--
    Copyright © 2025 Promisan

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->

<cfset vPass = 0>
<cfset vMess = "">
<cfset vTotal = 0>

<cfparam name="form.lines" default="0">

<!--- validations --->
<cfloop list="#form.lines#" index="vLine">
	<cfset vFund = trim(evaluate("form.fund_#vLine#"))>
	<cfset vProgramCode = trim(evaluate("form.programcode_#vLine#"))>
	<cfset vPercentage = trim(evaluate("form.percentage_#vLine#"))>

	<cfif vFund eq "">
		<cf_tl id="A fund is required for line" var="1">
		<cfset vMess = "#vMess# #lt_text#: #vLine#\n">
	</cfif>

	<cfif vProgramCode eq "">
		<cf_tl id="A project is required for line" var="1">
		<cfset vMess = "#vMess# #lt_text#: #vLine#\n">
	</cfif>

	<cfif vPercentage eq "" OR not isvalid("integer", vPercentage) OR not isnumeric(vPercentage) OR vPercentage lt 1>
		<cf_tl id="A positive integer percentage is required for line" var="1">
		<cfset vMess = "#vMess# #lt_text#: #vLine#\n">
	<cfelse>
		<cfset vTotal = vTotal + vPercentage>
	</cfif>
</cfloop>

<cfif vTotal neq 100>
	<cf_tl id="The sum of percentages must be 100" var="1">
	<cfset vMess = "#vMess# #lt_text#\n">
</cfif>

<cfif vMess eq "">
	<cfset vPass = 1>
<cfelse>
	<cfoutput>
		<script>
			alert('#vMess#');
		</script>
	</cfoutput>
</cfif>

<cfif vPass eq 1>

	<cftransaction>

		<cfquery name="getBase" 
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT 	*
				FROM 	PositionParentFunding
				WHERE 	PositionParentId = '#url.PositionParentId#'
				AND 	FundingId = '#url.FundingId#'
		</cfquery>

		<cfquery name="clearPrevious" 
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				DELETE
				FROM 	PositionParentFunding
				WHERE 	PositionParentId = '#url.PositionParentId#'
				AND 	DateEffective    = '#getBase.DateEffective#'
				<cfif getBase.DateExpiration neq "">
				AND 	DateExpiration   = '#getBase.DateExpiration#'
				</cfif>
		</cfquery>

		<cfloop list="#form.lines#" index="vLine">
		
			<cfset vFund = trim(evaluate("form.fund_#vLine#"))>
			<cfset vProgramCode  = trim(evaluate("form.programcode_#vLine#"))>
			<cfset vPercentage   = trim(evaluate("form.percentage_#vLine#"))>
			<cfset vPercentage   = vPercentage / 100>

			<cfquery name="insert" 
				datasource="AppsEmployee" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					INSERT INTO PositionParentFunding (
							PositionParentId,
							DateEffective,
							DateExpiration,
							Fundclass,
							Fund,
							ProgramCode,
							Percentage,
							OfficerUserId,
							OfficerLastName,
							OfficerFirstName )
					VALUES ('#url.PositionParentId#',
							'#getBase.DateEffective#',
							<cfif getBase.DateExpiration neq "">
							'#getBase.DateExpiration#',
							<cfelse>
							NULL,
							</cfif>
							<cfif getBase.FundClass neq "">
							'#getBase.FundClass#',
							<cfelse>
							NULL,
							</cfif>
							'#vFund#',
							'#vProgramCode#',
							#vPercentage#,
							'#session.acc#',
							'#session.last#',
							'#session.first#' )
			</cfquery>

		</cfloop>

	</cftransaction>
		
	<cfoutput>
		<script>
			ptoken.navigate('#session.root#/staffing/application/position/Funding/PositionFunding.cfm?ID=#url.positionparentid#','fundbox');
			ProsisUI.closeWindow('wFundingEdit');
		</script>
	</cfoutput>

</cfif>