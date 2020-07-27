<cfparam name="Attributes.type" default="item">
<cfparam name="Attributes.text" default="">
<cfparam name="Attributes.href" default="">



<cfif thisTag.executionmode is 'start'>
    <cfoutput>
        <cfscript>
            ArrayAppend(SESSION.UIBreadCrumb,{"type":"#attributes.type#", "text":"#attributes.text#", "href": "#attributes.href#", "showText" : true});
        </cfscript>
    </cfoutput>
</cfif>

