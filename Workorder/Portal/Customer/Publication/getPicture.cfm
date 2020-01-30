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