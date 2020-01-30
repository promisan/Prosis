
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>"> 

<cfparam name="Form.ProgramCategory" default="">
<cfparam name="Form.Mission" default="">
<cfparam name="Form.IndicatorTemplateAjax" default="0">
<cfparam name="Form.Operational" default="0">
<cfparam name="Form.ZeroBase" default="0">
<cfif Form.IndicatorTemplate eq "">
    <cfset Form.IndicatorDrilldown = "0">	
</cfif>

<cfif Len(Form.IndicatorMemo) gt 1000>
	 <cf_message message = "Your entered a memo that exceeded the allowed size of 1000 characters."
	  return = "back">
	  <cfabort>
</cfif>

<cfif Form.Mission eq "" and (ParameterExists(Form.Insert) or ParameterExists(Form.Update))>
	 		
		 <cf_message message = "You must associate the indicator to one or more trees. Operation not allowed."
		  return = "back">
		  <cfabort>		
			
</cfif>

<cfif ParameterExists(Form.Insert)> 
   
	<cfquery name="Verify" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM Ref_Indicator
	WHERE IndicatorCode  = '#Form.IndicatorCode#' 
	</cfquery>

   <cfif Verify.recordCount is 1>
   
   <script language="JavaScript">
   
     alert("An indicator with this code has been registered already!")
     
   </script>  
  
   <cfelse>
   
	   	<cftransaction>
   				
		<cfquery name="Insert" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		INSERT INTO Ref_Indicator
		         (IndicatorCode,
				 IndicatorCodeDisplay,
				 IndicatorDescription,
				 IndicatorDescriptionAlternate,
				 IndicatorUoM,
				 IndicatorType,
				 <cfif #Form.ProgramCategory# neq "">
				 ProgramCategory,
				 </cfif>
				 ZeroBase,
				 TargetDirection,
				 TargetRange,
				 IndicatorPrecision,
				 IndicatorDrilldown,
				 IndicatorTemplate,
				 IndicatorCriteriaBase,
				 IndicatorTemplateAjax,
				 AuditClass,
				 AuditSource,
				 IndicatorMemo,
				 OfficerUserId,
				 OfficerLastName,
				 OfficerFirstName,	
				 Created)
		  VALUES ('#Form.IndicatorCode#',
				  '#Form.IndicatorCodeDisplay#',
        		  '#Form.IndicatorDescription#', 
				  '#Form.IndicatorDescriptionAlternate#', 
				  '#Form.IndicatorUoM#',
				  '#Form.IndicatorType#',
				  <cfif #Form.ProgramCategory# neq "">
				  '#Form.ProgramCategory#',
				  </cfif>
				  '#Form.ZeroBase#',
				  '#Form.TargetDirection#',
				  '#Form.TargetRange#',
				  '#Form.IndicatorPrecision#',
				  '#Form.IndicatorDrilldown#',
				  '#Form.IndicatorTemplate#',
				  '#Form.IndicatorCriteriaBase#',
				  '#Form.IndicatorTemplateAjax#',
				  '#Form.AuditClass#',
				  '#Form.AuditSource#',
				  '#Form.IndicatorMemo#',
				  '#SESSION.acc#',
		    	  '#SESSION.last#',		  
			  	  '#SESSION.first#',
				  getDate())</cfquery>
			  		       								
				<cfloop index="mis" list="#form.mission#" delimiters=",">
				
					<cfquery name="Insert" 
					datasource="AppsProgram" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					INSERT INTO Ref_IndicatorMission
					         (IndicatorCode,
							 Mission,
							 OfficerUserId,
							 OfficerLastName,
							 OfficerFirstName,	
							 Created)
					  VALUES ('#Form.IndicatorCode#',
							  '#mis#',
							  '#SESSION.acc#',
					    	  '#SESSION.last#',		  
						  	  '#SESSION.first#',
							  getDate())
					</cfquery>
							
				</cfloop>
				
			</cftransaction>	
			
			 <!--- language provision --->
				
				  <cf_LanguageInput
				TableCode       = "Ref_Indicator" 
				Mode            = "Save"
				Key1Value       = "#Form.IndicatorCode#"
				Name1           = "IndicatorDescription">
	      			     		  
    </cfif>		  
           
</cfif>

