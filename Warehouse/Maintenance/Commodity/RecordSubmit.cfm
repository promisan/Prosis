
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>"> 

<cfif ParameterExists(Form.Insert)> 
	
	<cfquery name="Verify" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   Ref_Commodity
		WHERE  CommodityCode  = '#Form.Code#' 
	</cfquery>

   <cfif Verify.recordCount eq "1">
   
	   <script language="JavaScript">   
		     alert("A record with this code has been registered already!")     
	   </script>  
  
   <cfelse>
	   
		<cfquery name="Insert" 
		datasource="appsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		  INSERT INTO Ref_Commodity
		          (CommodityCode,
				   Description,
				   OfficerUserId,
				   OfficerLastName,
				   OfficerFirstName,	
				   Created)
		  VALUES  ('#Form.Code#',
		           '#Form.Description#', 
				   '#SESSION.acc#',
		    	   '#SESSION.last#',		  
			  	   '#SESSION.first#',
				   getDate())
		</cfquery>
		 
		<cf_ModuleControlLog systemfunctionid="#url.idmenu#" 
		                     action="Insert" 
							 content="#form#">
		  
    </cfif>		  
           
</cfif>

<cfif ParameterExists(Form.Update)>
	
	<cfquery name="Update" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE Ref_Commodity
		SET   CommodityCode  = '#Form.code#',
		      Description    = '#Form.Description#'
		WHERE CommodityCode   = '#Form.CodeOld#'
	</cfquery>
	
	<cf_LanguageInput
			TableCode       = "Ref_Commodity" 
			Mode            = "Save"
			DataSource      = "AppsMaterials"
			Key1Value       = "#Form.code#"
			Name1           = "Description">
	
	
	<cf_ModuleControlLog systemfunctionid="#url.idmenu#" 
	                     action="Update" 
						 content="#form#">

</cfif>	

<cfif ParameterExists(Form.Delete)> 

<cfquery name="CountRec" 
      datasource="appsMaterials" 
      username="#SESSION.login#" 
      password="#SESSION.dbpw#">
      SELECT CommodityCode
      FROM   Item
      WHERE  CommodityCode = '#Form.codeOld#' 
    </cfquery>

    <cfif CountRec.recordCount gt 0>
		 
	     <script language="JavaScript">    
		   alert("Code is in use. Operation aborted.")	        
	     </script>  
	 
    <cfelse>
	
		<cf_ModuleControlLog systemfunctionid="#url.idmenu#" 
             action="Delete" 
			 content="#form#">
			
		<cfquery name="Delete" 
		datasource="appsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			DELETE FROM Ref_Commodity
			WHERE CommodityCode = '#FORM.codeOld#'
	    </cfquery>
	
	</cfif>	
	
</cfif>	

<script language="JavaScript">
   
     window.close()
	 opener.location.reload()
        
</script>  
