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
	<cfparam name="URL.PhotoId" default="">
	
	
	<cfquery name="qMission" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT Mission
		FROM Item
		WHERE ItemNo = '#URL.PhotoId#'
	</cfquery>		
	
	<cfquery name="qImages" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT II.*,I.ItemNo,I.ItemDescription
		FROM ItemImage II INNER JOIN Item I ON II.ItemNo = I.ItemNo 
		WHERE II.ParentItemNo   = '#URL.PhotoId#'
			  AND II.ImageClass = 'Tagged'
			  AND II.Mission    = '#qMission.Mission#'
	</cfquery>	
	
	<cfset tags = [] />	
			
	<cfloop query="qImages">
	
	
			<cfset tag = {
				id = qImages.ImageId,
				x = qImages.SquarePositionX,
				y = qImages.SquarePositionY,
				width = qImages.SquareSizeWidth,
				height = qImages.SquareSizeHeight,
				message = "#qImages.ItemNo# #qImages.ItemDescription#",
				photoID = SESSION.photoID
			  } />
		

		
		<cfset arrayAppend( tags, tag ) />	
		
	</cfloop>
	
	<cfoutput>#serializeJSON( tags )#</cfoutput>