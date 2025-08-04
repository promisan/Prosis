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