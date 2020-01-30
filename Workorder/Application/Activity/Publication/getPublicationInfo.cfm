
<cfquery name="getPublication" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	*
		FROM	Publication
		WHERE	PublicationId = '#url.publicationId#'
</cfquery>

<cfoutput>
	<table>
		<tr>
			<td class="labellarge" style="padding-left:16px">
				#getPublication.Description# ( <span>#dateFormat(getPublication.PeriodEffective,client.dateformatshow)#&nbsp;-&nbsp;#dateFormat(getPublication.PeriodExpiration,client.dateformatshow)#</span> )
			</td>
		</tr>
	</table>
</cfoutput>