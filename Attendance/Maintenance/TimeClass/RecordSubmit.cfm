
<cfif url.id1 eq ""> 
	
	<cfquery name="Verify" 
	datasource="appsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   Ref_TimeClass
		WHERE  TimeClass  = '#Form.TimeClass#' 
	</cfquery>

   <cfif Verify.recordCount eq "1">
   
	   <script language="JavaScript">   
		     alert("A record with this code has been registered already!");
	   </script>  
  
   <cfelse>
	   
		<cfquery name="Insert" 
			datasource="appsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			  INSERT INTO Ref_TimeClass
			       	(
						TimeClass,
					   	Description,
						<cfif trim(form.DescriptionShort neq "")>DescriptionShort,</cfif>
					   	ListingOrder,
					   	ViewColor,
					   	ShowInAttendance
					)
			  VALUES  
			  		(	'#Form.TimeClass#',
			           	'#Form.Description#', 
					   	<cfif trim(form.DescriptionShort neq "")>'#form.DescriptionShort#',</cfif>
					   	#form.ListingOrder#,
			    	   	'#form.ViewColor#',		  
				  	   	#form.ShowInAttendance#
					)
		</cfquery>
		 
		<cf_ModuleControlLog systemfunctionid="#url.idmenu#" 
		                     action="Insert" 
							 content="#form#">
		 
    </cfif>		  
           
<cfelse>
	
	<cfquery name="Update" 
		datasource="appsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			UPDATE 	Ref_TimeClass
			SET   	Description = '#Form.Description#',
					DescriptionShort = <cfif trim(form.DescriptionShort) neq "">'#form.DescriptionShort#'<cfelse>null</cfif>,
					ListingOrder = #form.ListingOrder#,
					ViewColor = '#form.ViewColor#',
					ShowInAttendance = #form.ShowInAttendance#
			WHERE 	TimeClass = '#url.id1#'
	</cfquery>
	
	<cf_ModuleControlLog systemfunctionid="#url.idmenu#" 
	                     action="Update" 
						 content="#form#">		 

</cfif>	

<script>
	window.close();
	opener.location.reload();
</script>
