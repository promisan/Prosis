<cfset sourceImage = ImageRead(ExpandPath("Images/spendfish.png"))>

<cfparam name="url.backgroundColor" default="white" type="regex" pattern="[A-Za-z0-9##]+">	

<cfinvoke component="CFImageEffects" method="init" returnvariable="effects">

<cfset roundedImage = effects.applyRoundedCornersEffect(sourceImage, url.backgroundColor, 20)>

<cfimage action="WRITETOBROWSER" source="#roundedImage#" format="PNG">

<!---
<cfset ImageWrite(roundedImage, ExpandPath("images/rounded-corners-example.png"))>
<cfcontent  type="image/png" file="#ExpandPath("images/rounded-corners-example.png")#">
--->