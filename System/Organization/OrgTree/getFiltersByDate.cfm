<cfparam name="url.defaultOrgUnit" 	default="none">

<cfset vDate = url.referencedate>
<cfif trim(vDate) eq "">
	<cfset vDate = dateformat(now(), client.dateSQL)>
</cfif>

<cfquery name="getMandate" 
	datasource="AppsOrganization">
		SELECT *
		FROM   Ref_Mandate											
		WHERE  Mission = '#url.mission#'
		AND	   MandateNo = '#url.mandateno#'
</cfquery>

<cfquery name="getUnits" 
	datasource="AppsEmployee">
		SELECT DISTINCT	
				HierarchyCode, 
				O.OrgUnit, 
				O.OrgUnitName, 
				O.OrgUnitNameShort
		FROM	Organization.dbo.Organization O										
		WHERE	O.Mission     = '#url.mission#'
		AND		O.MandateNo   = '#url.MandateNo#'	
		AND     O.OrgUnitCode NOT LIKE '0000%'		
		AND     (O.DateExpiration = '#getMandate.DateExpiration#' OR O.DateExpiration > = '#vDate#')
		ORDER BY O.HierarchyCode
</cfquery>

<cfif getUnits.recordCount gt 1>

	<div class="form-group">
		<label class="control-label"><cf_tl id="Unit">:</label>
		<div class="input-group" style="width:100%;">
			<select class="form-control m-b" name="orgunit" id="orgunit">
				<option value="none" <cfif trim(lcase(url.defaultOrgUnit)) eq "none">selected</cfif>> - <cf_tl id="Please select a unit"> -
				<option value="all" <cfif trim(lcase(url.defaultOrgUnit)) eq "all">selected</cfif>> - <cf_tl id="All"> -
				<cfoutput query="getUnits">
					<cfset vHierarchyPadding = 0>
					<cfif len(HierarchyCode) gt 1>
						<cfset vHierarchyPadding = len(HierarchyCode) - 2>
					</cfif>
					<option value="#orgUnit#">#RepeatString("&nbsp;", vHierarchyPadding)##UCASE(OrgUnitNameShort)#
				</cfoutput>
			</select>
		</div>
	</div>
	
<cfelse>

	<input type="Hidden" name="orgunit" id="orgunit" value="all">

</cfif>

<!--- <div class="form-group">
	<label class="control-label"><cf_tl id="Fund">:</label>
	<div class="input-group" style="width:100%;">
	
		<cfquery name="getFunds" 
			datasource="AppsEmployee">
				SELECT DISTINCT	A.Fund
				FROM	vwAssignment A
				
				WHERE	A.MissionOperational = '#url.mission#'
				AND		A.DateEffective  <= '#vDate#'
				AND		A.DateExpiration >= '#vDate#'
				AND		A.AssignmentStatus IN ('0', '1')
				AND		A.Incumbency > 0
				AND		A.Operational = 1
				AND		LTRIM(RTRIM(A.PostGrade)) != ''
				
				ORDER BY A.Fund ASC
		</cfquery>
		
		<select class="form-control m-b" name="postgrade" id="postgrade">
			<option value=""> - <cf_tl id="ALL"> -
			<cfoutput query="getFunds">
				<option value="#Fund#">#Fund#
			</cfoutput>
		</select>
	
	</div>
</div> --->

<div class="form-group">
    <label class="control-label"><cf_tl id="Employee (Name, IndexNo or PersonNo)">:</label>
    <div class="input-group date" style="width:100%;">
        <input 
			type="text" 
			class="form-control" 
			name="employee" 
			id="employee"
			onkeyup="filterOnEnter(event);"  
			value="">
    </div>
</div>

<cfquery name="getBuildings" 
	datasource="AppsEmployee">
		SELECT DISTINCT
				A.Country,
				A.AddressCity,
				C.BuildingCode,
				B.Name as BuildingName
		FROM	PersonAddressContact C
				INNER JOIN System.dbo.Ref_Address A
					ON C.AddressId = A.AddressId
				INNER JOIN Ref_AddressBuilding B
					ON C.BuildingCode = B.Code
		WHERE	C.ContactCode = 'Office'
		AND		C.PersonNo IN
				(
					SELECT 	A.PersonNo
					FROM	vwAssignment A
							INNER JOIN Position P
							ON A.PositionNo = P.PositionNo					
					WHERE	A.MissionOperational = '#url.mission#'
					AND		A.DateEffective  <= '#vDate#'
					AND		A.DateExpiration >= '#vDate#'
					AND		A.AssignmentStatus IN ('0', '1')
					AND		A.Incumbency     > 0
					AND		A.Operational = 1
				)
		ORDER BY 
				A.Country,
				A.AddressCity,
				C.BuildingCode,
				B.Name
