	
	<cfparam name="Attributes.TotalWidth"   default="884px">
	<cfparam name="Attributes.ContentWidth" default="850px">
	<cfparam name="Attributes.HeightSize"   default="">
	<cfparam name="Attributes.Path"         default="#SESSION.root#/Images/Mail">
	<cfparam name="Attributes.PathHeight"   default="#SESSION.root#/Images/Mail/Smaller">
	<cfparam name="Attributes.Height"       default="175px">
	
	<cfif Attributes.HeightSize eq "small">
		<cfset Attributes.PathHeight = "#SESSION.root#/Images/Mail/Smaller">
		<cfset Attributes.Height = "175px">
		
	<cfelseif Attributes.HeightSize eq "large">
		<cfset Attributes.PathHeight = "#SESSION.root#/Images/Mail">
		<cfset Attributes.Height = "275px">
		
	<cfelse>
		<cfset Attributes.PathHeight = "#SESSION.root#/Images/Mail">
		<cfset Attributes.Height = "100%">
	</cfif>
	<cfoutput>
	
	<cfif thisTag.ExecutionMode is "start">
		<table cellpadding="0" cellspacing="0" width="#Attributes.TotalWidth#" border="0" align="center">
			<tr>
				<td width="17px" height="17px"><img src="#Attributes.Path#/Border_top_left.png" alt="" border="0" width="17px" height="17px" style="display:block"></td>
				<td height="17px" width="#Attributes.ContentWidth#"><img src="#Attributes.Path#/Border_top.png" alt="" border="0" width="#Attributes.ContentWidth#" height="17px" style="display:block"></td>
				<td width="17px" height="17px"><img src="#Attributes.Path#/Border_top_right.png" alt="" border="0" width="17px" height="17px" style="display:block"></td>
			</tr>
			
			<tr>
				<td width="17px" height="#Attributes.Height#"><img src="#Attributes.PathHeight#/Border_left.png" alt="" border="0" width="17px" height="#Attributes.Height#"></td>
				<td width="#Attributes.ContentWidth#" height="#Attributes.Height#">	
			
	<cfelse>

				</td>
				<td width="17px" height="#Attributes.Height#"><img src="#Attributes.PathHeight#/Border_right.png" alt="" border="0" width="17px" height="#Attributes.Height#"></td>
			</tr>
				
			<tr>
				<td width="17px" height="17px"><img src="#Attributes.Path#/Border_bottom_left.png" alt="" border="0" width="17px" height="17px" style="display:block"></td>
				<td height="17px" width="#Attributes.ContentWidth#"><img src="#Attributes.Path#/Border_bottom.png" alt="" border="0" width="#Attributes.ContentWidth#" height="17px" style="display:block"></td>
				<td width="17px" height="17px"><img src="#Attributes.Path#/Border_bottom_right.png" alt="" border="0" width="17px" height="17px" style="display:block"></td>
			</tr>
		</table>
	</cfif>
	</cfoutput>
	