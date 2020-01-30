<cfset isDirty = 0>
<cfset vMessage = "">

<cfset dateValue = "">
<CF_DateConvert Value="#form.DateEffective#">
<cfset STR = dateValue>
					
<cfset dateValue = "">
<CF_DateConvert Value="#form.DateExpiration#">
<cfset END = dateValue>

<!--- date validations --->
<cfquery name="minDate" 
datasource="appsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT 	MIN(DateEffective) as value
	FROM 	Ref_PayrollLocationDesignation
	WHERE 	LocationCode = '#Form.LocationCode#'
</cfquery>

<cfquery name="maxDate" 
datasource="appsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT 	MAX(DateExpiration) as value
	FROM 	Ref_PayrollLocationDesignation
	WHERE 	LocationCode = '#Form.LocationCode#'
</cfquery>

<cfif minDate.value neq "">

	<cfif dateFormat(STR,'yyyy-mm-dd') gt dateFormat(minDate.value,'yyyy-mm-dd')>
		<cfset isDirty = 1>
		<cfset vMessage = vMessage & "The effective date cannot be greater than the minimum effective date of the designations. \n">
	</cfif>

</cfif>

<cfif maxDate.value neq "">

	<cfif dateFormat(END,'yyyy-mm-dd') lt dateFormat(maxDate.value,'yyyy-mm-dd')>
		<cfset isDirty = 1>
		<cfset vMessage = vMessage & "The expiration date cannot be less than the maximum expiration date of the designations. \n">
	</cfif>

</cfif>

<cfif isDirty eq 0>
	
	<cfif ParameterExists(Form.Insert)> 
	
	<cfquery name="Verify" 
	datasource="AppsPayroll" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM  Ref_PayrollLocation
		WHERE LocationCode  = '#Form.LocationCode#' 
	</cfquery>
	
	   <cfif Verify.recordCount is 1>
	   
		   <script language="JavaScript">
	   
	    	 alert("A record with this code has been registered already!")
     		 window.close()
		   </script>  
	  
	   <cfelse>
		   
		<cfquery name="Insert" 
		datasource="AppsPayroll" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			INSERT INTO Ref_PayrollLocation
			         (LocationCode,				
					 Description,
					 LocationCountry,
					 DateEffective,
					 DateExpiration,
					 OfficerUserId,
					 OfficerLastName,
					 OfficerFirstName)
			  VALUES ('#Form.LocationCode#',		        
			          '#Form.Description#', 
					  '#Form.LocationCode#',
					  #STR#,
					  #END#,
					  '#SESSION.acc#',
			    	  '#SESSION.last#',		  
				  	  '#SESSION.first#')
		  </cfquery>
		  
		  <cfif isDefined("Form.Mission")>
		  
			  <cfloop index="mis" list="#Form.Mission#">
			  
			     <cfquery name="Insert" 
				  datasource="AppsPayroll" 
		   		  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
					INSERT INTO Ref_PayrollLocationMission
					         (LocationCode,
							 Mission,					
							 OfficerUserId,
							 OfficerLastName,
							 OfficerFirstName)
					  VALUES ('#Form.LocationCode#',
					          '#mis#',			       
							  '#SESSION.acc#',
					    	  '#SESSION.last#',		  
						  	  '#SESSION.first#')
				  </cfquery>
				  
			  </cfloop>
		  
		  </cfif>
		  
		  <script language="JavaScript">   
	    		parent.window.close()
				parent.opener.history.go()        
		  </script>
			  
	    </cfif>		  
	           
	</cfif>
	
	<cfif ParameterExists(Form.Update)>
		
			<cfquery name="Update" 
			datasource="AppsPayroll" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			UPDATE Ref_PayrollLocation
			SET Description    = '#Form.Description#',
				DateEffective  = #STR#,		
				DateExpiration = #END#
			WHERE LocationCode    = '#Form.LocationCode#'
			</cfquery>
			
			<cfquery name="Clean" 
			datasource="AppsPayroll" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				DELETE FROM Ref_PayrollLocationMission		
				WHERE  LocationCode    = '#Form.LocationCode#'
			</cfquery>		
			
			<cfif isDefined("Form.Mission")>
			
				<cfloop index="mis" list="#Form.Mission#">
			  
			     <cfquery name="Insert" 
				  datasource="AppsPayroll" 
		   		  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
					INSERT INTO Ref_PayrollLocationMission
					         (LocationCode,
							 Mission,					
							 OfficerUserId,
							 OfficerLastName,
							 OfficerFirstName)
					  VALUES ('#Form.LocationCode#',
					          '#mis#',			       
							  '#SESSION.acc#',
					    	  '#SESSION.last#',		  
						  	  '#SESSION.first#')
				 </cfquery>
				  
			   </cfloop>
		   
		   </cfif>
		   
		   <script language="JavaScript">   
	    		parent.window.close()
				parent.opener.history.go()        
		  </script>
			
	</cfif>	
	
	<cfif ParameterExists(Form.Delete)> 
	
	<cfquery name="CountRec" 
	      datasource="AppsPayroll" 
	      username="#SESSION.login#" 
	      password="#SESSION.dbpw#">
	      SELECT DISTINCT ServiceLocation
	      FROM SalaryScale
	      WHERE ServiceLocation  = '#Form.LocationCode#' 
	    </cfquery>
	
	    <cfif CountRec.recordCount gt 0>
			 
	     <script language="JavaScript">
	    
		   alert("Location is in use. Operation aborted.")
		        
	     </script>  
		 
	    <cfelse>
				
		<cfquery name="Delete" 
	    datasource="AppsPayroll" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
	    DELETE FROM Ref_PayrollLocation
	    WHERE LocationCode = '#FORM.LocationCode#'
	    </cfquery>
		
		<script language="JavaScript">   
	    		parent.window.close()
				parent.opener.history.go()        
		  </script>
		
		</cfif>
		
		
	</cfif>	  

<cfelse>

	<cfoutput>
		<script>
			alert('#vMessage#');
		</script>
		<cfset url.id1 = FORM.LocationCode>
		<cfinclude template="RecordEdit.cfm">
	</cfoutput>

</cfif>
