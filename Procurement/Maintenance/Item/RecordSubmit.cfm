<!--
    Copyright © 2025 Promisan

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

<cfparam name="url.action" default="">
<cfparam name="form.enforcelisting" default="0">
<cfparam name="form.isServiceItem" default="0">
<cfparam name="form.OCode" default="">

<cfif ParameterExists(Form.Insert)> 
    
	<cfif Form.Code neq "">
			<cfquery name="Verify" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT *
			FROM ItemMaster
			WHERE Code  = '#Form.Code#' 
			</cfquery>
				
			<cfif Len(Form.Memo) gt 200>
			 <cf_alert message = "Your entered a memo that exceeded the allowed size of 200 characters.">
			  <cfabort>
			</cfif>
			
			<cfset costprice = replace("#Form.CostPrice#",",","")> 
			
				<cfif Verify.recordCount is 1>
			   
				   <script language="JavaScript">			   
					 alert("A record with this code has been registered already!")								 
				   </script>  
			  
			    <cfelse>
							   
				  	<cfquery name="Insert" 
						datasource="AppsPurchase" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						INSERT INTO ItemMaster
							 (Code,
							 Mission,
							 Description, 						 
							 Memo,
							 CostPrice,						 
							 EnforceWarehouse,
							 EnforceListing,
							 EntryClass,
							 OfficerUserId,
							 OfficerLastName,
							 OfficerFirstName)
					    VALUES ('#Form.Code#', 
					          <cfif form.mission neq "">
					          '#Form.Mission#',
							  <cfelse>
							  NULL,
							  </cfif>
							  '#Form.Description#',				  		  
							  '#Form.Memo#',
							  '#costprice#',						 
							  '#Form.EnforceWarehouse#',
							  '#Form.EnforceListing#',
							  '#Form.EntryClass#',
							  '#SESSION.acc#',
							  '#SESSION.last#',		  
							  '#SESSION.first#')
					</cfquery>
					
				    <cfif form.OCode neq "">	
				  		   
					  <cfquery name="Insert" 
						datasource="AppsPurchase" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						INSERT INTO ItemMasterObject
								    (ItemMaster,ObjectCode)
						  VALUES    ('#Form.Code#','#Form.OCode#')						  
					  </cfquery>
				  
				    </cfif>
				  	
					<cf_LanguageInput
						TableCode       = "ItemMaster" 
						Mode            = "Save"
						DataSource      = "AppsPurchase"
						Key1Value       = "#Form.Code#"
						Name1           = "Description">
					
					<cfset url.immCode = Form.Code>
					<cfinclude template="RecordSubmitItemMasterMission.cfm">
					
					<cfif form.OCode neq "">
					   <cfset obj = form.OCode>
					<cfelse>
						<cfset obj = url.object>
					</cfif>
								
					<cfoutput>
						<script language="JavaScript">						     
						       try {
								     parent.opener.refreshlisting('#obj#')			 	  
							   } catch(e) {}	
							try {  
						    parent.window.close()						           
							} catch(e) {}
							try {  
						    opener.window.close()						           
							} catch(e) {}
				        </script>  
					</cfoutput>	
									  
			</cfif>	 
									 
	<cfelse>
	
			<cf_alert message = "You have not submitted all required fields. Operation not allowed.">
			<cfabort>		 
			
	</cfif>
	
</cfif>

