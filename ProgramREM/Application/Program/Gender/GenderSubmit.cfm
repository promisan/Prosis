
<!--- process and reload --->

<cfif parameterExists(Form.Save)>
    <cfset area = "Gender Marker">
	<cfinclude template="../Category/CategoryEntrySubmit.cfm">
</cfif>
<cfinclude template="GenderView.cfm">

