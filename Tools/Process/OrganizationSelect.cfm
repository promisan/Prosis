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

<cfparam name="Attributes.Mission"     default="-">
<cfparam name="Attributes.MandateNo"   default="-">
<cfparam name="Attributes.OrgUnitCode" default="-">
<cfparam name="Attributes.OrgUnit"     default="">
<cfparam name="Attributes.Enforce"     default="0">

<cfset nivnext = "0">

<cfif Attributes.OrgUnit eq "">

	<cfquery name="Check"
         datasource="AppsOrganization"       
         username="#SESSION.login#"
         password="#SESSION.dbpw#">
         SELECT    TOP 1 *
	     FROM      Organization
	     WHERE     Mission      = '#Attributes.Mission#'					  
	     AND       MandateNo    = '#Attributes.Mandate#'
	     AND       OrgUnitCode  = '#Attributes.OrgUnitCode#'  
	</cfquery>

<cfelse>

	<cfquery name="Check"
         datasource="AppsOrganization"       
         username="#SESSION.login#"
         password="#SESSION.dbpw#">
         SELECT    TOP 1 *
	     FROM      Organization
	     WHERE     OrgUnit  = #Attributes.OrgUnit#  
	</cfquery>

</cfif>

<CFSET Caller.OrgUnitSelect = check.orgunit>

<cfset niv = Len(Check.HierarchyCode)>

<cfswitch expression="#niv#">

  <!--- level 01 --->
  <cfcase value="2">
    <cfset No = Check.HierarchyCode+1>
	<cfif No lt 10>
     	<cfset nivNext = "0#No#">
	<cfelse>
	    <cfset nivNext = "#No#">
	</cfif>
  </cfcase>
  
  <!--- level 02 --->
  <cfcase value="5">
    <cfset No = Mid(Check.HierarchyCode, 4, 2)>
    <cfset No = No+1>
	<cfif No lt 10>
     	<cfset nivNext = "#Mid(Check.HierarchyCode, 1, 3)#0#No#">
	<cfelse>
	    <cfset nivNext = "#Mid(Check.HierarchyCode, 1, 3)##No#">
	</cfif>
  </cfcase>
  
  <!--- level 03 --->
  <cfcase value="8">
    <cfset No = Mid(Check.HierarchyCode, 7, 2)>
    <cfset No = No+1>
	<cfif No lt 10>
     	<cfset nivNext = "#Mid(Check.HierarchyCode, 1, 6)#0#No#">
	<cfelse>
	    <cfset nivNext = "#Mid(Check.HierarchyCode, 1, 6)##No#">
	</cfif>
  </cfcase>
  
  <!--- level 04 --->
  <cfcase value="11">
    <cfset No = Mid(Check.HierarchyCode, 10, 2)>
    <cfset No = No+1>
	<cfif No lt 10>
     	<cfset nivNext = "#Mid(Check.HierarchyCode, 1, 9)#0#No#">
	<cfelse>
	    <cfset nivNext = "#Mid(Check.HierarchyCode, 1, 9)##No#">
	</cfif>
  </cfcase>
  
  <!--- level 05 --->
  <cfcase value="14">
    <cfset No = Mid(Check.HierarchyCode, 13, 2)>
    <cfset No = No+1>
	<cfif No lt 10>
     	<cfset nivNext = "#Mid(Check.HierarchyCode, 1, 12)#0#No#">
	<cfelse>
	    <cfset nivNext = "#Mid(Check.HierarchyCode, 1, 12)##No#">
	</cfif>
  </cfcase>
  
  <!--- level 06 --->
  <cfcase value="17">
    <cfset No = Mid(Check.HierarchyCode, 16, 2)>
    <cfset No = No+1>
	<cfif No lt 10>
     	<cfset nivNext = "#Mid(Check.HierarchyCode, 1, 15)#0#No#">
	<cfelse>
	    <cfset nivNext = "#Mid(Check.HierarchyCode, 1, 15)##No#">
	</cfif>
  </cfcase>
   
</cfswitch>

<CFSET Caller.HStart = Check.HierarchyCode>

</cfsilent>

<cfif nivNext eq "0" and attributes.enforce eq "0">

	<cfoutput>
	<script language="JavaScript">
       window.location = "#SESSION.root#/System/Organization/Application/OrganizationHierarchy.cfm?href="
	</script>
	</cfoutput>

</cfif>

<CFSET Caller.HEnd   = nivNext>
<CFSET Caller.HUnit  = Check.OrgUnit>


