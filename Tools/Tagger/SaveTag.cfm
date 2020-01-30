
<cfparam name="url.id"      default="" />
<cfparam name="url.x"       default=""/>
<cfparam name="url.y"       default=""/>
<cfparam name="url.width"   default=""/>
<cfparam name="url.height"  default=""/>
<cfparam name="url.message" default=""/>
<cfparam name="url.photoID" default=""/>
<cfparam name="url.value"   default=""/>

<cfparam name="form.id" 	default="" />
<cfparam name="form.x" 		default=""/>
<cfparam name="form.y" 		default=""/>
<cfparam name="form.width" 	default=""/>
<cfparam name="form.height" default=""/>
<cfparam name="form.message" default=""/>
<cfparam name="form.photoID" default=""/>
<cfparam name="form.value"   default=""/>


<cfif url.id eq "">
	<cfset url.id = form.id>
</cfif>	

<cfif url.x eq "">
	<cfset url.x = form.x>
</cfif>	

<cfif url.y eq "">
	<cfset url.y = form.y>
</cfif>	

<cfif url.width eq "">
	<cfset url.width = form.width>
</cfif>	

<cfif url.height eq "">
	<cfset url.height = form.height>
</cfif>	

<cfif url.message eq "">
	<cfset url.message = form.message>
</cfif>	

<cfif url.photoID eq "">
	<cfset url.photoID = form.photoID>
</cfif>	

<cfif url.value eq "">
	<cfset url.value = form.value>
</cfif>	


<!--- Save the given tag and get the new / exisitng tag ID. --->

	
	<cfquery name="qMission" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT Mission,ItemNo
		FROM Item
		WHERE ItemNo = '#URL.PhotoId#'
	</cfquery>	

	<cfquery name="qOriginal" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT ImagePath,ImagePathThumbnail
		FROM ItemImage
		WHERE ItemNo  = '#URL.PhotoId#'
		AND ImageClass = 'Slider'
	</cfquery>	


	<cfquery name="qCheck" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM ItemImage
		WHERE ItemNo   = '#URL.value#'
		AND ImageClass = 'Tagged'
		AND Mission    = '#qMission.Mission#'
		AND SquarePositionX  = '#URL.x#'
		AND SquarePositionY  = '#url.y#'
		AND SquareSizeWidth  = '#url.width#'
		AND SquareSizeHeight = '#url.height#'
	</cfquery>
	
	<cfif qCheck.recordcount eq 0>

			<!---- get the last ImageSerialNo ---->

			<cfquery name="qLast" 
			datasource="appsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT MAX(ImageSerialNo) as LastNo
				FROM ItemImage
				WHERE ItemNo   = '#URL.value#'
				AND ImageClass = 'Tagged'
				AND Mission    = '#qMission.Mission#'
			</cfquery>
			
			<cfif qLast.LastNo neq "">		
				<cfset LastNo = qLast.LastNo+1>
			<cfelse>
				<cfset LastNo = 1>
			</cfif>	
			
			<cf_AssignId>
			<cfset TagId = rowguid>
			
			<cfset SESSION.photoID = tagID >

			<cfquery name="Item" 
			datasource="appsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				INSERT INTO ItemImage
				(
		           ItemNo
		           ,Mission
		           ,ImageClass
		           ,ImageSerialNo
		           ,ImageId
		           ,ImagePath
		           ,ImagePathThumbnail
		           ,ParentItemNo
		           ,SquarePositionX
		           ,SquarePositionY
		           ,SquareSizeWidth
		           ,SquareSizeHeight
		           ,OfficerUserId
		           ,OfficerLastName
		           ,OfficerFirstName
		           ,Created
				)
				VALUES ('#URL.value#'
						,'#qMission.Mission#'
						,'Tagged'
						,'#LastNo#'
						,'#TagId#'
						,'#qOriginal.ImagePath#'
						,'#qOriginal.ImagePathThumbnail#'
						,'#URL.PhotoId#'
						,'#url.x#'
						,'#url.y#'
						,'#url.width#'
						,'#url.height#'
						,'#SESSION.Acc#'
						,'#SESSION.Last#'
						,'#SESSION.First#'
						,getdate())
				
			</cfquery>

	<cfelse>
			
			<cfset SESSION.photoID = qCheck.TagId >

			<cfquery name="qUpdate" 
			datasource="appsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				UPDATE ItemImage
				SET 
				SquarePositionX  = '#URL.x#',
				SquarePositionY  = '#URL.y#',
				SquareSizeWidth  = '#URL.width#',
				SquareSizeHeight = '#URL.height#',
				ParentItemNo     = '#URL.PhotoId#'
				WHERE ItemNo     = '#URL.value#'
				AND ImageClass   = 'Tagged'
				AND Mission      = '#qMission.Mission#'
				AND ImageSerialNo = '#qCheck.ImageSerialNo#'
			</cfquery>
	
	</cfif>	
	
<cfoutput>#serializeJSON( SESSION.photoID )#</cfoutput>