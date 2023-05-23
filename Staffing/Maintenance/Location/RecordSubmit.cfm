
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>"> 

<cfset isDirty = 0>
<cfset errorMessage = "">

<cfset vEffective = "">
<cfset vExpiration = "">

<cfparam name="form.mission" default="">

<cfif trim(form.dateEffective) neq "">
	<cfset dateValue = "">
	<cf_DateConvert Value="#form.dateEffective#">
	<cfset vEffective = dateValue>
</cfif>

<cfif trim(form.dateExpiration) neq "">
	<cfset dateValue = "">
	<cf_DateConvert Value="#form.dateExpiration#">
	<cfset vExpiration = dateValue>
</cfif>

<cfif vEffective neq "" and vExpiration neq "" and vEffective gt vExpiration>
	<cfset isDirty = 1>
	<cfset errorMessage = errorMessage & "Expiration date must be greater than effective date.\n">
</cfif>

<cfif form.mission eq "">
    <cfset isDirty = 1>
	<cfset errorMessage = errorMessage & "Entity has to be selected.\n">
</cfif>

<cfif isDirty eq 0>

	<cfif ParameterExists(Form.Insert)> 
		
		<cfquery name="Verify" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT *
			FROM   Location
			WHERE  LocationCode  = '#Form.LocationCode#' 
		</cfquery>
		
		<cfif Verify.recordCount is 1>
		   
			   <script language="JavaScript">
			   
			     alert("A record with code #Form.LocationCode# was recorded already!")
			     
			   </script>  
		  
		<cfelse>
		   
			<cfquery name="Insert" 
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			INSERT INTO Location
			        (LocationCode,
					 LocationName,
					 Country,
					 <cfif trim(form.dateEffective) neq "">DateEffective,</cfif>
					 <cfif trim(form.dateExpiration) neq "">DateExpiration,</cfif>
					 <cfif trim(form.ServiceLocation) neq "">ServiceLocation,</cfif>
					 Mission,
					 ListingOrder,
					 OfficerUserId,
					 OfficerLastName,
					 OfficerFirstName)
			  VALUES ('#Form.LocationCode#',
			          '#Form.LocationName#', 
					  '#form.country#',
					  <cfif trim(form.dateEffective) neq "">#vEffective#,</cfif>
					  <cfif trim(form.dateExpiration) neq "">#vExpiration#,</cfif>
					  <cfif trim(form.ServiceLocation) neq "">'#Form.ServiceLocation#',</cfif>
					  '#Form.Mission#',
					  '#Form.ListingOrder#',
					  '#SESSION.acc#',
			    	  '#SESSION.last#',		  
				  	  '#SESSION.first#')
			</cfquery>
				  
		 </cfif>		  
	           
	</cfif>
	
	<cfif ParameterExists(Form.Update)>
	
		<cfparam name="Form.ServiceLocation" default="">
		
		<cfquery name="Update" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			UPDATE Location
			SET  LocationName     = '#Form.LocationName#',
			     Mission          = '#Form.Mission#',
				 Country          = '#form.country#', 
				 DateEffective    = <cfif trim(form.dateEffective) neq "">#vEffective#<cfelse>null</cfif>,
			     DateExpiration   = <cfif trim(form.dateExpiration) neq "">#vExpiration#<cfelse>null</cfif>,
				 ServiceLocation  = <cfif trim(form.ServiceLocation) neq "">'#Form.ServiceLocation#'<cfelse>null</cfif>,
				 ListingOrder     = '#Form.ListingOrder#'
			WHERE LocationCode    = '#Form.LocationCodeOld#'
		</cfquery>
	
	</cfif>

<cfelse>

	<cfoutput>
		<script language="JavaScript">   
    		 alert("#errorMessage#");		 
		</script> 
	</cfoutput> 

</cfif>

<cfif ParameterExists(Form.Delete)> 

    <cfquery name="CountProgram" 
      datasource="AppsProgram" 
      username="#SESSION.login#" 
      password="#SESSION.dbpw#">
      	  SELECT TOP 1 LocationCode
	      FROM   ProgramLocation
    	  WHERE  LocationCode  = '#Form.LocationCodeOld#' 
    </cfquery>
	
	<cfquery name="CountPost" 
      datasource="AppsEmployee" 
      username="#SESSION.login#" 
      password="#SESSION.dbpw#">
      	  SELECT TOP 1 LocationCode
	      FROM   Position
    	  WHERE  LocationCode  = '#Form.LocationCodeOld#' 
    </cfquery>

    <cfif CountProgram.recordCount gt 0 or CountPost.recordcount gt 0>
		 
     <script language="JavaScript">    
	   alert("Code is in use. Operation aborted.")     
     </script>  
	 
    <cfelse>
				
		<cfquery name="Delete" 
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			DELETE FROM Location
			WHERE LocationCode = '#FORM.LocationCodeOld#'
		</cfquery>
	
	</cfif>
		
</cfif>	

<script language="JavaScript">
   
	parent.window.close()
	parent.opener.history.go()

</script> 
