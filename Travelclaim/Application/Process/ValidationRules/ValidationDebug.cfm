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
 <proDes>Template for validation Rule Debugging just an insert  </proDes>
 <proCom>New File For Validation Debugging not needed in production should also remove in validationrule.cfm</proCom>
</cfsilent>

 <!--- 
 		This File is mainly used for Debugging since it inserts 
		the required fields into a userquery.dbo with a Debug_mcp and a random rumber 
		
 --->
 
 <!---
 
 <cfquery name ="InsertDebugTable" datasource="appstravelclaim" username="#SESSION.login#" 
  password="#SESSION.dbpw#">
    <cfif #ValPap# eq ""		>
	 	<cfset Valpap ="NULL">
	</cfif>
	<cfif #ValFundStatus# eq ""		>
	 	<cfset ValFundStatus ="NULL">
	</cfif>
	<cfif #ValFundremamt# eq ""		>
	 	<cfset ValFundremamt =0>
	</cfif>
<cfset ValIndexno = #client.personNo#>
<cfset ValTvrqno =0>


	select '#ValFundstatus#' as fundstatus ,
       '#ValPap#' as pap,
	   '#ValClaimrequestid#' as ClaimRequestId,
	   '#ValUrlClaimid#' as UrlClaimId,
	   '#Valfundremamt#' as FundRemaining,
	   '#Valincomplete#' as Incomplete_flag,
	   '#Valexecutiontime#' as execution_time,
	   '#ValRefCode#' as RefCode,
	   '#ValTvrqno#' as TvrqNo,
	   '#ValIndexno#' as Indexno
	   into userquery.dbo.#ValTname# 
</cfquery>

--->