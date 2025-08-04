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
<cfparam name="url.allowEdit" 				default="0">
<cfparam name="url.showAllTopics"			default="0">
<cfparam name="url.referenceDate" 			default="#dateformat(now(), 'yyyy-mm-dd')#">
<cfparam name="url.orgUnitType" 			default="Operational">
<cfparam name="url.configsystemfunctionid" 	default="#url.systemfunctionid#">

<cfset vAllowEdit = false>
<cfif trim(url.allowEdit) eq "1">
	<cfset vAllowEdit = true>
</cfif>

<cfquery name="getDetailPerson" 
	datasource="AppsEmployee">
		SELECT	A.*,
				Pe.OrganizationStart,
				N.Name as NationalityDescription,
				AD.EmailAddress as ContactEmailAddress,
				C.AddressId,
				AD.Country,
				AD.AddressCity,
				C.BuildingCode,
				B.Name as BuildingName,
				C.BuildingLevel,
				AD.AddressRoom,
				PP.ProfileText,
				L.LocationName,
				(
					SELECT TOP 1 PACx.ContactCallSign
					FROM	PersonAddress PAx
							INNER JOIN PersonAddressContact PACx
								ON PAx.PersonNo = PACx.PersonNo
								AND	PAx.AddressId = PACx.AddressId
								AND PACx.ContactCode = 'FixedPhone'
							INNER JOIN System.dbo.Ref_Address ADx
								ON PACx.AddressId = ADx.AddressId
								AND ADx.AddressScope IN ('Profile','Employee')
					WHERE	PAx.PersonNo = A.PersonNo
					ORDER BY PACx.Created DESC
				) as ContactTelephoneNo,
				(
					SELECT TOP 1 PACx.ContactCallSign
					FROM	PersonAddress PAx
							INNER JOIN PersonAddressContact PACx
								ON PAx.PersonNo = PACx.PersonNo
								AND	PAx.AddressId = PACx.AddressId
								AND PACx.ContactCode = 'Mobile'
							INNER JOIN System.dbo.Ref_Address ADx
								ON PACx.AddressId = ADx.AddressId
								AND ADx.AddressScope IN ('Profile','Employee')
					WHERE	PAx.PersonNo = A.PersonNo
					ORDER BY PACx.Created DESC
				) as ContactCellular,
				O.OrgUnitCode,
				O.MandateNo,
				O.ParentOrgUnit,
				(
					SELECT 	OrgUnitNameShort
					FROM	Organization.dbo.Organization
					WHERE	OrgUnitCode = O.ParentOrgUnit
					AND		Mission = O.Mission
					AND		MandateNo = O.MandateNo
				) as ParentOrgUnitNameShort,
				'' as ManagerPersonNo,
				'' as ManagerName,
				ISNULL((
					SELECT	COUNT(STx.Topic)
					FROM	Applicant.dbo.ApplicantSubmissionTopic STx
							INNER JOIN Applicant.dbo.ApplicantSubmission Sx
								ON STx.ApplicantNo = Sx.ApplicantNo
							INNER JOIN Applicant.dbo.Applicant Ax
								ON Sx.PersonNo = Ax.PersonNo
							INNER JOIN Applicant.dbo.Ref_Topic Tx
								ON STx.Topic = Tx.Topic
							INNER JOIN Applicant.dbo.Ref_TopicClass TCx
								ON Tx.TopicClass = TCx.TopicClass
					WHERE	Ax.EmployeeNo = A.PersonNo
					AND		Tx.Parent = 'DPASK1'
					AND		Tx.Operational = 1
					AND		LTRIM(RTRIM(STx.TopicValue)) <> ''
					AND		LTRIM(RTRIM(STx.TopicValue)) <> 'No'
				), 0) as HasSkills
		FROM	vwAssignment A
				INNER JOIN Person Pe
					ON A.PersonNo = Pe.PersonNo
				INNER JOIN Position P
					ON A.PositionNo = P.PositionNo
				INNER JOIN Organization.dbo.Organization O
					ON A.OrgUnit#trim(url.orgunittype)# = O.OrgUnit
				LEFT OUTER JOIN System.dbo.Ref_Nation N
					ON A.Nationality = N.Code
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
				LEFT OUTER JOIN Location L
					ON A.LocationCode = L.LocationCode
		WHERE	A.MissionOperational = '#url.mission#'
		AND		A.PersonNo = '#url.personno#'
		AND		A.DateEffective <= '#url.referencedate#'
		AND		A.DateExpiration >= '#url.referencedate#'
		AND		A.AssignmentStatus IN ('0', '1')
		AND		A.Incumbency > 0
		AND 	A.Operational = 1  
</cfquery>

