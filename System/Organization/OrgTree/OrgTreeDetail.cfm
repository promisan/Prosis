<cfparam name="url.orgUnit" 			default="">
<cfparam name="url.postGrade" 			default="">
<cfparam name="url.functionNo" 			default="">
<cfparam name="url.buildingcode" 		default="">
<cfparam name="url.showAllTopics" 		default="SHOWALL">
<cfparam name="url.flat" 				default="0">
<cfparam name="url.showDirectoryView"	default="1">

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

<cfif URL.flat eq 1>
	<cfset vTotal = 2>
	<cfset columns = 6>
<cfelse>
	<cfset vTotal = 3>
	<cfset columns = 4>
</cfif>	

<cf_tl id="Staff directory" var="lblStaffDirectory">

<cfquery name="getMandate" 
	datasource="AppsOrganization">	
		SELECT *
		FROM   Ref_Mandate											
		WHERE  Mission = '#url.mission#'
		AND	   MandateNo = '#url.mandateno#'
</cfquery>

<cfquery name="getMission" 
	datasource="AppsOrganization">
		SELECT 	*
		FROM 	Ref_Mission
		WHERE	Mission = '#url.mission#'
</cfquery>

<cfquery name="getDirectory" 
	datasource="AppsEmployee">
	
		SELECT 	*
		FROM
			(
				SELECT 	A.PersonNo,
						A.IndexNo,
						A.FunctionDescription,
						A.Gender,
						A.FirstName,
						'<b>'+A.LastName+'</b>' as LastName,
						A.Nationality,
						A.PostGrade,
						A.PostOrder,
						O.OrgUnit,
						O.OrgUnitName,
						O.OrgUnitNameShort,
						O.HierarchyCode,
						C.AddressId,
						AD.Country,
						AD.AddressCity,
						C.BuildingCode,
						B.Name as BuildingName,
						C.BuildingLevel,
						AD.AddressRoom,
						AD.EmailAddress as ContactEmailAddress,
						ISNULL((
							SELECT TOP 1 Account
							FROM	System.dbo.UserNames
							WHERE	PersonNo = A.PersonNo
							AND		Disabled = '0'
							ORDER BY Created DESC
						), '') AS UserAccount,
						(
							SELECT TOP 1 PACx.ContactCallSign
							FROM	PersonAddress PAx
									INNER JOIN PersonAddressContact PACx
										ON PAx.PersonNo = PACx.PersonNo
										AND	PAx.AddressId = PACx.AddressId
										AND PACx.ContactCode = 'Extension' --'FixedPhone'
									INNER JOIN System.dbo.Ref_Address ADx
										ON PACx.AddressId = ADx.AddressId
										AND ADx.AddressScope IN( 'Profile','Employee' )
							WHERE	PAx.PersonNo = A.PersonNo
							ORDER BY PACx.Created DESC
						) as ContactTelephoneNo,
						ISNULL((					
							SELECT	TOP 1 PC.ContractLevel
							FROM	PersonContract PC							
							WHERE	PC.PersonNo = A.PersonNo
							AND     PC.ActionStatus = '1'					
							AND     PC.DateExpiration >= '#url.referencedate#'
							ORDER BY DateExpiration DESC
						), A.PostGrade) as ContractLevel,				
						(
							SELECT 	OrgUnitNameShort
							FROM	Organization.dbo.Organization
							WHERE	OrgUnitCode = O.ParentOrgUnit
							AND		Mission     = O.Mission
							AND		MandateNo   = O.MandateNo
						) as ParentOrgUnitNameShort,
						ISNULL((
							SELECT	OCx.OrganizationCategory as Color
							FROM	Organization.dbo.OrganizationCategory OCx
									INNER JOIN Organization.dbo.Organization Ox
										ON OCx.OrgUnit = Ox.OrgUnit
									INNER JOIN Organization.dbo.Ref_OrganizationCategory ROCx
										ON OCx.OrganizationCategory = ROCx.Code
							WHERE	ROCx.Area = 'Color'
							AND 	Ox.Mission = O.Mission
							AND		Ox.MandateNo = O.MandateNo
							AND		Ox.HierarchyCode = LEFT(O.HierarchyCode, 2)
						), '') as RootUnitColor,
						'' as ManagerPersonNo,
						'' as ManagerName,				
						PP.ProfileText,
						A.LocationCode,
						L.LocationName
						
				FROM	vwAssignment A
						INNER JOIN Organization.dbo.Organization O
							ON A.OrgUnit#trim(url.orgunittype)# = O.OrgUnit
						INNER JOIN System.dbo.Ref_Nation N
							ON A.Nationality = N.Code	
						LEFT OUTER JOIN PersonAddressContact C
							ON A.PersonNo = C.PersonNo
							AND C.ContactCode = 'Extension'  -- 'Office'
						LEFT OUTER JOIN System.dbo.Ref_Address AD
							ON C.AddressId = AD.AddressId
							AND AD.AddressScope IN( 'Profile','Employee' )
						LEFT OUTER JOIN Ref_AddressBuilding B
							ON C.BuildingCode = B.Code
						LEFT OUTER JOIN PersonProfile PP
							ON A.PersonNo = PP.PersonNo
							AND PP.LanguageCode = 'ENG'   <!--- driven by the laguage in the portal ? --->
						LEFT OUTER JOIN Location L
							ON A.LocationCode = L.LocationCode
							
				WHERE	A.MissionOperational = '#url.mission#'
				AND		A.DateEffective <= '#url.referencedate#'
				AND		A.DateExpiration >= '#url.referencedate#'
				AND		A.AssignmentStatus IN ('0', '1')
				AND		A.Incumbency > 0
				AND 	A.Operational = 1  <!--- hide people --->
				AND		O.MandateNo = '#url.mandateno#'		
				AND    	(O.DateExpiration <= '#getMandate.DateExpiration#' OR O.DateExpiration >= '#url.referencedate#')	
				--- AND    	O.OrgUnitCode NOT LIKE '0000%'
				
				<cfif url.orgUnit eq "all">
					
				<cfelseif url.orgUnit eq "none">
					AND		1=0
				<cfelse>
					AND		(
								O.OrgUnit = '#url.orgUnit#'
								OR
								O.OrgUnit IN 
									(
										SELECT 	OrgUnit 
										FROM 	Organization.dbo.Organization 
										WHERE 	ParentOrgUnit = (SELECT OrgUnitCode FROM Organization.dbo.Organization WHERE OrgUnit = '#url.orgUnit#')
									)
							)
				</cfif>
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
						(
							SELECT 'X'
							FROM	PersonAddressContact
							WHERE	ContactCode = 'Office'
							AND		PersonNo = A.PersonNo
							AND		BuildingCode = '#url.buildingcode#'
						)
				</cfif>
				<cfif url.locationcode neq "">
					AND	L.LocationCode = '#url.locationcode#'
				</cfif>
				<cfif trim(url.PostClass) neq "">
					AND	A.PostClass = '#url.PostClass#'
				</cfif>
		) AS Data
		INNER JOIN Ref_PostGrade CG ON Data.ContractLevel = CG.PostGrade
		WHERE	1=1
		<cfif trim(url.postGrade) neq "">
			AND	Data.ContractLevel = '#url.postgrade#'
		</cfif>
		ORDER BY Data.HierarchyCode, Data.PostOrder, CG.PostOrder   
		
