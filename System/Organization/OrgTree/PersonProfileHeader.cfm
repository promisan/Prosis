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
<cfparam name="url.allowEdit" 				default="0">
<cfparam name="url.showAllTopics"			default="0">
<cfparam name="url.referenceDate" 			default="#dateformat(now(), 'yyyy-mm-dd')#">
<cfparam name="url.configsystemfunctionid" 	default="#url.systemfunctionid#">

<cfset vAllowEdit = false>
<cfif trim(url.allowEdit) eq "1">
	<cfset vAllowEdit = true>
</cfif>

<cfquery name="getPerson" 
	datasource="AppsEmployee">
	
		SELECT	*,
		
				ISNULL((
					SELECT TOP 1 Account
					FROM	System.dbo.UserNames
					WHERE	PersonNo = A.PersonNo
					AND		Disabled = '0'
					ORDER BY Created DESC
				), '') AS UserAccount,
				
				ISNULL((
					SELECT TOP 1 PAC.ContactURL
					FROM	PersonAddress PA
							INNER JOIN PersonAddressContact PAC
								ON PA.PersonNo = PAC.PersonNo
								AND	PA.AddressId = PAC.AddressId
								AND PAC.ContactCode = 'facebook'
							INNER JOIN System.dbo.Ref_Address AD
								ON PAC.AddressId = AD.AddressId
								AND AD.AddressScope IN ('Profile','Employee')
					WHERE	PA.PersonNo = '#url.personno#'
					ORDER BY PAC.Created DESC
				), '') as FacebookLink,
				
				ISNULL((
					SELECT TOP 1 PAC.ContactURL
					FROM	PersonAddress PA
							INNER JOIN PersonAddressContact PAC
								ON PA.PersonNo = PAC.PersonNo
								AND	PA.AddressId = PAC.AddressId
								AND PAC.ContactCode = 'twitter'
							INNER JOIN System.dbo.Ref_Address AD
								ON PAC.AddressId = AD.AddressId
								AND AD.AddressScope IN ('Profile','Employee')
					WHERE	PA.PersonNo = '#url.personno#'
					ORDER BY PAC.Created DESC
				), '') as TwitterLink,
				
				ISNULL((
					SELECT TOP 1 PAC.ContactURL
					FROM	PersonAddress PA
							INNER JOIN PersonAddressContact PAC
								ON PA.PersonNo = PAC.PersonNo
								AND	PA.AddressId = PAC.AddressId
								AND PAC.ContactCode = 'linkedin'
							INNER JOIN System.dbo.Ref_Address AD
								ON PAC.AddressId = AD.AddressId
								AND AD.AddressScope IN ('Profile','Employee')
					WHERE	PA.PersonNo = '#url.personno#'
					ORDER BY PAC.Created DESC
				), '') as LinkedinLink,
				
				ISNULL((
					SELECT	TOP 1 PC.ContractLevel
					FROM	PersonContract PC							
					WHERE	PC.PersonNo = '#url.personno#'
					AND     (PC.Mission = '#URL.Mission#' or PC.Mission = 'UNDEF')
					AND     PC.ActionStatus = '1'										
					ORDER BY DateExpiration DESC
				), '') as ContractLevel				
				
		FROM	vwAssignment A
		WHERE	PersonNo           = '#url.personNo#'
		AND		MissionOperational = '#url.mission#'
		AND		DateEffective     <= '#url.referencedate#'
		AND		DateExpiration    >= '#url.referencedate#'
		AND		AssignmentStatus IN ('0', '1')
		-- AND		Incumbency        > 0
		AND 	Operational       = 1
		ORDER BY Incumbency DESC
</cfquery>

<cfquery name="getContract" 
	datasource="AppsEmployee">	
		SELECT   TOP 1 *
		FROM 	 PersonContract
		WHERE	 PersonNo = '#url.personno#'
		AND      Mission = '#URL.Mission#'
		AND      ActionStatus = '1'
		ORDER BY DateEffective DESC		
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

<cf_tl id="Open LinkedIn profile" var="GotoLinkedinLink">
<cf_tl id="Open Twitter profile" var="GotoTwitterLink">
<cf_tl id="Open Facebook profile" var="GotoFacebookLink">

<cfinclude template="validateLoggedUser.cfm">

