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

<!--- does not have to be changed usually --->
<cfparam name="url.Nationality" default="">
<cfparam name="url.OrgUnitOperational" default="">
<cfparam name="url.OfficerUserId" default="">
<cfparam name="url.Print" default="0">

<cfquery name="Audit" 
    datasource="AppsProgram" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
	SELECT * 
	FROM   Ref_Audit A , Ref_Period P
	WHERE  A.Period = P.Period
	AND AuditId = '#URL.AuditId#'
</cfquery>

<cfquery name="BaseLine" 
    datasource="AppsProgram" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
	SELECT TOP 1 * FROM Ref_Audit 
	WHERE Period IN (SELECT Period FROM Ref_Period WHERE PeriodClass = '#Audit.PeriodClass#')
	AND   Period <> '#Audit.Period#'
	AND   AuditDate < '#dateformat(Audit.AuditDate,client.dateSQL)#'
	ORDER BY AuditDate
</cfquery>

<cfquery name="Target" 
    datasource="AppsProgram" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
	SELECT   PI.Period, Org.OrgUnitCode
	FROM     ProgramIndicator PI INNER JOIN
             ProgramPeriod Pe ON PI.ProgramCode = Pe.ProgramCode AND PI.Period = Pe.Period INNER JOIN
             Organization.dbo.Organization Org ON Pe.OrgUnit = Org.OrgUnit
	WHERE    TargetId = '#URL.TargetId#'  
</cfquery>	

<!--- filter orgunit --->

<cfinvoke component="Service.Access"  
	   method="staffing" 
	   mission="#Target.OrgUnitCode#" 	  
	   returnvariable="accessStaffing">	
	   
<cfif accessStaffing eq "NONE" or getAdministrator("*") eq "1">
    <cfset orgfilter = "">
<cfelse>
    <cfset orgfilter = "AND OrgUnitOperational IN (SELECT OrgunitOperational FROM Organization.dbo.OrganizationAuthorization WHERE UserAccount = '#SESSION.acc#' and Role = 'HROfficer' and Mission = '#Target.OrgUnitCode#' AND OrgUnit is NULL)">
</cfif>	   

<cfquery name="Indicator" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT     *
	FROM  Ref_Indicator
	WHERE IndicatorCode = '#URL.Indicator#' 
</cfquery>


