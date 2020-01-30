
<table width="100%" cellspacing="0" cellpadding="0">
			
	<tr><td height="1" class="line"></td></tr>

    <tr>
	<td id="menu">
		<cfinclude template="../../Application/Budget/AllotmentView/AllotmentViewMenu.cfm">	
	</td>
	</tr>
									
	<!--- budget lines --->		
	
	<cfquery name="Check" 
	datasource="AppsProgram">
	SELECT *
		FROM   Program
		WHERE  Mission = '#URL.Mission#'
		AND    ServiceClass IS NOT NULL
		AND    ProgramCode IN (SELECT ProgramCode 
		                       FROM   ProgramPeriod 
							   WHERE  OrgUnit = '#url.id1#')
	</cfquery>
	
	<tr>
	<td align="center" id="content">	
	
		<cfif check.recordcount eq "0">
		    <!--- special provision to create program codes for data entry, this is likely to be customised ---> 
			<cfinclude template="BudgetViewActionInit.cfm">	
		<cfelse>																
			<cfinclude template="../../Application/Budget/AllotmentView/AllotmentViewDetail.cfm">	
		</cfif>	
			
	</td>
	</tr>
	
</table>	