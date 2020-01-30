
<cfparam name="Form.PreparationMode"       default="Job">
<cfparam name="Form.PreparationModeCreate" default="0">

<cfif ParameterExists(Form.Insert)> 
	
		<cfquery name="Verify" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT *
			FROM Ref_OrderClass
			WHERE Code  = '#Form.Code#' 
		</cfquery>
	
	    <cfif Verify.recordCount is 1>
	   
	   <script language="JavaScript">
	   
	     alert("A record with this code has been registered already!")
	     
	   </script>  
  
   <CFELSE>
	    
	<cfquery name="Insert" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	INSERT INTO Ref_OrderClass
	         (Code,
			 Mission,
			 GLAccountTax,
			 Description, 
			 PreparationMode,
			 PreparationModeCreate,
			 PurchaseTemplate,
			 ExecutionTemplate,
			 OfficerUserId,
			 OfficerLastName,
			 OfficerFirstName,	
			 Created)
	  VALUES ('#Form.Code#', 
			  <cfif form.mission eq "">
			  NULL,
			  <cfelse>
			  '#Form.Mission#',
			  </cfif>
			  '#Form.GLAccountTax#',
	          '#Form.Description#',
			  '#Form.PreparationMode#',
			  '#Form.PreparationModeCreate#',
			  '#Form.PurchaseTemplate#',
			  '#Form.ExecutionTemplate#',
			  '#SESSION.acc#',
	    	  '#SESSION.last#',		  
		  	  '#SESSION.first#',
			  getDate())
	  </cfquery>
		  
	</cfif>	  

</cfif>

<cfif ParameterExists(Form.Update)>

	<cfquery name="Update" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE Ref_OrderClass
		SET   Description       = '#Form.Description#',
		      Code              = '#Form.Code#',
			  <cfif form.mission eq "">
			   	  Mission =  NULL,
			  <cfelse>
				  Mission = '#Form.Mission#',
			  </cfif>
			  GLAccountTax          = '#Form.GLAccountTax#',			  
			  PreparationMode       = '#Form.PreparationMode#',
			  PreparationModeCreate = '#form.PreparationModeCreate#',
			  PurchaseTemplate      = '#Form.PurchaseTemplate#',
			  ExecutionTemplate     = '#Form.ExecutionTemplate#'
		WHERE Code = '#Form.CodeOld#' 
	</cfquery>
	
</cfif>

<cfif ParameterExists(Form.Delete)> 

    <cfquery name="CountRec" 
     datasource="AppsPurchase" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     	 SELECT    *
	     FROM     Purchase
    	 WHERE    OrderClass = '#Form.Code#' 
	 </cfquery>
	
    <cfif CountRec.recordCount gt 0 >
		 
	     <script language="JavaScript">    
		   alert("Order Class is in use. Operation aborted.")     
	     </script>  
	 	 
    <cfelse>
			
		<cfquery name="Delete" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			DELETE FROM Ref_OrderClass
			WHERE  Code   = '#Form.code#'
	    </cfquery>
	
    </cfif>	
	
</cfif>	
	
<script language="JavaScript">   
     window.close()
	 opener.location.reload()        
</script>  