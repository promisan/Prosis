
<cfif url.show eq 1>

	<cfif url.RequirementDate eq "">
		<cfset vDate = "">
	<cfelse>
		<cfset vDate = url.RequirementDate>
	</cfif>
	<!-- <cfform name="frmFundObject_#url.vCodeId#"> -->
	<cf_intelliCalendarDate8
		FieldName="RequirementDate_#url.vCodeId#"
		Message="Select a valid Requirement Date for #url.code#"
		class="regularxl"
		Default="#vDate#"
		AllowBlank="False">
	<!-- </cfform> -->
	
	<cfset AjaxOnLoad("doCalendar")>

</cfif>