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

<cfoutput>

<table width="100%" cellspacing="0" cellpadding="0">

<cfquery name="Template" 
	datasource="appsControl">
	SELECT   *
	FROM     Ref_TemplateContent
	WHERE    ObservationId  = '#url.observationid#'
	AND      ActionCode     = '#URL.actionCode#'
	AND      PathName       = '#URL.PathName#' 
	AND      FileName       = '#URL.FileName#'	
</cfquery>
		
<cfif template.recordcount eq "0">

  <tr><td class="labelit" class="linedotted" align="center"><b>No history found</td></tr>

<cfelse>  
	
	<!---
	<tr bgcolor="white">
	    <td></td>
		<td><b>Modified on</td>
		<td><b>Officer</b></td>
		<td><b>Size</td>	
	</tr>
	--->
					
		<cfloop query="Template">
		
			<tr bgcolor="ffffcf" class="labelit">
			    <td width="20" align="center" style="padding-right:4px">
				<img src="#SESSION.root#/Images/pointer.gif" alt="" align="absmiddle" border="0">
				</td>
				<td width="100" class="labelit">
				<cfif find(".cfr",filename)>
					#dateFormat(TemplateModified,CLIENT.DateFormatShow)# #timeFormat(TemplateModified,"HH:MM")#
				<cfelse>
					<a href="javascript:templatedetail('#TemplateId#','prior')" title="Retrieve template details">
					  #dateFormat(TemplateModified,CLIENT.DateFormatShow)# #timeFormat(TemplateModified,"HH:MM")#
					</a>
				</cfif>
					
				</td>
				<td width="120" class="labelit">#TemplateModifiedBy#</td>
				<td width="80" class="labelit">#numberformat(TemplateSize/1024,"_._")# kb</td>
				<td class="labelit">#TemplateComments#</td>
			</tr>
			
		</cfloop>
		
	</tr>

</cfif>

</table>

</cfoutput>

