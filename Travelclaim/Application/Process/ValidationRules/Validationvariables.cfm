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
<cfsilent>
  <proUsr>Joseph George</proUsr>
  <proOwn>Joseph George</proOwn>
 <proDes>Template for validation Rule Validation Variables setup   </proDes>
 <proCom>File For Validation Variables setup is Required by all A validation  validationrule.cfm </proCom>
</cfsilent>
<cfobject action="create"
		type="java"
		class="coldfusion.server.ServiceFactory"
		name="factory">

<!---
<cfset dsService = factory.getDataSourceService()>
<cfset DataSources = dsService.getDatasources()>
<cfset DatabaseName = DataSources["appsTravelClaim"].URLMap.ConnectionProps.Database >
<cfset DatabaseServer = DataSources["appsTravelClaim"].URLMap.ConnectionProps.Host>
--->

<!--- This Cfm file just sets all the required variables that 
      Are going to be used by A01 => A02 etc which are being called from 
	  ValidationRule.cfm where it select from 
	  #DatabaseName#.Ref_Validation Table 
	  WHERE     (ValidationClass IN ('Rule1', 'Rule2')) 
--->

<cfset ValTname = 'Debug_mcp_'&RandRange(1,500)&RandRange(1,500)&RandRange(1,500)>
<cfset ValFundstatus = 'NULL'>
<cfset ValPap ='NULL'>
<cfset ValTolerance=0 >
<cfset ValClaimrequestid='#claim.claimRequestid#'>
<cfset ValUrlclaimid='#URL.claimid#'>
<cfset ValRefCode ='NULL'>
<cfset ValFundremamt =0>
<cfset Valincomplete = 0>
<cfset Valexecutiontime =0>
<cfset ValIndexno=0>
<cfset ValTvrqno=0>
<cfquery name="GetInformation" 
	datasource="appsTravelClaim" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
select ClaimTolerance , NonObligatedthreshold  from parameter 
</cfquery>

<cfset VariableTolerance=#GetInformation.ClaimTolerance#>
<cfset VariableNON_OBLIGATED_THRESHOLD=#GetInformation.Nonobligatedthreshold#>
