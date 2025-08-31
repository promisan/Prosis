<!--
    Copyright © 2025 Promisan B.V.

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
<cfset dateValue = "">
<cf_DateConvert Value="#Form.DateEffective#">
<cfset vEffective = dateValue>

<cfset dateValue = "">
<cf_DateConvert Value="#Form.DateExpiration#">
<cfset vExpiration = dateValue>

<cfset dateValue = "">
<cf_DateConvert Value="#Form.DateBudgetEffective#">
<cfset vBudgetEffective = dateValue>

<cfset dateValue = "">
<cf_DateConvert Value="#Form.DateBudgetExpiration#">
<cfset vBudgetExpiration = dateValue>

<cfif url.id1 eq "">
	
	<cfquery name="Insert" 
		datasource="appsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			INSERT INTO Ref_ReviewCycle (
					Mission,
					Period,
					Description,
					CycleName,
					DateEffective,
					DateExpiration,
					DateBudgetEffective,
					DateBudgetExpiration,
					EnableMultiple,
					EntityClass,
					Operational,
					OfficerUserId,
					OfficerLastName,
					OfficerFirstName )	
			VALUES ('#Form.mission#',
					'#Form.Period#',
					'#Form.Description#',
					'#Form.CycleName#',
					#vEffective#,
					#vExpiration#,
					#vBudgetEffective#,
					#vBudgetExpiration#,
					'#Form.EnableMultiple#',
					'#form.EntityClass#',
					#Form.Operational#,
					'#SESSION.acc#',
					'#SESSION.last#',
					'#SESSION.first#'
				)
	</cfquery>
	
	<cfquery name="getInsertId" 
		datasource="appsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		
			SELECT 	MAX(CycleId) as Id
			FROM	Ref_ReviewCycle
		
	</cfquery>
	
	<cfset vId = getInsertId.Id>
	
	<cf_ModuleControlLog systemfunctionid="#url.idmenu#" 
	                     action="Insert" 
						 content="#form#">
	
<cfelse>

	<cfset vId = url.id1>
	
	<cftransaction>
	
		<cfquery name="Update" 
			datasource="appsProgram" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				UPDATE Ref_ReviewCycle
				SET    Mission			    = '#Form.mission#',
					   Period			    = '#Form.Period#',
					   Description		    = '#Form.description#',
					   CycleName            = '#Form.CycleName#',
					   DateEffective 	    = #vEffective#,
					   DateExpiration 	    = #vExpiration#,
					   DateBudgetEffective  = #vBudgetEffective#,
					   DateBudgetExpiration = #vBudgetExpiration#,
					   EntityClass          = '#Form.EntityClass#',
					   EnableMultiple       = '#Form.EnableMultiple#',
					   Operational		    = #Form.operational#
				WHERE  CycleId			    = '#vId#'
		</cfquery>
		
		<cfquery name="clearProfile" 
			datasource="appsProgram" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				DELETE
				FROM	Ref_ReviewCycleGroup
				WHERE	CycleId = '#vId#'
		</cfquery>
		
		<cfquery name="getProfileList" 
			datasource="appsProgram" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT  *
				FROM	Ref_ProgramGroup
		</cfquery>
		
		<cfloop query="getProfileList">
		
			<cfif isDefined("groupcode_#code#")>
			
				<cfset vCode = evaluate("groupcode_#code#")>
				
				<cfquery name="insertProfile" 
					datasource="appsProgram" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						INSERT  INTO Ref_ReviewCycleGroup (
								CycleId,
								ProgramGroup,
								OfficerUserId,
								OfficerLastName,
								OfficerFirstName )
						VALUES (
								'#vId#',
								'#Code#',
								'#SESSION.acc#',
								'#SESSION.last#',
								'#SESSION.first#'
							)
				</cfquery>				
				
			</cfif>
			
		</cfloop>
		
		<cfquery name="clearProfile" 
			datasource="appsProgram" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				DELETE
				FROM	Ref_ReviewCycleProfile
				WHERE	CycleId = '#vId#'
		</cfquery>
		
		<cfquery name="getProfileList" 
			datasource="appsProgram" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT  *
				FROM	Ref_TextArea
		</cfquery>
		
		<cfloop query="getProfileList">
		
			<cfif isDefined("profileCode_#code#")>
			
				<cfset vCode = evaluate("profileCode_#code#")>
				
				<cfquery name="insertProfile" 
					datasource="appsProgram" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						INSERT  INTO Ref_ReviewCycleProfile (
								CycleId,
								TextAreaCode,
								OfficerUserId,
								OfficerLastName,
								OfficerFirstName )
						VALUES (
								'#vId#',
								'#Code#',
								'#SESSION.acc#',
								'#SESSION.last#',
								'#SESSION.first#'
							)
				</cfquery>				
				
			</cfif>
			
		</cfloop>
	
	</cftransaction>
	
	<cf_ModuleControlLog systemfunctionid="#url.idmenu#" 
	                     action="Update" 
						 content="#form#">

</cfif>

<cfoutput>
	<script>
		window.location = 'RecordEdit.cfm?idmenu=#url.idmenu#&id1=#vId#&fmission=#url.fmission#';
		try { 
		window.opener.ColdFusion.navigate('RecordListingDetail.cfm?idmenu=#url.idmenu#&fmission=#url.fmission#','divListing');
		} catch(e) {}
	</script>
</cfoutput>