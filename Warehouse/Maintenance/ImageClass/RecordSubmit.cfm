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
<cfif ParameterExists(Form.Insert)> 
	
	<cfquery name="Verify" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   Ref_ImageClass
		WHERE  Code  = '#Form.Code#'
	</cfquery>

   <cfif Verify.recordCount eq "1">
   
	   <script language="JavaScript">   
		     alert("A record with this code has been registered already!")     
	   </script>  
  
   <cfelse>
   
   		<cftransaction>
			
			
			<cfquery name="Insert" 
			datasource="appsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			  INSERT INTO Ref_Imageclass
			          (Code,
					   Description,
					   ResolutionWidth,
					   ResolutionHeight,
					   ResolutionWidthThumbnail,
					   ResolutionHeightThumbnail,
					   OfficerUserId,
					   OfficerLastName,
					   OfficerFirstName,
					   Created)
			  VALUES  ('#Form.Code#',
			           '#Form.Description#', 
					   '#Form.ResolutionWidth#',
					   '#Form.ResolutionHeight#',
					   '#Form.ResolutionWidthThumbnail#',
					   '#Form.ResolutionHeightThumbnail#',
					   '#SESSION.acc#',
			    	   '#SESSION.last#',		  
				  	   '#SESSION.first#',
					   getdate())
			</cfquery>
			
			<cf_ModuleControlLog systemfunctionid="#url.idmenu#" 
			                     action="Insert" 
								 datasource="AppsMaterials"
								 content="#form#">
		
		</cftransaction>
		  
    </cfif>		  
           
</cfif>

<cfif ParameterExists(Form.Update)>
	
	<cftransaction>
		
		<cfquery name="Update" 
		datasource="appsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			UPDATE 	Ref_ImageClass
			SET   	Description               = '#Form.Description#',
					ResolutionWidth           = '#Form.ResolutionWidth#',
					ResolutionHeight          = '#Form.ResolutionHeight#',
					ResolutionWidthThumbnail  = '#Form.ResolutionWidthThumbnail#',
					ResolutionHeightThumbnail = '#Form.ResolutionHeightThumbnail#'		
			WHERE Code         = '#Form.Code#'
		</cfquery>
		
		<cf_ModuleControlLog systemfunctionid="#url.idmenu#" 
		                     action="Update" 
							 datasource="AppsMaterials"
							 content="#form#">
						 
	</cftransaction>

</cfif>	

<cfif ParameterExists(Form.Delete)> 

	<cfquery name="CountRec" 
      datasource="appsMaterials" 
      username="#SESSION.login#" 
      password="#SESSION.dbpw#">
		SELECT *
		FROM   ItemImage
		WHERE  ImageClass='#Form.Code#'
    </cfquery>

    <cfif CountRec.recordCount gt 0>
		 
	     <script language="JavaScript">    
		   alert("Image class is in use. Operation aborted.")	        
	     </script>  
	 
    <cfelse>
	
		<cf_ModuleControlLog systemfunctionid="#url.idmenu#" 
             action="Delete" 
			 content="#form#">
			
		<cfquery name="Delete" 
		datasource="appsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			DELETE FROM Ref_ImageClass
			WHERE Code = '#FORM.code#'
	    </cfquery>
	
	</cfif>	
	
</cfif>	

<script language="JavaScript">
   
     window.close()
	 opener.location.reload()
        
</script>  
