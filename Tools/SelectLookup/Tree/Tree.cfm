
<!---
<cf_screentop label="Search" option="Select Organization Unit" html="no" height="100%" scroll="Yes" layout="webdialog" banner="yellow" close="ColdFusion.Window.hide('dialog#url.box#')">
--->

<cf_screentop label="Search" height="100%" scroll="No" line="no" layout="webapp" banner="gray" close="ColdFusion.Window.hide('dialog#url.box#')">

<table align="center" bgcolor="FFFFFF" width="100%" height="100%">

<tr><td valign="top">
	
	<table width="96%" border="0" align="center" align="center">
					
		<tr>
			<td colspan="2" align="center" style="padding-top:5px">
			 <cfset url.mission  = url.filter1value>
			 <cfset url.mandate  = url.filter2value>		
			 <cfinclude template="TreeResult.cfm">		
			</td>
		</tr>
	
	</table>

</td></tr>

</table>
