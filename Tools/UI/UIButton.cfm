<cfparam name="attributes.id" default="">
<cfparam name="attributes.label" default="">
    <!---
        "small"
        "medium"
        "large"
        "none"
    --->            

<cfparam name="attributes.icon" default="">
<cfparam name="attributes.script" default="">


<cfoutput>
    <span id="#attributes.id#">#attributes.label#</span>

    <cfsavecontent  variable="vScript">
        $("###attributes.id#").kendoButton({
            icon: "#attributes.icon#",
            <cfif attributes.script neq "">
                click: #attributes.script#
            </cfif>    
        });

    </cfsavecontent>

</cfoutput>

<cfset ajaxOnLoad("function(){ #vScript# }")>