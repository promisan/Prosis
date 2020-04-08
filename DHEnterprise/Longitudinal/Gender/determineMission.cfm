<cfparam name="thisTemplate"     default ="no">
<cfparam name="thisGenderModule" default ="no">

<!---- 0>day, 1> month ---->
<cfset thisPeriodicity 	=	"1">

<cfquery name="validMission" datasource="AppsOrganization">

	SELECT  TOP 1 A.*
	FROM ( 		SELECT '1' sort_, oa.Mission
				FROM	OrganizationAuthorization OA
					INNER JOIN Ref_AuthorizationRole R
						ON OA.Role = R.Role
				WHERE	R.Area = 'Human Resources'
				AND		OA.UserAccount = '#session.acc#'
				AND     R.Role	= 'HRInquiry'
				AND EXISTS (SELECT 'X' FROM [NYVM1617].[MartStaffing].[dbo].[GenderModuleMission] as G WHERE G.Mission=OA.Mission) ---there must be a configuration for this entity ---->
				AND		Mission IS NOT NULL 
						--give priority to the incumbency
				AND Mission IN (SELECT TOP 1 mission 
									FROM Employee.dbo.vwAssignment 
									WHERE DateEffective	<=GetDATE() 
									--AND DateExpiration	>=GETDATE() 
									AND AssignmentStatus!='9' 
									AND PersonNo = (
											SELECT TOP 1 PersonNo FROM System.dbo.UserNames WHERE Account= '#session.acc#' and disabled='0'
													)
									ORDER BY DateEffective DESC
								)
	UNION 
				SELECT  '2' sort_, oa.Mission
				FROM	OrganizationAuthorization OA
						INNER JOIN Ref_AuthorizationRole R
							ON OA.Role = R.Role
				WHERE	R.Area = 'Human Resources'
				AND		OA.UserAccount = '#session.acc#'
				AND     R.Role	= 'HRInquiry'
				AND EXISTS (SELECT 'X' FROM [NYVM1617].[MartStaffing].[dbo].[GenderModuleMission] as G WHERE G.Mission=OA.Mission) ---there must be a configuration for this entity ---->
				AND		Mission IS NOT NULL 
				AND Mission NOT IN (SELECT TOP 1 mission 
										FROM Employee.dbo.vwAssignment 
										WHERE DateEffective	<=GetDATE() 
										--AND DateExpiration	>=GETDATE() 
										AND AssignmentStatus!='9' 
										AND PersonNo = (
											SELECT TOP 1 PersonNo FROM System.dbo.UserNames WHERE Account= '#session.acc#' and disabled='0'
														)
										ORDER BY DateEffective  DESC
									)
				) as A
	ORDER BY 1 ASC

</cfquery>

<!---- the ones for EO, daily feed ------>
<cfquery name="GetEOPeriod" datasource="AppsOrganization">
	SELECT  TOP 1  oa.Mission, CAST(OA.Created AS DATE)
	FROM	OrganizationAuthorization OA
			INNER JOIN Ref_AuthorizationRole R
				ON OA.Role = R.Role
	WHERE	1=1
	AND 	R.Area = 'Human Resources'
	AND		OA.UserAccount = '#session.acc#'
	AND 	OA.Role=	'ContractManager'
	AND 	EXISTS (SELECT 'X' FROM [NYVM1617].[MartStaffing].[dbo].[GenderModuleMission] as G WHERE G.Mission=OA.Mission)
	AND		Mission ='#validMission.Mission#' 
	ORDER BY CAST(OA.Created AS DATE) DESC
</cfquery>

<cfset myValidMissions = QuotedValueList(validMission.Mission)>
<cfif findNoCase("'DPPA-DPO'", myValidMissions) neq 0>
	<cfset myValidMissions = "#myValidMissions#,'- DPPA','- DPO','- SS'">
</cfif>

<!--- check on periodicity ---->
<cfif GetEOPeriod.recordCount gte 1>
	<cfset thisPeriodicity 	=	"0">
</cfif>

<cfset seldateEffective = "">

<!---- if no missions, show error to block everything else ---->
<cfif (trim(myValidMissions) eq "" ) 
					OR findNoCase("'Test'", myValidMissions) gte 1 >
	<!---- anonymous version, show monthly --->
	<cfset myValidMissions 	= "'- DPPA','DPPA-DPO','- DPO','- SS'">
	<cfset url.showDetail	= "0">
	<cfset thisPeriodicity	= "1">

</cfif>

<cfif myValidMissions eq "">
	<cfabort>
</cfif>

<cfif thisTemplate neq "no">

	<cfquery name="getParams" 
	 datasource="martStaffing">		 
		SELECT   *
		FROM     GenderModuleMission
		WHERE    Mission IN (#preserveSingleQuotes(myValidMissions)#)
		AND 	 Template = '#thisTemplate#'
		AND      Operational = '1'
		ORDER BY ModuleOrder ASC
	</cfquery>
		
</cfif>

<cfif thisGenderModule neq "no">

	<cfquery name="getMParam" 
	 datasource="martStaffing">		 
		SELECT   *
		FROM     GenderModuleMission
		WHERE    Mission IN (#preserveSingleQuotes(myValidMissions)#)
		AND 	 GenderModule = '#thisGenderModule#'
		AND      Operational = '1'
		ORDER BY ModuleOrder ASC
		
	</cfquery>
	
</cfif>
