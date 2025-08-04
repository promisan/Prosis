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

<cf_screentop eight="100%" scroll="yes" html="No" jQuery="Yes" menuaccess="context">

<cfparam name="url.ID"   default="Per">
<cfparam name="url.ID1"  default="">
<cfparam name="url.ID2"  default="">

<cfif URL.ID eq "Loc">
	<cfset down = "hide">
	<cfset up   = "regular">	
<cfelse>
	<cfset down = "regular">
	<cfset up   = "hide">
</cfif>	

<cfoutput>

<cf_divscroll>

<!--- Search form --->
	
	<table width="96%" height="100%" cellspacing="0" cellpadding="0" align="center">
	
	<tr><td colspan="2">
		
	<cfset openmode = "show">
	
	<cfset _ID		= URL.ID>
	<cfset URL.ID	= URL.ID1> <!--- PersonNo --->
	<cfinclude template="../../../../Staffing/Application/Employee/PersonViewHeaderToggle.cfm">
	<cfset URL.ID = _ID>
		
	</td></tr>
	
	<tr class="labelmedium" onclick="maximize('locate')" style="cursor: pointer;">
	<td height="21">&nbsp;
	<img src="#SESSION.root#/images/filter.gif" alt="" border="0" align="absmiddle">
	&nbsp;<cf_tl id="Filter"></td>
	
	<td align="right" style="padding-right:4px">
		<img src="#SESSION.root#/images/up6.gif" 
		    id="locateMin"
			name="locateMin"
		    alt=""
			border="0" style="cursor: pointer;"
			class="#up#">
		<img src="#SESSION.root#/images/down6.gif" 
		    alt="" style="cursor: pointer;"
			id="locateExp"
			name="locateExp"
			border="0" 
			class="#down#">			
	</td>
	</tr>		
		
	<!--- retrieve the mission --->
	
	<cfif PersonAssignment.Mission eq "">
		
		<tr><td style="height:100%" colspan="2" align="center" class="labelmedium"><cf_tl id="No assignment found"></td></tr></table>	
				
	<cfelse>
	
		<cfset url.mission = PersonAssignment.Mission>
		
		<cfinclude template="ControlScript.cfm">
		<cfinclude template="ControlListPrepare.cfm">
		
		<tr><td colspan="2" height="1" class="linedotted"></td></tr>
		<tr id="locate" name="locate" class="#up#"><td colspan="2">		
			<cfinclude template="ControlListFilter.cfm"> 
		</td></tr>
		<tr id="locate" name="locate" class="#up#">
		   <td class="linedotted" colspan="2" height="1" ></td></tr>
		
		<tr><td colspan="2" valign="top" height="100%">
		
			<cfdiv id="listing" 
			        bind="url:ControlListData.cfm?ID=#URL.ID#&ID1=#URL.ID1#&ID2=#URL.ID2#"/>
		
		</td></tr>
		
	</cfif>	
	
	</table>

</cf_divscroll>

</cfoutput>

	