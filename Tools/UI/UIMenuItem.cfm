<cfparam name="Attributes.name" default="">
<cfparam name="Attributes.display" default="">
<cfparam name="Attributes.href" default="">
<cfparam name="Attributes.children" default="0">

<cfif thisTag.ExecutionMode is 'start'>
    <cfif attributes.children eq 0>
        <li>
        <cfoutput>
            #attributes.display#
        </cfoutput>
        <ul>
    <cfelse>
        <li>
        <cfoutput>
            <a href="#attributes.href#">#attributes.display#</a>
        </cfoutput>
    </cfif>
<cfelseif thisTag.executionmode is 'end'>

    <cfif attributes.children eq 0>
        </ul>
        </li>
    <cfelse>
        </li>
    </cfif>

</cfif>


