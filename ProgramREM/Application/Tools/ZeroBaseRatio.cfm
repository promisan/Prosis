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
<cfparam name="URL.ID" default="">

<cfquery name="AuditPeriod" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT    *
FROM      Ref_Period
WHERE Period = '#URL.ID#'
</cfquery>

<cfquery name="Audit" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT    *
FROM      Ref_Audit
WHERE     Period = '#URL.ID#'
ORDER BY AuditDate
</cfquery>

<cfquery name="AuditSub" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT    *
FROM      Ref_SubPeriod
</cfquery>

<cfset per = DateDiff("d", "#AuditPeriod.DateEffective#", "#AuditPeriod.DateExpiration#")+1>

<cfloop query="Audit">

	<cfquery name="Current" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT    *
	FROM      Ref_SubPeriod
	WHERE SubPeriod <= '#SubPeriod#'
	</cfquery>
	
	<cfset ela = DateDiff("d", "#AuditPeriod.DateEffective#", "#AuditDate#")+1>	
	<cfset sub = #AuditSub.recordcount# / #Current.recordcount#>
		
	<cfif #per# gt 0>
   		<cfset ratio = (#ela#)/(#per#)>
		<cfset ratio = #ratio#*#sub#>
	<cfelse> 
    	<cfset ratio = 1>
	</cfif>	
	
	<cfif ratio gt "0.97">
	  <cfset ratio = 1>
	</cfif>
		
	<cfquery name="Update" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		
	UPDATE Ref_Audit
	SET    ZeroBaseRatio = #ratio#, 
	       DaysIntoPeriod = #ela#
	WHERE  AuditId = '#AuditId#'
	</cfquery>
	
</cfloop>
