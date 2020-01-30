<cfinvoke component="CFImageEffects" method="init" returnvariable="effects">

<!--- create a new image --->
<cfset button = ImageNew("", 80, 30)>

<!--- draw a gradient filled rectangle --->
<cfset effects.DrawGradientFilledRect(button, 0, 0, 100, 40, "##155EA4", "##3986C4", "vertical")>

<!--- apply a plastic look effect --->
<cfset button = effects.ApplyPlasticEffect(button)>

<!--- apply rounded corners effect --->
<cfset effects.ApplyRoundedCornersEffect(button)>

<!--- draw the word Button on the picture --->
<cfset textOptions = StructNew()>
<cfset textOptions.size = "14">
<cfset textOptions.font = "Verdana">
<cfset textOptions.style="bold">
<cfset ImageSetAntialiasing(button, "on")>
<cfset ImageSetDrawingColor(button, "white")>
<cfset ImageDrawText(button, "Button", 15, 20, textOptions)>

<!--- add a reflection effect --->
<cfset button = effects.applyReflectionEffect(button)>

<!--- write the image to the browser --->
<cfset ImageWrite(button, ExpandPath("Images/plastic-button-effect-example.png"))>
<cfcontent  type="image/png" file="#ExpandPath("Images/plastic-button-effect-example.png")#">
