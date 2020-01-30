<cfoutput>
	<iframe name="mainOrgView"
		id="mainOrgView"
		width="100%"
		height="99%"
		scrolling="no"
		frameborder="0"
		src="#session.root#/System/Organization/Application/Lookup/OrganizationView.cfm?mode=#url.formname#&fldorgunit=#url.fldorgunit#&fldorgunitcode=#url.fldorgunitcode#&fldmission=#url.fldmission#&fldorgunitname=#url.fldorgunitname#&fldorgunitclass=#url.fldorgunitclass#&mission=#url.mission#&mandate=#url.mandate#&effective=#url.effective#"></iframe>
</cfoutput>