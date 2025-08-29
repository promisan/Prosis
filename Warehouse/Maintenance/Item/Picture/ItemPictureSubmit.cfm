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
<cfparam name="URL.action" default="">
 
<cfajaximport>
 
<!----------------------------------------------------------------------------->
<cfif DirectoryExists("#SESSION.rootDocumentPath#\Warehouse\Pictures\")>
	
        <!--- skip--->
			
<cfelse>  	
	  
	    <cfdirectory 
		  action   = "CREATE" 
		  directory= "#SESSION.rootDocumentPath#\Warehouse\Pictures\">
				  
</cfif>	  
		
<cfif ParameterExists(Form.Upload)> 
	
	
	<!--- Upload file, result stored in variable rawFile, to retrieve the extesion of the file uploaded --->
	<cffile action       = "UPLOAD"
	        filefield    = "uploadedfile_#URL.Class#"
	        destination  = "#SESSION.rootDocumentPath#\Warehouse\Pictures\"
			result		 = "rawFile"
	        nameconflict = "MakeUnique">

	
	<!--- Generate serial no --->
	<cfquery name="ItemImage" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
		SELECT MAX(ImageSerialNo) AS SerialNo
		FROM   ItemImage
		WHERE  ItemNo = '#URL.ItemNo#' AND Mission='#URL.Mission#' AND ImageClass='#URL.Class#' 
	
	</cfquery>

	<cfset serialNo = 0>
	
	<cfif ItemImage.SerialNo gte 0>
	
		<cfset serialNo = ItemImage.SerialNo + 1> 
	
	</cfif>
	
	<!--- Generate file name, do note the use of rawFile.ServerFileExt to retrieve the file extension. ---->
	<cfset fileName = URL.ItemNo&"_"&URL.Mission&"_"&URL.Class&"_"&serialNo&"."&rawFile.ServerFileExt>
	<cfset fileNameThumbnail = URL.ItemNo&"_"&URL.Mission&"_"&URL.Class&"_"&serialNo&"_thumbnail."&rawFile.ServerFileExt>
	
	<!--- Rename the uploaded file to the generated name ---->
	<cffile 
	    action 		= "rename"
    	destination = "#SESSION.rootDocumentPath#\Warehouse\Pictures\#fileName#" 
	    source 		= "#SESSION.rootDocumentPath#\Warehouse\Pictures\#rawFile.ServerFile#">

	<!--- Create DB record --->
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
           ,ImagePath
           ,ImagePathThumbnail
           ,OfficerUserId
           ,OfficerLastName
           ,OfficerFirstName
           ,Created
		)
		VALUES ('#URL.ItemNo#',
				'#URL.Mission#',
				'#URL.Class#',
				 #serialNo#,
				'Warehouse/Pictures/#fileName#',
				'Warehouse/Pictures/#fileNameThumbnail#',
				'#SESSION.Acc#',
				'#SESSION.Last#',
				'#SESSION.First#',
				getdate())
		
	</cfquery>
	
	<!--- Resize image and create thumbnail as per class configuration --->
	<cfquery name="ImageClass" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   Ref_ImageClass
		WHERE  Code = '#URL.Class#'
	</cfquery>


	<!--- actual image 
	cfimage action="resize" source="#SESSION.rootDocumentPath#\Warehouse\Pictures\#fileName#" 
		         width="#ImageClass.ResolutionWidth#" height="#ImageClass.ResolutionHeight#" 
		         destination="#SESSION.rootDocumentPath#\Warehouse\Pictures\#fileName#" 
		         overwrite="yes"/>
		         
	--->
	
	
	<!--- thumbnail --->
	<cfimage action="resize" source="#SESSION.rootDocumentPath#\Warehouse\Pictures\#fileName#" 
			         width="#ImageClass.ResolutionWidthThumbnail#" height="#ImageClass.ResolutionHeightThumbnail#" 
			         destination="#SESSION.rootDocumentPath#\Warehouse\Pictures\#fileNameThumbnail#" 
			         overwrite="yes"/>		
			         

	<!--- update view --->
	 <cfoutput>
	
		<script>		
			parent.ColdFusion.navigate('ItemPictureView.cfm?ItemNo=#URL.ItemNo#&Class=#Url.Class#','images_#Url.Class#');
			b = parent.document.getElementById("upload_#URL.Class#");
			b.className = "button10s";
			
			l = parent.document.getElementById("loader_#URL.Class#");
			l.className = "hide";
			
			parent.document.forms['attach'].reset();
		</script>
	
	</cfoutput>

<cfelseif url.action eq "delete"> 


	<!--- Make sure this ItemImage record exists --->
	<cfquery name="ItemImage" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT * 
		FROM   ItemImage
		WHERE  ItemNo 	  	 = '#URL.ItemNo#'
		AND    ImageClass 	 = '#URL.Class#'
		AND    Mission     	 = '#URL.Mission#'
		AND    ImageSerialNo = '#URL.SerialNo#'
	</cfquery>

	<cfif ItemImage.recordcount gt 0>
	
		<cfif FileExists("#SESSION.rootDocumentPath#\#ItemImage.ImagePath#") eq 'Yes'>
	
			<!--- delete actual image --->
			<cffile action="DELETE" 
	            file="#SESSION.rootDocumentPath#\#ItemImage.ImagePath#">
		
		</cfif>
		
		<cfif FileExists("#SESSION.rootDocumentPath#\#ItemImage.ImagePathThumbnail#") eq 'Yes'>
		
			<!--- delete thumbnail --->
			<cffile action="DELETE" 
	            file="#SESSION.rootDocumentPath#\#ItemImage.ImagePathThumbnail#">
				
		</cfif>
		
		<!--- Delete record --->
		<cfquery name="DeleteImage" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			DELETE FROM ItemImage
			WHERE  ItemNo 	  	 = '#URL.ItemNo#'
			AND    ImageClass 	 = '#URL.Class#'
			AND    Mission     	 = '#URL.Mission#'
			AND    ImageSerialNo = '#URL.SerialNo#'
		</cfquery>
		
		<!--- update view --->
		<cfinclude template="ItemPictureView.cfm">
	
	</cfif>

<cfelseif url.action eq "move">

	<cfquery name="MoveItem" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		Update ItemImage
		SET ImageClass = '#URL.destination#'
		WHERE 
           ItemNo 		=  '#URL.ItemNo#'
           AND Mission 	= '#URL.Mission#' 
           AND ImageClass = '#URL.Class#'
           AND ImageSerialNo = '#URL.serialNo#'
	</cfquery>

	<cfinclude template="ItemPictureView.cfm">
	
</cfif>

