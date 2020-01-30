

<cfparam name="url.height" default="100" type="integer">
<cfparam name="url.width" default="100" type="integer">
<cfparam name="url.startColor" default="##84CEDC" type="regex" pattern="[A-Za-z0-9##]+">	
<cfparam name="url.endColor" default="##257D9F" type="regex" pattern="[A-Za-z0-9##]+">
<cfparam name="url.gradientDirection" default="vertical" type="regex" pattern="(vertical|horizontal)" >

<cfif IsDefined("url.renderImage")>
	<cfinvoke component="CFImageEffects" method="init" returnvariable="effects">	

	<!--- create a new image --->
	<cfset newImage = ImageNew("", url.width, url.height)>
	
	<!--- draw a gradient filled rectangle --->
	<cfset effects.DrawGradientFilledRect(newImage, 0, 0, url.width, url.height, url.startColor, url.endColor, url.gradientDirection)>
	
	<!--- write the image to the browser --->
	<cfset ImageWrite(newImage, ExpandPath("Images/gradient-example.png"))>
	<cfcontent  type="image/png" file="#ExpandPath("Images/gradient-example.png")#">
<cfelse>
	<style>
		body { font-family: verdana, arial; }
		label { width: 150px; text-align:right; position:absolute; }
		input, select { margin-left: 160px; }
	</style>
	<cfoutput>
	<div style="width:500px;">
	<img src="gradient-example.cfm?renderImage=1&amp;height=#url.height#&amp;width=#url.width#&amp;startColor=#URLEncodedFormat(url.startColor)#&amp;endColor=#URLEncodedFormat(url.endColor)#&amp;gradientDirection=#url.gradientDirection#" style="position:absolute;margin-left:510px;">
	<form action="gradient-example.cfm" method="get">
		<label for="height">Height:</label>
		<input type="text" name="height" id="height" value="#url.height#" />
		<br />
		
		<label for="width">Width:</label>
		<input type="text" name="width" id="width" value="#url.width#" />
		<br />
		
		<label for="startColor">Start Color:</label>
		<input type="text" name="startColor" id="startColor" value="#url.startColor#" maxlength="10" />
		<br />
		
		<label for="endColor">End Color:</label>
		<input type="text" name="endColor" id="endColor" value="#url.endColor#" maxlength="10" />
		<br />
		
		<label for="dir">Gradient Direction</label>
		<select name="gradientDirection" id="dir">
			<option value="vertical">Vertical</option>
			<option value="horizontal">Horizontal</option>
		</select>
		
		
		<hr />
		<input type="submit" value="Draw Gradient Filled Rectangle" />
		
	</form>
	</div>
	</cfoutput>

</cfif>