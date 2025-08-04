<!--
    Copyright © 2025 Promisan

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->
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

