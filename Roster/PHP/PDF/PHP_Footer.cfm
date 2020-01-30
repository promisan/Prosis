<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />		
	<style type="text/css">
		td.footer {
			font-size : 7pt;
		}
	</style>
	
</head>
	<cfoutput>
	<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">

	<tr>
		<td width="2%"></td>
		<td class="footer" width="71%" align="left">PHP for #Applicant.FirstName# #UCase(Applicant.LastName)# (#Applicant.SubmissionSource#) Ref. #Applicant.SourceOrigin# <cfif prefix neq "">- #qFunction.ReferenceNo# </cfif>
		 <cfif prefix neq "">Submitted PHP</cfif>	
	</td>
		<td class="footer" align="right">
			#cfdocument.currentpagenumber# of #cfdocument.totalpagecount#
		</td>
		<td width="2%"></td>
	</tr>	
	</table>
	</cfoutput>

