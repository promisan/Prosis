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
<cfparam name="URL.Layout" default="Program">

<!--- headers and necessary Params for expand/contract --->
<cfparam name="URL.Verbose" default="#CLIENT.Verbose#">
<cfset CLIENT.Verbose = #URL.Verbose#>
<cfset Caller = "Verify.cfm?ProgramCode=#URL.ProgramCode#&Period=#URL.Period#&Layout=#URL.Layout#">

<cfif URL.Layout eq 'Program'>
	<cfinclude template="ProgramViewHeader.cfm">
<cfelse>
	<cfinclude template="ComponentViewHeader.cfm">
</cfif>

<cfquery name="ThisProgram"
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT ParentCode
    FROM Program
    WHERE ProgramCode ='#URL.ProgramCode#'
</cfquery>

<cfquery name="Parent" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT ProgramCode, ProgramClass, ParentCode
    FROM Program
    WHERE ProgramCode = '#ThisProgram.ParentCode#'
</cfquery>

<!--- Verify Category --->
<cfquery name="Category"
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT ProgramCode
    FROM ProgramCategory
    WHERE ProgramCode ='#URL.ProgramCode#'
</cfquery>

<cfset HasCategory = #Category.RecordCount#>

<!--- Verify Resources --->
<cfquery name="Resource"
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT ProgramCode
    FROM   ProgramResource
    WHERE  ProgramCode ='#URL.ProgramCode#'
	AND    Period='#URL.Period#'
	AND    RecordStatus != 9
</cfquery>

<cfset HasResource = #Resource.RecordCount#>

<!--- Verify Funding --->
<cfquery name="Funding"
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT ProgramCode
    FROM ProgramAllotment
    WHERE ProgramCode ='#URL.ProgramCode#'
	AND Period='#URL.Period#'
</cfquery>

<cfset HasFunding = #Funding.RecordCount#>

<!--- verify components only for programs and first level components --->
<cfif #Parent.RecordCount# eq 0 OR (#Parent.RecordCount# eq 1 AND #Parent.ProgramClass# eq 'Program')>

<!--- Verify Component --->
	<cfquery name="Component"
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT P.ProgramCode	
	    FROM Program P Inner Join ProgramPeriod Pe
	    ON P.ProgramCode = Pe.ProgramCode 
		WHERE Pe.Period = '#URL.Period#' 
		AND Pe.RecordStatus != 9
		AND P.ParentCode ='#URL.ProgramCode#'
	</cfquery>

	<cfset HasComponent = #Component.RecordCount#>

<cfelse>

	<cfset HasComponent = 0>

</cfif>

<!--- rest only apply to components and subcomponents --->

<cfset HasActivity = 0>
<cfset HasTarget = 0>

<cfif #Parent.RecordCount# eq 1 >

<!--- Verify Component --->
	<cfquery name="Activity"
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT ProgramCode	
	    FROM ProgramActivity 
	    WHERE ProgramCode ='#URL.ProgramCode#'
		AND ActivityPeriod='#URL.Period#'
		AND RecordStatus != 9
	</cfquery>

	<cfset HasActivity = #Activity.RecordCount#>
	
<!--- Verify Target --->
	<cfquery name="Target"
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT ProgramCode	
	    FROM ProgramTarget
	    WHERE ProgramCode ='#URL.ProgramCode#'
		AND Period='#URL.Period#'
		AND RecordStatus != 9
	</cfquery>

	<cfset HasTarget = #Target.RecordCount#>
	
</cfif>


<table width=60% border="1" cellspacing="0" cellpadding="0" align="center" bordercolor="#002350">

 <tr bgcolor="#002350">
    <td height="24" class="BannerXLN">
	  <b>&nbsp;Verify Program Elements</b>
	</td>
 </tr> 	
   
  <tr><td colspan="2">

<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" bordercolor="6688AA" bgcolor="F6F6F6">

<TR Class="BannerXLN">
    <td width="20%" class="top">&nbsp;</td>
    <TD width="25%"  class="top">Item</TD>
    <TD width="20%"  class="top" align="center">Elements Exist</TD>
	<TD width="20%"  class="top">&nbsp;</TD>
</TR>

<tr><td height=2></td></tr>

<cfoutput>
<!--- Category --->
<TR>
    <td></td>
    <TD class="regular">
	<a href="Category/GroupView.cfm?ProgramCode=#URL.ProgramCode#&Period=#URL.Period#&Layout=#URL.Layout#">
	<cf_tl id="Categorization"></A>
	</TD>
    <TD class="regular" align="center"><cfif #HasCategory# gt 0> <cf_tl id="YES"> <cfelse> <cf_tl id="NO"> </cfif></TD>
</TR>

<tr><td height=2></td></tr>

<!--- Resource --->
<TR>
    <td></td>
    <TD class="regular">
	<a href="Resource/ResourceView.cfm?ProgramCode=#URL.ProgramCode#&Period=#URL.Period#&Layout=#URL.Layout#">
	Resources</A>
	</TD>
    <TD class="regular" align="center"><cfif #HasResource# gt 0>YES<cfelse>NO</cfif></TD>
</TR>

<tr><td height=2></td></tr>

<!--- Funding --->
<TR>
    <td></td>
    <TD class="regular">
	<a href="Funding/FundingView.cfm?ProgramCode=#URL.ProgramCode#&Period=#URL.Period#&Layout=#URL.Layout#">
	Project Funding</A>
	</TD>
    <TD class="regular" align="center"><cfif #HasFunding# gt 0>YES<cfelse>NO</cfif></TD>
</TR>

<!---  components only for programs and first level components --->
<cfif #Parent.RecordCount# eq 0 OR (#Parent.RecordCount# eq 1 AND #Parent.ProgramClass# eq 'Program')>
<!--- Components --->
<TR>
    <td></td>
    <TD class="regular">
	<a href="ProgramViewTop.cfm?ProgramCode=#URL.ProgramCode#&Period=#URL.Period#&Layout=#URL.Layout#">
	Components</A>
	</TD>
    <TD class="regular" align="center"><cfif #HasComponent# gt 0>YES<cfelse>NO</cfif></TD>
</TR>

<tr><td height=2></td></tr>

</cfif>

<!--- Rest only for components --->
<cfif Parent.RecordCount eq 1 >

<!--- Activities --->
<TR>
    <td></td>
    <TD class="regular">
	<a href="Activity/ActivityView.cfm?ProgramCode=#URL.ProgramCode#&Period=#URL.Period#&Layout=#URL.Layout#">
	Activities</A>
	</TD>
    <TD class="regular" align="center"><cfif HasActivity gt 0>YES<cfelse>NO</cfif></TD>
</TR>

<tr><td height=2></td></tr>

<!--- Target --->
<TR>
    <td></td>
    <TD class="regular">
	<a href="Target/TargetView.cfm?ProgramCode=#URL.ProgramCode#&Period=#URL.Period#&Layout=#URL.Layout#">
	Outcomes and Indicators</A>
	</TD>
    <TD class="regular" align="center"><cfif HasTarget gt 0>YES<cfelse>NO</cfif></TD>
</TR>

<tr><td height=2></td></tr>

</cfif>

</cfoutput>

<tr><td height=2></td></tr>

<TR bgcolor="6688aa">
    <td height="5" colspan="5"></td>
</TR>
</table>

</td></tr>

</table>	
