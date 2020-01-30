
<cfquery name="Capture" 
			datasource="appsSystem">
			SELECT * FROM UserReportDistributionQuery
</cfquery>

<cfdump var="#capture#"
		 label="Capture">