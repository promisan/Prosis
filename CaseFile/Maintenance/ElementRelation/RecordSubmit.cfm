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


<cfif ParameterExists(Form.Insert)> 

	<cfquery name="Verify" 
	datasource="AppsCaseFile" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM Ref_ElementRelation
		WHERE Code = '#Form.Code#' 
<!---	
	Remove by Nery's request on 3/8/2011	
	    AND ElementClassFrom = '#Form.ElementFrom#'
		AND ElementClassTo = '#Form.ElementTo#' 
--->
	</cfquery>

  <cfif Verify.recordCount gt 0>
  		<cfoutput>
		<cf_tl id = "This relation has been registered already!" class="Message" var = "1">
	   <script language="JavaScript">
	   
	     alert("#lt_text#")
	     
	   </script>  
	   </cfoutput>
  
   <cfelse>		
   
		<cfquery name="Insert" 
		datasource="AppsCaseFile" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		
			INSERT INTO Ref_ElementRelation
           (Code
           ,ElementClassFrom
           ,ElementClassTo
           ,Description
           ,ListingOrder
           ,OfficerUserId
           ,OfficerLastName
           ,OfficerFirstName
           ,Created)     			
			  VALUES ('#Form.Code#', 
					  '#Form.ElementFrom#',  
			          '#Form.ElementTo#',
  	  				  '#Form.Description#',
					  '#Form.ListingOrder#',
			   	      '#SESSION.acc#',
			    	  '#SESSION.last#',		  
				      '#SESSION.first#',
				       getDate())
		  </cfquery>
		  
	</cfif>	  

	
<cfelse>	 

	<cfif ParameterExists(Form.Update)>
	
		
			<cfquery name="Update" 
			datasource="AppsCaseFile" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				UPDATE Ref_ElementRelation
				SET 
				ElementClassFrom = '#Form.ElementFrom#',
				ElementClassTo = '#Form.ElementTo#',
				ListingOrder = '#Form.ListingOrder#',
				Description  = '#Form.Description#'
				WHERE Code = '#Form.Code#'
			</cfquery>
		

	
	</cfif>
	
	
	<cfif ParameterExists(Form.Delete)> 
	
		<cfquery name="Related" 
	     datasource="AppsCaseFile" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
		     SELECT    *
			 FROM ElementRelation
			 where RelationCode = '#Form.Code#'
		 </cfquery>	
	      	
	    <cfif #Related.recordCount# gt 0>
			 <cfoutput>
	 		<cf_tl id = "Relation is in use. Operation aborted." class="Message" var = "1">
		     <script language="JavaScript">
		    
			   alert(" #lt_text#")
		     
		     </script> 
			 </cfoutput> 
			 	 
	    <cfelse>
		
			<cfquery name="Delete" 
				datasource="AppsCaseFile" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					DELETE FROM Ref_ElementRelation
					WHERE Code = '#Form.Code#'
			    </cfquery>		
		
	    </cfif>	
		
	</cfif>	
	
</cfif>

<script language="JavaScript">
   
     window.close()
	 opener.location.reload()
        
</script>  