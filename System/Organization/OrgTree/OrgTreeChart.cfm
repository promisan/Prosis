
<cfif trim(url.functions) neq "">

	<cfset vFunctionsKeywords = lcase(trim(url.functions))>
	<cfset vFunctionsKeywords = replace(vFunctionsKeywords, "'", "", "ALL")>
	<cfset vFunctionsKeywords = replace(vFunctionsKeywords, ",", "", "ALL")>
	<cfset vFunctionsKeywords = replace(vFunctionsKeywords, " ", ",", "ALL")>
	<cfset vFunctionsKeywords = replace(vFunctionsKeywords, "	", ",", "ALL")>
	
	<cfset vFunctionsKeywordsList = "">
	<cfloop list="#vFunctionsKeywords#" index="keyword" delimiters=",">
		<cfset vFunctionsKeywordsList = vFunctionsKeywordsList & ",%#keyword#%">
	</cfloop>
	
	<cfif vFunctionsKeywordsList neq "">
		<cfset vFunctionsKeywordsList = mid(vFunctionsKeywordsList, 2, len(vFunctionsKeywordsList))>
	</cfif>
	
</cfif>

<cfif trim(url.employee) neq "">

	<cfset vEmployeeKeywords = lcase(trim(url.employee))>
	<cfset vEmployeeKeywords = replace(vEmployeeKeywords, "'", "%", "ALL")>
	<cfset vEmployeeKeywords = replace(vEmployeeKeywords, ",", "%", "ALL")>
	<cfset vEmployeeKeywords = replace(vEmployeeKeywords, " ", "%", "ALL")>
	<cfset vEmployeeKeywords = replace(vEmployeeKeywords, "	", "%", "ALL")>
	
</cfif>

<cfquery name="getMandate" 
	datasource="AppsOrganization">
		SELECT *
		FROM   Ref_Mandate											
		WHERE  Mission = '#url.mission#'
		AND	   MandateNo = '#url.mandateno#'
</cfquery>

<cfset vFiltered = 0>
<cfif url.nationality neq "" OR url.functionNo neq "" OR trim(url.employee) neq "" OR trim(url.functions) neq "" OR url.buildingcode neq "" OR url.locationcode neq "" OR (url.orgUnit neq "all" AND url.orgUnit neq "none") OR url.postGrade neq "">
	<cfset vFiltered = 1>
</cfif>


