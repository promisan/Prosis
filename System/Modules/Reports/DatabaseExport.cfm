<!--
    Copyright © 2025 Promisan B.V.

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
<cfparam name="URL.mode" default="Export">

<cfquery name="report" 
 	 datasource="appsSystem">
		   SELECT   * 
		   FROM     Ref_ReportControl 
		   WHERE    ControlId = '#URL.ID#'
</cfquery>

<HTML><HEAD>

<TITLE>Report definition - database script</TITLE>

<script language="JavaScript">

	function execute(m) {
		lval = (<cfoutput>#CLIENT.width#</cfoutput>-200) / 2;
		tval = (<cfoutput>#CLIENT.height#</cfoutput>-200) / 2;	
	
		if (confirm("Do you want to execute the query below? It will create a non-operational report named <cfoutput>'#Report.FunctionName#(Replica)' pointing to the directory '#Replace(Left(Report.ReportPath,Len(Report.ReportPath)-1),'\','\\','all')#(Replica)\\'</cfoutput>")) {
	     window.open("DatabaseExportFile.cfm?id=<cfoutput>#URL.ID#</cfoutput>&mode="+m+"&execute=yes","runwindow","width=200, height=200, toolbar=no, scrollbars=no, resizable=no, left="+lval+",top="+tval)
		} 
	}
	
	function sendToClipboard() {
		var s=document.getElementById('textespan').innerHTML
		var vText = s.replace(/<br\s*\/?>/mg,"\n");
		var vText = vText.replace(/<[b|B][r|R]\s*\/?>/mg,"\n");				
		if( window.clipboardData && clipboardData.setData )	{
			clipboardData.setData("Text", vText);
			alert("Script for '<cfoutput>#URL.mode#</cfoutput>' operation has been moved into your clipboard");
		} else {
			alert("This function is only IE compatible");
		}
	}
	
</script> 		

<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>"> 
	<style type="text/css">

	td.continous {
		border-bottom: solid 1px #000000;
		padding: 0px 0 0px 0		

	}
	
	td.label_blue {
			font-family:"Verdana",Times,serif;
			font-size : 7.5pt;
			font-weight:bold;
			color: blue;
	}
		
	td.small {
			font-family:"Verdana",Times,serif;
			font-size : 7pt;
	}
		
	td.label_red {
			font-family:"Verdana",Times,serif;
			font-size : 7.5pt;
			font-weight:bold;
			color: red;
	}	

</style>

</HEAD>

<body leftmargin="0" topmargin="0" rightmargin="0" bgcolor="FfFfFf" onLoad="window.focus()">

<cfoutput>

<table width="100%" height="100%" cellspacing="0" cellpadding="0" class="formpadding">

<cfswitch expression="#URL.mode#">
	
	<cfcase value="Export">
		
		<tr>
		<td bgcolor="##C0D8F8" height="20">
		&nbsp;&nbsp;Transfering to another server <img src="#SESSION.root#/Images/export2.gif" align="absmiddle" alt="" border="0">
		</td>
		</tr>
		
		<tr>
		<td height="20">
			<table width="100%">
			<tr>
			<tr><td width="1%">&nbsp;<img src="#SESSION.root#/Images/rexport.png" align="absmiddle" alt="" border="0"></td><td class="labelmedium" colspan="2">&nbsp;Copy and paste the below script into Query analyser to transfer the report definitions to another DB server.</td></tr>						
			
			<tr><td></td><td width="15%" class="label_blue">&nbsp;System Module:</td>
			             <td class="labelmedium">#Report.SystemModule#</td></tr>
			<tr><td></td><td width="15%" class="label_blue">&nbsp;Owner:</td>
			             <td class="labelmedium">#Report.Owner#</td></tr>
			<tr><td></td><td width="15%" class="label_blue">&nbsp;Function Class:</td>
			             <td class="labelmedium">#Report.FunctionClass#</td></tr>
			<tr><td></td><td width="15%" class="label_blue">&nbsp;Function Name:</td>
			             <td class="labelmedium">#Report.FunctionName#</td></tr>
			<tr><td></td><td width="15%" class="label_blue">&nbsp;ReportPath:</td>
			             <td class="labelmedium">#Report.ReportPath#</td></tr>		
			</table>
		</td>
		</tr>
		
	</cfcase>

	<cfcase value="Replica">
		<tr>
		<td class="labelmedium" bgcolor="##C0D8F8" height="20">
		&nbsp;&nbsp;Create a report replica <img src="#SESSION.root#/Images/deploy.gif" align="absmiddle" alt="" border="0">
		</td>
		</tr>
		<tr>
		<td height="20">
			<table width="100%">
			<tr>
			<tr><td width="1%">&nbsp;<img src="#SESSION.root#/Images/duplicate.png" align="absmiddle" alt="" border="0"></td><td colspan="2">&nbsp;The following script will create a replica of the following report:</td></tr>						
			<tr><td></td><td width="15%" class="label_blue">&nbsp;System Module:</td><td> #Report.SystemModule#</td></tr>
			<tr><td></td><td width="15%" class="label_blue">&nbsp;Owner:</td><td> #Report.Owner#</td></tr>
			<tr><td></td><td width="15%" class="label_blue">&nbsp;Function Class:</td><td> #Report.FunctionClass#</td></tr>
			<tr><td></td><td width="15%" class="label_blue">&nbsp;Function Name:</td><td> #Report.FunctionName#</td></tr>
			<tr><td></td><td width="15%" class="label_blue">&nbsp;ReportPath:</td><td> #Report.ReportPath#</td></tr>				
			<tr height="35"><td>&nbsp;<img src="#SESSION.root#/Images/cloned.png" align="absmiddle" alt="" border="0"></td><td colspan="2">&nbsp;All parent values will be set to NULL and the resulting report will be no operational (Operational = 0), the new report will be named as follows</td></tr>						
			<tr><td></td><td width="15%" class="label_red">&nbsp;System Module:</td><td> #Report.SystemModule#</td></tr>
			<tr><td></td><td width="15%" class="label_red">&nbsp;Owner:</td><td> #Report.Owner#</td></tr>
			<tr><td></td><td width="15%" class="label_red">&nbsp;Function Class:</td><td> #Report.FunctionClass#</td></tr>
			<tr><td></td><td width="15%" class="label_red">&nbsp;Function Name:</td><td> #Report.FunctionName#(Replica)</td></tr>
			<tr><td></td><td width="15%" class="label_red">&nbsp;ReportPath:</td><td> #Left(Report.ReportPath,Len(Report.ReportPath)-1)#(Replica)\</td></tr>						
			<tr height="35"><td colspan="2"></td><td>&nbsp;<a href="javascript:execute('Replica')">&nbsp;<img src="#SESSION.root#/Images/runscript.png" align="absmiddle" alt="" border="0">&nbsp;&nbsp;Run this script</a></td></tr>								
			</table>
		</td>
		</tr>
	
	</cfcase>
	
</cfswitch>

<tr><td class="line"></td></tr>
<tr><td style="padding-left:10px" height="10" class="small"><a href="##" onclick="sendToClipboard()"><font color="0080C0"><img src="#SESSION.root#/images/clipboard.png" align="absmiddle" alt="Get script into clipboard" border="0">&nbsp;&nbsp;<u>Copy Script to Clipboard</a></td></tr>

<tr>
<td>
	<table width="100%">
	<tr>
	<td width="750" align="center">
	<cfif url.mode eq "Export">
		<cfset vheight="650">
	<cfelse>
		<cfset vheight="502">
	</cfif>
   <div ID='textespan' style="position:relative;width:795;height:#vheight#; overflow: auto; scrollbar-face-color: F4f4f4;">
			<cfinclude template="DatabaseExportFile.cfm">
	</div>	
	</td>
	</tr>
	</table>
</td>

</tr>

</table>
</cfoutput>


</body>