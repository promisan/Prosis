<cfparam name="Attributes.type" default="donut">
<cfparam name="Attributes.query" default="">
<cfparam name="Attributes.itemcolumn" default="">
<cfparam name="Attributes.valuecolumn" default="">
<cfparam name="Attributes.reference" default="">
<cfparam name="Attributes.colorlist" default="">
<cfparam name="Attributes.serieslabel" default="">
<cfparam name="Attributes.seriescolor" default="">

<cfif Attributes.colorlist eq "">
    <cfif attributes.seriescolor neq "">
        <cfset Attributes.colorlist = Attributes.SeriesColor>
    </cfif>
</cfif>

<cfif thisTag.executionmode is 'start'>
    <cfoutput>
        <cfscript>
            ArrayAppend(SESSION.chartSeries,{type:"#attributes.type#", query:"#attributes.query#", categoryField:"#attributes.itemcolumn#", currentField: "#attributes.valuecolumn#", field:"#attributes.valuecolumn#", reference:"#attributes.reference#",seriesColor:#attributes.colorlist# , serieslabel:"#Attributes.serieslabel#"});
        </cfscript>
    </cfoutput>
</cfif>


