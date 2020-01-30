<!--- JavaScript program form calls (in Tools tag directory)--->

<cf_dialogREMProgram>

<cfparam name="URL.Layout" default="Program">

<!--- headers and necessary Params for expand/contract --->
<cfparam name="URL.Verbose" default="#CLIENT.Verbose#">
<cfset #CLIENT.Verbose# = #URL.Verbose#>
<cfset Caller = "AuditViewTop.cfm?ProgramCode=#URL.ProgramCode#&Period=#URL.Period#&Auditid=#URL.AuditId#">

<table width="100%" border="0" cellspacing="0" align="center" cellpadding="0" bordercolor="#C0C0C0" rules="rows">
  <tr>
  <td>
  SOME INFO HERE
 </td>
 </tr>
</table> 

<table><tr><td height="2"></td></tr></table>

<!--- Query returning search results --->
<cfquery name="Parameter" 
datasource="AppsProgram" >
    SELECT *
    FROM Parameter
</cfquery>
	
