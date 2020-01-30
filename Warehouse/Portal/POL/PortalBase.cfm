
<!--- show in this template the stock for the warehouse to which the person has access, then the option to open the
warehouse to process --->

<cfif url.mission eq "">
	<table align="center"><tr><td>No entity selected</td></tr></table>
	<cfabort>
</cfif>

<cf_setRequestStatus mission = "#url.mission#">

<!--- ----------------------- --->
<!--- ------end of check----- --->
<!--- ----------------------- --->

<cfinclude template="../Stock/InquiryWarehouse.cfm">

