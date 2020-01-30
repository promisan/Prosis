
<cfsilent>

<cfquery name="GetTopic" dataSource = "AppsCaseFile">
	SELECT ET.ElementId, E.ElementClass, T.Description, ET.TopicValue 
	FROM ElementTopic ET
	INNER JOIN Ref_TopicElementClass TEC
		ON ET.Topic = TEC.Code
	INNER JOIN Ref_Topic T
		ON T.Code = TEC.Code
	INNER JOIN Element E
		ON E.ElementId = ET.ElementId AND E.ElementClass = TEC.ElementClass
	WHERE E.ElementId = '#url.elementid#'
	ORDER BY T.ValueObligatory desc
</cfquery>

</cfsilent>

<cfif url.mode eq "expanded">
<cfoutput>
	<table><tr><td width="450" align="left" style="padding:5px">
		<cfloop query="GetTopic">
			<b>#GetTopic.Description#:</b>&nbsp;&nbsp;#GetTopic.TopicValue#<br>
		</cfloop>
	</td></tr></table>
</cfoutput>
<cfelse>
	<cfoutput>
		<table><tr><td style="padding:5px">
		<cf_space spaces="20">
			#GetTopic.TopicValue#
		</td></tr></table>
	</cfoutput>
</cfif>