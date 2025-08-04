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