
<!--- Position box --->

<cfparam name="url.mission"    default="STL">
<cfparam name="url.selection"  default="01/01/2020">

<cf_screentop html="No" jquery="yes">


<cfquery name="Position" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		
		SELECT      Mission, MandateNo, MissionOwner, OrgunitOperational, OrgunitName, OrgunitNameShort, 
		            OrgUnitClass, HierarchyCode, OrgUnitCode, PositionNo, 
                    FunctionNo, FunctionDescription, OccGroupOrder, OccGroupAcronym, OccupationalGroup, OccGroupDescription, 
					PostType, PostClass, PostClassGroup, 
                    PostInBudget, 
					VacancyActionClass, ShowVacancy, PostAuthorised, PositionParentId, SourcePostNumber, 
					DateEffective, DateExpiration, PostGrade, PostOrder, 
                    ApprovalPostGrade, LocationCode, PostGradeBudget, PostOrderBudget, PostGradeParent
					
		FROM        vwPosition
		WHERE       Mission = '#URL.Mission#' 
		AND         DateEffective  < '#url.selection#' 
		AND         DateExpiration > '#url.selection#'
		<!--- limit access to positions for which this person is HRA 
		AND         OrgUnit = '#orgUnit#'
		--->
		ORDER BY    HierarchyCode, PostOrder
		
</cfquery>		


<!--- clean the field to pass only the needed ones --->

<cfquery name="Assignment" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		
		SELECT     Mission, MandateNo, MissionOperational, PersonNo, IndexNo, FullName, LastName, MiddleName, FirstName, Nationality, Gender, BirthDate, 
                   eMailAddress, ParentOffice, ParentOfficeLocation, PersonReference, Operational, OrgUnit, OrgUnitName, OrgUnitNameShort, OrgUnitHierarchyCode, OrgUnitClass, 
                   ParentOrgUnit, OrgUnitClassOrder, OrgUnitClassName, DateEffective, DateExpiration, FunctionDescriptionActual, FunctionNo, FunctionDescription, PositionNo, 
                   PositionParentId, OrgUnitOperational, OrgUnitAdministrative, OrgUnitFunctional, PostType, PostClass, LocationCode, VacancyActionClass, PostGrade, PostOrder, 
                   SourcePostNumber, PostOrderBudget, PostGradeBudget, PostGradeParent, OccGroup, OccGroupName, OccGroupOrder, PostGradeParentDescription, ViewOrder, 
                   ContractId, AssignmentNo, AssignmentStatus, AssignmentClass, AssignmentType, Incumbency, Remarks, ExpirationCode, ExpirationListCode, AssignmentLocation
		FROM       vwAssignment
		WHERE      Mission = '#URL.Mission#' 
		AND        DateEffective  < '#url.selection#' 
		AND        DateExpiration > '#url.selection#'
		AND        AssignmentStatus IN ('0','1') 
		
</cfquery>

<table style="border:1px solid silver;width:100%">

<tr class="labelmedium"><td colspan="3" style="padding-top:10px;height:67px;font-size:29px">#OrgUnitName#</td></tr>

<tr>

<cfoutput query="Position" group="HierarchyCode" maxrows=3>

	<td style="padding:3px;width:33%;min-width:300px">
		
		
	
	</td>
	
</cfoutput>	

</tr>
</table>

