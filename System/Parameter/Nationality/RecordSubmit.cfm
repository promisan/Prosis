
<cfif ParameterExists(Form.Insert)> 

<cfquery name="Verify" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM Ref_Nation
WHERE code = '#Form.Code#' 

</cfquery>

    <cfif #Verify.recordCount# is 1>
   
   <script language="JavaScript">
   
     alert("A nation with this code has been registered already!")
     
   </script>  
  
   <CFELSE>
    
   
<cfquery name="Insert" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
INSERT INTO Ref_Nation
         (code,
         isocode,
         isocode1,
		 name, 
		 operational,
		 OfficerUserId,
		 OfficerLastName,
		 OfficerFirstName,	
		 Created)
  VALUES ('#Form.code#',
  		  '#Form.isocode#',
  		  '#Form.isocode2#', 
          '#Form.Name#',
		  '#Form.Operational#',
		  '#SESSION.acc#',
    	  '#SESSION.last#',		  
	  	  '#SESSION.first#',
		  getDate())</cfquery>
		  
	</cfif>	  

</cfif>

<cfif ParameterExists(Form.Update)>
	
	<cfquery name="Update" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	UPDATE Ref_Nation
	SET    Name      = '#Form.Name#', 
	      Operational = '#Form.Operational#',
	      IsoCode = '#Form.IsoCode#',
	      IsoCode2 = '#Form.IsoCode2#'
	WHERE code  = '#Form.Code#'
	</cfquery>

</cfif>

<cfif ParameterExists(Form.Delete)> 
	
		<cf_verifyOperational 
         module    = "Roster" 
		 Warning   = "No">
		 
		 <cfset del = 0>
		 
		<cfif operational eq "1">

		    <cfquery name="CountRec" 
		     datasource="AppsSelection" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
		     SELECT    Nationality
		     FROM      Applicant
		     WHERE     Nationality  = '#Form.Code#'
			 UNION
			 SELECT    Nationality
		     FROM      Employee.dbo.Person
		     WHERE     Nationality  = '#Form.Code#'
		    </cfquery>
		
		    <cfif CountRec.recordCount gt 0>
			
				<cfset del = 1>
				
			</cfif>	
		
		</cfif>
			 	    	 	 
    	<cfif del eq "0">
	
			<cfquery name="Delete" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				DELETE FROM Ref_Nation
				WHERE Code   = '#Form.Code#'
			    </cfquery>
			
		<cfelse>
	
	 	<script language="JavaScript">
	    
		   alert("Nationality is in use. Operation aborted.")
	     
	     </script>  		
	
    </cfif>	
	
</cfif>	
	
<script language="JavaScript">
   
     window.close()
	 opener.location.reload()
        
</script>  
	
