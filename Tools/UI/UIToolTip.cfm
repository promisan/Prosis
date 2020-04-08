<cfparam name="ATTRIBUTES.id"        default="">
<cfparam name="ATTRIBUTES.tooltip"   default="">
<cfparam name="ATTRIBUTES.content"   default="">
<cfparam name="ATTRIBUTES.ContentURL"  default="">
<cfparam name="ATTRIBUTES.color"    default="steelblue">
<cfparam name="ATTRIBUTES.position" default="bottom">
<!---
Possible values
bottom
top
left
right
center
--->

<cfparam name="ATTRIBUTES.width"    default="500">
<cfparam name="ATTRIBUTES.height"   default="300">
<cfparam name="ATTRIBUTES.duration" default="500">
<cfparam name="ATTRIBUTES.callout"  default="true">
<cfparam name="ATTRIBUTES.showOn"    default="mouseenter">
<!----
mouseenter
click
---->



<cfif thisTag.ExecutionMode is 'start'>
<cfelseif thisTag.ExecutionMode is 'end'>
    <cfoutput>
    <cfsavecontent variable="vreturn">
        <cfif ATTRIBUTES.id eq "">
            <cf_AssignId>
            <cfset vId = rowguid>
        <cfelse>
            <cfset vId = ATTRIBUTES.id>
        </cfif>

        <span id="cf_tip_#vId#" title="#ATTRIBUTES.tooltip#" style="color:#attributes.color#">
            #thisTag.GeneratedContent#
        </span>
    </cfsavecontent>
    </cfoutput>

    <cfset thisTag.GeneratedContent = vreturn>
    <cfoutput>
        <cfset AjaxOnLoad("function(){ProsisUI.doToolTip('#vId#','#ATTRIBUTES.tooltip#','#ATTRIBUTES.content#','#ATTRIBUTES.ContentURL#','#ATTRIBUTES.width#','#ATTRIBUTES.height#','#ATTRIBUTES.position#','#ATTRIBUTES.duration#','#ATTRIBUTES.callout#','#ATTRIBUTES.showOn#');}")>
    </cfoutput>
</cfif>

