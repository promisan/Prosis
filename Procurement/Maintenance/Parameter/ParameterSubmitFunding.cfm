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

<cfparam name="Form.DefaultPeriod" default="">

<cfparam name="Form.FundingClearPurchase" default="0">
<cfparam name="Form.FundingCheckCleared" default="0">
<cfparam name="Form.FundingCheckTolerance" default="0">
<cfparam name="Form.ObjectUsage" default="Standard">
<cfparam name="Form.FundingCheckPointer" default="0">
<cfparam name="Form.FundingOnProgram" default="1">
<cfparam name="Form.FundingDetail" default="0">
<cfparam name="Form.FundingClearRollup" default="0">
<cfparam name="Form.FundingClearTransaction" default="0">
<cfparam name="Form.FundingClearResource" default="0">

<cfif Form.FundingCheckTolerance eq "">
   <cfset Form.FundingCheckTolerance = "0">
</cfif>   

<cfquery name="Update" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	UPDATE Ref_ParameterMission
		SET DefaultPeriod            = '#Form.DefaultPeriod#',
			FundingByReviewer        = '#Form.FundingByReviewer#',
			EnforceProgramBudget     = '#Form.EnforceProgramBudget#',
			FundingDetail            = '#Form.FundingDetail#',
			FundingOnProgram         = '#Form.FundingOnProgram#',
			EnableFundingCheck       = '#Form.EnableFundingCheck#',
			FundingCheckCleared      = '#Form.FundingCheckCleared#',
			FundingCheckTolerance    = '#Form.FundingCheckTolerance#',
			FundingClearTransaction  = '#Form.FundingClearTransaction#',
			FundingClearRollup       = '#Form.FundingClearRollup#',
			FundingClearResource     = '#Form.FundingClearResource#',
			FundingCheckPointer      = '#Form.FundingCheckPointer#',
			ObjectUsage              = '#Form.ObjectUsage#',
			FilterItemMaster         = '#Form.FilterItemMaster#',
			EnableEMail              = '#Form.EnableEMail#',
			EnforceObject            = '#Form.EnforceObject#',
			OfficerUserId 	 = '#SESSION.ACC#',
			OfficerLastName  = '#SESSION.LAST#',
			OfficerFirstName = '#SESSION.FIRST#',
			Created          =  getdate()								
	WHERE Mission              = '#url.Mission#'
</cfquery>

<!--- apply to all entries of that mission --->

<cfquery name="Class" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   Ref_ParameterMissionEntryClass R, 
		       Ref_EntryClass C
		WHERE  Mission    = '#URL.Mission#'		
		AND    Period     = '#Form.DefaultPeriod#'						
		AND    R.EntryClass = C.Code 		
</cfquery>

<cfloop query="Class">

    <cfparam name="Form.ItemMasterObjectExtend_#entryclass#" default="0">
		
	<cfset val = evaluate("Form.ItemMasterObjectExtend_#entryclass#")>
				
		<cfquery name="Update" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    UPDATE  Ref_ParameterMissionEntryClass 
			SET     ItemMasterObjectExtend = #val#,
					OfficerUserId 	 = '#SESSION.ACC#',
					OfficerLastName  = '#SESSION.LAST#',
					OfficerFirstName = '#SESSION.FIRST#',
					Created          =  getdate()
			WHERE   Mission               = '#url.Mission#'
			AND     EntryClass            = '#EntryClass#'
		</cfquery>
		
				
</cfloop>

<!--- apply to all entries of that mission --->

<cfquery name="FundingPeriod" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT DISTINCT Period
		FROM Ref_ParameterMissionEntryClass	
		WHERE Mission = '#url.mission#'
</cfquery>

<cfloop query="FundingPeriod">

    <cfparam name="Form.b#currentrow#DisabledFundingCheck" default="0">
		
	<cfset val = evaluate("Form.b#currentrow#DisabledFundingCheck")>
	
	<cfquery name="Update" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    UPDATE  Ref_ParameterMissionEntryClass 
		SET     DisableFundingCheck = '#val#',
				OfficerUserId 	 = '#SESSION.ACC#',
				OfficerLastName  = '#SESSION.LAST#',
				OfficerFirstName = '#SESSION.FIRST#',
				Created          =  getdate()		 		
		WHERE   Mission               = '#url.Mission#'
		AND     Period                = '#period#'
	</cfquery>
	
</cfloop>

<cfinclude template="ParameterEditFunding.cfm">

	
