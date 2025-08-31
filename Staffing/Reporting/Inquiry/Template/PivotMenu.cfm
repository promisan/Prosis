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
<cfset client.ProgramDetail = "pivot">
<cfparam name="url.print" default="0">

<cfif url.print eq "0">
	
	<table align="right"><tr><td>
	
	<cf_tl id="Listing" var="1">
	<cf_button2 
		mode="icon" 
		image="Listing.png" 
		onclick="list('listing')" 
		text="#lt_text#" 
		title="#lt_text#" 
		width="90px;"
		onmouseover="this.style.backgroundColor='E0E0E0';"
		onmouseout="this.style.backgroundColor='';">

	</td>
	<td style="padding-right:5px">|</td>
	<td>

	<cf_tl id="Summary" var="1">
	<cf_button2 
		mode="icon" 
		image="Summary.png" 
		onclick="inspect('sub')" 
		text="#lt_text#" 
		title="#lt_text#" 
		onmouseover="this.style.backgroundColor='E0E0E0';"
		onmouseout="this.style.backgroundColor='';">

	</td>
	<td style="padding-left:5px; padding-right:5px">|</td>
	<td>

	<cf_tl id="Print" var="1">
	<cf_button2 
		mode="icon" 
		image="print_gray.png" 
		onclick="printdetail('#url.item#','#URL.Select#','pivot')" 
		text="#lt_text#" 
		title="#lt_text#" 
		onmouseover="this.style.backgroundColor='E0E0E0';"
		onmouseout="this.style.backgroundColor='';">	
	
	</td></tr>
	</table>

<cfelse>
	
		<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">
		<link href="<cfoutput>#SESSION.root#/print.css</cfoutput>" rel="stylesheet" type="text/css" media="print">
	
		<table width="100%">
	
		<tr>
		<td><cfinclude template="../../../Application/Indicator/Details/DetailViewBaseTop.cfm"></td>
		</tr>
		
		<tr><td>&nbsp;Filter : <b>#URL.Select#</b></td></tr>
	
		<script> print() </script>
		
		</table>
	
	</cfif>

