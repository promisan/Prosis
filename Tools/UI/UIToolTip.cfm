<cfparam name="ATTRIBUTES.tooltip"     default="">
<cfparam name="ATTRIBUTES.color" default="steelblue">


<cfif thisTag.ExecutionMode is 'start'>
<cfelseif thisTag.ExecutionMode is 'end'>
    <cfoutput>
    <cfsavecontent variable="vreturn">
        <cf_AssignId>
        <cfset vId = rowguid>
        <span id="cf_tip_#vId#" title="#ATTRIBUTES.tooltip#" style="color:#attributes.color#">
            #thisTag.GeneratedContent#
        </span>
    </cfsavecontent>
    </cfoutput>

    <cfset thisTag.GeneratedContent = vreturn>
    <cfoutput>
    <script>
        ProsisUI.doToolTip('#vId#')
    </script>
    </cfoutput>
</cfif>

