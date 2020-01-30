
<cfparam name="Attributes.radius"   default="100">
<cfparam name="Attributes.color"   default="0.5">

<cfoutput>

	<cfset vCenter = Attributes.radius + 3>
	<cfset vSize = vCenter * 2>
	<iframe src="#SESSION.root#/Tools/jsGraphics/graphSphere/iGraphSphere.cfm?radius=#Attributes.radius#&color=#Attributes.color#&center=#vCenter#&size=#vSize#" 
		width="#vSize#" 
		height="#vSize#" 
		marginwidth="0" 
		marginheight="0" 
		frameborder="0" 
		AllowTransparency>
	</iframe>
</cfoutput>