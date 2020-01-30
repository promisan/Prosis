
<cfoutput>

<cfajaximport tags="cfwindow">

<cfparam name="url.id" default="">
<cfparam name="url.id1" default="">
<cfparam name="url.id2" default="">
<cfparam name="url.id3" default="">
<cfparam name="url.id4" default="">
	
	<table style="width:100%;height:99%">
	
	<tr>
	<td style="width:100%;height:100%" valign="top">
	
		<iframe src="#session.root#/System/Access/Lookup/UserSearchSelect.cfm?Form=#URL.Form#&ID=#URL.Id#&ID1=#URL.ID1#&ID2=#URL.ID2#&ID3=#URL.ID3#&ID4=#URL.ID4#" name="result" id="result" scrolling="yes" frameborder="0" style="width:100%;height:100%"></iframe>
	
	</td>
	</tr>
	
	</table>
	
</cfoutput>


