
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