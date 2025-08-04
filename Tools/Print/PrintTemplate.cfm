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

<cfparam name="attributes.docType"			default="<!DOCTYPE HTML PUBLIC '-//W3C//DTD HTML 4.01 Transitional//EN'>">
<cfparam name="attributes.meta"				default="<meta http-equiv='Content-Type' content='text/html; charset=iso-8859-1'>">
<cfparam name="attributes.stylesheet"		default="Custom/BCN/Warehouse/Invoice/InvoiceStyle.css">
<cfparam name="attributes.bodyOnLoad"		default="">

<cfset header = attributes.docType>
<cfset header = header & "<html> ">
<cfset header = header & "<head> ">
<cfset header = header & attributes.meta>
<cfset header = header & "<link rel='stylesheet' type='text/css' href='#SESSION.root#/#attributes.stylesheet#' media='print,screen' /> ">
<cfset header = header & "</he">

<cfset vBodyOnLoad = replace(attributes.bodyOnLoad,"'","\'","ALL")>
<cfset header2 = "ad> <body onload=""" & vBodyOnLoad & """>">

<cfset footer = "</body></html>">

<cfif thisTag.ExecutionMode is "start">
	
	<cfoutput>
	#attributes.docType#
	<html>
	<head>
		<title></title>
		#attributes.meta#
		
		<link rel='stylesheet' type='text/css' href='#SESSION.root#/#attributes.stylesheet#' media='print,screen' />
			
		<script>
		
			printPage = function () {
			
				var toPrint = document.getElementById('printingContent');
				
				var winPrint = window.open('','','left=0,top=0,width=1,height=1,toolbar=0,scrollbars=0,status=0');
				
				winPrint.document.write("#header#");
				winPrint.document.write('#header2#');
				winPrint.document.write(toPrint.innerHTML);
				winPrint.document.write("#footer#");
				winPrint.document.close();
				winPrint.focus();
				winPrint.print();
				winPrint.close();
				
			}
		</script>	
	</cfoutput>
		
	</head>
	
	<cfoutput>
		<body onload="#attributes.bodyOnLoad#">
	</cfoutput>
		
	<cfdiv id="dummy">
	
	<div id="reprint" align="right">
		<cfoutput>
			<img src="#SESSION.root#/images/print.png" onclick="printPage();" alt="Reprint this document" title="Reprint this document" style="cursor:pointer;">
		</cfoutput>
		&nbsp;
	</div>
	
	<div id="printingContent">
	
	<!--- tag direct content content goes here --->

<cfelse>
	
	</div>
	
	</body>
	</html>
	
	<!--- this triggers the function printpage upon loading --->
	<cfset AjaxOnLoad("printPage")>

</cfif>