<cfif ParameterExists(Form.Update)>

		
	<cftransaction>

	<cfquery name="Update" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE Ref_Indicator
		SET IndicatorCodeDisplay   = '#Form.IndicatorCodeDisplay#',
		    IndicatorDescription   = '#Form.IndicatorDescription#',
			IndicatorDescriptionAlternate = '#Form.IndicatorDescriptionAlternate#',
		    IndicatorUoM           = '#Form.IndicatorUoM#',
			IndicatorType          = '#Form.IndicatorType#',
			ProgramCategory        = '#Form.ProgramCategory#',
			IndicatorPrecision     = '#Form.IndicatorPrecision#',
			NameBase               = '#Form.NameBase#',
			NameCounter            = '#Form.NameCounter#',
			ZeroBase               = '#Form.ZeroBase#',
			IndicatorDrilldown     = '#Form.IndicatorDrilldown#',
		    IndicatorTemplate      = '#Form.IndicatorTemplate#',
			IndicatorCriteriaBase  = '#Form.IndicatorCriteriaBase#',
			IndicatorTemplateAjax  = '#Form.IndicatorTemplateAjax#',
			TargetDirection        = '#Form.TargetDirection#',
			TargetRange            = '#Form.TargetRange#',
			IndicatorWeight        = '#Form.IndicatorWeight#',
			AuditClass             = '#Form.AuditClass#',
			Operational            = '#Form.Operational#',
			ChartType              = '#Form.ChartType#',
			ChartColorTarget       = '#Form.ChartColorTarget#',
			ChartColorUpload       = '#Form.ChartColorUpload#',
			ChartColorManual       = '#Form.ChartColorManual#',
			<cfif form.indicatortype eq "0001">
				
				<cfif form.chartscaleto neq "">
					ChartScaleFrom      = '#Form.ChartScaleFrom#',
					ChartScaleTo        = '#Form.ChartScaleTo#',
					ChartLines          = '#Form.ChartLines#',
				<cfelse>
					ChartScaleTo        = NULL,
					ChartScaleFrom      = NULL,
					ChartLines         = NULL,					
				</cfif>			
			
			<cfelse>
			
				ChartScaleFrom         = NULL,
				ChartScaleTo           = NULL,
				ChartLines             = NULL,
				
			</cfif>	
			
			<cfif ParameterExists(Form.Source)>
			AuditSource            = '#Form.AuditSource#',
			<cfelse>
			AuditSource            = 'Manual',
			</cfif>
			IndicatorMemo          = '#Form.IndicatorMemo#'
		WHERE IndicatorCode        = '#Form.IndicatorCode#'
	</cfquery>
	
	<cfquery name="Clear" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		DELETE FROM Ref_IndicatorMission
		WHERE IndicatorCode = '#Form.IndicatorCode#'
	</cfquery>
	
	<cfloop index="mis" list="#form.mission#" delimiters=",">
	
		<cfparam name="Form.#Mis#AuthorizationClass" default="">
		<cfset cl = evaluate("Form.#mis#AuthorizationClass")>
				
					<cfquery name="Insert" 
					datasource="AppsProgram" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					INSERT INTO Ref_IndicatorMission
					         (IndicatorCode,
							 Mission,
							 AuthorizationClass,
							 OfficerUserId,
							 OfficerLastName,
							 OfficerFirstName,	
							 Created)
					  VALUES ('#Form.IndicatorCode#',
							  '#mis#',
							  '#cl#',
							  '#SESSION.acc#',
					    	  '#SESSION.last#',		  
						  	  '#SESSION.first#',
							  getDate())
					</cfquery>
							
	 </cfloop>
	 
	 </cftransaction>

	  <cf_LanguageInput
				TableCode       = "Ref_Indicator" 
				Mode            = "Save"
				Key1Value       = "#Form.IndicatorCode#"
				Name1           = "IndicatorDescription">
</cfif>	

<cfif ParameterExists(Form.Delete)> 

	<cfquery name="Delete" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		DELETE FROM ProgramIndicator
		WHERE Indicatorcode = '#FORM.Indicatorcode#'
		AND RecordStatus = '9'
    </cfquery>

    <cfquery name="CountRec" 
      datasource="AppsProgram" 
      username="#SESSION.login#" 
      password="#SESSION.dbpw#">
      SELECT *
      FROM   ProgramIndicator
      WHERE  IndicatorCode  = '#Form.IndicatorCode#' 
    </cfquery>
    
    <cfif CountRec.recordCount gt 0>
		 
     <script language="JavaScript">
    
	   alert("Code is in use. Operation aborted.")
	        
     </script>  
	 
    <cfelse>
			
	<cfquery name="Delete" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	DELETE FROM Ref_Indicator
	WHERE Indicatorcode = '#FORM.Indicatorcode#'
    </cfquery>
				
	</cfif>
		
</cfif>	

<!--- verify sources --->

<cfif ParameterExists(Form.Insert) or ParameterExists(Form.Update)> 

	<cfquery name="Remove" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	DELETE FROM Ref_IndicatorSource
	WHERE IndicatorCode = '#Form.IndicatorCode#'
	</cfquery>
	
	<cfquery name="Manual" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	INSERT INTO Ref_IndicatorSource
	(IndicatorCode, Source)
	VALUES ('#Form.IndicatorCode#', 'Manual')
	</cfquery>
	
	<cfif AuditSource eq "External" and ParameterExists(Form.Source)>
	
		<cfquery name="External" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		INSERT INTO Ref_IndicatorSource
		(IndicatorCode, Source)
		VALUES ('#Form.IndicatorCode#', '#Form.Source#')
		</cfquery>
		
	</cfif>

</cfif>

<CF_DropTable dbName="AppsQuery"  tblName="#SESSION.acc#Indicator">

<cfoutput>

<script language="JavaScript">    
     window.close()	
	 opener.ColdFusion.navigate('RecordListingDetail.cfm?mission=#url.mission#','i#url.mission#') 		   
</script>  
</cfoutput>

