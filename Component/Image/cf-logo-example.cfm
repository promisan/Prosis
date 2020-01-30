<cfinvoke component="CFImageEffects" method="init" returnvariable="effects">

<!--- create a new image --->
<cfset newImage = ImageNew("", 50, 50)>

<!--- draw a gradient filled rectangle --->
<cfset effects.DrawGradientFilledRect(newImage, 0, 0, 50, 50, "##8DB3C9", "##1A4C6E", "vertical")>

<!--- apply drop shadow --->
<cfset newImage = effects.ApplyDropShadowEffect(newImage, "white", "##A19FA4", 2, 2)>

<!--- draw CF --->
<cfset textOptions = StructNew()>
<cfset textOptions.size = "30">
<cfset textOptions.font = "Verdana">
<cfset ImageSetDrawingColor(newImage, "white")>
<cfset ImageSetAntialiasing(newImage, "on")>
<cfset ImageDrawText(newImage, "C", 5, 33, textOptions)>
<cfset textOptions.size = "26">
<cfset ImageDrawText(newImage, "F", 27, 36, textOptions)>

<!--- write the image to the browser --->
<cfset ImageWrite(newImage, ExpandPath("Images/cf-logo-example.png"))>
<cfcontent  type="image/png" file="#ExpandPath("Images/cf-logo-example.png")#">