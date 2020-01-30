
<cfsilent>

<cfquery name="CellElement" 
    datasource="appsCaseFile" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
	SELECT *
	FROM   Element E
	WHERE  ElementId = '#url.elementid#'
</cfquery>	

<cfquery name="GetTopic" dataSource = "AppsSelection">
	SELECT *
	FROM Applicant.dbo.Applicant
	WHERE PersonNo = '#Element.PersonNo#'
</cfquery>


</cfsilent>

<cfif url.mode eq "expanded">
<cfoutput>
	<table><tr><td width="450" align="center" style="padding:5px">
		#GetTopic.LastName#, #GetTopic.FirstName#<br>
		<cfif GetTopic.Gender eq 'M'>
			<cf_tl id="Male">
		<cfelseif GetTopic.Gender eq 'F'>
			<cf_tl id="Female">
		</cfif>
		<br>
		#DateFormat(GetTopic.DOB,CLIENT.DateFormatShow)#
	</td></tr></table>
</cfoutput>
<cfelse>
	<cfoutput>
		<table><tr><td style="padding:5px">
			#GetTopic.LastName#, #GetTopic.FirstName#
		</td></tr></table>
	</cfoutput>
</cfif>