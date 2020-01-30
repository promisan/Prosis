<cfset sourceImage = ImageRead(ExpandPath("Images/spendfish.png"))>

<cfparam name="url.backgroundColor" default="white" type="regex" pattern="[A-Za-z0-9##]+">	

<cfinvoke component="CFImageEffects" method="init" returnvariable="effects">

<cfset reflectedImage = effects.applyReflectionEffect(sourceImage, url.backgroundColor, 60)>

<cfset ImageWrite(reflectedImage, ExpandPath("Images/reflection-example-#url.backgroundColor#.png"))>
<cfcontent  type="image/png" file="#ExpandPath("images/reflection-example-#url.backgroundColor#.png")#">

