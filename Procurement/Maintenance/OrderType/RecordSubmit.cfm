
<cfif ParameterExists(Form.invoiceworkflow)>
	<cfset InvoiceWorkflow = "#Form.invoiceworkflow#" >
<cfelse>
	<cfset InvoiceWorkflow = 0>
</cfif>  

<cfif ParameterExists(Form.EnableFinanceFlow)>
	<cfset EnableFinanceFlow = "#Form.EnableFinanceFlow#" >
<cfelse>
	<cfset EnableFinanceFlow = 0>
</cfif>  
 
<cfif ParameterExists(Form.Tracking)>
	<cfset Tracking= "#Form.Tracking#" >
<cfelse>
	<cfset Tracking = 0>
</cfif>  

<cfif ParameterExists(Form.ReceiptEntry)>
	<cfset ReceiptEntry= "#Form.ReceiptEntry#" >
<cfelse>
	<cfset ReceiptEntry = 0>
</cfif>  

<cfif ParameterExists(Form.Insert)> 

<cfquery name="Verify" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM Ref_OrderType
	WHERE Code  = '#Form.Code#' 

</cfquery>

    <cfif #Verify.recordCount# is 1>
   
	   <script language="JavaScript">
	   
	     alert("An record with this code has been registered already!")
	     
	   </script>  
	  
	   <CFELSE>
			  
			   
			<cfquery name="Insert" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			INSERT INTO Ref_OrderType
			         (Code,
					 <!--- 	 Mission, --->
					 Description, 
					 InvoiceWorkflow, 
					 EnableFinanceFlow, 
					 Tracking, 
					 ReceiptValueValidate,
					 ReceiptValueComplete,
					 ReceiptValueThreshold,
					 ReceiptEntry,
					 OfficerUserId,
					 OfficerLastName,
					 OfficerFirstName,	
					 Created)
			  VALUES ('#Form.Code#', 
			          <!--- 
			          <cfif form.mission eq "">
					  NULL,
					  <cfelse>
					  '#Form.Mission#',
					  </cfif>
					  --->
			          '#Form.Description#',
					  '#InvoiceWorkflow#',
					  '#EnableFinanceFlow#',
					  '#Tracking#',
					  '#Form.ReceiptValueValidate#',
					  '#Form.ReceiptValueComplete#',
					  '#Form.ReceiptValueThreshold#',
					  '#ReceiptEntry#',
					  '#SESSION.acc#',
			    	  '#SESSION.last#',		  
				  	  '#SESSION.first#',
					  getDate())
			</cfquery>
			
			<cfparam name="Form.ClauseSelect" default="">	  
					
			<cfif Form.ClauseSelect neq "">
			
				<cfloop index="itm" list="#Form.ClauseSelect#">
				
					<cfquery name="Insert" 
					datasource="AppsPurchase" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					INSERT INTO Ref_OrderTypeClause
					         (OrderType,
							 ClauseCode,
							 Created)
					  VALUES ('#Form.Code#', 
					          '#itm#',
							  getDate())
					</cfquery>
			
				</cfloop>	
				  
		    </cfif>
			
			<!--- Missions --->
			
			<cfquery name="MissionL" 
				datasource="AppsPurchase" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT 	*
					FROM  	Ref_ParameterMission
			</cfquery>
			
			<cfloop query="MissionL">
			
				<cfset formattedMission = replace(mission,"-","","ALL")>
				<cfset formattedMission = replace(formattedMission," ","","ALL")>
				
				<cfif isDefined("Form.mission_#formattedMission#")>
					<cfquery name="InsertMission" 
					datasource="AppsPurchase" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					INSERT INTO Ref_OrderTypeMission (
							 	Code,
							 	Mission,
								OfficerUserId,
								OfficerLastName,
								OfficerFirstName )
					  VALUES (	'#Form.Code#', 
					          	'#mission#',
								'#SESSION.acc#',
								'#SESSION.last#',
								'#SESSION.first#' )
					</cfquery>
				</cfif>
			</cfloop>
				  
		</cfif>	  

