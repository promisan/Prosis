<cfparam name="attributes.url" 	default="">

<!--- Base query --->
<cfoutput>
	<cfset vThisQuery = evaluate("session.geoListingBaseQuery_#attributes.viewId#")>
	<cfsavecontent variable="preparationQueryFilters">
		#preserveSingleQuotes(vThisQuery)#

		WHERE 	1=1

		<cfif isDefined("attributes.url.country") AND trim(attributes.url.country) neq "">
			AND Country = '#attributes.url.country#'
		</cfif>

		<cfloop from="1" to="#arraylen(session.geoListingFilterMap)#" index="i">
			<cfif isDefined("attributes.url.#session.geoListingFilterMap[i].id#") AND trim(evaluate("attributes.url.#session.geoListingFilterMap[i].id#")) neq "">
				AND #session.geoListingFilterMap[i].queryField# = '#evaluate("attributes.url.#session.geoListingFilterMap[i].id#")#'
			</cfif>
		</cfloop>

	</cfsavecontent>

</cfoutput>

<cfset caller.preparationQueryFilters = preparationQueryFilters>