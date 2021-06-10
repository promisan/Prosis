<cfparam name="attributes.url" 	default="">

<!--- Base query --->
<cfoutput>
	<cfset vThisQuery = evaluate("session.geoListingBaseQuery_#attributes.viewId#")>
	<cfset vThisFilterMap = evaluate("session.geoListingFilterMap_#attributes.viewId#")>

	<cfsavecontent variable="preparationQueryFilters">
		#preserveSingleQuotes(vThisQuery)#

		WHERE 	1=1

		<cfif isDefined("attributes.url.country") AND trim(attributes.url.country) neq "">
			AND Country = '#attributes.url.country#'
		</cfif>

		<cfif isDefined("attributes.url.region") AND trim(attributes.url.region) neq "">
			AND CountryGroup = '#attributes.url.region#'
		</cfif>

		<cfloop from="1" to="#arraylen(vThisFilterMap)#" index="i">
			<cfif isDefined("attributes.url.#vThisFilterMap[i].id#") AND trim(evaluate("attributes.url.#vThisFilterMap[i].id#")) neq "">
				AND #vThisFilterMap[i].queryField# = '#evaluate("attributes.url.#vThisFilterMap[i].id#")#'
			</cfif>
		</cfloop>

	</cfsavecontent>

</cfoutput>

<cfset caller.preparationQueryFilters = preparationQueryFilters>