</cfquery>


<cfquery name="getFunction" 
	datasource="AppsSystem">	
		SELECT 	*
		FROM 	Ref_ModuleControl
		WHERE	SystemModule = 'Selfservice'
		AND		FunctionClass = '#url.id#'
		AND		MenuClass = 'Process'
		AND		FunctionName = 'MyProfile'
</cfquery>


<cfif getDirectory.recordcount gt 0>

	<cfif url.showDirectoryView eq "1">
		<div class="row" style="padding-bottom:10px;">
			<div class="input-group" style="width:100%; padding-left:5%;">
			<input type="checkbox" id="cbRIR" onchange="doFlat(this)"  style="float:left; margin-top:5px; cursor:pointer;" <cfif url.flat eq 1>checked</cfif>>
			<div style="margin-left: 25px;">
	     		<label for="cbRIR" style="margin-top:2px; cursor:pointer;">Directory View <!--- (Rir) ----></label>
			</div>			
			</div>
		</div>
	</cfif>
		
	<div class="row">
		<div class="input-group" style="width:100%; padding-left:5%;">
			
			<cf_tl id="Search over the" var="lblSearch1">
			<cf_tl id="persons found..." var="lblSearch2">
			<cfoutput>
				
				<input class="form-control" type="text" placeholder="#lblSearch1# #getDirectory.recordcount# #lblSearch2#" style="width:90%;" onkeyup="searchElement(this.value, '.personContainer', event);">
				<div class="clsSearchSpinner" style="text-align:center; padding-top:75px; display:none;">
					<i class="fa fa-cog fa-3x fa-spin text-success"></i>
				</div>
				<cf_tl id="Print" var="1">
				<i class="fa fa-print" style="font-size:210%; padding-left:20px; cursor:pointer;" onclick="printList();" title="#lt_text#"></i>
			</cfoutput>
		</div>
		<br>
	</div>
	
