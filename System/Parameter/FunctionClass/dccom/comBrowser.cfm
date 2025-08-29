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
<cfparam name="action" default="writeFrames">
<cfswitch expression="#action#">

	<cfcase value="writeFrames">
		<html>
		<head>
			<title>dcCom Browser</title>
		</head>
		<frameset name="mainframe" rows="20,*">
			<frame name="chooseFrame" src="comBrowser.cfm?action=header" frameborder="1" bordercolor="#202020">
			<frameset name="mainframe" cols="200,*">
				<frame name="chooseFrame" src="comBrowser.cfm?action=chooseCom">
				<frame name="viewFrame" src="comBrowser.cfm?action=viewCom">
			</frameset>
		</frameset>
		</html>
	</cfcase>
	
	<cfcase value="stylesheet">
	body{margin:0px;}
	body,td{font-family:verdana,arial;font-size:11px;}
	a{color:#101010;text-decoration:none;}
	a:hover{color:#1010FF;}
	.notSelDiv{
		border-left:1px solid buttonface;
		border-top:1px solid buttonface;
		border-right:1px solid buttonface;
		border-bottom:1px solid buttonface;
		background-color:buttonface;
		color:buttonshadow;
		cursor:pointer;}
	.selDiv{
		border-left:1px solid #202020;
		border-top:1px solid #202020;
		border-right:1px solid white;
		border-bottom:1px solid white;
		background-color:buttonshadow;
		color:buttonhighlight;
		cursor:pointer;}
	.highDiv{
		border-left:1px solid white;
		border-top:1px solid white;
		border-right:1px solid #202020;
		border-bottom:1px solid #202020;
		background-color:buttonface;
		color:buttonshadow;
		cursor:pointer;}
	.numClass{border-right:1px solid #202020;border-bottom:1px solid #202020;}
	</cfcase>

	<cfcase value="header">
	<html><head><link rel="stylesheet" media="screen" type="text/css" href="comBrowser.cfm?action=stylesheet"></head>
	<body style="margin:1px;padding:1px;background-color:buttonshadow;color:buttonhighlight;border-top:1px solid white;font-weight:bold;padding-left:10px;">
		dcCom Browser V1.0
	</body>
	</html>
	</cfcase>
	
	<cfcase value="chooseCom">
	<html><head><link rel="stylesheet" media="screen" type="text/css" href="comBrowser.cfm?action=stylesheet">
	<script language="JavaScript1.2" defer>
	var selTd=null;
	function resetComButtons(){if(selTd!=null) selTd.className = "notSelDiv";}
	function viewCom(td,com)
	{
		if(selTd!=null)selTd.className = "notSelDiv";
		top.viewFrame.document.location.href="comBrowser.cfm?action=viewCom&comName="+com;
		selTd = td;
		selTd.className = "selDiv";
	}
	function glow(td){if(td!=selTd)td.className="highDiv";}
	function dull(td){if(td!=selTd)td.className="notSelDiv";}
	</script>
	</head>
	<body style="padding-top:10px;padding-left:10px;background-color:buttonface;color:buttontext;border-left:1px solid white;border-top:1px solid white;border-right:1px solid black;border-bottom:1px solid black;">
		
		<cfdirectory name="comList" action="list" directory="#GetDirectoryFromPath(GetBaseTemplatePath())#components\">

		<cfset comCount = 0>
		<cfloop query="comList">
			<cfif Type EQ "Dir" AND Name NEQ "." AND Name NEQ ".." AND Name NEQ "TEMPLATE">
				<cfset comCount = comCount + 1>
			</cfif>
		</cfloop>
		
		<cfoutput>#comCount#</cfoutput> components installed.<br><br>
		
		<table width="100%" border="0" cellpadding="0" cellspacing="0" class="formpadding">
		<cfset comCount = 0>
		<cfoutput query="comList">
			<cfif Type EQ "Dir" AND Name NEQ "." AND Name NEQ ".." AND Name NEQ "TEMPLATE">
				<cfset comCount = comCount + 1>
				<tr>
					<td class="notSelDiv" onMouseOver="glow(this)" onMouseOut="dull(this)" onClick="viewCom(this,'#JSStringFormat(name)#')"><span style="width:20">#comCount#.</span>#name#</td>
				</tr>
			</cfif>
		</cfoutput>
		</table>
		<br><br>
		<a href="http://www.digital-crew.com/dccom/" target="_top" onClick="resetComButtons()"> About dcCom</a> <a href="http://www.digital-crew.com/dccom/library/" target="_blank" title="New Window">&raquo;</a><br><br>
		<a href="http://www.digital-crew.com/dccom/Index.cfm?action=gallery" target="_top" onClick="resetComButtons()"> Component Gallery</a> <a href="http://www.digital-crew.com/dccom/library/" target="_blank" title="New Window">&raquo;</a><br>
	</body>
	</html>
	</cfcase>

	<cfcase value="viewCom">
	<html><head><style>body,td{font-family:Courier New,verdana,arial;font-size:8pt;}</style></head>
	<body style="margin:0px;padding:10px;background-color:white;">
	<cfif isdefined("comName")>

		<cfset useMainCFM = FALSE>
		
		<cfif fileExists( "#GetDirectoryFromPath(GetBaseTemplatePath())#/components/#comName#/info.html" )>
			<cflocation addtoken="No" url="components/#comName#/info.html">
		<cfelse>
			<cfset documentation = "">
			<!--- Get documentation --->
			<cffile action="READ" file="#GetDirectoryFromPath(GetBaseTemplatePath())#/components/#comName#/main.cfm" variable="mainFile">
			<!--- Extract Header Comment From File --->
			<cfset startComment = Find("<" & "!--",mainFile)+4>
			<cfloop condition="Mid(mainFile,startComment,1) EQ '-'"><cfset startComment = startComment + 1></cfloop>
			<cfif startComment NEQ -1>
				<cfset endComment = Find("-" & "-->",mainFile,startComment+1)-1>
				<cfif endComment NEQ -1>
					<cfloop condition="endComment GT 1 AND Mid(mainFile,endComment,1) EQ '-'"><cfset endComment = endComment - 1></cfloop>
					<cfset documentation = Mid(mainFile, startComment, EndComment - startComment)>
					<cfset documentation = Replace( documentation, chr(9), "    ", "ALL" )>
					Documentation for Component <cfoutput>#comName#</cfoutput><hr size=1 color=#202020>
					<pre><cfoutput>#HTMLEditFormat(Trim(documentation))#</cfoutput></pre>
				</cfif>
			</cfif>
			
			<cfif documentation EQ "">
				No data available
			</cfif>
		
		</cfif>

	<cfelse>
		<div align="center" style='padding-top:40px;font-family:"Trebuchet Ms",sans-serif;font-size: 50pt;'>
		dcCom Browser
		</div>
		<div align="center" style="font-family:verdana;font-size:12px;">Select a component to view its build-in documentation</div>
	</cfif>	
	</body>
	</html>
</cfcase>

</cfswitch>
