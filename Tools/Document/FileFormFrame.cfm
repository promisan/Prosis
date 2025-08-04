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

<!---

<HTML><HEAD>
    <TITLE>Attach document</TITLE>
</HEAD><body bgcolor="ffffff" leftmargin="0" topmargin="0" rightmargin="0" bottommargin="0">
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

--->

<cf_screentop html="No" jquery="Yes">

<cfajaxproxy cfc="Service.Process.System.UserController" jsclassname="systemcontroller">

<script language="JavaScript">

function checkfile() {

	var uController = new systemcontroller();			
	document.attach.action = document.attach.action + '&mid='+ uController.GetMid();
		
	if (document.attach.uploadedfile.value == "") {
	   alert("You must select a file to upload.")
	   return false }
	   
	}
</script>

<cfparam name="url.mode"    default="attachment">

<CFFORM name="attach" 
    action="FileFormSubmit.cfm?dialog=0&inputsize=#URL.inputsize#&mode=#url.mode#&Box=#URL.Box#&host=#url.host#&DIR=#URL.DIR#&ID=#URL.ID#&ID1=#URL.ID1#&reload=#URL.reload#" 
	method="post" 
	style="border:0px;padding:0px"
	enctype="multipart/form-data" 
	onSubmit="return checkfile()">
			
	<input type="hidden" name="DocumentServerPath" id="DocumentServerPath" value="" size="50" readonly>
				
	<table width="100%" cellspacing="0" cellpadding="0" style="padding:0px;">	
	
	<TR>
		<TD width="90%" align="left" style="padding-left:20px;padding-top:3px">
			<cfinput type="file" name="uploadedfile" style="border:0px; height:30px; width:100%;" class="regularxl">	
		</TD>
		<td style="padding-left:1px;padding-right:2px;padding-top:2px">	
		    
			<button type="submit"  value="Attach File" style="font-size:14px;width:120;height:28" class="button10g">
			 <cf_tl id="Attach">
			</button>		
			<input type="hidden" name="serverfile" id="serverfile">
						
		</TD>
	</TR>
	
	</table>
	
</CFFORM>

<!---

</BODY></HTML>

--->