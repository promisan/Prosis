
<cf_screentop height="100%" scroll="Yes" html="No" jquery="Yes">

<cf_dialogREMProgram>

<cfparam name="URL.Layout" default="Program">

<table width="99%" border="0" cellspacing="0" align="center" cellpadding="0">
 <tr>
  <td>
	<cfinclude template="Header/ViewHeader.cfm">
	
 </td>
 </tr>

 <tr><td>
	
	<!--- Query returning search results --->
	<cfquery name="Parameter" 
	datasource="AppsProgram" >
	    SELECT *
	    FROM Ref_ParameterMission
		WHERE Mission = '#Mission#'
	</cfquery>
		
	<cfset ThisProgram= URL.ProgramCode>
	
	<!--- subcomponents template  --->
	  <cfinclude template="ProgramComponents.cfm">
  
  </td>
  </tr>
  
</table>  