</cfif>

<cfif ParameterExists(Form.Update)>	 

	<cfquery name="Update" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	UPDATE Ref_OrderType
	SET   Description      = '#Form.Description#' ,
	      <cfif ReceiptEntry neq "9">
	     	 InvoiceWorkflow  = '#InvoiceWorkflow#',
		  <cfelse>
			 InvoiceWorkflow  = '1',
		  </cfif>		 
	      EnableFinanceFlow  = '#EnableFinanceFlow#',
		  ReceiptValueValidate  = '#form.ReceiptValueValidate#',
		  ReceiptValueComplete  = '#Form.ReceiptValueComplete#', 
		  ReceiptValueThreshold  = '#Form.ReceiptValueThreshold#', 
		  <cfif receiptentry eq "1">
		  ReceiptEntryForm    = '#form.ReceiptEntryForm#',
		  ReceiptEntryLines   = '#form.ReceiptEntryLines#',
		  ReceiptPrice        = '#Form.ReceiptPrice#',
		  ReceiptDeliveryTime = '#Form.ReceiptDeliveryTime#',
		  <cfelse>
		  ReceiptEntryForm   = NULL,
		  ReceiptEntryLines  = 0,
		  </cfif>
	      Tracking           = '#Tracking#',
		  ReceiptEntry       = '#ReceiptEntry#',
	      Code               = '#Form.Code#'
	WHERE Code  = '#Form.CodeOld#' 
	</cfquery>
	
	<!--- Missions --->
	
	<cfquery name="ClearMission" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			DELETE
			FROM  	Ref_OrderTypeMission
			WHERE	Code = '#Code#'
	</cfquery>
			
	<cfquery name="MissionL" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT 	*
			FROM  	Ref_ParameterMission
	</cfquery>
	
	<cfloop query="MissionL">
		<cfset formattedMission = replace(mission,"-","","ALL")>
		<cfset formattedMission = replace(formattedMission," ","","ALL")>
		<cfif isDefined("Form.mission_#formattedMission#")>
			<cfquery name="InsertMission" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			INSERT INTO Ref_OrderTypeMission
			         (
					 	Code,
					 	Mission,
						OfficerUserId,
						OfficerLastName,
						OfficerFirstName
					 )
			  VALUES (
			  			'#Form.Code#', 
			          	'#mission#',
						'#SESSION.acc#',
						'#SESSION.last#',
						'#SESSION.first#'
					 )
			</cfquery>
		</cfif>
	</cfloop>
	
	<cfquery name="Delete" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		DELETE FROM Ref_OrderTypeClause
		WHERE OrderType = '#Form.CodeOld#'
	</cfquery>
	
	<cfparam name="Form.ClauseSelect" default="">	  
				
		<cfif Form.ClauseSelect neq "">
		
			<cfloop index="itm" list="#Form.ClauseSelect#">
			
				<cfquery name="Insert" 
				datasource="AppsPurchase" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				INSERT INTO Ref_OrderTypeClause
				         (OrderType,
						 ClauseCode,
						 Created)
				  VALUES ('#Form.Code#', 
				          '#itm#',
						  getDate())
				</cfquery>
		
			</cfloop>	
			  
	    </cfif>	
			

</cfif>

<cfif ParameterExists(Form.Delete)> 

    <cfquery name="CountRec" 
     datasource="AppsPurchase" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     SELECT    *
     FROM     Purchase
     WHERE    OrderType = '#Form.Code#' 
	 </cfquery>
	
    <cfif CountRec.recordCount gt 0 >
		 
     <script language="JavaScript">
    
	   alert(" Order type is in use. Operation aborted.")
     
     </script>  
	 	 
    <cfelse>	
			
	<cfquery name="Delete" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	DELETE FROM Ref_OrderType
	WHERE Code   = '#Form.code#'
    </cfquery>
	
    </cfif>	
	
</cfif>	
	
<script language="JavaScript">
   
     window.close()
	 opener.location.reload()
        
</script>  