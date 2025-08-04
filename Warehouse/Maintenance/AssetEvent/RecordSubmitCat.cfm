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
<cf_tl id = "This category has been registered already!" var = "vAlready"> 

<cfif url.category eq ""> 

	<cfquery name="Verify" 
		datasource="appsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT 	*
			FROM 	Ref_AssetEventCategory
			WHERE 	EventCode  = '#url.id1#' 
			AND		Category = '#form.category#'
	</cfquery>
	
	   <cfif Verify.recordCount gt 0>
	   
		   	<cfoutput>
			   <script>
			    	alert("#vAlready#");
			   </script>  
		   </cfoutput>
	  
	   <cfelse>
	   
			<cfquery name="Insert" 
				datasource="appsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					INSERT INTO Ref_AssetEventCategory
						(
							EventCode,
							Category,
							ModeIssuance,
							OfficerUserId,
							OfficerLastName,
							OfficerFirstName
						)
					VALUES
						(
							'#url.id1#',
							'#Form.Category#',
							#Form.ModeIssuance#,
							'#SESSION.acc#',
							'#SESSION.last#',
							'#SESSION.first#'
						)
			</cfquery>
			
			<cf_ModuleControlLog systemfunctionid="#url.idmenu#" 
		     action="Insert"
			 content="#form#">
			
			<cfoutput>
				<script>
				    ColdFusion.Window.hide('mydialog');
					ColdFusion.navigate('RecordEditDetail.cfm?idmenu=#url.idmenu#&id1=#url.id1#','divDetail');
				</script> 
			</cfoutput>
			  
	    </cfif>		  
           
<cfelse>

	<cfquery name="Update" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE Ref_AssetEventCategory
		SET 
			ModeIssuance		= #Form.ModeIssuance#
		WHERE EventCode   		= '#url.id1#'
		AND   Category			= '#form.category#'
	</cfquery>
	
	<cf_ModuleControlLog systemfunctionid="#url.idmenu#" 
     action="Update"
	 content="#form#">
	
	<cfoutput>
		<script>
			ColdFusion.Window.hide('mydialog');
			ColdFusion.navigate('RecordEditDetail.cfm?idmenu=#url.idmenu#&id1=#url.id1#','divDetail');
		</script>
	</cfoutput>

</cfif>