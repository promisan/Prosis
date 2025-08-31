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
<cfset isDirty = 0>
<cfset vMessage = "">

<cfquery name="GetLocation" 
datasource="appsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT 	*
	FROM 	Ref_PayrollLocation
	WHERE 	LocationCode = '#URL.ID1#'
</cfquery>

<cfset dateValue = "">
<cf_DateConvert Value="#Form.ddateEffective#">
<cfset vDateEffective = dateValue>

<cfif url.effective neq "">
	<cfset vyear = mid(url.effective, 1, 4)>
	<cfset vmonth = mid(url.effective, 6, 2)>
	<cfset vday = mid(url.effective, 9, 2)>
	<cfset vUrlDate = createDate(vyear, vmonth, vday)>
</cfif>

<cfif dateFormat(vDateEffective, 'yyyy-mm-dd') lt dateFormat(getLocation.dateEffective, 'yyyy-mm-dd') or dateFormat(vDateEffective, 'yyyy-mm-dd') gt dateFormat(getLocation.dateExpiration, 'yyyy-mm-dd')>
	<cfset isDirty = 1>
	<cfset vMessage = vMessage & "The effective date should be between the location effective period. \n">
</cfif>

<cfif Form.ddateExpiration neq "">
	
	<cfset dateValue = "">
	<cf_DateConvert Value="#Form.ddateExpiration#">
	<cfset vDateExpiration = dateValue>
	<cfset vDateExpirationOverlap = dateValue>
	
	<cfset dateValue = "">
	<cf_DateConvert Value="#Form.ddateExpirationOld#">
	<cfset vDateExpirationOld = dateValue>
	
	<cfif vDateExpiration lt vDateEffective>
		<cfset isDirty = 1>
		<cfset vMessage = vMessage & "Expiration date should be greater or equal than the effective date. \n">
	</cfif>
	
	<cfif dateFormat(vDateExpiration, 'yyyy-mm-dd') lt dateFormat(getLocation.dateEffective, 'yyyy-mm-dd') or dateFormat(vDateExpiration, 'yyyy-mm-dd') gt dateFormat(getLocation.dateExpiration, 'yyyy-mm-dd')>
		<cfset isDirty = 1>
		<cfset vMessage = vMessage & "The expiration date should be between the location effective period. \n">
	</cfif>

<cfelse>
	
	<cfset vDateExpirationOverlap = createDate(3000,12,31)>
	
</cfif>

<!--- Verify overlapping --->

<cfquery name="validateOverlapping" 
datasource="appsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT 	* 
	FROM 	Ref_PayrollLocationDesignation D
	WHERE 	1=1
	<cfif url.designation neq "">
	AND 	NOT EXISTS
	(
		SELECT 	* 
		FROM 	Ref_PayrollLocationDesignation
		WHERE	LocationCode = D.LocationCode
		AND		Designation = D.Designation
		AND		DateEffective = D.DateEffective
		AND		LocationCode = '#URL.ID1#'
		AND		Designation  = '#form.designation#'
		AND		DateEffective = #vDateEffective#
	)
	</cfif>
	AND		LocationCode = '#URL.ID1#'
	AND		Designation  = '#form.designation#'
	AND		
	(
		DateEffective BETWEEN #vDateEffective# AND #vDateExpirationOverlap#
		OR		DateExpiration BETWEEN #vDateEffective# AND #vDateExpirationOverlap#
		OR		#vDateEffective# BETWEEN DateEffective AND DateExpiration
		OR		#vDateExpirationOverlap# BETWEEN DateEffective AND DateExpiration
	)
</cfquery>

<cfif validateOverlapping.recordcount gt 0>
	<cfset isDirty = 1>
	<cfset vMessage = vMessage & "The entered dates overlap with another existing period. \n">
</cfif>


<cfif isDirty eq 0>

	<cfquery name="validate" 
	datasource="appsPayroll" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	* 
		FROM 	Ref_PayrollLocationDesignation
		WHERE 	LocationCode = '#URL.ID1#'
		AND		Designation  = '#URL.designation#'
		AND		DateEffective = #vDateEffective#
	</cfquery>
	
	<cfif url.designation eq "">
	
		<cfif validate.recordcount eq 0>
	
			<cfquery name="insert" 
			datasource="appsPayroll" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				INSERT INTO Ref_PayrollLocationDesignation
					(
						LocationCode,
						DateEffective,
						Designation,
						<cfif Form.ddateExpiration neq "">DateExpiration,</cfif>
						OfficerUserId,
						OfficerLastName,
						OfficerFirstName
					)
				VALUES
					(
						'#url.id1#',
						#vDateEffective#,
						'#form.designation#',
						<cfif Form.ddateExpiration neq "">#vDateExpiration#,</cfif>
						'#SESSION.acc#',
						'#SESSION.last#',
						'#SESSION.first#'
					)
			</cfquery>
			
			<cfoutput>
				<script>
					ColdFusion.Window.hide('mydialog');
					ColdFusion.navigate('DesignationListing.cfm?id1=#url.id1#','divDesignationsList');
				</script>
			</cfoutput>
		
		<cfelse>
		
			<script>
				ColdFusion.Window.hide('mydialog');
				alert('This designation is already associated to this date!');
			</script>
		
		</cfif>
	
	<cfelse>
	
		<cfif validate.recordcount gt 0 and dateDiff('d',vDateEffective, vUrlDate) neq 0>
		
			<script>
				ColdFusion.Window.hide('mydialog');
				alert('This designation is already associated to this date!');
			</script>
		
		<cfelse>
			
			<cfquery name="insert" 
			datasource="appsPayroll" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				UPDATE Ref_PayrollLocationDesignation
				SET	
					Designation = '#form.designation#',
					DateEffective = #vDateEffective#,
					DateExpiration = <cfif Form.ddateExpiration neq "">#vDateExpiration#<cfelse>null</cfif>
				WHERE 	LocationCode = '#URL.ID1#'
				AND		Designation  = '#URL.designation#'
				AND		DateEffective = #vUrlDate#
			</cfquery>
			
			<cfoutput>
				<script>
					ColdFusion.Window.hide('mydialog');
					ColdFusion.navigate('DesignationListing.cfm?id1=#url.id1#','divDesignationsList');
				</script>
			</cfoutput>
		
		</cfif>
	
	</cfif>

<cfelse>

	<cfoutput>
		<script>
			ColdFusion.Window.hide('mydialog');
			alert('#vMessage#');
		</script>
	</cfoutput>

</cfif>