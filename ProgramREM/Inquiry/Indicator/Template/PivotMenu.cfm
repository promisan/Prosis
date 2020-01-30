
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

