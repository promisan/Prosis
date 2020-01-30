<cfquery name="Image" 
		 datasource="AppsMaterials" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
			SELECT *
			FROM   ItemImage
			WHERE  ItemNo      = '#URL.ItemNo#'
			AND    ImageClass  = '#URL.Class#' 
</cfquery>


<cfoutput>


		<cfloop query="Image">
		
			<div class="imageShow" style="width: 100%;background:##fafafa;text-align:center;padding: 5% 0;">
				
			<cfinclude template="../ItemPictureToggle.cfm">
			<br><br>

			<a style="color:##0080FF" href="javascript:ColdFusion.navigate('ItemPictureSubmit.cfm?action=delete&ItemNo=#Image.ItemNo#&Class=#Image.ImageClass#&serialno=#Image.ImageSerialNo#&Mission=#Image.Mission#','images_#Url.Class#')">[<cf_tl id="delete">]</a>
			<cfquery name="qTargets" 
					 datasource="AppsMaterials" 
					 username="#SESSION.login#" 
					 password="#SESSION.dbpw#">
						SELECT *
						FROM   Ref_ImageClass
						WHERE  Target = '1' 
					 	AND Code != '#URL.Class#'
			</cfquery>
			<cfloop query="qTargets">			
				<a style="color:##0080FF" href="javascript:ColdFusion.navigate('ItemPictureSubmit.cfm?action=move&destination=#qTargets.Code#&ItemNo=#Image.ItemNo#&Class=#Image.ImageClass#&serialno=#Image.ImageSerialNo#&Mission=#Image.Mission#','images_#Url.Class#')">[<cf_tl id="Move to #qTargets.Code#">]</a>
			</cfloop>						
			</div>
			
		</cfloop>


</cfoutput>