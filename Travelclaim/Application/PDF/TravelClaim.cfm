

<cfparam name="URL.claimId" default="">

<cfif URL.claimId eq "">
	<cf_message message="Problem preparing report" return="false">
	<cfabort>
</cfif>

<cf_wait1 flush="Force" text="Please wait while I am preparing your PDF">

<cfoutput>
<script>
window.open("TravelClaimPDF.cfm?#CGI.QUERY_STRING#","_self")
</script>
</cfoutput>