<cfquery name="getDirectory" 
	datasource="AppsEmployee">
	
		SELECT 	O.OrgUnitNameShort,
				O.OrgUnitCode,
				O.OrgUnit,
				O.OrgUnitName,
				O.HierarchyCode as OrgUnitHierarchyCode,
				
				ISNULL((
					SELECT	OCx.OrganizationCategory as Color
					FROM	Organization.dbo.OrganizationCategory OCx
							INNER JOIN Organization.dbo.Organization Ox
								ON OCx.OrgUnit = Ox.OrgUnit
							INNER JOIN Organization.dbo.Ref_OrganizationCategory ROCx
								ON OCx.OrganizationCategory = ROCx.Code
					WHERE	ROCx.Area     = 'Color'
					AND 	Ox.Mission    = O.Mission
					AND		Ox.MandateNo   = O.MandateNo
					AND		Ox.HierarchyCode = LEFT(O.HierarchyCode, 2)
				), '') as RootUnitColor,				
				
				Data.*
		FROM
			(
				SELECT  A.MissionOperational as Mission, A.PersonNo, A.IndexNo, A.FullName, A.LastName, A.MiddleName, A.FirstName, A.Nationality, A.Gender, A.BirthDate, 
				        A.eMailAddress, 
		                A.ParentOffice, A.ParentOfficeLocation, A.PersonReference, A.OrgUnitClass, A.OrgUnitClassOrder, 
		                A.OrgUnitClassName, A.DateEffective, A.DateExpiration, A.FunctionDescriptionActual, A.FunctionDescription, A.PositionNo, A.PositionParentId, 
		                A.OrgUnitOperational, A.OrgUnitAdministrative, A.OrgUnitFunctional, A.PostType, A.PostClass, A.LocationCode, A.VacancyActionClass, A.PostGrade, 
		                A.PostOrder, A.SourcePostNumber, A.PostOrderBudget, A.PostGradeBudget, A.PostGradeParent, A.OccGroup, A.OccGroupName, A.OccGroupOrder, 
		                A.PostGradeParentDescription, A.ViewOrder, A.ContractId, A.AssignmentNo, A.AssignmentStatus, A.AssignmentClass, A.AssignmentType, A.Incumbency, 
		                A.Remarks, A.ExpirationCode, A.ExpirationListCode, A.AssignmentLocation, A.Created, 
						C.AddressId, 						
						C.BuildingCode, 
		                B.Name AS BuildingName, 
						C.BuildingLevel, 
						AD.AddressRoom, 
						AD.Country, 
						AD.AddressCity, 
						AD.eMailAddress AS ContactEmailAddress, 
						'' AS Manager,					
												
						ISNULL((
							SELECT TOP 1 Account
							FROM	System.dbo.UserNames
							WHERE	PersonNo = A.PersonNo
							AND		Disabled = '0'
							ORDER BY Created DESC ), '') AS UserAccount,
						
						ISNULL((					
							SELECT	TOP 1 PC.ContractLevel
							FROM	PersonContract PC							
							WHERE	PC.PersonNo        = A.PersonNo
							AND     PC.ActionStatus    IN ('1','0')					
							AND     PC.DateExpiration >= '#url.referencedate#'
							ORDER BY DateExpiration DESC ), '') as ContractLevel
						
				FROM	vwAssignment A							
							
						LEFT OUTER JOIN PersonAddressContact C
							ON A.PersonNo = C.PersonNo
							AND C.ContactCode = 'Office'
						LEFT OUTER JOIN System.dbo.Ref_Address AD
							ON C.AddressId = AD.AddressId
							AND AD.AddressScope = 'Profile'
						LEFT OUTER JOIN Ref_AddressBuilding B
							ON C.BuildingCode = B.Code						
						LEFT OUTER JOIN PersonProfile PP
							ON A.PersonNo = PP.PersonNo
							AND PP.LanguageCode = 'ENG'
						
				WHERE	A.MissionOperational = '#url.mission#'
				AND		A.DateEffective     <= '#url.referencedate#'
				AND		A.DateExpiration    >= '#url.referencedate#'
				AND		A.AssignmentStatus IN ('0', '1')
				AND		A.Incumbency       > 0
				AND 	A.Operational      = 1
				
				<cfif url.nationality neq "">
					AND	A.Nationality = '#url.nationality#'
				</cfif>
				<cfif url.functionNo neq "">
					AND	A.FunctionNo = '#url.functionNo#'
				</cfif>
				<cfif trim(url.employee) neq "">
					AND	
						(
							A.FullName LIKE '%#vEmployeeKeywords#%'
							OR
							A.IndexNo LIKE '%#vEmployeeKeywords#%'
							OR
							A.PersonNo LIKE '%#vEmployeeKeywords#%'
						)
				</cfif>
				<cfif trim(url.functions) neq "">
					AND	
						(
							<cfset kwCnt = 1>
							<cfloop list="#vFunctionsKeywordsList#" index="keyword" delimiters=",">
								<cfif kwCnt gt 1>
								 OR 
								</cfif>
								PP.ProfileText LIKE '#keyword#' 
								<cfset kwCnt = kwCnt + 1>
							</cfloop>
						)
				</cfif>
						
				<cfif url.buildingcode neq "">
					AND	EXISTS
						(	SELECT 'X'
							FROM	PersonAddressContact
							WHERE	ContactCode = 'Office'
							AND		PersonNo = A.PersonNo
							AND		BuildingCode = '#url.buildingcode#'
						)
				</cfif>
				<cfif url.locationcode neq "">
					AND	A.LocationCode = '#url.locationcode#'
				</cfif>	

				<cfif trim(url.PostClass) neq "">
					AND	A.PostClass = '#url.PostClass#'
				</cfif>		
				
			) as Data
			
			LEFT OUTER JOIN Ref_PostGrade CG ON Data.ContractLevel = CG.PostGrade
			RIGHT OUTER JOIN Organization.dbo.Organization O ON Data.OrgUnit#trim(url.orgunittype)# = O.OrgUnit 
			
			WHERE  O.Mission          = '#url.mission#'
			AND		O.MandateNo        = '#url.mandateno#'
			AND    	(O.DateExpiration <= '#getMandate.DateExpiration#' OR O.DateExpiration >= '#url.referencedate#')

			<cfif trim(url.postGrade) neq "">
				AND	Data.ContractLevel = '#url.postgrade#'
			</cfif>	
																	
			<cfif url.orgUnit eq "all">
			
			<cfelseif url.orgUnit eq "none">
						
			<cfelse>
						AND		(
									O.OrgUnit = '#url.orgUnit#'
									OR
									O.OrgUnit IN 
										(
											SELECT 	OrgUnit 
											FROM 	Organization.dbo.Organization 
											WHERE   Mission   = '#url.mission#'
											AND     MandateNo = '#url.mandateno#'
											AND   	HierarchyCode LIKE (SELECT HierarchyCode+'%'
											                            FROM   Organization.dbo.Organization 
																		WHERE  OrgUnit = '#url.orgUnit#')
										)
								)
								
								
			</cfif>				
			
		ORDER BY O.HierarchyCode, Data.PostOrder, CG.PostOrder	
		
		
