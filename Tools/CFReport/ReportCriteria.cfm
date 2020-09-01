
<cfquery name="Init" 
   datasource="AppsSystem">
   SELECT     * 
   FROM       Parameter
</cfquery>	

<!--- Get valid OrgUnits for this user/report --->
<CF_DropTable dbName="AppsQuery" tblName="#answerOrgAccess#"> 

<cfquery name="defineOrgAccess" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	  	SELECT  Mission, 
		        MandateNo, 
				HierarchyCode, 
				OrgUnitCode,
				0 as OrgUnit
		INTO    userQuery.dbo.#answerOrgAccess#
		FROM    Organization
		WHERE   1=0
</cfquery>

<!--- retrieve variant values --->

<cfparam name="Form.FileFormat" default = "PDF">

<cfif URL.Mode neq "Form"> 
	
		<cfif URL.ReportId eq "">
					
			  <cf_message message="This report variant has been removed from your account" 
			            return="no"	report="1">
			   <cfexit method="EXITTEMPLATE">
			   
		</cfif>
		
		<!--- identify layout --->
		<cfquery name="UserReport" 
		    datasource="AppsSystem">
			 SELECT     R.*, 
			            U.*, 
						L.LayoutId,
						L.TemplateReport, 
						L.LayOutCode, 
						L.LayoutClass, 
						L.LayoutName, 
						U.OfficerLastName as LastName, 
						U.OfficerFirstName as FirstName, 
						U.OfficerUserId as UserId
			 FROM       UserReport U, 
			            Ref_ReportControlLayout L, 
						Ref_ReportControl R
			 WHERE      ReportId    = '#URL.ReportId#' 
			 AND        R.ControlId = L.ControlId 
			 AND        U.LayoutId  = L.LayoutId 
		</cfquery>
		
		<cfif UserReport.reportPath eq "" and url.formselect neq "SQL" and UserReport.TemplateSQL eq "SQL.cfm">		  
			<cf_message message="The path of the report has not been defined." report="1" return="no">
			<cfabort>
		</cfif>
			
		<cfif UserReport.recordcount eq "0">		
			<cf_message message="This report variant has been disabled or deleted." report="1" return="no">
			<cfabort>
		</cfif>
		
		<cfset FORM.LayoutName   = UserReport.LayoutName>
		<cfset FORM.LayoutId     = UserReport.LayoutId>
		<cfset FORM.LayoutCode   = UserReport.LayoutCode>
		<cfset FORM.FileFormat   = UserReport.FileFormat>
		<cfset FORM.uLastName    = UserReport.LastName>
		<cfset FORM.uFirstName   = UserReport.FirstName>
		<cfset FORM.uAccount     = UserReport.UserId>
		
<cfelse>
	
		<!--- retrieve values from the form --->
	
		<!--- identify layout --->
		<cfquery name="UserReport" 
		    datasource="AppsSystem">
			 SELECT     R.*, 
			 			L.LayoutId,
			            L.TemplateReport, 
						L.LayoutCode, 
						L.LayoutClass, 
						L.LayoutName, 
						'#Form.FileFormat#' as FileFormat 
			 FROM       Ref_ReportControl R, Ref_ReportControlLayout L
			 WHERE      L.LayoutId = '#Form.LayoutId#' 
			 AND        R.ControlId = L.ControlId   
		</cfquery>
		
		<cfif UserReport.reportPath eq "" and url.formselect neq "SQL" and UserReport.TemplateSQL eq "SQL.cfm">		    
			<cf_message message="The path of the report has not been defined." report="1" return="no">
			<cfabort>
		</cfif>
		
		<cfset FORM.LayoutName   = "#UserReport.LayoutName#">
		<cfset FORM.LayoutCode   = "#UserReport.LayoutCode#">
		<cfset FORM.uLastName    = "#SESSION.last#">
		<cfset FORM.uFirstName   = "#SESSION.first#">
		<cfset FORM.uAccount     = "#SESSION.acc#">
			
</cfif>

<!--- drop temp tables --->
 
<cfif url.formselect neq "sql">
	<cfinclude template="SQLDropAnswer.cfm">	
</cfif>

<cfif UserReport.recordcount eq "0">
		
	<script>
		alert("Problem, report has one or more config errors.")
	</script>
	<cfabort>
	
</cfif>
	
