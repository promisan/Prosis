<!--
    Copyright © 2025 Promisan

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->
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