<cfelse>

	<cfinclude template="OrgTreeInstructions.cfm">
	
</cfif>

<cfset cntElements = 1>
<cfset cnt = 0>
<cfset j = 0>
<cfset vColorArray = ['hyellow','hred','hgreen','hblue','hviolet','horange','hreddeep','hnavyblue']>
<cfset vRemovePanelAnimation = "">
<cfif getDirectory.recordcount gt 50>
	<cfset vRemovePanelAnimation = "clsNoAnimation">
</cfif>

<div class="clsListingContainer">

	<div class="row clsListingContainerRow">
		
		<cfoutput query="getDirectory" group="HierarchyCode">

			<cfquery name="getOrgUnit" 
				datasource="AppsSystem">	
					SELECT 
					/*A.eMailAddress*/
					A.eMailAddress + ' '+A.Remarks as eMailAddress
			  		FROM System.dbo.Ref_Address A INNER JOIN Organization.dbo.OrganizationAddress OA 
						ON A.AddressId = OA.AddressId
					WHERE OA.OrgUnit='#OrgUnit#'  
					AND A.EmailAddress IS NOT NULL
			</cfquery>
		
			<cfif url.flat eq 1>
				</div>
				<div class="row clsListingContainerRow">
			</cfif>
			<cfset j = 0>
			
			<div class="row clsPrintOnly" style="margin-left:15px; margin-right:15px;">
				<div class="col-lg-12" style="border-bottom:1px solid ##C0C0C0;">
					<p style="padding:0px; padding-left:15px; font-size:225%;">#OrgUnitName#</p>
					<cfif getOrgUnit.eMailAddress neq ""> 
						<p style="padding:0px; padding-left:15px; font-size:130%; margin-top:-15px;"><cf_tl id="For general inquiries">: #getOrgUnit.eMailAddress#</p>
					</cfif>	
				</div>
				<br>
			</div>
			
		
			<cfoutput>
			
				<cfset vColor = vColorArray[RandRange(1, 8, "SHA1PRNG")]>
				<cfset vColorBodyStyle = "">
				<cfif RootUnitColor neq "">
					<cfset vColor = "">
					<cfset vColorBodyStyle = "border-top: 2px solid ###RootUnitColor#;">
				</cfif>
				<cfset vHighlightExtension = 0>
				<cfset vTelephone = trim(ContactTelephoneNo)>
				<cfinclude template="formatPhoneNumber.cfm">

				<cfquery name="getConfiguration" 
					datasource="AppsSystem">
						SELECT 	UMC.*
						FROM   	UserModule UM
								INNER JOIN UserModuleCondition UMC
									ON UM.Account = UMC.Account
									AND UM.SystemFunctionId = UMC.SystemFunctionId
						WHERE 	1=1
						<cfif trim(url.id) neq "" and getFunction.recordCount gt 0>
							AND 	UM.SystemFunctionId = '#getFunction.systemfunctionid#'
						<cfelse>
							AND 	1=1
						</cfif>
						AND		UM.Account = '#UserAccount#'
						AND		UMC.ConditionValue = '1'
				</cfquery>
				
				<cfset vAuthorizedElements = "">
				<cfloop query="getConfiguration">
					<cfset vAuthorizedElements = vAuthorizedElements & ",[#ConditionClass#]">
				</cfloop>

				<cfif trim(vAuthorizedElements) eq "">
					<cfset vAuthorizedElements = url.showAllTopics>
				</cfif>
			
				<div class="col-lg-#columns# animated-panel zoomIn personContainer" onclick="showProfile('#personNo#');" <cfif url.flat eq 1>style="max-width:50%; padding-left:3px; padding-right:3px;"</cfif>>
	
					<div class="searchable" style="display:none;">
						#lastName#
						#firstName#
						#FunctionDescription#
						#OrgUnitName#
						#ParentOrgUnitNameShort#
						<cfif trim(Nationality) neq "" and (FindNoCase('NAT',vAuthorizedElements) neq 0 OR vAuthorizedElements eq 'SHOWALL')>NAT:#Nationality#</cfif>
						<cfif trim(PostGrade) neq "" and (FindNoCase('GRD',vAuthorizedElements) neq 0 OR vAuthorizedElements eq 'SHOWALL')>GRA:#Postgrade#</cfif>
						GEN:<cfif Gender eq "f">Female<cfelse>Male</cfif>
						<cfif trim(LocationName) neq "" and (FindNoCase('LOC',vAuthorizedElements) neq 0 OR vAuthorizedElements eq 'SHOWALL')>#LocationName#</cfif>
						#AddressRoom#
						#BuildingName#
						#AddressCity#
						#Country#
						#vFormattedTelephone#
					</div>
			        <div class="hpanel #vColor# contact-panel" style="cursor:pointer;">
			            <div class="panel-body #vRemovePanelAnimation#" style="#vColorBodyStyle#">
						
						<cfif url.flat eq 1>
							<div style ="width:100%; overflow:hidden;"> 
							<div style="width:50%; float:left; text-align:center;">
						</cfif>		
								<cfset vIndexNo = IndexNo>
								<cfset vGender = Gender>
								<cfset vUserAccount = UserAccount>
								<cfinclude template="getProfilePicture.cfm">
				                <cfif url.flat eq 1>
				                	<div class="img-circle clsRoundedPicture">
				                		<img src='#vPhoto#' class="img-circle clsRoundedPicture" style="height:75px; width:75px;">
				                	</div>
				                <cfelse>
									<div class="img-circle clsRoundedPicture" style="background-image:url('#vPhoto#'); height:80px; width:80px;"></div>				                
				                </cfif> 	
								
				                <h3><a style="font-size:55%;" href="##"><span style="text-transform:capitalize;">#lcase(firstName)#</span> #ucase(lastName)#</a></h3>
				                
								<p style="text-transform:capitalize; font-size:85%;">#FunctionDescription#</p>
				                
								<p font-size:85%;">#OrgUnitName#</p>
								
								<cfif url.flat neq 1>
									<cfif FindNoCase('LOC',vAuthorizedElements) neq 0 OR vAuthorizedElements eq 'SHOWALL'>
										<cfif trim(LocationCode) neq "">
											<p style="padding-top:7px;">
												<i class="fa fa-map-marker" style="font-size:125%;"></i>&nbsp;&nbsp;#LocationName#
											</p>
										</cfif>
										
										<cfif trim(AddressRoom) neq "">
											<p style="padding-top:7px;">
												<i class="fa fa-building" style="font-size:125%;"></i>&nbsp;&nbsp;#AddressRoom#
											</p>
										</cfif>
										
										<cfif trim(ContactTelephoneNo) neq "">
											<p style="padding-top:7px;">
												<i class="fa fa-phone-square" style="font-size:125%;"></i>&nbsp;&nbsp;#vFormattedTelephone#
											</p>
										</cfif>
										
										<cfif trim(ContactEmailAddress) neq "">
											<p style="padding-top:7px;">
												<i class="fa fa-envelope" style="font-size:125%;"></i>&nbsp;&nbsp;#ContactEmailAddress#
											</p>
										</cfif>
										
										<cfif trim(ManagerPersonNo) neq "" and trim(ManagerPersonNo) neq PersonNo>
											<p style="padding-top:7px;" class="clsPrintOnly">
												<i class="fa fa-sort-amount-asc clsRotate-180" style="font-size:125%;"></i>&nbsp;&nbsp;<span style="text-transform:capitalize;">#lcase(ManagerName)#</span>
											</p>
										</cfif>
									</cfif>
								</cfif>	
							<cfif url.flat eq 1>	
									<div style="display:table; height:70px;">
										<div style="display:table-cell; vertical-align:bottom;">
											<cfif trim(LocationCode) neq "" OR trim(AddressRoom) neq "">
												<p style="padding-top:3px; text-align:left;">
													<i class="fa fa-map-marker" style="font-size:125%; text-align:center;"></i>&nbsp;&nbsp; <!---#LocationName#----> <cfif trim(AddressRoom) neq "">#AddressRoom#</cfif>
												</p>
											</cfif>
											
											<cfif trim(ContactTelephoneNo) neq "">
												<p style="text-align:left;">
													<i class="fa fa-phone-square" style="font-size:125%; text-align:center;"></i>&nbsp;&nbsp;#vFormattedTelephone#
												</p>
											</cfif>
											
											<cfif trim(ContactEmailAddress) neq "">
												<p style="text-align:left;">
													<i class="fa fa-envelope" style="font-size:125%; text-align:center;"></i>&nbsp;&nbsp;#ContactEmailAddress#
												</p>
											</cfif>
											
											<cfif trim(ManagerPersonNo) neq "" and trim(ManagerPersonNo) neq PersonNo>
												<p style="text-align:left;" class="clsPrintOnly">
													<i class="fa fa-sort-amount-asc clsRotate-180" style="font-size:125%; text-align:center;"></i>&nbsp;&nbsp;<span style="text-transform:capitalize;">#lcase(ManagerName)#</span>
												</p>
											</cfif>
										</div>		
									</div>					
								</div>
							</cfif>	
							
							<cfif trim(ProfileText) neq "">
								<cfif url.flat eq 1>
									<div style="width:50%; float:left; padding-left:5px; padding-right:5px; height:200px; overflow:none;" >
										<i class="fa fa-user" style="font-size:70%; overflow:none;"></i>&nbsp;&nbsp;
										<cf_tl id="Functions">:<br><span style="font-size:70%; color:##969696;">#trim(ProfileText)#</span>
									</div>
								</cfif>	
							</cfif>		
								    
							<cfif url.flat eq 1>
								</div>
							</cfif>
			            </div>
			            
			            <cfif url.flat neq 1>
				            <div class="panel-footer contact-footer clsNoPrint">
				                <div class="row">
				                    <cfset vColShow = 1>
									<cfif trim(Nationality) neq "" and (FindNoCase('NAT',vAuthorizedElements) neq 0 OR trim(vAuthorizedElements) eq 'SHOWALL')>
										<cfset vColShow = vColShow + 1>
									</cfif>
									<cfif trim(ContractLevel) neq "" and (FindNoCase('GRD',vAuthorizedElements) neq 0 OR trim(vAuthorizedElements) eq 'SHOWALL')>
										<cfset vColShow = vColShow + 1>
									</cfif>
									<cfset vResponsiveClass = "col-md-12">
									<cfif vColShow eq 2>
										<cfset vResponsiveClass = "col-md-6">
									</cfif>
									<cfif vColShow eq 3>
										<cfset vResponsiveClass = "col-md-4">
									</cfif>
									
									<cfif trim(Nationality) neq "" and (FindNoCase('NAT',trim(vAuthorizedElements)) neq 0 OR trim(vAuthorizedElements) eq 'SHOWALL')>
					                    <div class="#vResponsiveClass# border-right animated-panel zoomIn" style="animation-delay: 0.2s;"> <div class="contact-stat"><span><cf_tl id="NAT"></span> <strong>#Nationality#</strong></div> </div>
									</cfif>
				                    <div class="#vResponsiveClass# border-right animated-panel zoomIn" style="animation-delay: 0.2s;"> <div class="contact-stat"><span><cf_tl id="GEN"></span> <strong>#Gender#</strong></div> </div>
									<cfif trim(ContractLevel) neq "" and (FindNoCase('GRD',trim(vAuthorizedElements)) neq 0 OR trim(vAuthorizedElements) eq 'SHOWALL')>
					                    <div class="#vResponsiveClass# animated-panel zoomIn" style="animation-delay: 0.3s;"> <div class="contact-stat"><span><cf_tl id="GRA"></span> <strong>#ContractLevel#</strong></div> </div>
									</cfif>
				                </div>
				            </div>
			            </cfif>
			            
			        </div>
			    </div>
				
				<cfset cntElements = cntElements + 1>
				
				<cfif url.flat eq 1 AND cntElements lt getDirectory.recordCount>
					<cfset j = j + 1>
					<cfif j eq 6>
						<cfset j = 0>
						<div style="page-break-after: always;"></div>
						<div class="clsPrintOnly">
							<cfset url.missionName = getMission.MissionName>
							<cfset url.label = lblStaffDirectory>
							<cfinclude template="PrintHeader.cfm">
						</div>						
					</cfif>
				</cfif>
				
			</cfoutput>
			
			<cfif url.flat eq 1 AND cntElements lt getDirectory.recordCount>
				<cfif cntElements % 2 eq 0>
					</div>
					<div class="row clsListingContainerRow">
				</cfif>
				<div style="page-break-after: always;"></div>
				<div class="clsPrintOnly">
					<cfset url.missionName = getMission.MissionName>
					<cfset url.label = lblStaffDirectory>
					<cfinclude template="PrintHeader.cfm">
				</div>						
			</cfif>
				
		</cfoutput>
	
	</div>

</div>