<cfquery name="getUser" 
	datasource="AppsSystem">	
		SELECT TOP 1 *
		FROM 	UserNames
		WHERE	PersonNo = '#url.personno#'
		AND		Disabled = '0'
		ORDER BY Created DESC
</cfquery>

<cfquery name="getConfiguration" 
	datasource="AppsSystem">
		SELECT 	UMC.*
		FROM   	UserModule UM
				INNER JOIN UserModuleCondition UMC
					ON UM.Account = UMC.Account
					AND UM.SystemFunctionId = UMC.SystemFunctionId
		WHERE 	UM.SystemFunctionId = '#url.configsystemfunctionid#'
		AND		UM.Account = '#getUser.account#'
		AND		UMC.ConditionValue = '1'
</cfquery>

<cfset vAuthorizedElements = "">
<cfoutput query="getConfiguration">
	<cfset vAuthorizedElements = vAuthorizedElements & ",[#ConditionClass#]">
</cfoutput>

<cfif trim(vAuthorizedElements) eq "">
	<cfset vAuthorizedElements = url.showAllTopics>
</cfif>

<cfset vPStyle = "padding-top:0px; font-size:14px;">
<cfset vIconStyle = "font-size:125%; width:45px; text-align:center;">
<cf_tl id="Manager" var="vManagerLbl">
<cf_tl id="Mr." var="vMrLbl">
<cf_tl id="Mrs." var="vMrsLbl">
<cf_tl id="Ms." var="vMsLbl">

<cf_tl id="IndexNo and Full Name" var="lblIndexNo">
<cf_tl id="Organization Unit" var="lblOrgUnit">
<cf_tl id="Organization Start" var="lblOrganizationStart">
<cf_tl id="Gender" var="lblGender">
<cf_tl id="Age" var="lblAge">
<cf_tl id="Nationality" var="lblNationality">
<cf_tl id="years" var="lblYears">

<cf_tl id="Location" var="lblLocation">
<cf_tl id="Office Address" var="lblOffice">
<cf_tl id="Email" var="lblEmail">
<cf_tl id="Office Phone" var="lblExtension">
<cf_tl id="Cell Phone" var="lblCellular">

<cfinclude template="validateLoggedUser.cfm">

