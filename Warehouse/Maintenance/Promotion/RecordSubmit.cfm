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

<cfset dateValue = "">
<cf_DateConvert Value="#Form.DateEffective#">
<cfset vEffective = dateValue>
<cfset vEffective = dateAdd('h',Int(Form.TimeEffective_Hour),vEffective)>
<cfset vEffective = dateAdd('n',Int(Form.TimeEffective_Minute),vEffective)>

<cfif Form.DateExpiration neq "">
	<cfset dateValue = "">
	<cf_DateConvert Value="#Form.DateExpiration#">
	<cfset vExpiration = dateValue>
	<cfset vExpiration = dateAdd('h',Int(Form.TimeExpiration_Hour),vExpiration)>
	<cfset vExpiration = dateAdd('n',Int(Form.TimeExpiration_Minute),vExpiration)>
</cfif>

<cfset vId = "">

<cfif url.id1 eq "">
	
	<cf_AssignId>
	<cfset vId = rowguid>
	
	<cfquery name="Insert" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		INSERT INTO Promotion (
				Mission,
				PromotionId,
				Description,
				<cfif Form.CustomerLabel neq "">CustomerLabel,</cfif>
				DateEffective,
				<cfif Form.DateExpiration neq "">DateExpiration,</cfif>
				Operational,
				Priority,
				OfficerUserId,
				OfficerLastName,
				OfficerFirstName )	
		VALUES	('#Form.mission#',
				'#vId#',
				'#Form.Description#',
				<cfif Form.CustomerLabel neq "">'#Form.CustomerLabel#',</cfif>
				#vEffective#,
				<cfif Form.DateExpiration neq "">#vExpiration#,</cfif>
				#Form.Operational#,
				'#form.Priority#',
				'#SESSION.acc#',
				'#SESSION.last#',
				'#SESSION.first#' )
	</cfquery>
	
	<!--- insert schedules --->
	
	<cfparam name="Form.PriceSchedule" default="">
	
	<cfif form.PriceSchedule neq "">
	
		<cfloop index="itm" list="#Form.PriceSchedule#">
		
			<cfquery name="Insert" 
			datasource="appsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				INSERT INTO PromotionSchedule (				
						PromotionId,
						PriceSchedule,				
						OfficerUserId,
						OfficerLastName,
						OfficerFirstName )	
				VALUES	('#vId#',
						'#itm#',				
						'#SESSION.acc#',
						'#SESSION.last#',
						'#SESSION.first#' )
			</cfquery>
		
		</cfloop>	
	
	</cfif>
	
	<cf_ModuleControlLog systemfunctionid="#url.idmenu#" 
	                     action="Insert" 
						 content="#form#">
	
<cfelse>

	<cfset vId = url.id1>
	
	<cfquery name="Update" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE Promotion
		SET    Mission			= '#Form.mission#',
			   Description		= '#Form.description#',
			   Priority         = '#Form.Priority#',
			   CustomerLabel    = <cfif Form.CustomerLabel neq "">'#Form.CustomerLabel#'<cfelse>null</cfif>,
			   DateEffective 	= #vEffective#,
			   DateExpiration 	= <cfif Form.DateExpiration neq "">#vExpiration#<cfelse>null</cfif>,
			   Operational		= #Form.operational#
		WHERE  PromotionId		= '#vId#'
	</cfquery>
	
	<cfif form.PriceSchedule neq "">
	
		<cfquery name="Insert" 
			datasource="appsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				DELETE FROM PromotionSchedule
				WHERE  PromotionId = '#vId#' 
		</cfquery>
	
		<cfloop index="itm" list="#Form.PriceSchedule#">
		
			<cfquery name="Insert" 
			datasource="appsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				INSERT INTO PromotionSchedule (				
						PromotionId,
						PriceSchedule,				
						OfficerUserId,
						OfficerLastName,
						OfficerFirstName )	
				VALUES	('#vId#',
						'#itm#',				
						'#SESSION.acc#',
						'#SESSION.last#',
						'#SESSION.first#' )
			</cfquery>
		
		</cfloop>	
	
	</cfif>
	
	<cf_ModuleControlLog systemfunctionid="#url.idmenu#" 
	                     action="Update" 
						 content="#form#">

</cfif>

<cfoutput>
	<script>
		window.location = 'RecordEdit.cfm?idmenu=#url.idmenu#&id1=#vId#&fmission=#url.fmission#';
		window.opener.ptoken.navigate('RecordListingDetail.cfm?idmenu=#url.idmenu#&fmission=#url.fmission#','divListing');
	</script>
</cfoutput>