<cfif URL.Mode eq "Form">

    <!--- all form parameters are already
	 available from the FORM, except for extended, so these we need to capture
	 , unit ---> 

	<cfquery name="parameter" 
	 datasource="AppsSystem">
	 SELECT *
	 FROM   Ref_ReportControlCriteria 
	 WHERE  ControlId = '#UserReport.ControlId#' 
	 AND    CriteriaType = 'Extended' 
	 AND    Operational    = 1	
	</cfquery>	
	
	<cfset crt = "">
		
	<cfoutput query="parameter">
		
		<cfif CriteriaInterface eq "Combo">
	
			<cfquery name="selected" 
			    datasource="#LookupDataSource#">
				SELECT PK
			    FROM   userQuery.dbo.#SESSION.acc#_crit_#CriteriaName# 
			</cfquery>
			
			<cfset val = "">
			<cfset crit = CriteriaName>
					
			<cfset ln = 0>	
												
			<cfloop query="selected">
			     <cfif ln eq "0">
					  <cfset val = "#PK#">
				  <cfelse>
					  <cfset val = "#val#,#PK#">
				  </cfif>
				  <cfset Form[Crit] = val>
				  <cfset ln = ln + 1>
			</cfloop>			
								
		<cfelse>
				
			  <cfquery name="SubFields" 
	         datasource="AppsSystem" 
	         username="#SESSION.login#" 
	         password="#SESSION.dbpw#">
	         SELECT   *
	         FROM     Ref_ReportControlCriteriaField 
	         WHERE    ControlId    = '#UserReport.ControlId#'
	         AND      CriteriaName = '#CriteriaName#'
	         AND      Operational  = '1'  
			 ORDER BY FieldOrder 
	        </cfquery>			
								
			<cfloop query="SubFields">
			
				<cfif currentrow neq recordcount>
					
					<cfparam name="FORM.#CriteriaName#_#FieldName#" default="">					
					<cfset val = Evaluate("FORM.#CriteriaName#_#FieldName#")>
					<!--- global default removal --->
					
					<cfset Form["#CriteriaName#_#FieldName#"] = val>
				
				</cfif>
																		
			</cfloop>
					
		</cfif>
		
		<!--- verify if extended has any records --->
		
		<cfif CriteriaObligatory eq "1" 
		      and (criteriainterface eq "Combo" and selected.recordcount eq "0")>
		  
				   <cfset validate = "0">				   

				   <cfif CriteriaError eq "">
						<script>
						
							try {					
								document.getElementById('myprogressbox').className   = "hide"
								document.getElementById('myreportcontent').className = "regular"																						
							} catch(e) {}
					
							if (rpt)
									rpt.src = "#SESSION.root#/Tools/CFReport/OutputMessage.cfm?msg=Please select : #CriteriaDescription#"
							else	
									window.location = "#SESSION.root#/Tools/CFReport/OutputMessage.cfm?msg=Please select : #CriteriaDescription#"							
						</script>			
					   <cfif url.formselect eq "Batch">
					   	 <cfexit method="EXITTEMPLATE">
					   <cfelse> 
					      <CFABORT>
					   </cfif>
				   <cfelse>
						<script>
						
							try {					
								document.getElementById('myprogressbox').className   = "hide"
								document.getElementById('myreportcontent').className = "regular"																						
							} catch(e) {}
					
							if (rpt)
									rpt.src = "#SESSION.root#/Tools/CFReport/OutputMessage.cfm?msg=#CriteriaError#"
							else	
									window.location = "#SESSION.root#/Tools/CFReport/OutputMessage.cfm?msg=#CriteriaError#"							
						</script>			
				      <cfif url.formselect eq "Batch">
					   	  <cfexit method="EXITTEMPLATE">
					   <cfelse> 
					     <CFABORT>
					   </cfif>
				   </cfif>	  
						  		  
		</cfif>
				
			
	</cfoutput>
	
<cfelse>

	<!--- alternatively declare parameter from the variant table in those cases --->
	
	<cfquery name="variant" 
	    datasource="AppsSystem">
		SELECT   *
		FROM     UserReportCriteria 
		WHERE    ReportId = '#UserReport.ReportId#' 
		ORDER BY CriteriaName
	</cfquery>
			
	<cfoutput query="variant" group="CriteriaName">
	     <cfset ln = 0>
		 <cfoutput>
		     <cfif ln eq "0">
			  <cfset val = "#CriteriaValue#">
			 <cfelse>
			  <cfset val = "#val#,#CriteriaValue#">
			 </cfif>
			 <cfset ln = ln + 1>
	 	</cfoutput>
			 
	 	<cfset Form[CriteriaName] = "#val#">
			 
	</cfoutput>
	
</cfif>	



<!--- declare all variables in the FORM.xxxxx format --->

