
<cfparam name="CLIENT.DateFormatShow" default="DD/MM/YY">

<cfquery name="Action" 
	datasource="AppsOrganization">
		SELECT   * 
		FROM     OrganizationObjectAction
		WHERE    ObjectId = '#url.objectid#'
		AND      ActionStatus IN ('2','2Y','2N')
		ORDER BY Created DESC
</cfquery>

<cfoutput>

	<table style="width:230px" align="center">
	
	<tr style="height:20px" class="labelmedium"><td><b><cf_tl id="Last Action"></td></tr>
	<tr style="height:20px" class="labelmedium"><td>#Action.OfficerFirstName# #Action.OfficerLastName#</td></tr>
	<tr style="height:20px" class="labelmedium"><td><cfif Action.ActionStatus eq "2N">
				<span style="color:##FF0000;">Denied</span>
			<cfelse>
				<span style="color:##34AB3A;">Confirmed</span>
			</cfif></td></tr>
	<tr style="height:20px" class="labelmedium"><td>#dateformat(Action.OfficerDate,CLIENT.DateFormatShow)# #timeformat(action.OfficerDate,"HH:MM")#</td></tr>	
	
	</table>

	<!---
	<cf_mobilerow>
		<cf_mobilecell class="col-lg-12">
			<cf_tl id="Last Action performed by">:
		</cf_mobilecell>
	</cf_mobilerow>

	<cf_mobilerow>
		<cf_mobilecell class="col-lg-12">
			#Action.OfficerFirstName# #Action.OfficerLastName#
		</cf_mobilecell>
	</cf_mobilerow>

	<cf_mobilerow>
		<cf_mobilecell class="col-lg-12">
			<cfif Action.ActionStatus eq "2N">
				<span style="color:##FF0000;">Denied</span>
			<cfelse>
				<span style="color:##34AB3A;">Confirmed</span>
			</cfif>
		</cf_mobilecell>
	</cf_mobilerow>

	<cf_mobilerow>
		<cf_mobilecell class="col-lg-12">
			#dateformat(Action.OfficerDate,CLIENT.DateFormatShow)# #timeformat(action.OfficerDate,"HH:MM")#
		</cf_mobilecell>
	</cf_mobilerow>
	--->

</cfoutput>