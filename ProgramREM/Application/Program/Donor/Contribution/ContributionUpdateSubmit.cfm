<CF_DateConvert Value="#DateFormat('#Form.dateSubmitted#',CLIENT.dateSQL)#">
<cfset date     = dateValue>

<cfquery name="qContributionAdd" datasource="AppsProgram">
	UPDATE 	Contribution
	SET 	Description    = '#FORM.Description#',
    		EarMark        = '#FORM.Earmark#',
	    	DateSubmitted  = #date#,
    		Contact        = '#FORM.Contact#'
	WHERE   ContributionId = '#FORM.ContributionId#'
</cfquery>

<cfquery name="qCheck" datasource="AppsProgram">
	SELECT *
	FROM   Contribution
	WHERE  ContributionId = '#FORM.ContributionId#'
</cfquery>

<script language="JavaScript1.1">
	$(document).ready(function() {
		$('.fcontribution').css({left:20, 'top':'70px' });
		$('.fcontribution_line').css({'display':'block', 'left':'500px', 'top':'70px'});
		$('#contributionid').val('#FORM.ContributionId#');
	});
</script>