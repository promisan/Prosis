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
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM  Ref_Speedtype
WHERE Speedtype  = '#Form.Speedtype#' 
</cfquery>

   <cfif Verify.recordCount is 1>
   
	   <script language="JavaScript">
	   
	     alert("A record with this code has been registered already!")
	     
	   </script>  
  
   <cfelse>
	
		<cfquery name="Insert" 
		datasource="AppsLedger" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		INSERT INTO Ref_Speedtype
		         (SpeedType,
				 Description,
				 InstitutionTree,
				 CostCenter,
				 ExternalProgram,
				 TaxCodeMode,
				 TaxCode,
				 OfficerUserId,
				 OfficerLastName,
				 OfficerFirstName,	
				 Created)
		  VALUES ('#Form.Speedtype#', 
		          '#Form.Description#',
				  '#Form.InstitutionTree#',
				  '#Form.CostCenter#',
				  '#Form.ExternalProgram#',
				  '#Form.TaxCodeMode#',
				  '#Form.TaxCode#',
				  '#SESSION.acc#',
		    	  '#SESSION.last#',		  
			  	  '#SESSION.first#',
				  getDate())
	    </cfquery>
		    	
		<cfparam name="Form.ParentSelect" default="">	  
		
		<cfif Form.ParentSelect neq "">
		
			<cfloop index="itm" list="#ParentSelect#">
			
				<cfquery name="Insert" 
				datasource="AppsLedger" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				INSERT INTO Ref_SpeedtypeParent
				         (SpeedType,
						 AccountParent,
						 Created)
				  VALUES ('#Form.Speedtype#', 
				          '#itm#',
						  getDate())
				</cfquery>
		
			</cfloop>	
			  
	    </cfif>	
		
		<cfparam name="Form.CustomSelect" default="">	  
		
		<cfif Form.CustomSelect neq "">
		
			<cfloop index="itm" list="#CustomSelect#">
			
				<cfquery name="Insert" 
				datasource="AppsLedger" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				INSERT INTO Ref_SpeedtypeTopic
				         (SpeedType,
						 Topic,
						 Created)
				  VALUES ('#Form.Speedtype#', 
				          '#itm#',
						  getDate())
				</cfquery>
		
			</cfloop>	
			  
	    </cfif>	
	           
	</cfif>
	
</cfif>	

<cfif ParameterExists(Form.Update)>
	
	<cfquery name="Update" 
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE Ref_Speedtype
		SET Description        = '#Form.Description#',
			InstitutionTree    = '#Form.InstitutionTree#',
			CostCenter         = '#Form.CostCenter#',
			ExternalProgram    = '#Form.ExternalProgram#',
			TaxCodeMode        = '#Form.TaxCodeMode#',
			TaxCode            = '#Form.TaxCode#'
		WHERE Speedtype        = '#Form.Speedtype#'
	</cfquery>
	
	<cfquery name="Delete" 
		datasource="AppsLedger" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		DELETE FROM Ref_SpeedtypeParent
		WHERE Speedtype = '#Form.Speedtype#'
	</cfquery>
	
	<cfparam name="Form.ParentSelect" default="">	  
		
		<cfif Form.ParentSelect neq "">
		
			<cfloop index="itm" list="#ParentSelect#">
			
				<cfquery name="Insert" 
				datasource="AppsLedger" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				INSERT INTO Ref_SpeedtypeParent
					         (SpeedType,
							 AccountParent,
							 Created)
				  VALUES ('#Form.Speedtype#','#itm#',getDate())
				</cfquery>
		
			</cfloop>	
			  
	    </cfif>		
		
	<cfquery name="Delete" 
		datasource="AppsLedger" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		DELETE FROM Ref_SpeedtypeTopic
		WHERE  Speedtype    = '#Form.Speedtype#'
	</cfquery>	
		
	<cfparam name="Form.CustomSelect" default="">	  
		
		<cfif Form.CustomSelect neq "">
		
			<cfloop index="itm" list="#CustomSelect#">
			
				<cfquery name="Insert" 
				datasource="AppsLedger" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				INSERT INTO Ref_SpeedtypeTopic
				         (SpeedType,
						 Topic,
						 Created)
				  VALUES ('#Form.Speedtype#', 
				          '#itm#',
						  getDate())
				</cfquery>
		
			</cfloop>	
			  
	    </cfif>		

</cfif>	

<cfif ParameterExists(Form.Delete)> 
				
		<cfquery name="Delete" 
		datasource="AppsLedger" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		DELETE FROM Ref_Speedtype 
		WHERE  Speedtype  = '#Form.Speedtype#' 
	    </cfquery>
		
</cfif>	

<script language="JavaScript">   
     window.close()
	 opener.history.go()        
</script>  
