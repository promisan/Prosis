<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />		
	<style type="text/css">
	
		body {
			width:100%;
		}

		table { 
			width:95%; 
			border:0px solid #D9D5BE; 
			margin:10px; 
			background:white; 
			border-collapse:collapse; 
		
		}		

		td {
			font-family:"Verdana",Times,serif;
			font-size : 11pt;
			text-align:justify;
		}

		td.title {
			font-family:"Verdana",Times,serif;
			font-size : 14pt;
			text-align:center;
			font-weight: bold;
		}
		
	</style>
	
</head>
<!--- GENERAL DETAILS --->
<!--- *************************************************************************** --->

<cfoutput>
<table border="0" align="center">
		
	<tr><td colspan="7" height="90px"align="center" class="title">Profiles included in this document</td>
	</tr>
	<tr>
	<td></td>
	<td>Name</td>
	<td>Index</td>
	<td align="center">DOB</td>
	<td align="center">Gender</td>
	<td align="center">Nationality</td>
	<td>EMail</td>
	</tr>
	<tr><td colspan = "7" bgcolor="333333"></td></tr>
		
	<cfloop query="URLQuery">

	<!--- Query returning detail information for selected item --->
	
	<tr>
	<td align="Right">#currentrow#.&nbsp;&nbsp;&nbsp;</td>
	<td>#UCase(Trim(LastName))#, #FirstName#</b></td>
	<td>#IndexNo#</b></td>
	<td align="center">#Dateformat(DOB, CLIENT.DateFormatShow)#</b></td>
	<td align="center">#Gender#</b></td>
	<td align="center">#Nationality#</b></td>
	<td>#eMailAddress#</b></td>
	</tr>
	
	<cfif ApplicantNo eq "">
		<td></td>
		<td colspan="6">&nbsp;&nbsp;***No Personal History Profile registered for #UCase(Trim(LastName))#, #FirstName#.  Profile is thus not included in output</td>
	</cfif>

	</cfloop>	
</table>
</cfoutput>