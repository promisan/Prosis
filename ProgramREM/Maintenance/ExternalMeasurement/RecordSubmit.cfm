
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>"> 

<cfparam name="Form.Overwrite" default="0">
<cfparam name="Form.LocationEnabled" default="0">

<cfif ParameterExists(Form.Insert)> 
    
	<cfquery name="Verify" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM stProgramMeasure
	WHERE fileName  = '#Form.FileName#' 
	AND Mission     = '#Form.Mission#'
	AND Period      = '#Form.Period#'
	</cfquery>

   <cfif Verify.recordCount gte 1>
   
   <script language="JavaScript">
   
     alert("A database table name with this name and period has been registered already!")
     
   </script>  
  
   <cfelse>
   				
		<cfquery name="Insert" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		INSERT INTO stProgramMeasure
		         (FileName,
				 Mission,
				 DataSource,
				 Period,
				 Overwrite,
				 Operational,
				 Source,
				 LocationEnabled,
				 OfficerUserId,
				 OfficerLastName,
				 OfficerFirstName)
		  VALUES ('#Form.FileName#',
        		  '#Form.Mission#', 
				  '#Form.DataSource#',
				  '#Form.Period#',
				  '#Form.Overwrite#',
				  '#Form.Operational#',
				  '#Form.Source#',
				  '#Form.LocationEnabled#',
				  '#SESSION.acc#',
		    	  '#SESSION.last#',		  
			  	  '#SESSION.first#')</cfquery>
		  	     		  
    </cfif>		  
           
</cfif>

<cfif ParameterExists(Form.Update)>

	<cfquery name="Update" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE stProgramMeasure
		SET 
		    FileName  = '#Form.FileName#',
		    Mission   = '#Form.Mission#',
			Period    = '#Form.Period#',
			DataSource = '#Form.DataSource#',
			Overwrite = '#Form.Overwrite#',
			Source    = '#Form.Source#',
			LocationEnabled  = '#Form.LocationEnabled#',
			Operational      = '#Form.Operational#'
		WHERE FileNo = '#URL.FileNo#'		
	</cfquery>

</cfif>	

<cfif ParameterExists(Form.Delete)> 
		
	<cfquery name="Delete" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
DELETE FROM stProgramMeasure
WHERE FileNo = '#URL.FileNo#'	
    </cfquery>
			
</cfif>	

<script language="JavaScript">
   
     window.close()
	 opener.history.go()
        
</script>  