<cfif ParameterExists(Form.Update)>

	<cfif Len(Form.Memo) gt 200>
		 <cf_alert message = "Your entered a memo that exceeded the allowed size of 200 characters.">
		  <cfabort>
		</cfif>

		<cfquery name="Verify" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT *
		FROM   ItemMaster
		WHERE  Code  = '#Form.Code#' 
		AND    Code != '#Form.CodeOld#'
		</cfquery>
		
		<cfparam name="Form.CustomDialog" default="">
		
		<cfif verify.recordcount eq "0">
		
			<cfset costprice = replace("#Form.CostPrice#",",","")> 

			<cfquery name="Update" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			UPDATE ItemMaster
				SET Description  = '#Form.Description#' ,
				Code             = '#Form.Code#',
				<cfif form.mission neq "">
				Mission = '#Form.Mission#',
				<cfelse>
				Mission = NULL,
				</cfif>			
				Memo             = '#Form.Memo#',
				CostPrice        = '#CostPrice#',
				EnforceWarehouse = '#Form.EnforceWarehouse#',
				CustomForm       = '#Form.CustomForm#',
				<cfif Form.CustomForm eq "0">
				CustomDialogOverwrite     = '#Form.CustomDialog#',
				<cfelse>
				CustomDialogOverwrite     = NULL,
				</cfif>
				CodeDisplay      = '#Form.CodeDisplay#',
				isServiceItem    = '#Form.isServiceItem#',
				EmployeeLookup   = '#Form.EmployeeLookup#',			
				EnforceListing   = '#Form.EnforceListing#',
				EntryClass       = '#Form.EntryClass#',
				<!--- 
				BudgetRounding   = '#Form.BudgetRounding#', --->
				BudgetAuditClass = '#Form.BudgetAuditClass#',
				BudgetTopic      = '#Form.BudgetTopic#',
				BudgetLabels     = '#replaceNoCase(Form.ReqLabel,',','|','ALL')#',
				Operational      = '#Form.OperationalItem#'
			WHERE Code       = '#Form.CodeOld#'
			</cfquery>
			
			<cf_LanguageInput
			TableCode       = "ItemMaster" 
			Mode            = "Save"
			DataSource      = "AppsPurchase"
			Key1Value       = "#Form.Code#"
			Name1           = "Description">			
			
			<cfset url.immCode = Form.Code>
			<cfinclude template="RecordSubmitItemMasterMission.cfm">					
						
			<cfquery name="Get" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT *
				FROM ItemMaster
				WHERE Code = '#Form.Code#'
			</cfquery>
									
			<cfquery name="Param" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT *
				FROM Parameter
			</cfquery>
						
			<cfquery name="Parameters" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT *
				FROM Ref_ParameterMission
				WHERE Mission = '#form.mission#'
			</cfquery>
									
			<cfquery name="Usage" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT TOP 1 ItemMaster
				FROM   RequisitionLine
				WHERE ItemMaster = '#Form.Code#'
			</cfquery>			
			
			<cfset url.id1 = Form.Code>
			<cfset url.mission = form.mission>
			<cfinclude template="RecordEditForm.cfm">
			
			<cfoutput>
	
		<script language="JavaScript">		   
		   try {
		     parent.opener.refreshlist('#Form.Code#')			 	  
		   } catch(e) {}	
		  
	   	</script>  
	
	       </cfoutput>
									
		<cfelse>	
		
			<script language="JavaScript">
			  	 alert("Code already exists.")				
	    	</script>  
			
		</cfif>
			
</cfif>

<cfif url.action eq "delete"> 

    <cfquery name="Request" 
     datasource="AppsPurchase" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     SELECT   top 1 * 
     FROM     RequisitionLine
     WHERE    ItemMaster = '#url.Code#' 
	 </cfquery>
	 
	  <cfquery name="Allotment" 
     datasource="AppsProgram" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     SELECT    top 1 *
     FROM     ProgramAllotmentRequest
     WHERE    ItemMaster = '#url.Code#' 
	 </cfquery>
	
    <cfif Request.recordCount gte "1" or Allotment.recordcount gte "1">
		 
     <script language="JavaScript">
    
	   alert("Item Master is in use. Operation aborted.")
     
     </script>  
	 	 
    <cfelse>
	
		<cfquery name="Delete" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		DELETE FROM ItemMasterVendor
		WHERE Code   = '#url.code#'
    </cfquery>
	
	<cfquery name="Delete" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		DELETE FROM ItemMaster
		WHERE Code   = '#url.code#'
    </cfquery>	
	
    </cfif>	
	
	<cfoutput>
	
		<script language="JavaScript">		   
		   try {
		     parent.opener.refreshlist('#url.code#')			 	  
		   } catch(e) {}	
		   try {  
			    opener.window.close()						           
				} catch(e) {}
			try {  
			    parent.window.close()						           
				} catch(e) {}				
		  	
	   	</script>  
	
	</cfoutput>
	
</cfif>	
	