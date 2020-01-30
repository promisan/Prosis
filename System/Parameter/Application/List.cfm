<cfparam name="url.code" default="">

<cfquery name="GetModule" 
		 datasource="AppsSystem" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">

			SELECT M.*, AM.SystemModule AppModule
			FROM   Ref_SystemModule M
			LEFT   JOIN  Ref_ApplicationModule AM
				   ON M.SystemModule = AM.SystemModule AND AM.Code = '#url.code#'
			WHERE  M.Operational = 1
			AND    MenuOrder < 90
			ORDER  BY M.MenuOrder

</cfquery>

<br>
	
<cfform method="POST" name="moduleform_#url.code#" onsubmit="return false">

<table width="89%" align="center" cellpadding="0" cellspacing="0" class="formpadding">

	<cfset cols = 5>
	<cfset cont =0>
	
	<tr><td colspan="#cols#"><font face="Calibri" size="3"><b>Modules operational under this application</font></td></tr>
	<tr><td colspan="#cols#" class="linedotted"></td></tr>
	
	<cfoutput query="GetModule">
	
		<cfif cont eq 0> <tr> </cfif>
		<cfset cont = cont +1>
		
		<cfif AppModule neq "">
		   <cfset cl = "ffffcf">
		<cfelse>
		   <cfset cl = "ffffff">
		</cfif> 
		
		<td style="background-color:#cl#" id="td_#url.code#_#SystemModule#">
		    <table width="100%">
			<tr><td width="20" style="padding:1px">
			<font face="Calibri" size="2">
				<input type="checkbox" 
					   name="module_#url.code#" 
					   value="#SystemModule#" 
					   onclick="submitModule('#url.code#','#SystemModule#');" 
					   <cfif AppModule neq "">checked</cfif>>
					   </td><td style="padding-left:3px" class="labelit">#Description#</td>
			  </table>		   
			</font>
		</td>
		
		<cfif cont eq cols > </tr> <cfset cont = 0> </cfif>
		
	</cfoutput>
		
	<tr class="hide"><td colspan="<cfoutput>#cols#</cfoutput>" id="submit_<cfoutput>#url.code#</cfoutput>"></td></tr>
		
</table>

</cfform>