</cfquery>

<cfif getBuildings.recordCount gt 1>

	<div class="form-group">
		<label class="control-label"><cf_tl id="Building">:</label>
		<div class="input-group" style="width:100%;">
			<select class="form-control m-b" name="buildingcode" id="buildingcode">
				<option value=""> - <cf_tl id="ALL"> -
				<cfoutput query="getBuildings" group="AddressCity">
					<optgroup label="#Country# - #AddressCity#">
					<cfoutput>
						<option value="#BuildingCode#">#BuildingName# (#BuildingCode#)
					</cfoutput>
					</optgroup>
				</cfoutput>
			</select>
		</div>
	</div>
	
<cfelse>

	<input type="Hidden" name="buildingcode" id="buildingcode" value="">

</cfif>

<cfquery name="getLocations" 
	datasource="AppsEmployee">
		SELECT DISTINCT
				L.*
		FROM	vwAssignment A
				INNER JOIN Location L
					ON A.LocationCode = L.LocationCode
		WHERE	A.MissionOperational = '#url.mission#'
		AND		A.DateEffective  <= '#vDate#'
		AND		A.DateExpiration >= '#vDate#'
		AND		A.AssignmentStatus IN ('0', '1')
		AND		A.Incumbency > 0
		AND		A.Operational = 1
		ORDER BY L.ListingOrder ASC
</cfquery>

<cfif getLocations.recordCount gt 1>

	<div class="form-group">
		<label class="control-label"><cf_tl id="Location">:</label>
		<div class="input-group" style="width:100%;">
			<select class="form-control m-b" name="locationcode" id="locationcode">
				<option value=""> - <cf_tl id="ALL"> -
				<cfoutput query="getLocations">
					<option value="#LocationCode#">#LocationName#
				</cfoutput>
			</select>
		</div>
	</div>
	
<cfelse>

	<input type="Hidden" name="locationcode" id="locationcode" value="">

</cfif>

<cfquery name="getGrades" 
	datasource="AppsEmployee">
		SELECT DISTINCT
				PG.PostOrder,
				Data.ContractLevel
		FROM
			(
				SELECT 	A.PostOrder, 
						ISNULL((
							SELECT	TOP 1 PC.ContractLevel
							FROM	PersonContract PC							
							WHERE	PC.PersonNo = A.PersonNo
							AND     PC.ActionStatus = '1'					
							AND     PC.DateExpiration >= '#vDate#'
							ORDER BY DateExpiration DESC
						), '') as ContractLevel		
				FROM	vwAssignment A
				WHERE	A.MissionOperational = '#url.mission#'
				AND		A.DateEffective  <= '#vDate#'
				AND		A.DateExpiration >= '#vDate#'
				AND		A.AssignmentStatus IN ('0', '1')
				AND		A.Incumbency > 0
				AND		A.Operational = 1
			) as Data
			INNER JOIN Ref_PostGrade PG
				ON Data.ContractLevel = PG.PostGrade
		ORDER BY PG.PostOrder ASC
</cfquery>

<cfif getGrades.recordCount gt 1>

	<div class="form-group">
		<label class="control-label"><cf_tl id="Grade">:</label>
		<div class="input-group" style="width:100%;">
			<select class="form-control m-b" name="postgrade" id="postgrade">
				<option value=""> - <cf_tl id="ALL"> -
				<cfoutput query="getGrades">
					<cfif trim(ContractLevel) neq "">
						<option value="#ContractLevel#">#ContractLevel#
					</cfif>
				</cfoutput>
			</select>
		</div>
	</div>
	
<cfelse>

	<input type="Hidden" name="postgrade" id="postgrade" value="">

</cfif>

