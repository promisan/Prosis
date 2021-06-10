<cfparam name="attributes.viewId"               default="">
<cfparam name="attributes.viewLabel"            default="">
<cfparam name="attributes.dataSource"           default="">
<cfparam name="attributes.baseQuery"            default="">
<cfparam name="attributes.countFemale"          default="">
<cfparam name="attributes.countMale"            default="">
<cfparam name="attributes.countTotal"           default="">
<cfparam name="attributes.filterHTML"           default="">
<cfparam name="attributes.filterMap"            default="">
<cfparam name="attributes.detailSelect"         default="">
<cfparam name="attributes.detailOrder"          default="">
<cfparam name="attributes.detailFieldMap"       default="">
<cfparam name="attributes.detailOrderScript"    default="">
<cfparam name="attributes.zoomFunction"         default="">
<cfparam name="attributes.summaryType"          default="Region">

<cfoutput>
    <script>
        $('##___prosisMobileSubTitle').html('#attributes.viewLabel#');
    </script>

    <style>

        @media only screen and (min-width: 1200px) {
            .detailGeoContent#attributes.viewId#Detail > thead > tr > th, 
            .detailGeoRegionContent#attributes.viewId#Detail > thead > tr > th,
            .detailGeoContent#attributes.viewId# > thead > tr > th, 
            ###attributes.viewId#MapContainer {
                top:75px !important;
            }
        }

        @media only screen and (max-width: 1200px) {
            ###attributes.viewId#FiltersContainer, ###attributes.viewId#MapContainer {
                position:relative !important;
            }
        }

    </style>
</cfoutput>

<cf_mobileRow id="#attributes.viewId#FiltersContainer" style="padding-bottom:10px; background-color:##f1f3f6; z-index:1; position:-webkit-sticky; position:sticky; top:0;">
    <cf_MobileCell class="col-lg-12">
        <cfoutput>
            #preserveSingleQuotes(attributes.filterHTML)#
        </cfoutput>
    </cf_MobileCell>
</cf_mobileRow>

<cfset "session.geoListingDataSource_#attributes.viewId#" = attributes.dataSource>
<cfset "session.geoListingBaseQuery_#attributes.viewId#" = preserveSingleQuotes(attributes.baseQuery)>
<cfset "session.geoListingMainTableScriptFunction_#attributes.viewId#" = "showGeoListingSummary">
<cfset "session.geoListingCountFemale_#attributes.viewId#" = preserveSingleQuotes(attributes.countFemale)>
<cfset "session.geoListingCountMale_#attributes.viewId#" = preserveSingleQuotes(attributes.countMale)>
<cfset "session.geoListingCountTotal_#attributes.viewId#" = preserveSingleQuotes(attributes.countTotal)>
<cfset "session.geoListingFilterMap_#attributes.viewId#" = attributes.filterMap>

<cfset "session.geoListingDetailSelect_#attributes.viewId#" = preserveSingleQuotes(attributes.detailSelect)>
<cfset "session.geoListingDetailOrder_#attributes.viewId#" = preserveSingleQuotes(attributes.detailOrder)>
<cfset "session.geoListingDetailFieldMap_#attributes.viewId#" = attributes.detailFieldMap>
<cfset "session.geoListingDetailOrderScript_#attributes.viewId#" = attributes.detailOrderScript>
<cfset "session.geoListingSummaryType_#attributes.viewId#" = attributes.summaryType>

<cfset vFilterParams = "">
<cfloop from="1" to="#ArrayLen(attributes.filterMap)#" index="i">
    <cfset vFilterParams = vFilterParams & "&geoF#i#={geoF#i#}">
</cfloop>

<cf_mobileRow>

    <cfdiv 
        id="#attributes.viewId#MapContainer" 
        class="col-lg-6 col-sm-12" 
        style="position:-webkit-sticky; position:sticky; top:0;" 
        bind="url:#session.root#/Tools/Listing/Geographic/geoListingMap.cfm?viewId=#attributes.viewId#&country=#vFilterParams#&zoomFunction=#attributes.zoomFunction#">
    
    <cfdiv 
        id="#attributes.viewId#MapTable" 
        class="col-lg-6 col-sm-12" 
        bind="url:#session.root#/Tools/Listing/Geographic/geoListingMapSummary.cfm?viewId=#attributes.viewId#&country=#vFilterParams#">

</cf_mobileRow>