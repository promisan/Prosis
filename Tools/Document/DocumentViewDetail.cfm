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



<head>
	<style>
		body, html {
			width:100%;
			height:100%;
			padding:0px;
			margin:0px;
		}
		.label {
			font-family:Calibri,Trebuchet MS, Helvetica;
			color:#454545
		}
		.labellarge {
			font-size:20px;
			font-weight:bold;

		}
		.linedotted {
			height:1px;
			border-top:1px dotted silver;
		}
	</style>
	<cf_systemscript>
	
	
</head>


	<body style="overflow:hidden">
		<cfoutput>
		
		<cfparam name="URL.dir" default="">
		<cfparam name="URL.sub" default="">
		<cfparam name="URL.name" default="">
		
		<cfif url.mode eq "Report">
			<cfset rt = "">	
		<cfelse>
			<cfset rt = "#SESSION.rootDocument#/">
		</cfif>		
		
		<!--- correct the passing of the path --->
		<cfset dir = replaceNoCase(url.dir,"|","\","ALL")> 	
		
		  <cfquery name="Attachment" 
				 datasource="AppsSystem"
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">
			     SELECT    TOP 1 *
				 FROM      Attachment
				 WHERE     Reference = '#url.sub#' 
				 AND       FileName = '#Name#'						
				 ORDER BY Created DESC
		</cfquery>
		
		<cfif Attachment.server eq "documentserver" or Attachment.server eq "document">
			<cfset rt = session.rootdocument>
		<cfelse>
			<cfset rt = attachment.server>
		</cfif>
		

		<table width="100%" height="100%" border="0" style="padding:4px" align="center" cellpadding="0" cellspacing="0">
			<tr>
				<td class="label labelarge" colspan="2" style="padding-left:4px;height:34">
					<b>#url.name#</b> : #Attachment.AttachmentMemo#
				</td>
			</tr>
			<tr><td colspan="2" class="linedotted"></td></tr>
			<tr>
				<td class="label" style="padding-left:4px; background-color:##ffffcf; height:21px">
					Recorded by: <b>#Attachment.OfficerFirstName# #Attachment.OfficerLastName#</b> on <b>#dateformat(Attachment.Created,CLIENT.DateFormatShow)# - #timeformat(Attachment.Created,"HH:MM:SS")#</b>
				</td>
				<td style="width:50px; background-color:##f3f3f3; cursor:pointer" class="label" onclick="window.print()" align="center">
					Print
				</td>
			</tr>
			<tr><td colspan="2" class="linedotted"></td></tr>
			
			<tr>
				<td height="100%" colspan="2">
		
					<cfif url.name neq "">
					
					<cffile action="COPY" 
						source="#rt##dir#\#url.sub#\#url.name#" 
	    		    	destination="#SESSION.rootPath#\CFRStage\User\#SESSION.acc#\#url.name#" 
						nameconflict="OVERWRITE">
		
					<iframe src="#SESSION.root#/CFRStage/User/#SESSION.acc#/#url.name#"
		        		name="right"
			       		id="right"
		    	    	width="100%"
			        	height="100%"
						style="overflow:hidden"
		    	    	frameborder="0">
					</iframe>

					</cfif>			
					
				</td>
			</tr>
		</table>	

		
		</cfoutput> 
	
	
	</body>




