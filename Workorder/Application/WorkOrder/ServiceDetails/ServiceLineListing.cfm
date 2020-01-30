
<!--- container for the service workorder lines to be shown --->

<!--- Removed by Armin on 9/6/2013 due to flickering issues on IE 10 --->

<cfparam name="url.ref"       default="">
<cfparam name="url.domain"    default="">

<cf_screentop html="No">

<cfajaximport tags="cfdiv,cfwindow,cfform">

<table width="100%" height="100%" style="padding:6px">
    <tr>
	    <td class="labelmedium"></td>
	</tr>
	<tr>
		<td>
		<cfdiv bind="url:ServiceLineListingContent.cfm?systemfunctionid=#url.systemfunctionid#&workorderid=#url.workorderid#&ref=#url.ref#&domain=#url.domain#">
		</td>
	</tr>
</table>