<cfoutput query="getDetailPerson">

	<div class="row clsPersonDetailsList" style="padding-bottom:10px;">
		<div class="col-lg-6 col-md-6 col-sm-6 animated-panel zoomIn">
			<cfif trim(IndexNo) neq "">
				<p style="#vPStyle#" title="#lcase(lblIndexNo)#">
					<i class="fa fa-info-circle" style="#vIconStyle#"></i>[#ucase(IndexNo)#] #Fullname#
				</p>
			</cfif>
			<cfif trim(OrgUnitName) neq "">
				<p style="#vPStyle#" title="#lcase(lblOrgUnit)#">
					<i class="fa fa-sitemap" style="#vIconStyle#"></i>
					<span style="font-size:12px;font-weight:400;text-transform:capitalize;">
						<cfset OrgParent = ParentOrgUnit>
						<cfif OrgParent neq "">
							<cfset OrgList = "'#OrgUnitCode#','#OrgParent#'">
						<cfelse>
							<cfset OrgList = "'#OrgUnitCode#'"> 
						</cfif>  

						<cfloop condition = "OrgParent neq ''">
							 <cfquery name="getParent" 
					           datasource="AppsOrganization">
						           SELECT 	* 
						           FROM   	Organization
						           WHERE  	OrgUnitCode = '#OrgParent#'
							       AND  	Mission     = '#url.Mission#'
							       AND  	MandateNo   = '#MandateNo#'
						     </cfquery>     
						     <cfif getParent.ParentOrgUnit neq "">
						      	<cfset OrgList = "#OrgList#,'#getParent.ParentOrgUnit#'">      
						     </cfif>  
						     <cfset OrgParent = getParent.ParentOrgUnit>
						</cfloop>

						<cfquery name="getUnits" 
							datasource="AppsOrganization">
								SELECT   * 
								FROM     Organization
								WHERE    Mission     = '#url.Mission#'
								AND      MandateNo   = '#MandateNo#'
								AND      OrgUnitCode IN (#preservesinglequotes(OrgList)#)
								ORDER BY HierarchyCode
						</cfquery>
						
						<cfset vCntOrgs = 0>
						<cfset vLeftSpace = 0>
						<cfset vOrgStyle = "">
						<cfloop query="getUnits">
							<cfif vCntOrgs gt 0>
								<cfset vLeftSpace = 50 + (12*vCntOrgs)>
							</cfif>
							<cfset vOrgStyle = "">
							<cfif vCntOrgs neq getUnits.recordCount - 1>
								<cfset vOrgStyle = "color:##919191;">
							</cfif>
							<span style="padding-left:#vLeftSpace#px; #vOrgStyle#">
								#lcase(OrgUnitName)# <cfif trim(OrgUnitNameShort) neq "">(#ucase(OrgUnitNameShort)#)</cfif>
							</span><br>
							<cfset vCntOrgs = vCntOrgs + 1>
						</cfloop>
					</span>
				</p>
			</cfif>
			<cfif trim(OrganizationStart) neq "">
				<p style="#vPStyle#" title="#lcase(lblOrganizationStart)#">
					<i class="fa fa-history" style="#vIconStyle#"></i>#DateFormat(OrganizationStart, client.DateFormatShow)#
				</p>
			</cfif>
			<cfif trim(ManagerPersonNo) neq "" and trim(ManagerPersonNo) neq PersonNo>
				<p style="#vPStyle#" title="#lcase(vManagerLbl)#">
					<i class="fa fa-sort-amount-asc clsRotate-180" style="#vIconStyle#"></i><span style="text-transform:capitalize;">#lcase(ManagerName)#</span>
				</p>
			</cfif>
			<cfif trim(gender) neq "">
				<p style="#vPStyle#" title="#lcase(lblGender)#">
					<cfset vGenIcon = "fa-male"> 
					<cf_tl id="Male" var="1">
					<cfif gender eq "f">
						<cfset vGenIcon = "fa-female"> 
						<cf_tl id="Female" var="1">
					</cfif>
					<i class="fa #vGenIcon#" style="#vIconStyle#"></i>#lt_text#
				</p>
			</cfif>
			<cfif trim(Birthdate) neq "">
				<p style="#vPStyle#" title="#lcase(lblAge)#">
					<i class="fa fa-birthday-cake" style="#vIconStyle#"></i>#lsDateFormat(Birthdate, client.DateFormatShow)# (#INT(dateDiff('m', Birthdate, now())/12.0)# #lblYears#)
				</p>
			</cfif>
			<cfif trim(NationalityDescription) neq "" and (FindNoCase('NAT',vAuthorizedElements) neq 0 OR vAuthorizedElements eq 'SHOWALL')>
				<p style="#vPStyle#" title="#lcase(lblNationality)#">
					<i class="fa fa-flag" style="#vIconStyle#"></i>#NationalityDescription#
				</p>
			</cfif>
		</div>
		<div class="col-lg-6 col-md-6 col-sm-6 animated-panel zoomIn">
			<cfif trim(LocationCode) neq "" and (FindNoCase('LOC',vAuthorizedElements) neq 0 OR vAuthorizedElements eq 'SHOWALL')>
				<p style="#vPStyle#" title="#lcase(lblLocation)#">
					<i class="fa fa-map-marker" style="#vIconStyle#"></i>#LocationName#
				</p>
			</cfif>
			<cfif trim(AddressRoom) neq "" OR trim(BuildingName) neq "" OR trim(AddressCity) neq "" OR trim(Country) neq "">
				<p style="#vPStyle#" title="#lcase(lblOffice)#">
					<i class="fa fa-building" style="#vIconStyle#"></i><cfif AddressId neq "">#AddressRoom#<cfif BuildingName neq "">, </cfif>#BuildingName#. #AddressCity#<cfif Country neq "">, </cfif>#Country#.</cfif>
				</p>
			</cfif>
			<cfif trim(ContactEmailAddress) neq "">
				<p style="#vPStyle#" title="#lcase(lblEmail)#">
					<i class="fa fa-envelope" style="#vIconStyle#"></i>#ContactEmailAddress#
				</p>
			</cfif>
			<cfif trim(ContactTelephoneNo) neq "">
				<p style="#vPStyle#" title="#lcase(lblExtension)#">
					<cfset vHighlightExtension = 0>
					<cfset vTelephone = trim(ContactTelephoneNo)>
					<cfinclude template="formatPhoneNumber.cfm">
					<i class="fa fa-phone-square" style="#vIconStyle#"></i><cfif vTelephone neq "">#vFormattedTelephone#</cfif>
				</p>
			</cfif>
			<cfif trim(ContactCellular) neq "" and (FindNoCase('CPH',vAuthorizedElements) neq 0 OR vAuthorizedElements eq 'SHOWALL')>
				<p style="#vPStyle#" title="#lcase(lblCellular)#">
					<cfset vHighlightExtension = 0>
					<cfset vTelephone = trim(ContactCellular)>
					<cfinclude template="formatPhoneNumber.cfm">
					<i class="fa fa-mobile" style="#vIconStyle#"></i><cfif trim(ContactCellular) neq "">#vFormattedTelephone#</cfif>
				</p>
			</cfif>
		</div>
	</div>
	
	<div class="row clsPersonDetailSections">
		<cfif trim(ProfileText) neq "" OR (isUserLoggedIn and vAllowEdit)>
			<cfset vColClass = "col-lg-12">
			<cfif HasSkills eq 0>
				<cfset vColClass = "col-lg-12">
			</cfif>
			<div class="#vColClass#">
				<cf_mobilePanel 
					bodyStyle="background-color:##F4F3EE;">
						<cf_tl id="About" var="1">
	                <img src="#session.root#/Images/About.png" style="height: 40px;width: 40px;float: left;margin-right:10px;">
	                    <h3 class="m-xs text-success" style="color:##005B9A; padding:1px 0 0 0;">
							#ucase(lt_text)# <cfif gender eq "m">#ucase(vMrLbl)#<cfelse>#ucase(vMsLbl)#</cfif> #ucase(lastName)#
							<cfif isUserLoggedIn and vAllowEdit and url.personno eq client.personno>
								<cf_tl id="Edit" var="1">
								<i class="fa fa-pencil text-info clsNoPrint" style="font-size:18px;color:##333333;padding-left:10px; cursor:pointer;" title="#lt_text#" onclick="editElement('#personNo#','profile');"></i>
							</cfif>
						</h3>
						<br>
	                    <div style="font-size:14px;text-align:left;">
							<span style="text-transform: capitalize;">#lcase(firstName)# #lcase(lastName)#</span> <cf_tl id="serves as"> #functionDescription# <cf_tl id="in the"> #orgUnitName# <cf_tl id="of"> #url.mission#.<br/><br/>
							<cfif gender eq 'm'><cf_tl id="His"><cfelse><cf_tl id="Her"></cfif> <cf_tl id="functions are">:<br/> #ProfileText#
						</div>
				</cf_mobilePanel>
			</div>
		</cfif>
		<cfif HasSkills gt 0>
			<cfset vColClass = "col-lg-12">
			<cfif trim(ProfileText) eq "">
				<cfset vColClass = "col-lg-12">
			</cfif>
			<div class="#vColClass#">
				<cf_mobilePanel
					bodyStyle="background-color:##F4F3EE;">
						<cf_tl id="Political Affairs Skills" var="1">
	                	<i class="pe-7s-medal pull-left" style="font-size:500%; padding-right:10px;"></i>
	                    <h3 class="m-xs text-success" style="color:##005B9A; padding-top:10px;">
							#ucase(lt_text)#
							<cfif isUserLoggedIn and vAllowEdit and url.personno eq client.personno>
								<cf_tl id="Edit" var="1">
								<i class="fa fa-pencil-square text-info clsNoPrint" style="font-size:24px; padding-left:10px; cursor:pointer;" title="#lt_text#" onclick="editElement('#personNo#','skills');"></i>
							</cfif>
						</h3>
						<br>
	                    <div>
							<cfdiv id="divSkills_#personno#" style="font-size:130%; text-align:left; width:100%;" bind="url:#session.root#/system/organization/orgTree/getpersonSkills.cfm?personNo=#personNo#">
						</div>
				</cf_mobilePanel>
			</div>
		</cfif>
	</div>

	<div class="row clsPersonDetailSections">
		<cfif FindNoCase('EDU',vAuthorizedElements) neq 0 OR vAuthorizedElements eq 'SHOWALL'>
			<cfset isComplementAuthorized = 0>
			<cfif FindNoCase('EXP',vAuthorizedElements) neq 0 OR vAuthorizedElements eq 'SHOWALL'>
				<cfset isComplementAuthorized = 1>
			</cfif>
			<cfdiv id="divAcademics_#personno#" bind="url:#session.root#/system/organization/orgTree/getpersonBackground.cfm?personNo=#personNo#&categories='School','University'&categoriesValidation='Employment'&title=Academics&icon=pe-7s-study&isComplementAuthorized=#isComplementAuthorized#">
		</cfif>
		<cfif FindNoCase('EXP',vAuthorizedElements) neq 0 OR vAuthorizedElements eq 'SHOWALL'>
			<cfset isComplementAuthorized = 0>
			<cfif FindNoCase('EDU',vAuthorizedElements) neq 0 OR vAuthorizedElements eq 'SHOWALL'>
				<cfset isComplementAuthorized = 1>
			</cfif>
			<cfdiv id="divExperience_#personno#" bind="url:#session.root#/system/organization/orgTree/getpersonBackground.cfm?personNo=#personNo#&categories='Employment'&categoriesValidation='School','University'&title=Experience&icon=pe-7s-portfolio&isComplementAuthorized=#isComplementAuthorized#">
		</cfif>
	</div>

</cfoutput>