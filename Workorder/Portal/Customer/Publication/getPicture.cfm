<!--
    Copyright © 2025 Promisan B.V.

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
<cfparam name="url.id" 			default="">
<cfparam name="url.url" 		default="">
<cfparam name="url.style" 		default="">
<cfparam name="url.roundborder" default="0">
<cfparam name="url.rotateEvent" default="0">

<cfset vRoundBorder = "">
<cfif url.roundborder eq 1>
	<cfset vRoundBorder = "border-radius:5px; -moz-border-radius:5px; -webkit-border-radius:5px;">
</cfif>

<cfset vRotateEvent = "">
<cfif url.rotateEvent eq 1>
	<cfset vRotateEvent = "$('.clsPicture_#url.id#').toggleClass('rotate');">
</cfif>

<cfoutput>
	<cf_tl id="Click to rotate" var="1">
	<img 
		class="clsPicture clsPicture_#url.id#" 
		src="#url.url#" 
		style="cursor:pointer; #vRoundBorder# #url.style#"
		title="#lt_text#"
		onclick="#vRotateEvent#"/>
</cfoutput>