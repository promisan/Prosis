<cfparam name="Attributes.type" default="rootitem">
<cfparam name="Attributes.text" default="">
<cfparam name="Attributes.href" default="">


<cfif thisTag.ExecutionMode is 'start'>
    <cfscript>
        SESSION.UIBreadCrumb = ArrayNew(1);
        ArrayAppend(SESSION.UIBreadCrumb,{"type":"#attributes.type#", "text":"#attributes.text#", "href" : "#attributes.href#", "showText" : true});
    </cfscript>
    <cfoutput>
        <nav id="BreadCrumb_#ATTRIBUTES.id#"></nav>
    </cfoutput>


<cfelseif thisTag.ExecutionMode is 'end'>

    <cffunction name="getBreadCrumbOptions">
        <cfset vReturnJSon = SerializeJSON(SESSION.UIBreadCrumb)>
        <cfreturn vReturnJSon>
    </cffunction>

    <cfoutput>
        <cfset AjaxOnLoad("function(){ProsisUI.doBreadCrumb('#ATTRIBUTES.id#',#getBreadCrumbOptions()#);}")>
    </cfoutput>

</cfif>


