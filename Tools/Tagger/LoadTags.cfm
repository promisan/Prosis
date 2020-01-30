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