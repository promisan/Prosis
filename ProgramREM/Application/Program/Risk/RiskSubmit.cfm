
<!--- process and reload --->

<cfif parameterExists(Form.Save)>
    <cfset area = "Risk">
	<cfinclude template="../Category/CategoryEntrySubmit.cfm">
</cfif>
<cfinclude template="RiskView.cfm">

