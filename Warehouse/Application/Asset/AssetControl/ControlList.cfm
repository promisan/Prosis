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
<cfparam name="ID" default="Loc">
<cfparam name="ID1" default="">
<cfparam name="ID2" default="">

<cfif URL.ID eq "Loc">
	<cfset down = "hide">
	<cfset up   = "regular">	
<cfelse>
	<cfset down = "hide">
	<cfset up   = "regular">
</cfif>	

<cfoutput>

<cf_screentop height="100%" scroll="Yes" html="No">


<!--- Search form --->
	
	<table width="99%" height="100%" align="center">
	
	<tr onclick="maximize('locate')" style="cursor:pointer">
	<td height="26" width="97%" class="labelmedium" style="font-weight:200;padding-left:6px">
	<cf_tl id="Filter"></td>
	<td align="right" style="padding-right:10px">
		<img src="#SESSION.root#/images/up6.png" 
		    id="locateMin"		  
			style="border: 0px solid Silver;cursor: pointer;"
			class="#up#">
		<img src="#SESSION.root#/images/down6.png" 		    
			id="locateExp"
			style="border: 0px solid Silver;cursor: pointer;"
			class="#down#">
	</td>
	</tr>
		
	<cfinclude template="ControlListPrepare.cfm">
		
	<tr><td colspan="2" class="line"></td></tr>
	<tr name="locate" id="locate" class="#up#"><td colspan="2">
	 	<cfinclude template="ControlListFilter.cfm"> 	
	</td></tr>
		
	<tr id="locate" class="#up#"><td class="line" colspan="2"></td></tr>
	
	<tr><td colspan="2" valign="top" height="100%">
	
	    <cf_divscroll id="listing">			
			<cfinclude template="ControlListData.cfm">			
		</cf_divscroll>		
	
	</td></tr>
	
	</table>


</cfoutput>

	