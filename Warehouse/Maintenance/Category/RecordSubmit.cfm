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

<cfparam name="Form.InitialReview" default="0">
<cfparam name="Form.Acronym" default="">

<cfif ParameterExists(Form.Insert)> 

<cfquery name="Verify" 
datasource="appsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM Ref_Category
	WHERE Category   = '#Form.Category#' 
</cfquery>

    <cfif #Verify.recordCount# is 1>
   
   <script language="JavaScript">
   
     alert("A record with this code has been registered already!")
     
   </script>  
  
   <CFELSE>
   
   		<cftransaction>
     
		<cfquery name="Insert" 
		datasource="appsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			INSERT INTO Ref_Category
		         (Category,
				 <cfif trim(form.Acronym) neq "">Acronym,</cfif>
				 Description, 
				 <cfif trim(form.tabOrder) neq "">TabOrder,</cfif>
				 <cfif trim(form.tabIcon) neq "">TabIcon,</cfif>
				 SensitivityLevel,				 
				 InitialReview,
				 DistributionMode,
				 DistributionFilter,
				 FinishedProduct,
				 StockControlMode,
				 CommissionMode,
				 VolumeManagement,
				 OfficerUserId,
				 OfficerLastName,
				 OfficerFirstName)
		  	VALUES ('#Form.Category#', 
				  <cfif trim(form.Acronym) neq "">'#Form.Acronym#',</cfif>
		          '#Form.Description#',
				  <cfif trim(form.tabOrder) neq "">#Form.TabOrder#,</cfif>
				  <cfif trim(form.tabIcon) neq "">'#Form.TabIcon#',</cfif>
				  '#Form.SensitivityLevel#',
				  '#Form.InitialReview#',
				  '#Form.DistributionMode#',
				  '#Form.DistributionFilter#',
				  '#Form.FinishedProduct#',
				  '#Form.StockControlMode#',
				  '#Form.CommissionMode#',
				  '#Form.VolumeManagement#',
				  '#SESSION.acc#',
		    	  '#SESSION.last#',		  
			  	  '#SESSION.first#')
		</cfquery>
		
		<cf_LanguageInput
			TableCode       = "Ref_Category" 
			Mode            = "Save"
			DataSource      = "AppsMaterials"
			Key1Value       = "#Form.Category#"
			Name1           = "Description">
			
		<!--- Default generic Item --->	
		
		<cfquery name="insertItem" 
			datasource="appsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				INSERT INTO Ref_CategoryItem (
						Category,
						CategoryItem,
						CategoryItemName,
						CategoryItemOrder,
						OfficerUserId,
						OfficerLastName,
						OfficerFirstName )
				VALUES	(
						'#Form.Category#',
						'001',
						'Default',
						1,
						'#SESSION.acc#',
						'#SESSION.last#',
						'#SESSION.first#'
					)
		</cfquery>
		
		<cf_ModuleControlLog systemfunctionid="#url.idmenu#" 
	                         action ="Insert" 
							 datasource="AppsMaterials"
							 content="#Form#">
		
		</cftransaction>				
		  
	</cfif>	  

</cfif>

<cfif ParameterExists(Form.Update)>


<!--- remove  this cftransaction it was orphaned 
<cftransaction>

--->	

	<cfparam name="Form.CommissionMode" default="1">
	 
	<cfquery name="Update" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE Ref_Category
		SET    Description        = '#Form.Description#', 
		       Acronym			  = <cfif trim(form.Acronym) neq "">'#Form.Acronym#'<cfelse>null</cfif>,
	           InitialReview      = '#Form.InitialReview#',
		       DistributionFilter = '#Form.DistributionFilter#',
		       ValuationCode      = '#Form.ValuationCode#',
		       DistributionMode   = '#Form.DistributionMode#',
			   VolumeManagement	  = '#Form.VolumeManagement#',
			   CommissionMode     = '#Form.CommissionMode#',
			   FinishedProduct	  = '#Form.FinishedProduct#',
			   StockControlMode   = '#Form.StockControlMode#',
		       TabOrder			  = <cfif trim(form.tabOrder) neq "">#Form.TabOrder#<cfelse>null</cfif>,
		       TabIcon    		  = <cfif trim(form.TabIcon) neq "">'#Form.TabIcon#'<cfelse>null</cfif>,
		       SensitivityLevel   = '#Form.SensitivityLevel#'
		WHERE  Category           = '#Form.Category#'
	</cfquery>
	
	<cf_ModuleControlLog systemfunctionid="#url.idmenu#" 
	                         action ="Update" 
							 content="#Form#">
	
	<cf_LanguageInput
			TableCode       = "Ref_Category" 
			Mode            = "Save"
			Key1Value       = "#Form.Category#"
			Name1           = "Description">
					
	<!--- I, dev, placed this before the verification otherwise the server got down as the verification is  heavy ---->
		
	<!--- 5/8/2016, this is now disabled as we don't allow GL stock accounts to be changed anymore once used
	now we check of the value in the general ledger would need to be corrected by comparing transaction value with GL value 
	
	<cfinvoke component = "Service.Process.Materials.Stock"  
				   method           = "setStockLedger" 		
				   datasource       = "AppsMaterials"		  				   	  				  		   
				   categorynew      = "#Form.Category#">	    
				   
	--->			   
				   
					
			
</cfif>

<cf_systemscript>

<cfoutput>
	<script>
		opener.location.reload();
		ptoken.location("RecordEditTab.cfm?id1=#Form.Category#&idmenu=#url.idmenu#");		
	</script>
</cfoutput>
	