<cfquery name="parameter" 
 datasource="AppsSystem">
 SELECT   *
 FROM     Ref_ReportControlCriteria 
 WHERE    ControlId   = '#UserReport.ControlId#'   
 <cfif URL.Mode eq "Form">
 AND      Operational = 1
 <cfelse>
 AND    CriteriaName IN (
						SELECT    URC.CriteriaName
						FROM      UserReportCriteria AS URC INNER JOIN
			                      UserReport AS UR ON URC.ReportId = UR.ReportId INNER JOIN
			                      Ref_ReportControlLayout AS L ON UR.LayoutId = L.LayoutId
						WHERE     URC.ReportId = '#UserReport.ReportId#'
						)					  
 </cfif>
 ORDER BY CriteriaOrder 
</cfquery>

<cfset parscript="">
	
<cfset validate = "1">	
<cfset filecrit = "">
<cfset cluster  = "">
				
<cfoutput query="parameter">

		<!--- link each parameter to a value entered on the screen/form --->
						   		
        <cfparam name="Form.#CriteriaName#" default="#CriteriaDefault#"> 
				
		<cfset val = Evaluate("FORM.#CriteriaName#")>
				
		<cfif CriteriaObligatory eq "1" and val eq "" and CriteriaInterface neq "Checkbox" and CriteriaCluster eq "">
				
			<script language="JavaScript">
						
				se = parent.document.getElementById("pBar")			
				if (se) {
			       parent.ColdFusion.ProgressBar.hide("pBar")
			       parent.ColdFusion.ProgressBar.stop("pBar", "true")					  
			    }				
				
			</script>
		     		
			<cf_waitend>
			
			<cfif CriteriaError eq "">
			
				<script>
				
				    try {					
						document.getElementById('myprogressbox').className   = "hide"
						document.getElementById('myreportcontent').className = "regular"																						
					} catch(e) {}
					
					if (rpt) {
						alert('Required field selection is missing : #CriteriaDescription#');
					} else {	
						window.location = "#SESSION.root#/Tools/CFReport/OutputMessage.cfm?msg=Please select : #CriteriaDescription#"
					}							
				</script>		
									
				<cfif url.formselect eq "Batch">
				   	 <cfexit method="EXITTEMPLATE">
				<cfelse> 
				     <CFABORT>
				</cfif>
					   
			<cfelse>
			
				<script>
				
					try {					
						document.getElementById('myprogressbox').className   = "hide"
						document.getElementById('myreportcontent').className = "regular"																						
					} catch(e) {}
					
					if (rpt)
						rpt.src = "#SESSION.root#/Tools/CFReport/OutputMessage.cfm?msg=#CriteriaError#"
					else	
						window.location = "#SESSION.root#/Tools/CFReport/OutputMessage.cfm?msg=#CriteriaError#"							
				</script>	
								
			    <cfif url.formselect eq "Batch">
				   	 <cfexit method="EXITTEMPLATE">
				<cfelse> 
				     <CFABORT>
				</cfif>
					   
			</cfif>	 
			
		</cfif>
												
		<!--- expand the dataset --->
		<cfif CriteriaType eq "Unit">
		
			<cfset uni = Evaluate("FORM.#CriteriaName#")>
													
			<cfif url.formselect neq "sql">
			 					
			    <cfif uni neq "">
								
				    <cfif CriteriaNameParent eq "">
					
					   <cfset mission = LookupUnitTree>
					
					<cfelse>
					
						<cfset mission = Evaluate("FORM.#CriteriaNameParent#")>
				   		
					</cfif>					
													
					<cfinclude template="ReportCriteriaOrgUnit.cfm">
					
				<cfelse>
								
					<cfquery name="Temptable" 
					datasource="AppsOrganization" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					  	SELECT  Mission, 
						        MandateNo, 
								HierarchyCode, 
								OrgUnitCode,
								0 as OrgUnit
						INTO    userQuery.dbo.#answerOrg#
						FROM    Organization
						WHERE   1=0
					</cfquery>
	
				</cfif>	
			
			</cfif>
			
			<cfset val = Evaluate("FORM.#CriteriaName#")>
						
			<cfset tmp = "">
			
			<cfif Parameter.LookupMultiple eq "1">
						
				<cfloop index="itm" list="#uni#" delimiters=",">
		        	 <cfif tmp eq "">
				    	<cfset tmp = "'#itm#'">
					 <cfelse>
					    <cfset tmp = "#tmp#,'#itm#'">
					 </cfif>
				</cfloop>
						
			<cfelse>
			
				<cfset tmp = '#uni#'>				
			
			</cfif>
			
			<cfset Form[CriteriaName] = "#tmp#">
											
		<cfelseif CriteriaType eq "List" 
		      and LookupMultiple eq "1"
			  and CriteriaInterface eq "Checkbox">	
								   						  
			    <cfquery name="List" 
			     datasource="AppsSystem" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
				 SELECT *
				 FROM   Ref_ReportControlCriteriaList
				 WHERE  ControlId = '#UserReport.ControlId#'
				 AND   CriteriaName = '#CriteriaName#'  
				</cfquery>
						  
				<cfset tmp  = "">
						 
				<cfloop query="list">
					     
					 <cfparam name="FORM.#CriteriaName#_#currentrow#" default="">
					 <cfset val  = Evaluate("FORM." & #CriteriaName# & "_#currentrow#")> 
					
					 <cfif val neq "">
						<cfif tmp eq "">
						   <cfset tmp  = "'#val#'">
  							<cfelse>
						   <cfset tmp  = "#tmp#,'#val#'">
						</cfif>
					 </cfif>
						 							  
				</cfloop>			
										  						  
				<cfif tmp eq "" and CriteriaObligatory eq "1">		
				
					<script language="JavaScript">
						
						se = parent.document.getElementById("pBar")			
						if (se) {
					       parent.ColdFusion.ProgressBar.hide("pBar")
					       parent.ColdFusion.ProgressBar.stop("pBar", "true")			   			
						  
					    }				
					</script>			   
								
					<cfif CriteriaError eq "">
			
				       <cf_message message="Please select checkbox for : #CriteriaDescription#" report="1" return="no">
					   <cfif url.formselect eq "Batch">
					   	 <cfexit method="EXITTEMPLATE">
					   <cfelse> 
					     <CFABORT>
					   </cfif>
					   
					<cfelse>
			
					   <cf_message message="#CriteriaError#" return="no" report="1">
				      <cfif url.formselect eq "Batch">
					   	 <cfexit method="EXITTEMPLATE">
					   <cfelse> 
					     <CFABORT>
					   </cfif>
					   
					</cfif>	 	
					
				<cfelseif tmp eq "">
				
					<cfset tmp = "''">
					
				</cfif>
						  
				<cfset Form[CriteriaName] = "#tmp#">
										
		<cfelseif Parameter.LookupMultiple eq "1" 
		        and CriteriaType neq "Date" 
				and CriteriaType neq "Text"
				and CriteriaType neq "Integer">
									
			<cfset val = Replace(val, "'", "", "ALL")>
			<cfset val = replace(val,"*","","ALL")> 	
				
			<cfset tmp = "">
			<cfloop index="itm" list="#val#" delimiters=",">
	        	 <cfif tmp eq "">
			    	<cfset tmp = "'#itm#'">
				 <cfelse>
				    <cfset tmp = "#tmp#,'#itm#'">
				 </cfif>
			</cfloop>
			<!--- global default removal --->
				
			<cfset Form[CriteriaName] = "#tmp#">
			
		<cfelseif CriteriaType eq "date" and (CriteriaDateRelative eq "1" or val eq "today")>		
			
			<cfif val eq "">
				<cfset val = "0">
			</cfif>	
								
		    <cfif val eq "today">
			   <cfset tmp = "#DateFormat(now(),client.DateSQL)#">
		    <cfelseif val gte "0">
			   <cfset tmp = "#DateFormat(now()+val,client.DateSQL)#">
			<cfelse> 
			   <cfset tmp = "#DateFormat(now()+val,client.DateSQL)#">  
			</cfif>
			
			<cfset Form[CriteriaName] = "'#tmp#'">
			<cfset Form["#CriteriaName#_num"] = "#val#">
			
			<cfif CriteriaDatePeriod eq "1">
				
					<cfset val = Evaluate("FORM.#CriteriaName#_end")>
					
					<cfif val eq "">
						<cfset val = "0">
					</cfif>	
					
					<cfif val eq "today">
			   			<cfset tmp = "#DateFormat(now(),client.DateSQL)#">
				    <cfelseif val gte "0">
					   <cfset tmp = "#DateFormat(now()+val,client.DateSQL)#">
					<cfelse> 
					   <cfset tmp = "#DateFormat(now()+val,client.DateSQL)#">  
					</cfif>
					
					<cfset Form["#CriteriaName#_end"] = "'#tmp#'">
					<cfset Form["#CriteriaName#_end_num"] = "#val#">
					
			</cfif>		
					
		<cfelseif CriteriaType eq "date" and len(val) gte "6" and len(val) lte "10">	
												  														
				<cfquery name="Dformat" datasource="AppsSystem" maxrows=1>
				 SELECT *
				 FROM   Parameter
				</cfquery>	
																		
				<cfif dformat.DateFormat eq dFormat.DateFormatSQL>
					
					   <!--- do nothing, SQL will understand --->
					   
					   <cfset tmp   = val>
					  					   
				<cfelseif url.mode neq "Form">
				
					   <cfset tmp   = val>
					  							
				<cfelse>							
																			
						<!--- reverse --->
						<cfif mid(val,2,1) eq "/">
					            <cfset d      = '0'&left(#val#,1)>
								
					            <cfif mid(#val.Value#,4,1) eq "/">
					                 <cfset m      = '0'&mid(#val#,3,1)>
					            <cfelse>
					                 <cfset m      = mid(#val#,3,2)>
					            </cfif>
						<cfelse>
					           <cfset d      = left(#val#,2)>
							   <cfif mid(#val#,5,1) eq "/">
					                 <cfset m      = '0'&mid(#val#,4,1)>
					           <cfelse>
					                 <cfset m      = mid(#val#,4,2)>
					           </cfif>
						</cfif>
					         
						<cfset y      = mid(#val#,len(#val#)-1,2)>
					   	<cfset st = FindOneOf("./-", #y#, 1)>
					   	<cfif st eq 1>
					         <cfset y      = '0'&mid(#val#,len(#val#),1)>
					    </cfif>
					   
						<cfif y gte 50>
						    <cfset y = "19"&#y#> 
						<cfelse>
						  	<cfset y = "20"&#y#> 
						</cfif>
					   
						<cfset tmp   = "#m#/#d#/#y#">
													
				</cfif>
							
				
				<cfset Form[CriteriaName] = "'#tmp#'">
								
				<!--- period/range --->					
								
				<cfif CriteriaDatePeriod eq "1" and CriteriaType eq "Date">
				
					<cfset val = Evaluate("FORM.#CriteriaName#_end")>
					
					<cfquery name="Dformat" 
				   	 datasource="AppsSystem" 
					 maxrows=1>
					 SELECT *
					 FROM Parameter
					</cfquery>	
																			
					<cfif dformat.DateFormat eq dFormat.DateFormatSQL>
						
						   <!--- do nothing, SQL will understand --->
						   
						   <cfset end   = val>
						   
					<cfelseif url.mode neq "Form">
					
						   <cfset end   = val>
								
					<cfelse>							
																				
							<!--- reverse --->
							<cfif mid(val,2,1) eq "/">
						            <cfset d      = '0'&left(#val#,1)>
									
						            <cfif mid(#val.Value#,4,1) eq "/">
						                 <cfset m      = '0'&mid(#val#,3,1)>
						            <cfelse>
						                 <cfset m      = mid(#val#,3,2)>
						            </cfif>
							<cfelse>
						           <cfset d      = left(#val#,2)>
								   <cfif mid(#val#,5,1) eq "/">
						                 <cfset m      = '0'&mid(#val#,4,1)>
						           <cfelse>
						                 <cfset m      = mid(#val#,4,2)>
						           </cfif>
							</cfif>
						         
							<cfset y      = mid(#val#,len(#val#)-1,2)>
						   	<cfset st = FindOneOf("./-", #y#, 1)>
						   	<cfif st eq 1>
						         <cfset y      = '0'&mid(#val#,len(#val#),1)>
						    </cfif>
						   
							<cfif y gte 50>
							    <cfset y = "19"&#y#> 
							<cfelse>
							  	<cfset y = "20"&#y#> 
							</cfif>
						   
							<cfset end   = "#m#/#d#/#y#">
														
					</cfif>
					
					<cfset Form["#CriteriaName#_end"] = "'#end#'">
					
					<cfif end lt tmp>
					
						<script language="JavaScript">
						
							se = parent.document.getElementById("pBar")			
							if (se) {
						       parent.ColdFusion.ProgressBar.hide("pBar")
						       parent.ColdFusion.ProgressBar.stop("pBar", "true")			   			
							  
						    }				
						</script>						
					
						 <cf_message 
					      message="Please select an end date beyond the defined start date : [#tmp#]" 
					      return="no"
					      report="1">
					  
					  <cf_waitEnd>
					
			  		  <cfabort>
				      					   	  
				    </cfif>	
				
				</cfif>
													
		<cfelse>
			
			   <cfset val = Evaluate("FORM." & #CriteriaName#)>			   
			
			   <cfif Find(",",'#val#')>
			   		
					<cfloop index="itm" from="1" to="20">
						<cfset val = Replace(#val#, ", ", ",", "ALL")>
					</cfloop>
					<cfloop index="itm" from="1" to="20">
					    <cfset val = Replace(val, " ,", ",", "ALL")>
					</cfloop>
					<cfset val = Replace(val,"'","","ALL")>
					<cfset val = replace(val,"*","","ALL")> 	
					<cfset tmp = "">
					<cfloop index="itm" list="#val#" delimiters=",">
			        	 <cfif tmp eq "">
					    	<cfset tmp = "'#itm#'">
						 <cfelse>
						    <cfset tmp = "#tmp#,'#itm#'">
						 </cfif>
					</cfloop>
				
			   <cfelse>	
			   
			   	   <cfset val = replace(val,"*","","ALL")> 
				   <cfset tmp = "'#val#'">
			   
			   </cfif> 
			  		  
				<cfset Form[CriteriaName] = "#tmp#">
				
				<cfif CriteriaDatePeriod eq "1" and CriteriaType eq "Text">				
				
					   <cfset val = Evaluate("FORM." & #CriteriaName# & "_end")>			   
					
					   <cfif Find(",",'#val#')>
					   		
							<cfloop index="itm" from="1" to="20">
								<cfset val = Replace(#val#, ", ", ",", "ALL")>
							</cfloop>
							<cfloop index="itm" from="1" to="20">
							    <cfset val = Replace(val, " ,", ",", "ALL")>
							</cfloop>
							<cfset val = Replace(val,"'","","ALL")>
							<cfset val = replace(val,"*","","ALL")> 	
							<cfset tmp = "">
							<cfloop index="itm" list="#val#" delimiters=",">
					        	 <cfif tmp eq "">
							    	<cfset tmp = "'#itm#'">
								 <cfelse>
								    <cfset tmp = "#tmp#,'#itm#'">
								 </cfif>
							</cfloop>
						
					   <cfelse>	
					   
					   	   <cfset val = replace(val,"*","","ALL")> 
						   <cfset tmp = "'#val#'">
					   
					   </cfif> 
					  
					   <cfset Form["#CriteriaName#_end"] = "#tmp#">					  
					  				
				</cfif>
		
		</cfif>	
						
		<!--- find clustered selection --->
		
		<cfif CriteriaCluster neq "">
						
		  <cfif not Find("#CriteriaCluster#", "#cluster#")>
		
			<cfset cluster =  "#Cluster#,#CriteriaCluster#">
		
			<cfparam name="Form.#CriteriaCluster#" default=""> 
			<cfset cval = Evaluate("FORM." & #CriteriaCluster#)>
						
			<cfsavecontent variable="parscript">
				#parscript#
				<tr class="labelmedium navigation_row line" style="height:20px">
					<td style="padding-left:3px" width="100"><cf_tl id="Cluster"></td>
					<td>#CriteriaDescription#</td>
					<td>Form.#CriteriaCluster#</td>
					<td style="word-wrap: break-word; word-break: break-all;">#cval#</td>
				</tr>
			</cfsavecontent>
												  
		   </cfif>  
			
		   <cfif cval eq CriteriaName>
		   		   
			   <cfsavecontent variable="parscript">
				#parscript#
				<tr class="labelmedium navigation_row line" style="height:20px">
					<td style="padding-left:3px" width="100">#UCase(CriteriaType)#</td>
					<td>#CriteriaDescription#</td>
					<td>Form.#CriteriaName#</td>
					<td style="word-wrap: break-word; word-break: break-all;">#evaluate("form.#criterianame#")#</td>
				</tr>
				</cfsavecontent>
										
				 <cfif CriteriaDatePeriod eq "1" and (CriteriaType eq "Date" or CriteriaType eq "Text")>
				  
					   <cfsavecontent variable="parscript">			 
						  #parscript#
						  <tr class="labelmedium navigation_row line" style="height:20px">
							<td style="padding-left:3px" width="100">#UCase(CriteriaType)#</td>
							<td>#CriteriaDescription#</td>
							<td>Form.#CriteriaName#_end</td>
							<td style="word-wrap: break-word; word-break: break-all;">#evaluate("form.#criterianame#_end")#</td>
						  </tr>
				  	  </cfsavecontent>					  
				  
				 </cfif>
				
				<!--- also capture the subselection in the select related --->
				
				<cfif CriteriaType eq "Extended" and CriteriaInterface neq "Combo">
				
					  <cfquery name="SubFields" 
			         datasource="AppsSystem" 
			         username="#SESSION.login#" 
			         password="#SESSION.dbpw#">
			         SELECT   *
			         FROM     Ref_ReportControlCriteriaField 
			         WHERE    ControlId    = '#ControlId#'
			         AND      CriteriaName = '#CriteriaName#'
			         AND      Operational  = '1' 
					 ORDER BY FieldOrder 
			        </cfquery>			
										
					<cfloop query="SubFields">
					
						<cfif currentrow neq recordcount>
						
							<cfset val = Evaluate("FORM.#CriteriaName#_#FieldName#")>
							
							<cfset val = Replace(#val#, "'", "", "ALL")>
							<cfset tmp = "">
							<cfloop index="itm" list="#val#" delimiters=",">
				    	    	 <cfif tmp eq "">
					    			<cfset tmp = "'#itm#'">
								 <cfelse>
								    <cfset tmp = "#tmp#,'#itm#'">
								 </cfif>
							</cfloop>
			
							<cfset Form["#CriteriaName#_#FieldName#"] = "#tmp#">
																
							<cfsavecontent variable="parscript">
							  #parscript#
							  <tr class="labelmedium navigation_row line" style="height:20px">
								<td style="padding-left:3px" width="100">#UCase(FieldDisplay)#</td>
								<td>#Parameter.CriteriaDescription#</td>
								<td>Form.#CriteriaName#_#FieldName#</td>
								<td style="word-wrap: break-word; word-break: break-all;">#evaluate("form.#CriteriaName#_#FieldName#")#</td>
							  </tr>
						    </cfsavecontent>
														 
						</cfif>	 
															
					</cfloop>
				
				</cfif>
										  
			<cfelse>
						
			  <!--- make sure not selected value is blank --->
			  <cfset Form[CriteriaName] = "'@NOT SELECTED'">  
			  <cfset val = Evaluate("FORM." & #CriteriaName#)>
			  			 
			  <cfsavecontent variable="parscript">
				  #parscript#
				  <tr class="labelmedium navigation_row line" style="height:20px">
					<td style="padding-left:3px" width="100">#UCase(CriteriaType)#</td>
					<td>#CriteriaDescription#</td>
					<td>Form.#CriteriaName#</td>
					<td style="word-wrap: break-word; word-break: break-all;">#evaluate("form.#criterianame#")#</td>
				  </tr>
		  	  </cfsavecontent>
			  		 
			  			 						  
			</cfif>  
			
		<cfelse>
		 
		      <cfsavecontent variable="parscript">			 
				  #parscript#
				  <tr class="labelmedium navigation_row line" style="height:20px">
					<td style="padding-left:3px" width="100">#UCase(CriteriaType)#</td>
					<td>#CriteriaDescription#</td>
					<td>Form.#CriteriaName#</td>
					<td style="word-wrap: break-word; word-break: break-all;"><b>#evaluate("form.#criterianame#")#</td>
				  </tr>
		  	  </cfsavecontent>
			  
			  <cfif CriteriaDatePeriod eq "1" and (CriteriaType eq "Date" or CriteriaType eq "Text")>
			  
				   <cfsavecontent variable="parscript">			 
					  #parscript# 
					  <tr class="labelmedium navigation_row line" style="height:20px">
						<td style="padding-left:3px" width="100">#UCase(CriteriaType)#</td>
						<td>#CriteriaDescription#</td>
						<td>Form.#CriteriaName#_end</td>
						<td style="word-wrap: break-word; word-break: break-all;">#evaluate("form.#criterianame#_end")#</td>
					  </tr>
			  	  </cfsavecontent>
			  
			  </cfif>
			  
			  <cfif CriteriaType eq "Extended" and CriteriaInterface neq "Combo">
				
					<cfquery name="SubFields" 
			         datasource="AppsSystem" 
			         username="#SESSION.login#" 
			         password="#SESSION.dbpw#">
			         SELECT   *
			         FROM     Ref_ReportControlCriteriaField 
			         WHERE    ControlId    = '#ControlId#'
			         AND      CriteriaName = '#CriteriaName#'
			         AND      Operational  = '1' 
					 ORDER BY FieldOrder 
			        </cfquery>			
										
					<cfloop query="SubFields">
					
						<cfif currentrow neq recordcount>
						
							<cfset val = Evaluate("FORM.#CriteriaName#_#FieldName#")>
							
							<cfset val = Replace(val,"'","","ALL")>
							<cfset val = replace(val,"*","","ALL")> 
							<cfset tmp = "">
							<cfloop index="itm" list="#val#" delimiters=",">
				    	    	 <cfif tmp eq "">
					    			<cfset tmp = "'#itm#'">
								 <cfelse>
								    <cfset tmp = "#tmp#,'#itm#'">
								 </cfif>
							</cfloop>
										
							<cfset Form["#CriteriaName#_#FieldName#"] = "#tmp#">
																
							<cfsavecontent variable="parscript">
							  #parscript#
							  <tr class="labelmedium navigation_row line" style="height:20px">
								<td style="padding-left:3px" width="100">#UCase(FieldDisplay)#</td>
								<td>#CriteriaDescription#</td>
								<td>Form.#CriteriaName#_#FieldName#</td>
								<td style="word-wrap: break-word; word-break: break-all;">#evaluate("form.#CriteriaName#_#FieldName#")#</td>
							  </tr>
						    </cfsavecontent>
						
						</cfif>
															
					</cfloop>
				
				</cfif>			 
				
		</cfif>
				  
		  <cfif (CriteriaMask neq "" or CriteriaPattern neq "")
		      and CriteriaType eq "Text" and CriteriaObligatory eq "1">
			  			  		  		      		  
			  <cfif CriteriaMaskLength+2 gt len(tmp)>
									  			  			  			       			 		 
			       <cfset validate = "0">
				   
				   <script language="JavaScript">
						
					se = parent.document.getElementById("pBar")			
					if (se) {
				       parent.ColdFusion.ProgressBar.hide("pBar")
				       parent.ColdFusion.ProgressBar.stop("pBar", "true")			   			
					  
				    }				
				</script>
				 				 	   
				   <cf_message 
				      message="Formatting error: #CriteriaMemo# [Mask=#CriteriaMask#]" 
				      return="no"
				      report="1">
					  
				   <cfabort>	  
												  				   
			  </cfif> 
		  
		  </cfif>
		  		  
		<!--- 23/7 external Hanno correction for date --->
		<cfif CriteriaType eq "date" and CriteriaDateRelative eq "0">
			<cfset val = Replace(val, "/", "", "ALL")>
			<cfset val = Replace(val, "-", "", "ALL")>
			<cfset val = Replace(val, ".", "", "ALL")>
		</cfif>
        <cfset filecrit = "#FileCrit#_#val#">
		  			 		
</cfoutput>


<!--- verify clustering if value is entered --->


<cfquery name="Cluster" 
 datasource="AppsSystem">
 SELECT DISTINCT CriteriaCluster
 FROM   Ref_ReportControlCriteria 
 WHERE  ControlId = '#UserReport.ControlId#'   
 AND    Operational = 1
 AND   CriteriaCluster > ''
</cfquery>

<cfoutput query="Cluster">

<!--- determine field value of the cluster and then determine if the variable has a value --->

<cfparam name="Form.#CriteriaCluster#" default="" >

<cfset selfld = Evaluate("Form.#CriteriaCluster#")>

<cfquery name="Check" 
 datasource="AppsSystem">
 SELECT *
 FROM   Ref_ReportControlCriteria 
 WHERE  ControlId = '#UserReport.ControlId#'   
 AND   CriteriaName = '#selfld#' 
</cfquery>

<cfif check.CriteriaObligatory eq "1" and not ParameterExists(Form.SQL) and url.formselect neq "sql">

	<cfset val = Evaluate("Form.#selfld#")>
	
	<cfif val eq "''" or val eq "">
			
		   <cf_wait last=1>
			
			<cfif check.criteriaError eq "">

				<script>
				    try {					
						document.getElementById('myprogressbox').className   = "hide"
						document.getElementById('myreportcontent').className = "regular"																						
					} catch(e) {}
							
					if (rpt)
						rpt.src = "#SESSION.root#/Tools/CFReport/OutputMessage.cfm?msg=Please enter a #check.criteriaDescription#"
					else
						window.location = "#SESSION.root#/Tools/CFReport/OutputMessage.cfm?msg=Please enter a #check.criteriaDescription#"							
				</script>			

			<cfelse>
			
				<script>
				
					try {					
						document.getElementById('myprogressbox').className   = "hide"
						document.getElementById('myreportcontent').className = "regular"																						
					} catch(e) {}
							
					if (rpt)
						rpt.src = "#SESSION.root#/Tools/CFReport/OutputMessage.cfm?msg=#check.criteriaError#"
					else
						window.location = "#SESSION.root#/Tools/CFReport/OutputMessage.cfm?msg=#check.criteriaError#"							
				</script>			
				   
			</cfif>	
								
		<cfabort>
		
	</cfif>

</cfif>

</cfoutput>
