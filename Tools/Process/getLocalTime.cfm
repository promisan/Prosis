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
<cfparam name="attributes.Mission"     default="">
<cfparam name="attributes.Datasource"  default="AppsOrganization">
<cfparam name="Attributes.RecordDate"  default="#DateFormat(now(), CLIENT.DateFormatShow)#">
<cfparam name="Attributes.RecordTime"  default="#TimeFormat(now(), 'HH:MM')#">

<cfset dateValue = "">
<CF_DateConvert Value="#Attributes.RecordDate#">
<cfset dte = dateValue>

<cfset dte = DateAdd("h","#TimeFormat(Attributes.RecordTime, 'HH')#", dte)>
<cfset dte = DateAdd("n","#TimeFormat(Attributes.RecordTime, 'MM')#", dte)>

<cfquery name="Param"
    datasource="#attributes.datasource#" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
	SELECT * 
	FROM   System.dbo.Parameter 	
</cfquery>
	
<!--- database server timezone --->
	
<cfquery name="MissionZone"
    datasource="#attributes.datasource#" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
	SELECT   TOP 1 * 
	FROM     Organization.dbo.Ref_MissionTimeZone
	WHERE    Mission = '#attributes.Mission#'
	AND      DateEffective <= #dte# 
	ORDER BY DateEffective DESC 	
</cfquery>

<cfif MissionZone.recordcount eq "1">

	<!--- if server is in brindisi the time is 7 hours earlier --->
	<cfset correction = (Param.DatabaseServerTimeZone - MissionZone.TimeZone)*-1>	
	<cfset dte = DateAdd("h",correction,dte)>	
	<cfset caller.timezone  = "#MissionZone.TimeZone#:00">	
	
<cfelse>	

	<cfset caller.timezone  = "0:00">	
	<cfset correction = 0>
	
</cfif>		
	
<cfset caller.localtime = dte>
<cfset caller.correction = correction>