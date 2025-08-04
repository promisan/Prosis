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
<cfparam name="url.filter"        default="">

<input type="hidden" name="selecteditem" id="selecteditem" value="">

<cfoutput>

<table width="100%" height="100%" cellspacing="0" cellpadding="0">
				
	<tr>
	
	<td valign="top">	
	
		<table width="100%" height="100%" cellspacing="0" cellpadding="0">
		
		<tr><td height="20" style="padding:2px" width="100%"><cfinclude template="NoteMenu.cfm"></td></tr>
												
		<tr><td height="20">
		
			<table width="100%" class="formpadding" cellspacing="0" cellpadding="0">
			<tr>
			<td width="95%" style="padding:5px">
			<input class="regularxl" type="text" name="filter" id="filter" style="width:100%" value="#url.filter#">
			</td>
			<td width="30" align="center" onclick="javascript:doSearch()">
				<cfoutput>
					<img src="#SESSION.root#/images/locate.gif" height="13" width="13" alt="" border="0">
				</cfoutput>
			</td>
			</tr>
			</table>
		
		</td></tr>
		
		<tr><td class="linedotted"></td></tr>
		
		<tr><td height="100%">
			 
			<cf_divscroll id="notecontainerdetail" overflowy="scroll">				
				<cfinclude template="NoteList.cfm">
			</cf_divscroll>
			
		</td></tr>
		</table>  
		
	</td>
	</tr>		
	
</table>

</cfoutput>

<cfset ajaxonload("enable_enter")>