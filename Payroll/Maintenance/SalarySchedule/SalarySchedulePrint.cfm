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
<cfoutput>

<cfset tReportPath = "Payroll/Maintenance/SalarySchedule/SalarySchedulePrint.cfr">

<cfquery name="getLogoInfo"
datasource="AppsInit" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM Parameter
	WHERE  HostName  = '#CGI.HTTP_HOST#'
</cfquery>

<cfset Session.LogoPath = getLogoInfo.LogoPath>
<cfset Session.LogoFileName = getLogoInfo.LogoFileName>

<script>
	  window.open("#SESSION.root#/Tools/Mail/MailPrepareOpen.cfm?id=print&ID1=#URL.scaleno#&ID0=#tReportPath#","_blank", "left=30, top=30, width=800, height=600, toolbar=no, menubar=no, status=yes, scrollbars=no, resizable=no")
</script>

</cfoutput>
