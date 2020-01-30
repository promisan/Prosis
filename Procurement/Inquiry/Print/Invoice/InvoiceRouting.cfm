<cfset actionform = 'MarkDown'>

<cfoutput>
<cfif not DirectoryExists("#SESSION.rootPath#CFRStage\user\#SESSION.acc#\")>

	   <cfdirectory 
	     action="CREATE" 
            directory="#SESSION.rootPath#CFRStage\user\#SESSION.acc#\">

</cfif>

<cfset FileNo = round(Rand()*100)>
<cfset attach = "SlipReport_#FileNo#.pdf">

	<cfreport 
	   template     = "Routing.cfr" 
	   format       = "pdf" 
	   overwrite    = "yes" 
	   encryption   = "none"
	   filename     = "#SESSION.rootPath#CFRStage\user\#SESSION.acc#\#attach#">
			<cfreportparam name = "ID"  value="#Object.ObjectKeyValue4#"> 
	</cfreport>	

<table border="0" cellpadding="0" cellspacing="0" width="100%">

<tr><td height="1" colspan="2" bgcolor="d4d4d4" align="center"><b>Routing Slip Invoicing Procedure</b></td></tr>	

<TR>
	<td align="center"><br><br><br><br>
	Please as last step, open up the Slip Invoicing Procedure for the invoice as a <img src="#SESSION.root#/Images/pdf_1.JPG" alt="Print out of routing slip invoicing procedures" border="0">
	<a href="#SESSION.root#/CFRStage/user/#SESSION.acc#/#attach#" target="_blank">
	<b>PDF file and Print it</b></a>
	<br><br><br><br><br><br>
 	</td>
</tr>
</table>

	
</cfoutput>

