
<cfparam name="url.latitude"         default="">
<cfparam name="url.longitude"        default="">

<cfparam name="attributes.scope"     default="embed">
<cfparam name="attributes.script"    default="yes">
<cfparam name="attributes.mode"      default="edit">
<cfparam name="attributes.width"     default="400">
<cfparam name="attributes.height"    default="300">
<cfparam name="attributes.latitude"  default="#url.latitude#">
<cfparam name="attributes.longitude" default="#url.longitude#">
<cfparam name="attributes.country"   default="">
<cfparam name="attributes.city"   	 default="">
<cfparam name="attributes.address" 	 default="">
<cfparam name="attributes.format"    default="map">
<cfparam name="attributes.zoomlevel" default="15">

<cf_mapscript scope = "#attributes.scope#"
              mode  = "#attributes.mode#"
			  width = "#attributes.width#" 
			  height= "#attributes.height#">

<cfoutput>

<table width="#attributes.width+4#" height="#attributes.height+40#">
	 
</cfoutput>
	
<tr>
	<td height="100%" id="mapcontent" align="center">
	
			
	<cfset url.longitude = attributes.longitude>
	<cfset url.latitude  = attributes.latitude>
	<cfset url.country   = attributes.country>
	<cfset url.city      = attributes.city>
	<cfset url.address   = attributes.address>
	<cfset url.mode      = attributes.mode>
	<cfset url.width     = attributes.width>
	<cfset url.height    = attributes.height>
	<cfset url.scope     = attributes.scope>
	<cfset url.format    = attributes.format>
	<cfset url.zoomlevel = attributes.zoomlevel>
		
		
	<cfinclude template="MapContent.cfm">

	</td>
</tr>

<!---
	
<cfif attributes.mode eq "edit">	
	
	<tr>
			<td height="20" align="center">
			<table cellspacing="0" cellpadding="0" class="formspacing">
			<tr>				
			<td><a href="javascript:mapaddress()" class="labelit"><font color="#0080C0"><cf_tl id="Show Address"></a></td>	
			<td>&nbsp;|&nbsp;</td>
			<!---
			<td><a href="javascript:mapzip()">Show Postal Code</a></td>
			<td>&nbsp;|&nbsp;</td>
			--->
			<td><a href="javascript:mapcoord()" class="labelit"><font color="#0080C0"><cf_tl id="Show Coordinates"></a></td>		
			</tr>
			</table>
			</td>
	</tr>

</cfif>	

--->

</table>	
