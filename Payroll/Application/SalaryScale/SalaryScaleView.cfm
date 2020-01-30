
<cfoutput>

<!--- not needed
<cf_screentop height="100%" user="no" layout="webapp" banner="gray" scroll="Yes" title="Salary Schedule and Grade" label="Select: <b>Salary Scale">
--->

<table width="100%" height="99%" cellspacing="0" cellpadding="0">
	<tr><td height="100%" width="320">
	<iframe src="#session.root#/Payroll/Application/SalaryScale/SalaryScaleTree.cfm?contractid=#url.contractid#"
        width="100%"
        height="99%"
        scrolling="no"
        frameborder="0">
	</iframe>
	</td>
	
	<td height="100%" style="border-left: 1px solid gray;padding:10px">
	<iframe width="100%"
        height="99%"
		name="scaleright" id="scaleright"
        scrolling="no"
        frameborder="0"></iframe>
	</td>
	</tr>
</table>

</cfoutput>

<cf_screenbottom layout="webapp">

