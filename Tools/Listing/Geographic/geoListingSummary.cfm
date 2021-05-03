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
<cfparam name="attributes.mapStyle"             default="">

<cfoutput>
    <script>
        $('##___prosisMobileSubTitle').html('#attributes.viewLabel#');
    </script>

    <style>

        @media only screen and (min-width: 1200px) {
            .detailGeoContent#attributes.viewId#Detail > thead > tr > th, .detailGeoContent#attributes.viewId# > thead > tr > th, ###attributes.viewId#MapContainer {
                top:<cfif trim(attributes.filterHTML) neq "">75px<cfelse>25px</cfif> !important;
            }
        }

        @media only screen and (max-width: 1200px) {
            ###attributes.viewId#FiltersContainer, ###attributes.viewId#MapContainer {
                position:relative !important;
            }
        }

    </style>
</cfoutput>

<cfif trim(attributes.filterHTML) neq "">
    <cf_mobileRow id="#attributes.viewId#FiltersContainer" style="padding-bottom:10px; background-color:##f1f3f6; z-index:1; position:-webkit-sticky; position:sticky; top:0;">
        <cf_MobileCell class="col-lg-12">
            <cfoutput>
                #preserveSingleQuotes(attributes.filterHTML)#
            </cfoutput>
        </cf_MobileCell>
    </cf_mobileRow>
</cfif>

<cfset session.geoListingDataSource = attributes.dataSource>
<cfset "session.geoListingBaseQuery_#attributes.viewId#" = preserveSingleQuotes(attributes.baseQuery)>
<cfset "session.geoListingMainTableScriptFunction_#attributes.viewId#" = "showGeoListingSummaryMapSummary">
<cfset session.geoListingCountFemale = preserveSingleQuotes(attributes.countFemale)>
<cfset session.geoListingCountMale = preserveSingleQuotes(attributes.countMale)>
<cfset session.geoListingCountTotal = preserveSingleQuotes(attributes.countTotal)>
<cfset session.geoListingFilterMap = attributes.filterMap>

<cfset session.geoListingDetailSelect = preserveSingleQuotes(attributes.detailSelect)>
<cfset session.geoListingDetailOrder = preserveSingleQuotes(attributes.detailOrder)>
<cfset session.geoListingDetailFieldMap = attributes.detailFieldMap>
<cfset session.geoListingDetailOrderScript = attributes.detailOrderScript>

<cfset vFilterParams = "">
<cfloop from="1" to="#ArrayLen(attributes.filterMap)#" index="i">
    <cfset vFilterParams = vFilterParams & "&geoF#i#={geoF#i#}">
</cfloop>

<cf_mobileRow class="clsGeoListingSummary" style="border-top:1px solid ##C0C0C0; padding-top:10px; height:auto;">

    <cfdiv 
        id="#attributes.viewId#MapContainer" 
        class="col-lg-4 col-sm-12" 
        bind="url:#session.root#/Tools/Listing/Geographic/geoListingMap.cfm?viewId=#attributes.viewId#&country=#vFilterParams#&zoomFunction=#attributes.zoomFunction#&mapStyle=#attributes.mapStyle#">
    
    <cfdiv 
        id="#attributes.viewId#MapTable" 
        class="col-lg-8 col-sm-12" 
        style="min-height:300px;"
        bind="url:#session.root#/Tools/Listing/Geographic/geoListingSummaryMapDetail.cfm?viewId=#attributes.viewId#&country=#vFilterParams#">

</cf_mobileRow>

<style>
    .chartWrapper {
        height:auto;
    }

    .clsGeoListingSummary .dataTables_filter {
        display:none;
    }
</style>