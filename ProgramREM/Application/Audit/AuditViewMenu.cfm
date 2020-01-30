<cfoutput>

<cfquery name="Parameter"
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
    FROM Parameter
</cfquery>


<cfquery name="ThisAudit"
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
    FROM ProgramAudit.dbo.ProgramAudit
    WHERE ProgramCode='#URL.ProgramCode#'
	and Period='#URL.Period#'
	and AuditId='#URL.AuditId#'
</cfquery>


<cf_submenuleftscript>

<script language="JavaScript">

function recommendations()

{
   window.urllocation.value = "Recommendation/RecommendationView.cfm?ProgramCode=#URL.ProgramCode#&AuditId=#URL.AuditId#";

   parent.right.location.href = window.urllocation.value

}


</script>

</cfoutput>

<input type="hidden" name="urllocation" id="urllocation" value="AuditViewTop.cfm?ProgramCode=#URL.ProgramCode#&Period=#URL.period#&AuditId=#URL.AuditId#">


<cfset fcolor = "002350">


<table width="100%" border="0" cellspacing="0" cellpadding="0" align="left" class="menu">
<tr><td>
<cfoutput>
	<cfset heading = "Recommendations">
	<cfset module = "'Program'">
	<cfset selection = "'Audit'">
	<cfset menuclass = "'Recommendations'">
	<cfinclude template="../Tools/SubmenuLeft.cfm">
</cfoutput>


</td>
</tr>
<tr>
   <td><hr></td>
  </tr>

</table>
