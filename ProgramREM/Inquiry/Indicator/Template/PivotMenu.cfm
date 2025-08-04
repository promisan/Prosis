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

<cfset client.ProgramDetail = "pivot">
<cfparam name="url.print" default="0">

<cfif url.print eq "0">
	
	<table align="right"><tr><td>
	
	<cfmenu 
	    name="notemenu"
	    font="verdana"
	    fontsize="14"
	    bgcolor="f4f4f4"
	    selecteditemcolor="C0C0C0"
	    selectedfontcolor="FFFFFF">
		
	<cfmenuitem 
	   display="Listing"
	   name="pivot"
	   href="javascript:list('listing')"
	   image="#SESSION.root#/Images/list.gif"/>	
		
	<cfmenuitem 
	   display="Summary"
	   name="summarysub"
	   href="javascript:inspect('sub')"
	   image="#SESSION.root#/Images/overview1.gif"/>
	   
	<cfmenuitem 
	   display="Print"
	   name="print"
	   href="javascript:printdetail('#url.item#','#URL.Select#','pivot')"
	   image="#SESSION.root#/Images/print.gif"/> 				
	
	</cfmenu>	
	
	</td></tr></table>

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

