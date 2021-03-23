<!--- Create Criteria string for query from data entered thru search form --->

<cf_screentop html="No" jquery="Yes">

<table style="height:100%;width:100%">
<tr><td style="height:20">

<cfset add          = "1">
<cfset Header       = "Payroll Item">
<cfinclude template = "../HeaderPayroll.cfm">   
</td></tr>

 <!--- initially populate --->

<cfquery name="List"
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT     S.Mission, S.SalarySchedule, R.PayrollItem
	FROM         SalaryScheduleMission S CROSS JOIN
                      Ref_PayrollItem R
</cfquery>

<cfloop query="List">

	<cfquery name="Verify"
	datasource="AppsPayroll" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
		FROM  SalarySchedulePayrollItem
		WHERE PayrollItem    = '#PayrollItem#'	
		AND   Mission        = '#Mission#'
		AND   SalarySchedule = '#SalarySchedule#'
	</cfquery>
	
	<cfif verify.recordcount eq "0">
	
		<cfquery name="Insert" 
			datasource="AppsPayroll" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			INSERT INTO SalarySchedulePayrollItem
			         (PayrollItem,
					  Mission,
					  SalarySchedule,
					  OPerational,
					  OfficerUserId,
					  OfficerLastName,
					  OfficerFirstName)
			  VALUES ('#PayrollItem#',
	        		  '#Mission#', 
					  '#salaryschedule#',
					  '0',
					  '#SESSION.acc#',
					  '#SESSION.last#',
					  '#SESSION.first#')
			  </cfquery>	
	
	</cfif>

</cfloop>		


<tr><td height="100%">

<cf_divscroll>
			  
	<table width="100%" align="center">
	 
	<cfoutput>
	
	<script>
	
	function recordadd(grp) {
	        ptoken.open("RecordEditTab.cfm?idmenu=#url.idmenu#&ID1=", "Add");
	}
	
	function recordedit(id1) {
	        ptoken.open("RecordEditTab.cfm?idmenu=#url.idmenu#&ID1=" + id1, "Edit");
	}
	
	function recordpurge(id) {
		if (confirm('Do you want to remove this item ?')) {
			ptoken.navigate('RecordPurge.cfm?idmenu=#url.idmenu#&id1=' + id,'divDetail');
		}
	}
	
	</script>	
	
	</cfoutput>
		
	<tr>
		<td colspan="2">
			<cfdiv id="divDetail" bind="url:RecordListingDetail.cfm?mission=#list.mission#&salaryschedule=#list.salaryschedule#">
		</td>
	
	</table>

</cf_divscroll>

</td></tr>
</table>

