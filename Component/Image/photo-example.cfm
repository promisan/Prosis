<html>
	<head>
		<style>
			body { font-family: "trebuchet ms", verdana; }
			#main div { padding:4px; font-size:small; } 
		</style>
	</head>
<body>
<cfset sourceImg = "Images/fall-trail-small.jpg">

<div align="center" id="main">
<cfoutput><img src="#sourceImg#" alt="Source Image"></cfoutput>
<cfimage action="read" source="#sourceImg#" name="img">
<cfset imageEffects = CreateObject("component", "CFImageEffects")>
<br />
<div>brightenImage()</div>
<cfset imageEffects.brightenImage(img)>
<cfimage action="writeToBrowser" source="#img#">
<cfflush>
<br />
<div>darkenImage()</div>
<cfimage action="read" source="#sourceImg#" name="img">
<cfset imageEffects.darkenImage(img)>
<cfimage action="writeToBrowser" source="#img#">
<cfflush>
<br />
<div>sepiaTone()</div>
<cfimage action="read" source="#sourceImg#" name="img">
<cfset imageEffects.sepiaTone(img)>
<cfimage action="writeToBrowser" source="#img#">
<br />
<div>applyRoundedCornersEffect()</div>
<cfset imageEffects.applyRoundedCornersEffect(img)>
<cfimage action="writeToBrowser" source="#img#">
<br />
<div>applyReflectionEffect()</div>
<cfset img = imageEffects.applyReflectionEffect(img)>
<cfimage action="writeToBrowser" source="#img#">
</div>

</body>
<html>