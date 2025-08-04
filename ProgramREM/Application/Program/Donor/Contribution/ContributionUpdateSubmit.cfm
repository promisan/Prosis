<!--
    Copyright © 2025 Promisan

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->
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