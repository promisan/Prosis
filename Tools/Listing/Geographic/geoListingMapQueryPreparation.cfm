<cfparam name="attributes.url" 		default="">
<cfparam name="attributes.exclude" 	default="">

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

		<cfif isDefined("attributes.url.representation") AND trim(attributes.url.representation) neq "">
			AND Status = '#attributes.url.representation#'
		</cfif>

		<cfloop from="1" to="#arraylen(vThisFilterMap)#" index="i">
			<cfif isDefined("attributes.url.#vThisFilterMap[i].id#") AND trim(evaluate("attributes.url.#vThisFilterMap[i].id#")) neq "">
				<cfif trim(attributes.exclude) eq "" OR findNoCase(vThisFilterMap[i].queryField, attributes.exclude) eq 0>
					AND #vThisFilterMap[i].queryField# = '#evaluate("attributes.url.#vThisFilterMap[i].id#")#'
				</cfif>
			</cfif>
		</cfloop>

	</cfsavecontent>

</cfoutput>

<cfset caller.preparationQueryFilters = preparationQueryFilters>