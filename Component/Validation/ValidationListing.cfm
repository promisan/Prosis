<cf_param name="url.systemfunctionid" default="" type="string">
<cf_param name="url.target"			  default="" type="string">
<cf_param name="url.object"			  default="" type="string">
<cf_param name="url.width"			  default="90%" type="string">


  <!--- if condition is not met it re-create an entry in the table --->
			 							 
		 <cfquery name="getValidation" 
		 datasource="AppsSystem" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
			 SELECT   C.SystemModule, 
			          C.FunctionName, 
					  R.ValidationCode, 
					  R.ValidationName, 
					  R.ValidationMethod,
					  M.ValidationClass
			 FROM     Ref_ModuleControlValidation M INNER JOIN
                      Ref_Validation R ON M.ValidationCode = R.ValidationCode INNER JOIN
                      Ref_ModuleControl C ON M.SystemFunctionId = C.SystemFunctionId
			 WHERE    M.SystemFunctionId = '#url.SystemFunctionId#'
			 <cfif mission neq "">
			 AND      EXISTS (SELECT 'X' 
			                     FROM  Ref_ModuleControlValidationMission
								 WHERE SystemFunctionId = M.SystemFunctionId
								 AND   ValidationCode = M.ValidationCode
								 AND   Mission = '#url.mission#') 
			 </cfif>
			 AND      M.Operational = 1
			 ORDER BY M.ListingOrder ASC
			 
			 
		 </cfquery> 		 
			 
		<cf_pane id="validationMonitor" search="No" height="95%">
		
			<div style="width:84%; background-color:#DEDEDE; padding:8px; margin-bottom:10px; font-size:125%;">
				<cfoutput>
					<cf_tl id="Validations" var="1">
					#ucase(lt_text)#
					<cf_tl id="Refresh all" var="1">
					<img 
						src="#session.root#/images/refresh_gray.png" 
						style="float:right; height:16px; cursor:pointer;" 
						onclick="parent.parent.doProjectValidations();"
						title="#lt_text#">
				</cfoutput>
			</div>
						 	 			 
			 <cfoutput query="getValidation">
			 
									 			 			 		
				 <!--- <cftry>	--->
 
				 	<cfinvoke component = "Service.Validation.#SystemModule#"  
					   method           = "#ValidationMethod#" 					   
					   mission          = "#Mission#" 
					   ValidationCode   = "#ValidationCode#"
					   Owner            = "#Owner#" 
					   Object           = "#Object#"
					   ObjectKeyValue1  = "#ObjectKeyValue1#"
					   ObjectKeyValue2  = "#ObjectKeyValue2#"
					   ObjectKeyValue3  = "#ObjectKeyValue3#"
					   ObjectKeyValue4  = "#ObjectKeyValue4#"
					   Target			= "#target#"
					   returnvariable   = "validationResult">	
					   
					  <cfparam name="ValidationResult.pass" default="OK">
					   
					  <cfquery name="get" 
						 datasource="AppsSystem" 
						 username="#SESSION.login#" 
						 password="#SESSION.dbpw#">
						   SELECT * FROM ValidationAction
						   WHERE SystemFunctionId = '#SystemFunctionId#'
						   AND   Mission          = '#mission#'
						   AND   Owner            = '#Owner#'
						   AND   ValidationCode   = '#ValidationCode#'
						   <cfif ObjectKeyValue1 neq "">
						   AND   ObjectKeyValue1  = '#ObjectKeyValue1#'
						   </cfif>
						   <cfif ObjectKeyValue2 neq "">
						   AND   ObjectKeyValue2  = '#ObjectKeyValue2#'
						   </cfif>
						   <cfif ObjectKeyValue3 neq "">
						   AND   ObjectKeyValue3  = '#ObjectKeyValue3#'
						   </cfif>
						   <cfif ObjectKeyValue4 neq "">
						   AND   ObjectKeyValue4  = '#ObjectKeyValue4#'
						   </cfif>							 								
					  </cfquery> 	

					  <cfset vActionsList = QuotedValueList(get.ValidationActionId)> 					  	  				   
					   				   
					   <cfif validationResult.Pass eq "OK">
					   
						   <!--- see if record exists and if so we update the status = 3 and put in the expiration date --->
						   
						    <cfif get.recordcount gt 0>
						   
							   	<cfquery name="setValidation" 
								 datasource="AppsSystem" 
								 username="#SESSION.login#" 
								 password="#SESSION.dbpw#">
								   UPDATE 	ValidationAction
								   SET    	ValidationStatus = '3',
								   			ValidationExpiration = GETDATE()
								   WHERE  	ValidationActionId IN (#preserveSingleQuotes(vActionsList)#)					 
								</cfquery> 	 
							 
							 </cfif> 
					   
					   <cfelse>						   
						  
						  <cfif get.recordcount eq "0">
						  
							  <cf_assignid>
							  <cfset actionid = rowguid>							  								  
						   
							    <cfquery name="addValidation" 
								 datasource="AppsSystem" 
								 username="#SESSION.login#" 
								 password="#SESSION.dbpw#">
								   INSERT INTO      ValidationAction
										(ValidationActionId,
										 SystemFunctionId, 
										 ValidationCode, 
										 Owner, 
										 Mission, 
										 <cfif ObjectKeyValue1 neq "">
										 ObjectKeyValue1,
										 </cfif>
										 <cfif ObjectKeyValue2 neq "">
										 ObjectKeyValue2,
										 </cfif>
										 <cfif ObjectKeyValue3 neq "">
										 ObjectKeyValue3,
										 </cfif>
										 <cfif ObjectKeyValue4 neq "">
										 ObjectKeyValue4,
										 </cfif>
										 ValidationEffective,										 
										 ValidationStatus,
										 OfficerUserId,
										 OfficerLastName,
										 OfficerFirstName)
										 VALUES
										 ('#actionid#',
										 '#systemfunctionid#',
										 '#validationcode#',
										 '#owner#',
										 '#mission#',
										 <cfif ObjectKeyValue1 neq "">
										 '#objectkeyvalue1#',
										 </cfif>
										 <cfif ObjectKeyValue2 neq "">
										 '#objectkeyvalue2#',
										 </cfif>
										 <cfif ObjectKeyValue3 neq "">
										 '#objectkeyvalue3#',
										 </cfif>
										 <cfif ObjectKeyValue4 neq "">
										 '#objectkeyvalue4#',
										 </cfif>
										 getDate(),
										 '0',
										 '#session.acc#',
										 '#session.last#',
										 '#session.first#')									
								   </cfquery> 	 
							   							  
						  <cfelse>
						  
						  	<cfset actionid = get.ValidationActionId>
							
							<cfquery name="resetValidation" 
								datasource="AppsSystem" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">
									UPDATE ValidationAction
									SET    ValidationStatus = '0',
										ValidationExpiration = null
									WHERE  	ValidationActionId IN (#preserveSingleQuotes(vActionsList)#)						 
							</cfquery>
						   
						  </cfif>							  
						  
						  <cfset exception = "1">	
						  				   				   
						  <cfif NOT structKeyExists(ValidationResult, "height")>
						  		<cfset vHeight = "150px">								
						  <cfelse>
						  		<cfif ValidationResult.height eq "">
									<cfset vHeight = "150px">
						  		<cfelse>
									<cfset vHeight = "#ValidationResult.height*1+35#px">	
						  		</cfif>								
						  </cfif>		
						  						  						  						  				   				   
					   	  <cfset vPaneId = replace(actionId,"-","","ALL")>	
						  
						  <!--- the validations to be performed --->

						  <cfset vPaneStyle = "color:##FFFFFF; background-color:##E35457;">
						  <cfset vPaneIconSet = "white">
						  <cf_tl id="#ValidationClass#" var="1">
						  <cfif ValidationClass eq "Alert">
							  <cfset vPaneStyle = "color:##333333; background-color:##FFFF7D;">
							  <cfset vPaneIconSet = "gray">
						  </cfif>
						  		  						  						  				   				   
					   	  <cf_paneItem id="#vPaneId#"  
							source="#session.root#/Component/Validation/ValidationApply.cfm?ValidationActionId=#actionid#&target=#target#"								
							style="margin-bottom:2px;"
							headerStyle="padding-top:4px; padding-bottom:3px; height:26px; font-size:13px !important; cursor:pointer; #vPaneStyle#"
							showSeparator="0"
							systemfunctionid="#systemfunctionid#"
							width="#url.width#"
							height="auto"
							ShowPrint="0"
							Transition="fade"
							TransitionTime="1000"	
							IconSet="#vPaneIconSet#"							
							IconHeight="13px"
							label="<span title='#lt_text#'>#ucase(validationResult.label)#</span>">
					   					   
					   </cfif>		
					   
					   <!---				   
					  										   
					<cfcatch>
						<!--- not run : #ValidationMethod# --->
					</cfcatch>      
					
				</cftry>	
				
				--->				
							 
			 </cfoutput>	
			 
			<!--- 			 
			 
			<cfif exception eq "0">
											
			  <cf_paneItem id="review" 
					source="#session.root#/Component/Validation/ApplyValidation.cfm?ValidationActionId="
					filterValue=""
					style="padding-left:5px; padding-right:5px; background-color:C9FCE0; border:1px solid c0c0c0; -moz-border-radius:5px; -webkit-border-radius:5px; -ms-border-radius:5px; -o-border-radius:5px; border-radius:5px;"
					headerStyle="font-size:100%; color:gray; font-weight:bold;"
					showSeparator="1"
					systemfunctionid="#systemfunctionid#"
					width="200px"
					height="130px"
					ShowPrint="1"
					Transition="fade"
					TransitionTime="1000"								
					IconHeight="16px"
					label="Good">	
	
			</cfif>
			
			--->
	
	</cf_pane>		
	
<cfif url.notificationLayout neq "">

	<cfquery name="getProgramValidations"
		datasource="AppsSystem"
		username="#SESSION.login#"
		password="#SESSION.dbpw#">
		    SELECT 	VA.*
		    FROM 	ValidationAction VA
					INNER JOIN Ref_ModuleControlValidation MCV
						ON VA.SystemFunctionId = MCV.SystemFunctionId
						AND VA.ValidationCode = MCV.ValidationCode
			WHERE 	VA.SystemFunctionId = '#url.systemfunctionid#'
			AND		VA.Mission = '#url.mission#'
			AND		VA.ObjectKeyValue1 = '#url.ObjectKeyValue1#'
			AND		VA.ValidationStatus <> '3'
			AND		VA.ValidationExpiration IS NULL
			AND		MCV.Operational = '1'
	</cfquery>
	
	<cfoutput>
		<cf_tl id="There are pending elements that require your attention" var="lblNotificationsMessage">
		<cfif getProgramValidations.recordCount gt 0>
			<script>
				notifyBorderById('#url.notificationLayout#', '#url.notificationLayoutArea#', 'Logos/Info.png', '#lblNotificationsMessage#', 'validationsNotification');
				expandArea('#url.notificationLayout#', '#url.target#');
			</script>
		<cfelse>
			<script>
				collapseArea('#url.notificationLayout#', '#url.target#');
				removeNotificationBorderById('#url.notificationLayout#', '#url.notificationLayoutArea#', 'validationsNotification');
			</script>
		</cfif>
	</cfoutput>
	
</cfif>	
