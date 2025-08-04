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
<cfparam name="url.code" default="">

<cfif trim(url.code) eq "">
	<cf_tl id="Add Section" var="1">
<cfelse>
	<cf_tl id="Edit Section" var="1">
</cfif>

<cf_screentop height="100%" 
              scroll="Yes" 
			  layout="webapp" 
			  label="#lt_text#" 
			  banner="blue"
			  jQuery="yes"
			  user="no">

<cfquery name="get" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	*
		FROM	PublicationCluster
		WHERE	PublicationId = '#url.publicationId#'
		<cfif trim(url.code) eq "">
		AND		1=0
		<cfelse>
		AND		Code = '#url.code#'
		</cfif>
</cfquery>

<cfform name="frmCluster" method="POST" onsubmit="return false;">
	<table width="96%" height="100%" align="center">
		<tr><td height="15"></td></tr>
		<tr>
			<td class="labelit"><cf_tl id="Code">:</td>
			<td>
				<cfif trim(url.code) eq "">
					<cfinput name="code" id="code" maxlength="10" size="5" required="Yes" message="Please, enter a valid code." class="regularxl">
				<cfelse>
					<cfoutput>
						#url.code#
						<input type="hidden" name="code" id="code" value="#url.code#">
					</cfoutput>
				</cfif>
			</td>
		</tr>
		<tr><td height="5"></td></tr>
		<tr>
			<td class="labelit"><cf_tl id="Description">:</td>
			<td>
				<cfinput 
					name="description" 
					id="description" 
					maxlength="50" 
					size="30" 
					value="#get.description#"
					required="Yes" 
					message="Please, enter a valid description." 
					class="regularxl">
			</td>
		</tr>
		<tr><td height="5"></td></tr>
		<tr>
			<td class="labelit"><cf_tl id="Order">:</td>
			<td>
				<cfinput 
					name="listingOrder" 
					id="listingOrder" 
					maxlength="3" 
					size="2" 
					required="Yes" 
					value="#get.listingorder#" 
					message="Please, enter a valid numeric order." 
					validate="integer" 
					class="regularxl" 
					style="text-align:center;">
			</td>
		</tr>
		<tr><td height="5"></td></tr>
		<tr><td class="line" colspan="2"></td></tr>
		<tr><td height="5"></td></tr>
		<tr>
			<td colspan="2" align="center">
				<cf_tl id="Save" var="1">
				<cfoutput>
					<input type="Button" name="btnsubmit" id="btnsubmit" value="  #lt_text#  " class="button10g" onclick="submitClusterForm('#url.publicationid#','#url.code#');">
				</cfoutput>
			</td>
		</tr>
	</table>
</cfform> 

<table><tr><td id="processCluster"></td></tr></table>