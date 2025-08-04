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
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM Ref_Category
WHERE Code  = '#Form.Code#' 

</cfquery>

    <cfif #Verify.recordCount# is 1>
   
   <script language="JavaScript">
   
     alert("A record with this code has been registered already!")
     
   </script>  
  
   <CFELSE>
     
		<cfquery name="Insert" 
		datasource="AppsLedger" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		INSERT INTO Ref_Category
		         (Code,
				 Description, 
				 Mission,
				 EntityCode, 
				 CategoryClass,
				 OfficerUserId,
				 OfficerLastName,
				 OfficerFirstName)
		  VALUES ('#Form.Code#', 
		          '#Form.Description#',
				  '#Form.Mission#',
				  '#Form.EntityCode#',
				  '#Form.CategoryClass#',
				  '#SESSION.acc#',
		    	  '#SESSION.last#',		  
			  	  '#SESSION.first#')
		</cfquery>
		
		<cfif form.Object1 neq "">
		
			<cfquery name="Insert" 
				datasource="AppsLedger" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				INSERT INTO Ref_CategoryObject
				(Code,Object)
				VALUES
				('#Form.Code#','#form.Object1#')
			</cfquery>
		
		</cfif>
		
		<cfif form.Object2 neq "" and form.Object1 neq form.Object2>
		
			<cfquery name="Insert" 
				datasource="AppsLedger" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				INSERT INTO Ref_CategoryObject
				(Code,Object)
				VALUES
				('#Form.Code#','#form.Object2#')
			</cfquery>
		
		</cfif>
		
		  
	</cfif>	  

</cfif>

<cfif ParameterExists(Form.Update)>

	<cfquery name="Update" 
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	UPDATE Ref_Category
	SET   Description    = '#Form.Description#',
	      EntityCode     = '#Form.EntityCode#',
		  Mission        = '#Form.Mission#',
		  Operational    = '#Form.Operational#',
		  CategoryClass  = '#Form.CategoryClass#',
		  ListingOrder   = '#Form.ListingOrder#',
	      Code           = '#Form.Code#'
	WHERE Code    = '#Form.CodeOld#'
	</cfquery>

</cfif>


<cfif ParameterExists(Form.Delete)> 

    <cfquery name="CountRec" 
     datasource="AppsLedger" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     SELECT    *
     FROM     FinancialObjectAmountCategory
     WHERE    Category = '#Form.CodeOld#' 
	 </cfquery>
	
    <cfif #CountRec.recordCount# gt 0 >
		 
     <script language="JavaScript">
    
	   alert(" Category is in use. Operation aborted.")
     
     </script>  
	 	 
    <cfelse>
	
			
	<cfquery name="Delete" 
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
DELETE FROM Ref_category
WHERE Code   = '#Form.codeOld#'
    </cfquery>
	
    </cfif>	
	
</cfif>	
	
<script language="JavaScript">
   
     window.close()
	 opener.location.reload()
        
</script>  