<!--- Create Criteria string for query from data entered thru search form --->

<cf_screentop html="No" jquery="Yes">

<table width="98%" height="100%" align="center">

<cfset Page         = "0">
<cfset add          = "1">
<cfset save         = "0">
<cfset Header       = "Salary Percentage Base">
 
<tr style="height:10px"><td><cfinclude template = "../HeaderPayroll.cfm"></td></tr>

<cfquery name="SearchResult"
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM Ref_CalculationBase
</cfquery>

<cfoutput>

<script language = "JavaScript">

	function recordadd(grp) {
	      ptoken.open("RecordEdit.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width=990, height=860, toolbar=no, status=yes, scrollbars=yes, resizable=yes");
	}
	
	function recordedit(id1) {
	      ptoken.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "Edit", "left=80, top=80, width=990, height=860, toolbar=no, status=yes, scrollbars=yes, resizable=yes");
	}

</script>	

</cfoutput>

<tr><td>

<cf_divscroll>

	<table width="97%" align="center" class="navigation_table">
		
		<tr class="labelmedium line" style="height:20px;">
		    <td align="left"></td>
			<td colspan="2" align="left"><cf_tl id="Name"></td>	
			<td align="left" style="padding-left:20px"><cf_tl id="Base"></td>	  
		</tr>
			
		<cfloop query="SearchResult">
			
			<cfoutput>
			<tr><td height="10"></td></tr>
			<tr class="labelmedium navigation_row line"> 
			    
				<td width="6%" align="center" style="padding-top:1px;">
				    <cf_img icon="open" onclick="recordedit('#Code#')" navigation="Yes">
				</td>	
				<td colspan="2"width="170" style="font-size:15px">#Description#</td>			
				<td style="padding-left:20px"><b>
				<cfif BaseAmount eq "1">Full entitlement (Full)
				<cfelseif BaseAmount eq "2">
				Contract -/- LWOP amount (Base)
				<cfelseif BaseAmount eq "3">
				Contract amount (Days)
				<cfelseif BaseAmount eq "0">
				Payable Entitlement <font size="1" color="800040">(usually with deduction of SLWOP + Suspension days)</font>
				</cfif></td>
			</tr>	
			</cfoutput>
			
			<cfquery name="Applied"
			datasource="AppsPayroll" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">	
				SELECT DISTINCT ComponentName, Description
				FROM            SalaryScalePercentage P INNER JOIN Ref_PayrollComponent R ON R.Code = P.ComponentName
				WHERE        CalculationBase = '#Code#'
			</cfquery>		
			
			<cfif Applied.recordcount gte "1">				
			<tr bgcolor="DAF9FC" class="line labelmedium" style="border-top:1px solid silver"><td></td><td colspan="3"><cf_tl id="Used for">: <cfoutput query="Applied">#Description# <cfif currentrow neq recordcount>/</cfif> </cfoutput></td></tr>
			</cfif>
							
			<cfquery name="Detail"
			datasource="AppsPayroll" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">	
				SELECT  I.SalarySchedule, 
				        I.Code, 
						R.PayrollItem, 
						R.PayrollItemName
				FROM    Ref_CalculationBaseItem I INNER JOIN
			            Ref_PayrollItem R ON I.PayrollItem = R.PayrollItem
				WHERE   I.Code = '#Code#'
				ORDER BY SalarySchedule
			</cfquery>		
			
			<cfset prior = "">
			
			<cfoutput query="detail" group="SalarySchedule">
			
			    <tr>
					<td></td>						
					<td class="labelit" style="border-top:1px solid silver;padding-left:60px">#SalarySchedule#</td>
					<td bgcolor="f4f4f4" class="labelit" colspan="2" style="border-top:1px solid silver;padding-left:30px;">	
					
						<table><tr>
						<cfoutput>
						
						<cfquery name="get"
						datasource="AppsPayroll" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">	
								SELECT  Period as Mode
								FROM    SalaryScheduleComponent
								WHERE   SalarySchedule = '#SalarySchedule#'
								AND     PayrollItem = '#PayrollItem#'										
						</cfquery>		
						
						<td class="labelit">												
						<cfif get.Mode eq "Percent"><font color="DD6F00">#PayrollItem# #PayrollItemName# [%]</font><cfelse>#PayrollItem# #PayrollItemName#</cfif><cfif currentrow neq recordcount>&nbsp;/&nbsp;</cfif></td>
						</cfoutput>
						</tr>
						</table>	
						
					<td>
								
				</tr>
			</cfoutput>		
			
		</cfloop>
	
	</table>

</cf_divscroll>

</td>
</tr>
</table>

<cfset AjaxOnLoad("doHighlight")>	
