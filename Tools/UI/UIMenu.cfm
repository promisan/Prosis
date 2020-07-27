
<cfparam name="ATTRIBUTES.id"       default="">


<cfif thisTag.ExecutionMode is 'start'>
    <cfscript>
        SESSION.UIMenu = ArrayNew(1);
    </cfscript>
    <cfoutput>
    <ul id="Menu_#ATTRIBUTES.id#" class="hide">
    </cfoutput>

<cfelseif thisTag.ExecutionMode is 'end'>


    </ul>

    <cfoutput>
        <cfset AjaxOnLoad("function(){ProsisUI.doMenu('#ATTRIBUTES.id#');}")>
    </cfoutput>

</cfif>



