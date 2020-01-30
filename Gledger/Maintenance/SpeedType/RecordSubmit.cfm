
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
