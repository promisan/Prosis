<cfparam name="attributes.title1" 	default="">
<cfparam name="attributes.title2" 	default="">

<cf_tl id="#attributes.title1#" var="lblPart1"> 
<cf_tl id="#attributes.title2#" var="lblPart2"> 

<cfoutput>
	<table width="100%" cellspacing="0" cellpadding="0">
		<tr>
			<td style="font-size:14pt; font-face:Verdana; font-family:Verdana; padding-left:10px; height:32px; background-color:##0080FF; color:##FFFFFF;" valign="middle">
				#lblPart1#: #ucase(lblPart2)#
			</td>
		</tr>
		<tr><td height="20"></td></tr>
	</table>
</cfoutput>