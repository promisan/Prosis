<cfparam name="Attributes.name" default="">
<cfparam name="Attributes.source" default="">



<cfif thisTag.executionmode is 'start'>
    <cfif Attributes.source neq "">
        <cfoutput>
            <cfscript>
                ArrayAppend(SESSION.TabOptions,{name:"#attributes.name#", source:"#attributes.source#"});
            </cfscript>
        </cfoutput>
    </cfif>
</cfif>


