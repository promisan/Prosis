<!--- Create Criteria string for query from data entered thru search form --->


<cf_screentop html="No" jquery="Yes">

<table width="98%" height="100%" align="center">

<cfset Page         = "0">
<cfset add          = "1">
<cfset save         = "0">
<cfset Header       = "Salary Entitlement Trigger Groups">
 
<tr style="height:10px"><td><cfinclude template = "../HeaderPayroll.cfm"></td></tr>
 
<cfquery name="SearchResult"
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM Ref_PayrollTrigger
	ORDER BY TriggerGroup, Operational DESC
</cfquery>

<!--- create default record --->

<cfquery name="Addline"
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    INSERT INTO Ref_PayrollTriggerGroup
	         (SalaryTrigger, EntitlementGroup,OfficerUserId, OfficerLastName, OfficerFirstName)
			 
	SELECT   SalaryTrigger, 
	         'Standard',
			 '#SESSION.acc#',
			 '#SESSION.last#', 
			 '#SESSION.first#'	
			 
	FROM     Ref_PayrollTrigger
	WHERE    SalaryTrigger NOT IN (SELECT SalaryTrigger FROM Ref_PayrollTriggerGroup WHERE EntitlementGroup = 'Standard')	
</cfquery>


<cfoutput>

	<script LANGUAGE = "JavaScript">
	
		function recordadd(grp) {
		   ptoken.open("RecordEdit.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width=670, height=630, toolbar=no, status=yes, scrollbars=no, resizable=yes");
		}
		
		function recordedit(id1) {
		   ptoken.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "Edit", "left=80, top=80, width=1000, height=800, toolbar=no, status=yes, scrollbars=no, resizable=yes");
		}
	
	</script>	

</cfoutput>

<tr><td height="100%">

	<cf_divscroll>
	
	<table width="97%" align="center" class="navigation_table">
	
	<tr class="labelmedium2 fixrow fixlengthlist">
	    <td></td>
		<td><cf_tl id="Code"></td>
		<td><cf_tl id="Description"></td>
		<td><cf_tl id="Entry Class"></td>
		<td width="100"><cf_tl id="Contract"></td>
		<td><cf_tl id="Oper"></td>		  
	</tr>
	
	<cfoutput query="SearchResult" group="TriggerGroup">
			
		<tr class="fixrow2"><td colspan="6" style="height:30px" class="labellarge">#TriggerGroup#</td></tr>
		
		<cfoutput>     
			
			<cfif operational eq "0">	
				<tr style="height:15px" bgcolor="f2f2f2" class="labelmedium2 line navigation_row fixlengthlist"> 
			<cfelse>
				<tr style="height:15px" bgcolor="#IIf(CurrentRow Mod 2, DE('FFFFFF'), DE('ffffff'))#" class="labelmedium2 line navigation_row fixlengthlist"> 
			</cfif>     
				<td width="6%" align="center" style="padding-top:1px;">
					  <cf_img icon="open" navigation="Yes" onclick="recordedit('#SalaryTrigger#')">
				</td>	
				<td width="170">#SalaryTrigger#</td>
				<td>#Description#</td>
				<td>#EntitlementClass#</td>
				<td><cfif triggergroup eq "Contract">n/a<cfelse>
				        <cfif EnableContract eq "1">Yes<cfelseif EnableContract eq "2">Yes, default<cfelse>No</cfif>
					</cfif>
				</td>
				<td><cfif operational eq "0">No<cfelse>Yes</cfif></td>
			</tr>	
		</cfoutput>	
			
	</cfoutput>
	
	</table>
	
	</cf_divscroll>

</td></tr>
</table>
