
<cfquery name="qPerson"
        datasource="AppsEmployee"
        username="#SESSION.login#"
        password="#SESSION.dbpw#">
        SELECT * FROM Person
        WHERE PersonNo = '#URL.personNo#'
</cfquery>

<cfquery name="qContract"
        datasource="AppsEmployee"
        username="#SESSION.login#"
        password="#SESSION.dbpw#">
    SELECT * FROM PersonContract
    WHERE PersonNo = '#URL.personNo#'
</cfquery>

<cfoutput>

<table width="100%">

    <tr><td style="padding-top:5px"></td></tr>
	<tr style="background-color:e1e1e1">
	<td style="padding-top:20px;padding:10px;font-size:20px" class="labelmedium">#qPerson.FullName#</td>
	</tr>
	
	<tr>
	
	<tr><td style="padding-left:10px" class="labelmedium">Contact Information</td></tr>
	
	<tr><td style="padding-left:10px;height:40px" class="labelmedium"></td></tr>
	
	<tr>
	<td>

		<CF_UITabStrip id="tabstrip_#url.assignmentNo#">
		
			<CF_UITabStripItem name="Appointment" source="StaffingViewDetailContracts.cfm">
			<CF_UITabStripItem name="Assigments"  source="StaffingViewDetailAssignments.cfm">
		
		</CF_UITabStrip>
   	

	</td>
	
	</tr>
	</table>
</cfoutput>

<cfoutput>

<cfsavecontent variable="vScript">
	ProsisUI.doTooltipPositioning(500);
</cfsavecontent>

</cfoutput>


<cfset ajaxOnLoad("function(){#vScript#}")>

