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
<table style="min-width:200px;" width="98%" align="center" class="formpadding navigation_table">

	<cfquery name="Position" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
	    SELECT * FROM Employee.dbo.Position 
    	 WHERE PositionParentid = '#url.positionparentId#'
	</cfquery>

	<cfoutput>
		<tr class="labelmedium line">
			<td colspan="2" style="font-size:15px;padding-left:2px;font-weight:200px">
			<a href="javascript:EditPosition('#position.mission#','#position.Mandateno#','#Position.PositionNo#')">
			<cfif Position.SourcePostNumber eq "">#Position.PositionParentId#<cfelse>#Position.SourcePostNumber#</cfif>&nbsp;#Position.PostGrade#
			</a>
			</td>
		</tr>
		
		<tr>	
			<td colspan="2" align="right" style="padding-right:10px;">
				<table>
					<tr class="labelmedium">
						<td><input type="radio" id="fGroup1" name="fGroup" style="cursor:pointer;" onclick="showPositionDetail('#PositionParentId#', '#url.programcode#', '#url.period#', 'pi');"> <label for="fGroup1" style="cursor:pointer;"><cf_tl id="Item"></label></td>
						<td style="padding-left:10px;"><input type="radio" id="fGroup2" name="fGroup" checked="checked" style="cursor:pointer;" onclick="showPositionDetail('#PositionParentId#', '#url.programcode#', '#url.period#', 'oc');"> <label for="fGroup2" style="cursor:pointer;"><cf_tl id="Object"></label></td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td colspan="2" style="padding-right:5px">
				<cfdiv id="divPositionDetail" 
				bind="url:#session.root#/ProgramREM/Application/Budget/Forecast/PositionViewDetail.cfm?PositionParentId=#PositionParentId#&period=#url.period#&programcode=#url.programcode#&group=oc">
			</td>
		</tr>
	</cfoutput>
</table>

<cfset ajaxonload("doHighlight")>