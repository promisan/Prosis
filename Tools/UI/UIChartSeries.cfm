<cfparam name="Attributes.type" default="donut">
<cfparam name="Attributes.query" default="">
<cfparam name="Attributes.itemcolumn" default="">
<cfparam name="Attributes.valuecolumn" default="">
<cfparam name="Attributes.colorlist" default="">


<cfif thisTag.executionmode is 'start'>
        <cfoutput>
            <cfscript>
                ArrayAppend(SESSION.chartSeries,{type:"#attributes.type#", query:"#attributes.query#", categoryField:"#attributes.itemcolumn#", field:"#attributes.valuecolumn#",seriesColor:#attributes.colorlist# });
            </cfscript>
        </cfoutput>
</cfif>