<cfquery name="getClasses" 
	datasource="AppsEmployee">
		SELECT DISTINCT PC.PostClass, PC.ListingOrder
		FROM
			(
				SELECT 	A.PostClass		
				FROM	vwAssignment A
				WHERE	A.MissionOperational = '#url.mission#'
				AND		A.DateEffective  <= '#vDate#'
				AND		A.DateExpiration >= '#vDate#'
				AND		A.AssignmentStatus IN ('0', '1')
				AND		A.Incumbency > 0
				AND		A.Operational = 1
			) as Data
			INNER JOIN Ref_PostClass PC
				ON Data.PostClass = PC.PostClass
		ORDER BY PC.ListingOrder ASC
</cfquery>

<cfif getClasses.recordCount gt 1>

	<div class="form-group">
		<label class="control-label"><cf_tl id="Class">:</label>
		<div class="input-group" style="width:100%;">
			<select class="form-control m-b" name="postclass" id="postclass">
				<option value=""> - <cf_tl id="ALL"> -
				<cfoutput query="getClasses">
					<option value="#PostClass#">#PostClass#
				</cfoutput>
			</select>
		</div>
	</div>
	
<cfelse>

	<input type="Hidden" name="postclass" id="postclass" value="">

</cfif>

<cfquery name="getFunctions" 
	datasource="AppsEmployee">
		SELECT DISTINCT 
				A.PostOrder, 
				A.FunctionNo, 
				A.FunctionDescription
		FROM	vwAssignment A				
		WHERE	A.MissionOperational = '#url.mission#'
		AND		A.DateEffective  <= '#vDate#'
		AND		A.DateExpiration >= '#vDate#'
		AND		A.AssignmentStatus IN ('0', '1')
		AND		A.Incumbency > 0
		AND		A.Operational = 1
		ORDER BY A.FunctionDescription ASC
</cfquery>

<cfif getFunctions.recordCount gt 1>

	<div class="form-group">
		<label class="control-label"><cf_tl id="Title">:</label>
		<div class="input-group" style="width:100%;">
			<select class="form-control m-b" name="functionno" id="functionno">
				<option value=""> - <cf_tl id="ALL"> -
				<cfoutput query="getFunctions">
					<option value="#functionNo#">#functiondescription# [#functionNo#]
				</cfoutput>
			</select>
		</div>
	</div>
	
<cfelse>

	<input type="Hidden" name="functionno" id="functionno" value="">

</cfif>

<cfquery name="getNationalities" 
	datasource="AppsEmployee">
		SELECT DISTINCT	
				A.Nationality, 
				N.Name as NationalityDescription
		FROM	vwAssignment A
				INNER JOIN System.dbo.Ref_Nation N
					ON A.Nationality = N.Code
		WHERE	A.MissionOperational = '#url.mission#'
		AND		A.DateEffective  <= '#vDate#'
		AND		A.DateExpiration >= '#vDate#'
		AND		A.AssignmentStatus IN ('0', '1')
		AND		A.Incumbency > 0
		AND		A.Operational = 1
		ORDER BY N.Name ASC
		
</cfquery>

<cfif getNationalities.recordCount gt 1>

	<div class="form-group">
		<label class="control-label"><cf_tl id="Nationality">:</label>
		<div class="input-group" style="width:100%;">
			<select class="form-control m-b" name="nationality" id="nationality">
				<option value=""> - <cf_tl id="ALL"> -
				<cfoutput query="getNationalities">
					<option value="#Nationality#">#NationalityDescription#
				</cfoutput>
			</select>
		</div>
	</div>
	
<cfelse>

	<input type="Hidden" name="nationality" id="nationality" value="">

</cfif>

<cfquery name="getFunctionTexts" 
	datasource="AppsEmployee">
		SELECT 	PP.*
		FROM	vwAssignment A
				INNER JOIN PersonProfile PP
					ON A.PersonNo = PP.PersonNo
		WHERE	A.MissionOperational = '#url.mission#'
		AND		A.DateEffective  <= '#vDate#'
		AND		A.DateExpiration >= '#vDate#'
		AND		A.AssignmentStatus IN ('0', '1')
		AND		A.Incumbency > 0
		AND		A.Operational = 1
</cfquery>

<cfif getFunctionTexts.recordCount gt 0>

	<div class="form-group">
		<label class="control-label"><cf_tl id="Functions key words">:</label>
		<div class="input-group" style="width:100%;">
			<input 
				type="text" 
				class="form-control" 
				name="functions" 
				id="functions" 
				onkeyup="filterOnEnter(event);" 
				value="">
		</div>
	</div>
	
<cfelse>

	<input type="Hidden" name="functions" id="functions" value="">

</cfif>