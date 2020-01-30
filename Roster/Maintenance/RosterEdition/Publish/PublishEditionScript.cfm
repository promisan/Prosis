
<cfoutput>

<cfajaximport tags="cfprogressbar">

<script language="JavaScript">

function doGenerateBuckets(edition) {		
	_cf_loadingtexthtml="";		
	document.getElementById('Generate').style.display='none';
	ColdFusion.ProgressBar.start('pBar') ;
 	ColdFusion.navigate('#SESSION.root#/Roster/Maintenance/RosterEdition/Publish/doPublishEdition.cfm?submissionedition='+edition, 'formResult');
}

</script>

</cfoutput>