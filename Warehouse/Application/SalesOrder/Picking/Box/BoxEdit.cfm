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
<cfparam name="url.mode" 				default="listing">
<cfparam name="url.collectionid" 	default="">

<cfquery name="getBoxes" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT  C.*,
				ISNULL((SELECT SUM(CollectionQuantity) FROM ItemTransactionCollection WHERE CollectionId = C.CollectionId), 0) as CountItems
		FROM   	WarehouseBatchCollection C
		WHERE  	C.BatchNo = '#url.batchno#'
		ORDER BY CONVERT(INT, C.CollectionCode) ASC
</cfquery> 

<table width="95%" align="center" class="table table-striped table-bordered table-hover">
	<thead>
		<tr>
			<th><cf_tl id="Code"></th>
			<th><cf_tl id="Name"></th>
			<th style="text-align:center;"><cf_tl id="Items"></th>
			<th><cf_tl id="Created"></th>
			<th style="text-align:center;"></th>
		</tr>
	</thead>
	<tbody>
		<cfset vCode = 1>
		<cfoutput query="getBoxes">
			<tr>
				<td>#CollectionCode#</td>
				<td>
					<cfif url.mode eq "edit" AND collectionId eq url.collectionid>
						<input type="textbox" id="name" maxlength="50" value="#CollectionName#" style="padding-left:5px; width:150px;">
					<cfelse>
						#CollectionName#
					</cfif>
				</td>
				<td style="text-align:center;">#numberformat(CountItems, ',')#</td>
				<td>#OfficerUserId# (#dateformat(created,client.dateformatshow)#)</td>
				<td style="text-align:center;">
					<cfif url.mode eq "edit" AND collectionId eq url.collectionid>
						<cf_tl id="Save" var="1">
						<input type="button" id="save" value="#lt_text#" class="btn" onclick="saveBox('#url.collectionid#', '#url.batchno#','#vCode#',$('##name').val())">
					<cfelse>
						<table>
							<tr>
								<td><cf_img icon="edit" onclick="editBox('#collectionid#', '#url.batchno#');"></td>
								<td style="padding-left:5px;">
									<cfif CountItems eq 0>
										<cf_img icon="delete" onclick="removeBox('#collectionid#', '#url.batchno#');">
									</cfif>
								</td>
							</tr>
						</table>
					</cfif>
				</td>
			</tr>
			<cfset vCode = CollectionCode + 1>
		</cfoutput>
		<cfif url.mode eq "listing">
			<cfoutput>
				<tr>
					<td>
						#vCode#
					</td>
					<td><input type="textbox" id="name" maxlength="50" value="#vCode#" style="padding-left:5px; width:150px;"></td>
					<td></td>
					<td></td>
					<td style="text-align:center;"><cf_img icon="add" onclick="saveBox('#url.collectionid#', '#url.batchno#','#vCode#',$('##name').val())"></td>
				</tr>
			</cfoutput>
		</cfif>
		<div style="display:none;" id="boxEditSubmit"></div>
	</tbody>
</table>