<cfoutput>

	<div class="media social-profile clearfix">
	    
		<a class="pull-left" style="padding-right:18px;" href="javascript:enlargeProfilePicture('.profilePicture_#personNo#');">
					
			<cf_getProfilePicture 
			    IndexNo      = "#getPerson.IndexNo#" 
				UserAccount  = "#getPerson.useraccount#" 
				Gender       = "#getPerson.Gender#"
				Class        = "clsEnableTransition profilePicture_#personNo#"
				style        = "height:120px; width:120px; border:3px solid ##aaaaaa;">

	    </a>
		
	    <div class="media-body">
	        <h1 style="font-weight:400; color:##333333;font-size:32px;letter-spacing:1px;margin-bottom:4px;">#ucase(getPerson.FirstName)# #ucase(getPerson.LastName)#</h1>
	        <cfif isUserLoggedIn and vAllowEdit and url.personno eq client.personno>
				<cf_tl id="set/change my signature" var="1">
				<div 
					title="#lt_text#" 
					style="font-weight:400; cursor:pointer; color:##265F8E; font-size:10px; padding-bottom:3px;" 
					onclick="event.preventDefault(); if (parent.showOptions) { parent.showOptions(); }">
						[#trim(lt_text)#]
				</div>
			</cfif>
			<h4 style="color:##265F8E; margin-top:4px;font-size:16px;text-transform:uppercase;">
			<cfif getContract.ContractFunctionDescription neq "">#getContract.ContractFunctionDescription#<cfelse>#getPerson.FunctionDescription#</cfif>
			
			<cfif trim(getPerson.ContractLevel) neq "" and (FindNoCase('GRD',vAuthorizedElements) neq 0 OR vAuthorizedElements eq 'SHOWALL')>(#getPerson.ContractLevel#)</cfif> [<cfif getPerson.SourcePostNumber neq "">#getPerson.SourcePostNumber#<cfelse>#getPerson.PositionParentId#</cfif>]</h4>
			<h4 style="margin-left:-10px;">
			
				<cfif FindNoCase('LKD',vAuthorizedElements) neq 0 OR vAuthorizedElements eq 'SHOWALL'>
				
					<cfset vLink = "javascript:">
					<cfset vOptions = "">
					<cfif trim(getPerson.LinkedinLink) neq "">
						<cfset vLink = trim(getPerson.LinkedinLink)>
						<cfset vOptions = "target='_blank' title='#GotoLinkedinLink#'">
					</cfif>
					<a href="#vLink#" style="color:##8C8984;" #vOptions#>
						<i class="fab fa-linkedin-square" style="padding-left:10px;"></i>
					</a>
					<cfif isUserLoggedIn and vAllowEdit and url.personno eq client.personno>
						<cf_tl id="Edit" var="1">
						<i class="fa fa-pencil text-info clsNoPrint" style="font-size:85%; padding-left:10px; cursor:pointer;" title="#lt_text#" onclick="editElement('#personNo#','linkedin');"></i>
					</cfif>
					
				</cfif>	
				
				<cfif FindNoCase('TWT',vAuthorizedElements) neq 0 OR vAuthorizedElements eq 'SHOWALL'>
				
					<cfset vLink = "javascript:">
					<cfset vOptions = "">
					<cfif trim(getPerson.TwitterLink) neq "">
						<cfset vLink = trim(getPerson.TwitterLink)>
						<cfset vOptions = "target='_blank' title='#GotoTwitterLink#'">
					</cfif>
					<a href="#vLink#" style="color:##8C8984;" #vOptions#>
						<i class="fab fa-twitter-square" style="padding-left:10px;"></i>
					</a>
					<cfif isUserLoggedIn and vAllowEdit and url.personno eq client.personno>
						<cf_tl id="Edit" var="1">
						<i class="fa fa-pencil text-info clsNoPrint" style="font-size:85%; padding-left:10px; cursor:pointer;" title="#lt_text#" onclick="editElement('#personNo#','twitter');"></i>
					</cfif>
					
				</cfif>
				
				<cfif FindNoCase('FCB',vAuthorizedElements) neq 0 OR vAuthorizedElements eq 'SHOWALL'>
				
					<cfset vLink = "javascript:">
					<cfset vOptions = "">
					<cfif trim(getPerson.FacebookLink) neq "">
						<cfset vLink = trim(getPerson.FacebookLink)>
						<cfset vOptions = "target='_blank' title='#GotoFacebookLink#'">
					</cfif>
					<a href="#vLink#" style="color:##8C8984;" #vOptions#>
						<i class="fab fa-facebook-square" style="padding-left:10px;"></i>
					</a>
					<cfif isUserLoggedIn and vAllowEdit and url.personno eq client.personno>
						<cf_tl id="Edit" var="1">
						<i class="fa fa-pencil text-info clsNoPrint" style="font-size:85%; padding-left:10px; cursor:pointer;" title="#lt_text#" onclick="editElement('#personNo#','facebook');"></i>
					</cfif>
					
				</cfif>
			</h4>
	    </div>
	</div>
</cfoutput>

<cfset AjaxOnLoad("function(){ $('.clsOpenStaffingProfile').off('click').on('click', function(){ showPerson('#url.personno#'); }) }")>