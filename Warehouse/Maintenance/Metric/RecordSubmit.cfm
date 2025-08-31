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
			SELECT 	*
			FROM 	Ref_Metric
			WHERE 	Code  = '#Form.Code#' 
	</cfquery>

   <cfif #Verify.recordCount# is 1>
   
	   <script language="JavaScript">
	   
	     alert("A record with this code has been registered already!")
	     
	   </script>  
  
   <cfelse>
   
		<cfquery name="Insert" 
		datasource="appsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			INSERT INTO Ref_Metric
		         (code,
				 Description,
				 Measurement,
				 <cfif trim(Form.MeasurementUoM) neq "">MeasurementUoM,</cfif>
				 Operational,
				 OfficerUserId,
				 OfficerLastName,
				 OfficerFirstName)
		  	VALUES ('#Form.Code#',
		          '#Form.Description#', 
				  '#Form.Measurement#', 
				  <cfif trim(Form.MeasurementUoM) neq "">'#Form.MeasurementUoM#',</cfif>
				  '#Form.Operational#', 
				  '#SESSION.acc#',
		    	  '#SESSION.last#',		  
			  	  '#SESSION.first#')
		</cfquery>
		
		<cf_ModuleControlLog systemfunctionid="#url.idmenu#" 
	                     	 action="Insert" 
						 	 content="#Form#">
		
		<script language="JavaScript">     
	 		opener.location.reload()
	 		parent.window.close()        
		</script>
		  
    </cfif>		  
           
</cfif>

<cfif ParameterExists(Form.Update)>

	<cfquery name="Verify" 
		datasource="appsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT 	*
			FROM 	Ref_Metric
			WHERE 	Code  = '#Form.Code#' 
	</cfquery>

   <cfif #Verify.recordCount# gt 0 and Form.Code neq Form.CodeOld>
   
	   <script language="JavaScript">	   
			alert("A record with this code has been registered already!")	     
	   </script>  
  
   <cfelse>

		<cfquery name="Update" 
		datasource="appsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			UPDATE Ref_Metric
			SET 
			    Code           = '#Form.code#',
			    Description    = '#Form.Description#',
				Measurement    = '#Form.Measurement#',
				MeasurementUoM = <cfif trim(Form.MeasurementUoM) neq "">'#Form.MeasurementUoM#'<cfelse>null</cfif>,
				Operational    = '#Form.Operational#'
			WHERE Code         = '#Form.CodeOld#'
		</cfquery>
		
		<cf_ModuleControlLog systemfunctionid="#url.idmenu#" 
	                     	 action="Update" 
						 	 content="#Form#">
		
		<script language="JavaScript">     
	 		opener.location.reload()
	 		parent.window.close()        
		</script>
		
	</cfif>
	
</cfif>	

<cfif ParameterExists(Form.Delete)> 

	<cfquery name="CountRec" 
      datasource="appsMaterials" 
      username="#SESSION.login#" 
      password="#SESSION.dbpw#">
      		SELECT TOP 1 Metric
      		FROM 	AssetItemActionMetric
      		WHERE 	Metric  = '#Form.codeOld#' 
			UNION
			SELECT TOP 1 Metric
      		FROM 	ItemSupplyMetric
      		WHERE 	Metric  = '#Form.codeOld#'
			UNION
			SELECT TOP 1 Metric
      		FROM 	Ref_AssetActionMetric
      		WHERE 	Metric  = '#Form.codeOld#'
    </cfquery>

    <cfif #CountRec.recordCount# gt 0>
		 
     	<script language="JavaScript">    
			alert("Metric is in use. Operation aborted.")	        
	    </script>  
	 
    <cfelse>
			
		<cfquery name="Delete" 
		datasource="appsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			DELETE FROM Ref_Metric
			WHERE 	Code = '#FORM.codeOld#'
	    </cfquery>
		
		<cf_ModuleControlLog systemfunctionid="#url.idmenu#" 
	                     action="Delete" 
						 content="#Form#">
		
		<script language="JavaScript">     
	 		opener.location.reload()
	 		parent.window.close()        
		</script>
	
	</cfif>	
	
</cfif>	  