</cfquery>


<cfquery name="getResult" maxrows=1 dbtype="query">
	SELECT *
	FROM	getDirectory
	WHERE   LastName > ''
</cfquery>

<cfif getResult.recordcount eq 0>

	<cfinclude template="OrgTreeInstructions.cfm">

<cfelse>
	
	<div style="position:fixed;top:25px;right:60px;">
		<cfoutput>
			<cf_tl id="Print" var="1">
			<i class="fa fa-print" style="font-size:210%; cursor:pointer;" onclick="printList();" title="#lt_text#"></i>					
		</cfoutput>
	</div>
	
	<div class="clsListingContainer">

	<cfoutput query="getDirectory" group="OrgUnitHierarchyCode">
	
		<cfset vHierachyLen = len(OrgUnitHierarchyCode)>
		<cfset vPaddingLeft = 0>
		<cfif (vHierachyLen-2) gt 0>
			<cfset vPaddingLeft = (vHierachyLen-2) * 15>
		</cfif>
		
		<cfset vPanelHeadingStyle   = "">
		<cfset vPeopleProfileStyle  = "width:40px; height:40px;">
		<cfset vManagerProfileStyle = "width:80px; height:80px;">
		<cfset vManagerMargin       = "margin-left:calc(50% - 40px); margin-bottom:5px;">
		<cfset vPeopleMargin        = "margin-left:calc(50% - 20px); margin-bottom:5px;">
		
		<cfif RootUnitColor eq "">
			<cfif vHierachyLen eq 2>
				<cfset vPanelHeadingStyle = "background-color:##F9BF3B; color:##FFFFFF; font-size:140%;">
				<cfset vManagerProfileStyle = "width:80px; height:80px; border:4px solid ##F9BF3B;">
			<cfelseif vHierachyLen eq 5>
				<cfset vPanelHeadingStyle = "background-color:##3498DB; color:##FFFFFF; font-size:115%;">
				<cfset vManagerProfileStyle = "width:80px; height:80px; border:4px solid ##3498DB;">
			<cfelseif vHierachyLen eq 8>
				<cfset vPanelHeadingStyle = "background-color:##1ABCDC; color:##FFFFFF;">
				<cfset vManagerProfileStyle = "width:80px; height:80px; border:4px solid ##1ABCDC;">
			<cfelseif vHierachyLen eq 11>
				<cfset vPanelHeadingStyle = "background-color:##B3B6B7; color:##FFFFFF;">
				<cfset vManagerProfileStyle = "width:80px; height:80px; border:4px solid ##B3B6B7;">
			<cfelseif vHierachyLen eq 14>
				<cfset vPanelHeadingStyle = "background-color:##58D68D; color:##FFFFFF;">
				<cfset vManagerProfileStyle = "width:80px; height:80px; border:4px solid ##58D68D;">
			<cfelseif vHierachyLen eq 17>
				<cfset vPanelHeadingStyle = "background-color:##58D23D; color:##FFFFFF;">
				<cfset vManagerProfileStyle = "width:80px; height:80px; border:4px solid ##58D68D;">	
			</cfif>
		<cfelse>
			<cfset vRGBColorRed   = InputBaseN(Mid(RootUnitColor, 1, 2), 16)>
			<cfset vRGBColorGreen = InputBaseN(Mid(RootUnitColor, 3, 2), 16)>
			<cfset vRGBColorBlue  = InputBaseN(Mid(RootUnitColor, 5, 2), 16)>
			<cfset vRGBColor      = "#vRGBColorRed#, #vRGBColorGreen#, #vRGBColorBlue#">
			
			<cfif vHierachyLen eq 2>
				<cfset vPanelHeadingStyle = "background-color:rgba(#vRGBColor#, 1); color:##FFFFFF; font-size:140%;">
				<cfset vManagerProfileStyle = "width:80px; height:80px; border:4px solid ###RootUnitColor#;">
			<cfelseif vHierachyLen eq 5>
				<cfset vPanelHeadingStyle = "background-color:rgba(#vRGBColor#, 0.7); color:##FFFFFF; font-size:115%;">
				<cfset vManagerProfileStyle = "width:80px; height:80px; border:4px solid ###RootUnitColor#;">
			<cfelseif vHierachyLen eq 8>
				<cfset vPanelHeadingStyle = "background-color:rgba(#vRGBColor#, 0.6);; color:##000000;">
				<cfset vManagerProfileStyle = "width:80px; height:80px; border:4px solid ###RootUnitColor#;">
			<cfelseif vHierachyLen eq 11>
				<cfset vPanelHeadingStyle = "background-color:rgba(#vRGBColor#, 0.5);; color:##000000;">
				<cfset vManagerProfileStyle = "width:80px; height:80px; border:4px solid ###RootUnitColor#;">
			<cfelseif vHierachyLen eq 14>
				<cfset vPanelHeadingStyle = "background-color:rgba(#vRGBColor#, 0.4);; color:##000000;">
				<cfset vManagerProfileStyle = "width:80px; height:80px; border:4px solid ###RootUnitColor#;">
			<cfelseif vHierachyLen eq 17>
				<cfset vPanelHeadingStyle = "background-color:rgba(#vRGBColor#, 0.3);; color:##000000;">
				<cfset vManagerProfileStyle = "width:80px; height:80px; border:4px solid ###RootUnitColor#;">	
			<cfelseif vHierachyLen eq 20>
				<cfset vPanelHeadingStyle = "background-color:rgba(#vRGBColor#, 0.25);; color:##000000;">
				<cfset vManagerProfileStyle = "width:80px; height:80px; border:4px solid ###RootUnitColor#;">	
			</cfif>
		</cfif>
		
		<div class="col-lg-12 animated-panel zoomIn orgUnitTopContainer" style="padding-left:#vPaddingLeft#px;">
		
			<cfset vPanelCollpsed = "panel-collapse">
			<cfset vBodyCollpsed  = "display:none;">
			
			<cfif PersonNo neq "">
				<cfset vPanelCollpsed = "">
				<cfset vBodyCollpsed = "">
			</cfif>
						
			<cfset vOrgTitle = ucase(OrgUnitName)>
			<cfif trim(OrgUnitNameShort) neq "">
				<cfset vOrgTitle = "#vOrgTitle# <span style='font-size:80%; padding-left:10px;'>#ucase(OrgUnitNameShort)#</span>">
			</cfif>
		
			<cf_mobilePanel 
				id="#orgunit#"
				title="#vOrgTitle#"
				panelClass="#vPanelCollpsed# orgUnitContainer"
				bodyStyle="#vBodyCollpsed#"
				panelHeadingStyle="#vPanelHeadingStyle#"
				addContainer="0">
					
					<div class="searchable" style="display:none;">#OrgUnitNameShort# #OrgUnitName# #OrgUnitCode# #OrgUnit#</div>
					
					<div class="clsHierarcyCode clsHierarchyCode_#orgUnit#" style="display:none;">#OrgUnitHierarchyCode#</div>
														
					<cfoutput group="Manager">
	
						<div style="cursor:pointer;">
						
							<div class="row">
							
							    <cfif Gender neq "">
								
								<div class="col-lg-2" onclick="showProfile('#personno#');">
									<cfset vIndexNo = IndexNo>
									<cfset vGender = Gender>
									<cfset vUserAccount = UserAccount>
									<cfinclude template="getProfilePicture.cfm">
									<div class="img-circle clsRoundedPicture" style="background-image:url('#vPhoto#'); #vManagerProfileStyle# #vManagerMargin#"></div>
									<div class="text-center" style="font-size:110%; text-transform:capitalize;">#lcase(FirstName)# #lcase(LastName)#<cfif trim(contractLevel) neq ""><br>(#ContractLevel#)</cfif></div>
									<div class="searchable" style="display:none;">#lcase(FirstName)# #lcase(LastName)# #IndexNo# #ContractLevel#</div>
								</div>								
								
								<div class="col-lg-10">
								
									<cfset cnt = 1>
									<cfoutput>
										<cfif cnt neq 1>
											<div class="col-lg-3 col-sm-6" onclick="showProfile('#personno#');" style="margin-bottom:15px; height:100px;">
												<cfset vIndexNo = IndexNo>
												<cfset vGender = Gender>
												<cfset vUserAccount = UserAccount>
												<cfinclude template="getProfilePicture.cfm">
												<div class="img-circle clsRoundedPicture" style="background-image:url('#vPhoto#'); #vPeopleProfileStyle# #vPeopleMargin#"></div>
												<div class="text-center" style="text-transform:capitalize;">#lcase(FirstName)# #lcase(LastName)#<cfif trim(contractLevel) neq ""><br>(#ContractLevel#)</cfif></div>
												<div class="searchable" style="display:none;">#lcase(FirstName)# #lcase(LastName)# #IndexNo# #ContractLevel#</div>
											</div>
										</cfif>
										<cfset cnt = cnt + 1>
									</cfoutput>
									
								</div>
								
								</cfif>
								
							</div>
						</div>
						
					</cfoutput>
					
			</cf_mobilePanel>
			
		</div>
	
	</cfoutput>

</div>
	
</cfif>



<!--- $('.orgUnitContainer .panel-heading').on('click', function(){ toggleChildOrgUnit($(this).closest('.animate-panel').attr('id')); }); --->
<cfset AjaxOnLoad("function() { initPanelButtons(); }")>

