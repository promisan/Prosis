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

<cfparam name="Form.Mission" default="">
<cfparam name="Form.ProgramCategory" default="">

<cfif ParameterExists(Form.Insert)> 

<cfquery name="Verify" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM  Ref_ProgramEvent
WHERE Code  = '#Form.Code#' 
</cfquery>

   <cfif #Verify.recordCount# is 1>
   
   <script language="JavaScript">
   
     alert("An event with this code has been registered already!")
     
   </script>  
  
   <cfelse>
   
   	<cftransaction>
	   
	<cfquery name="Insert" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	INSERT INTO Ref_ProgramEvent
		         (Code,
				 Description,
				 ListingOrder,
				 OfficerUserId,
				 OfficerLastName,
				 OfficerFirstName,	
				 Created)
		  VALUES ('#Form.Code#',
		          '#Form.Description#', 
				  '#Form.ListingOrder#',
				  '#SESSION.acc#',
		    	  '#SESSION.last#',		  
			  	  '#SESSION.first#',
				  getDate())
	  </cfquery>
	  
	  <!--- Missions --->
	  
	  <cfif isDefined("Form.Mission") and Form.Mission neq "">
	  
	  <cfloop index="mis" list="#Form.Mission#">
	  
		<cfquery name="Insert" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			INSERT INTO Ref_ProgramEventMission
					         (ProgramEvent,
							 Mission,				
							 OfficerUserId,
							 OfficerLastName,
							 OfficerFirstName)
				  VALUES ('#Form.Code#',
				          '#mis#', 				
						  '#SESSION.acc#',
			    		  '#SESSION.last#',		  
					  	  '#SESSION.first#')
		</cfquery>
		  	  
	  </cfloop>
	  
	  </cfif>
	  
	  <!--- Categories --->
	  
	  <cfif Form.ProgramCategory neq "">
	  
	  <cfloop index="cat" list="#Form.ProgramCategory#">
	  
		<cfquery name="Insert" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			INSERT INTO Ref_ProgramEventCategory
					         (ProgramEvent,
							 ProgramCategory,				
							 OfficerUserId,
							 OfficerLastName,
							 OfficerFirstName)
				  VALUES ('#Form.Code#',
				          '#cat#', 				
						  '#SESSION.acc#',
			    		  '#SESSION.last#',		  
					  	  '#SESSION.first#')
		</cfquery>
		  	  
	  </cfloop>
	  
	  </cfif>
	  
	  </cftransaction>
			  
	 </cfif>		  
           
</cfif>

<cfif ParameterExists(Form.Update)>
	
	<cftransaction>
	
	<cfquery name="Update" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	UPDATE Ref_ProgramEvent
	SET 
	    Code           = '#Form.Code#',
	    Description    = '#Form.Description#',
		ListingOrder   = '#Form.ListingOrder#'
	WHERE Code    = '#Form.CodeOld#'
	</cfquery>
	
	<cfquery name="Clear" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		DELETE FROM Ref_ProgramEventMission	
		WHERE ProgramEvent    = '#Form.Code#'
	</cfquery>
		
	<cfif isDefined("Form.Mission") and Form.Mission neq "">
	  
		  <cfloop index="mis" list="#Form.Mission#">
		  
			<cfquery name="Insert" 
			datasource="AppsProgram" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			INSERT INTO Ref_ProgramEventMission
				         (ProgramEvent,
						 Mission,				
						 OfficerUserId,
						 OfficerLastName,
						 OfficerFirstName)
			  VALUES ('#Form.Code#',
			          '#mis#', 				
					  '#SESSION.acc#',
		    		  '#SESSION.last#',		  
				  	  '#SESSION.first#')
			</cfquery>
			  	  
		  </cfloop>
	  
	</cfif>
	
	
	<!--- Categories --->
	
	<cfquery name="ClearCats" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		DELETE FROM Ref_ProgramEventCategory	
		WHERE ProgramEvent    = '#Form.CodeOld#'
	</cfquery>
	  
	  <cfif Form.ProgramCategory neq "">
	  
	  <cfloop index="cat" list="#Form.ProgramCategory#">
	  
		<cfquery name="Insert" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			INSERT INTO Ref_ProgramEventCategory
					         (ProgramEvent,
							 ProgramCategory,				
							 OfficerUserId,
							 OfficerLastName,
							 OfficerFirstName)
				  VALUES ('#Form.Code#',
				          '#cat#', 				
						  '#SESSION.acc#',
			    		  '#SESSION.last#',		  
					  	  '#SESSION.first#')
		</cfquery>
		  	  
	  </cfloop>
	  
	  </cfif>
	  
	</cftransaction>

</cfif>	

<cfif ParameterExists(Form.Delete)> 

<cfquery name="CountRec" 
      datasource="AppsProgram" 
      username="#SESSION.login#" 
      password="#SESSION.dbpw#">
      SELECT DISTINCT *
      FROM   ProgramEvent
      WHERE  ProgramEvent  = '#Form.Code#' 
    </cfquery>

    <cfif #CountRec.recordCount# gt 0>
		 
     <script language="JavaScript">
    
	   alert("Event is in use. Operation aborted.")
	        
     </script>  
	 
    <cfelse>
			
	<cfquery name="Delete" 
    datasource="AppsProgram" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
    	DELETE FROM Ref_ProgramEvent
	    WHERE Code = '#FORM.CodeOld#'
    </cfquery>
	
	</cfif>
		
</cfif>	

<script language="JavaScript">   
     window.close()
	 opener.location.reload()        
</script>  
