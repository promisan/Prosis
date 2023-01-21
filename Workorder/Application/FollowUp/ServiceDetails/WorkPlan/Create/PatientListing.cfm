	
<cf_screentop jquery="yes" html="yes" label="Schedule Patient" layout="webapp" user="yes" banner="gray" bannerforce="yes">

<cf_listingscript>
<cf_dialogStaffing>

<cfoutput>
	
	<script>
		function patientadd(mis,org,per,date) {
			ptoken.open('#session.root#/Roster/Candidate/Details/Applicant/ApplicantEntry.cfm?class=4&header=0&next=patient&mission='+mis+'&orgunit='+org+'&personno='+per+'&date='+date,'_top')
		}
	
	</script>

</cfoutput>
	
<table width="100%" height="100%">
<tr><td style="padding-left:15px;padding-right:15px">
	<cfinclude template="PatientListingContent.cfm">
</td></tr></table>


