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
<cfset cond = "">

<cfparam name="Form.FunctionDescription" default="">

<CFSET des = Replace(Form.FunctionDescription, "'", "''", "ALL" )>

<cfif Form.FunctionDescription neq "">
   <cfset cond = "AND (F.FunctionDescription LIKE '%#des#%' or F.FunctionNo LIKE '%#des#%' or F.FunctionClassification LIKE '%#des#%')">
</cfif>

<cfparam name="Form.OccupationalGroup" default="">
<cfif Form.OccupationalGroup neq "">
   <cfif cond eq "">
     <cfset cond = "AND F.OccupationalGroup IN (#Form.OccupationalGroup#)">
   <cfelse>
      <cfset cond = #cond# & " AND F.OccupationalGroup IN (#Form.OccupationalGroup#)">
   </cfif>  
</cfif>


<cfparam name="Form.SubmissionEdition" default="">
<cfif Form.SubmissionEdition neq "">
   <cfif cond eq "">
     <cfset cond = "AND F.FunctionNo IN (SELECT FunctionNo FROM FunctionOrganization WHERE SubmissionEdition IN ('#Form.SubmissionEdition#'))">
   <cfelse>
      <cfset cond = cond & " AND F.FunctionNo IN (SELECT FunctionNo FROM FunctionOrganization WHERE SubmissionEdition IN ('#Form.SubmissionEdition#'))">
   </cfif>  
</cfif>


<cfparam name="Form.FunctionOperational" default="1">
<cfif Form.FunctionOperational neq "">
  <cfif cond eq "">
     <cfset cond = "AND F.FunctionOperational IN (#Form.FunctionOperational#)">
   <cfelse>
     <cfset cond = #cond# & " AND F.FunctionOperational IN (#Form.FunctionOperational#)">
  </cfif>	 
</cfif>

<cfparam name="Form.FunctionClass" default="">
<cfif #Form.FunctionClass# neq "">
  <cfif cond eq "">
     <cfset cond = "AND F.FunctionClass IN (#Form.FunctionClass#)">
   <cfelse>
     <cfset cond = #cond# & " AND F.FunctionClass IN (#Form.FunctionClass#)">
  </cfif>	 
</cfif>

<cfset CLIENT.condition = cond>

<cfoutput>

<script language="JavaScript">
	 window.location = "RecordListing.cfm?idmenu=#url.idmenu#&ID=#Form.FunctionDescription#" 
</script>

</cfoutput>