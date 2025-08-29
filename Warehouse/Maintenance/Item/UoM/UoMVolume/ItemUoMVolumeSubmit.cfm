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
<cfset Temperature = replace("#Form.Temperature#",",","")>
<cfset VolumeRatio = replace("#Form.VolumeRatio#",",","")>

<cfquery name="verifyUnique" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	TOP 1 Temperature
		FROM    ItemUoMVolume
		WHERE	ItemNo = '#Form.ItemNo#'
		AND		UoM = '#Form.UoM#'
		AND		Temperature = '#Temperature#'
</cfquery>

<cfoutput>

<cf_tl id = "The combination of item, uom and temperature already exists.  Operation aborted." var = "vAlready">

<cfif ParameterExists(Form.Save)>	
	
	<cfif verifyUnique.recordCount gt 0>
	
		<script language="JavaScript">
			alert("#vAlready#");
			ProsisUI.closeWindow('mydialog');
		</script>  
	
	<cfelse>
	
		<cfquery name="Insert" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		INSERT INTO ItemUoMVolume
		           (ItemNo,
		           UoM,
		           Temperature,
				   VolumeRatio,
		           OfficerUserId,
		           OfficerLastName,
		           OfficerFirstName)
		     VALUES
		           ('#Form.ItemNo#',
		           '#Form.UoM#',
				   #Temperature#,
				   #VolumeRatio#,
				   '#SESSION.acc#',
				   '#SESSION.last#',
				   '#SESSION.first#')
		
		</cfquery>
		
		<script language="JavaScript">   
		    ptoken.navigate('UoMVolume/ItemUoMVolume.cfm?id=#Form.ItemNo#&UoM=#Form.UoM#','itemUoMVolumelist');     
			ProsisUI.closeWindow('mydialog');
		</script> 
		
	</cfif>
		  
</cfif>

<cfif ParameterExists(Form.Update)>	
	
	<cfif verifyUnique.recordCount gt 0 and Form.Temperature neq Form.TemperatureOld>
	
		<script language="JavaScript">
			alert("#vAlready#");
			ProsisUI.closeWindow('mydialog');
		</script>  
	
	<cfelse>
	
		<cfquery name="Update" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		UPDATE ItemUoMVolume
		SET 
		      Temperature         = #Temperature#,
			  VolumeRatio         = #VolumeRatio#
		WHERE ItemNo              = '#Form.ItemNo#'
		AND   UoM                 = '#Form.UoM#'
		AND   Temperature         = '#Form.TemperatureOld#'
		</cfquery>
		
		<script language="JavaScript">   
		    ptoken.navigate('UoMVolume/ItemUoMVolume.cfm?id=#Form.ItemNo#&UoM=#Form.UoM#','itemUoMVolumelist');     
			ProsisUI.closeWindow('mydialog');	          
		</script> 
		
	</cfif>

</cfif>	

<cfif ParameterExists(Form.Delete)> 	
			
	<cfquery name="Delete" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		DELETE FROM ItemUoMVolume
		WHERE ItemNo = '#Form.ItemNo#'
		AND   UoM = '#Form.UoM#'
		AND   Temperature = '#Form.TemperatureOld#'
	</cfquery>	
	
	<script language="JavaScript">   
	    ptoken.navigate('UoMVolume/ItemUoMVolume.cfm?id=#Form.ItemNo#&UoM=#Form.UoM#','itemUoMVolumelist');     
		ProsisUI.closeWindow('mydialog');          
	</script> 
	
</cfif>

</cfoutput>