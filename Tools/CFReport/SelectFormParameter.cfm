
<cfparam name="url.val" default="">
<cfparam name="flash"   default="No">
<cfparam name="format"  default="HTML">
<cfparam name="class"   default="regular1">
<cfparam name="cl"      default="regular1">
<cfparam name="cls"     default="">
<cfparam name="tpe"     default="Text">
<cfparam name="fldid"   default="">
<cfparam name="ajax"    default="0">
<cfparam name="lookupmode"          default="view">
<cfparam name="LookupViewScript"    default="">

<cfif LookupDataSource eq "">
	<cfset ds = "AppsSystem">
<cfelse>
	<cfset ds = LookupDataSource>
</cfif>

<cfset s = "6">

<cfif CriteriaObligatory eq "1" and CriteriaCluster eq "">
   	   <cfset ob   = "yes">
	   <cfset obd  = "false">
<cfelse>
	   <cfset ob   = "no">
	   <cfset obd  = "true">
</cfif>

<cfif format eq "HTML">
	<cfset sizeU = CriteriaWidth>
<cfelse>
	<cfset sizeU = CriteriaWidth*8>
</cfif>	

<cfif CriteriaError eq "">
  <cfset error   = CriteriaMemo>
<cfelse>
  <cfset error   = CriteriaError>
</cfif>  

<!--- global values presetted --->

<!--- there are three types of default prepoulated values --->

<!--- 

   1. if the report is a variant the default is always the values selected previusly for the variant
   2. if the report is new, the system takes the report criteria defined default 
   3. unless the user has defined a default as a global values for the same parameter
    Exception:
	  The default definition under 2 and 3 value does not apply for the multiple select boxes, 
	  it does for the variant though
	  Exception on the exceptio :
	  The default definition under 2 and 3 DOES apply for the multiple select boxes in the 
	  advanced dialog for extended, allowing you to filter the mission based on valid values 
	  
--->	

<cfif LookupMode eq "View" and len(LookupViewScript) gt 20>
			   
	 	 
	<cfset script = replaceNoCase(LookupViewScript,  "FROM ", " FROM ")> 
	<cfset script = replaceNoCase(script,  "WHERE", " WHERE ")> 
	<cfset script = replaceNoCase(script,  "AND ", " AND ", "ALL")> 
		
<!--- ALTER commands are not allowed in begin/end blocks in SQL, that's why we validete if the view exists as below --->
                
     <cfquery name="ViewExists"
                     datasource="#LookupDataSource#">
                                     SELECT * 
                         FROM   dbo.sysobjects 
                         WHERE  id = object_id(N'[dbo].[#LookupTable#]') 
                         AND    OBJECTPROPERTY(id, N'IsView') = 1
     </cfquery>
     
     <cftry> 
     
         <cfif ViewExists.Recordcount gt 0>
               <cfquery name="UpdateView"
					datasource="#LookupDataSource#">
                         ALTER VIEW dbo.#LookupTable#
                         AS #preservesingleQuotes(script)# 
                </cfquery>        
         <cfelse>
               <cfquery name="CreateView"
                    datasource="#LookupDataSource#">
						CREATE VIEW dbo.#LookupTable#
						AS #preservesingleQuotes(script)# 
               </cfquery>
         </cfif>

         <cfcatch>
         
                 <cfoutput>
                 
                     <script>
						alert("PROBLEM CREATING VIEW: #CFCATCH.Detail#")
                     </script>
					 
                     <cfabort>
                                 
                 </cfoutput>
         
         </cfcatch>
                     
     </cftry>
	 			 
</cfif>  


<cfquery name="Default" 
 datasource="AppsSystem" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">

	 SELECT    UC.CriteriaValue as DefaultValue
	 FROM      UserReportCriteria UC INNER JOIN
	           UserReport U ON UC.ReportId = U.ReportId INNER JOIN
	           Ref_ReportControlLayout RL ON U.LayoutId = RL.LayoutId INNER JOIN
	           Ref_ReportControl R ON RL.ControlId = R.ControlId
	 WHERE     U.Account = '#SESSION.acc#' 
	 AND       R.SystemModule  = '#Report.SystemModule#' 
	 AND       UC.CriteriaName = '#criteriaName#'
	 AND       U.Status = '6' 
</cfquery>

<!--- provision for the period --->

<cfquery name="Parent" 
 datasource="AppsSystem" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
	 SELECT    *
	 FROM      Ref_ReportControlCriteria
 	 WHERE     ControlId = '#URL.ControlId#' 
	 AND       CriteriaNameParent= '#criteriaName#'	
</cfquery>

<cfif Default.recordcount eq "1" 
    AND reportId eq "00000000-0000-0000-0000-000000000000" <!--- in case of variant always take the variant below --->
	AND Report.FunctionClass neq "System"
	AND Default.DefaultValue neq "">
			
	<!--- no variant avaiable -> takes default as defined in Global if exist --->
	
	 <cfset DefaultValue = Default.DefaultValue>	
	 	
	 <!--- date period provision --->
	 
	 <cfif CriteriaDatePeriod eq "1" and CriteriaType eq "Date">
	
		<cfquery name="DefaultEnd" 
		 datasource="AppsSystem" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
			 SELECT    CriteriaValue as DefaultValue
			 FROM      UserReportCriteria UC INNER JOIN
			           UserReport U ON UC.ReportId = U.ReportId INNER JOIN
			           Ref_ReportControlLayout RL ON U.LayoutId = RL.LayoutId INNER JOIN
			           Ref_ReportControl R ON RL.ControlId = R.ControlId
			 WHERE     U.Account = '#SESSION.acc#' 
			 AND       R.SystemModule  = '#Report.SystemModule#' 
			 AND       UC.CriteriaName = '#criteriaName#_end'
			 AND       U.Status = '6'
		</cfquery>
		 
		<cfset DefaultValueEnd = DefaultEnd.DefaultValue>
		
	   </cfif>	
	 
<cfelse>
     
	 <!-- take defined report config default or variant selection depends on the query in 
	 FormHTMLCriteria.cfm which takes either the report defauult or the default of
	 the variant  --->
	 
	 <cfif CriteriaType eq "date">
	 	
		<cfset DefaultValue    = ListFirst(CriteriaDefault)>	
		 		 
	 <cfelse>
	 
	 	<cfset DefaultValue    = CriteriaDefault>	
	 
	 </cfif>
	 
	 <cfif CriteriaDatePeriod eq "1"> 
	 
	 	<cfif reportId  eq "00000000-0000-0000-0000-000000000000">
				
			<cfset DefaultValueEnd = ListLast(CriteriaDefault)>
				
		<cfelse>
			 
		 	<cfquery name="DefaultEnd" 
			 datasource="AppsSystem" 
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
				 SELECT    CriteriaValue as DefaultValue
				 FROM      UserReportCriteria
				 WHERE     ReportId = '#ReportId#' 
				 AND       CriteriaName = '#criteriaName#_end'				 
			</cfquery>
	 	  
		    <cfset DefaultValueEnd = DefaultEnd.DefaultValue>
			
		</cfif>	
	 
	 </cfif>

</cfif>	 

<cfswitch expression="#CriteriaType#">
			
		<cfcase value="Text">
		 
		 	<cfinclude template="InputParameter/SelectFormParameterText.cfm">
	
		</cfcase> 
		
		<cfcase value="TextArea">
		 
		 <cfif format eq "HTML">
			<textarea cols="<cfoutput>#CriteriaWidth#</cfoutput>" rows="4" name="<cfoutput>#CriteriaName#</cfoutput>" class="regular" size="60"><cfoutput>#CriteriaDefault#</cfoutput></textarea> 
		 <cfelse>
		    <!--- not apllicable --->
		 </cfif>	   
	
		</cfcase> 
				
		<cfcase value="TextList">
		
			<cfinclude template="InputParameter/SelectFormParameterTextList.cfm">
	
		</cfcase> 
		
		<!--- deprecated --->
																		
		<cfcase value="Integer">
		
			<cfoutput>
				 
		     <table bordercolor="97A8BB" cellpadding="0" border="0" id="#fldid#_box" class="#cl# formpadding">
				 <tr><td>
				 
				 <cf_textInput
				   form      = "selection"
				   type      = "#tpe#"
				   mode      = "regular"
				   name      = "#CriteriaName#"
			       value     = "#DefaultValue#"
				   label     = "#CriteriaDescription#:"
			       required  = "#ob#"
				   validate  = "integer"
			       visible   = "Yes"
			       enabled   = "Yes"
				   id        = "#fldid#"
			       size      = "#CriteriaWidth#"
			       maxlength = "800"
				   style     = "text-align: center;"
				   class     = "regular3"
				   tooltip   = "#CriteriaMemo#">
							
				  
				   </td></tr>
			   </table>
			   
			 </cfoutput>  
	
		</cfcase> 
									
		<cfcase value="Date">
		
		   <cfinclude template="InputParameter/SelectFormParameterDate.cfm">
				
		</cfcase>
		
		<!--- ------------------- --->
		<!--- -------LIST-------- --->
		<!--- ------------------- --->
																		
		<cfcase value="List">
				
		  <cfinclude template="InputParameter/SelectFormParameterList.cfm">
					
		</cfcase>
		
		<!--- ------------------- --->
		<!--- ------LOOKUP------- --->
		<!--- ------------------- --->
														
		<cfcase value="Lookup">
				   								
		    <cfinclude template="InputParameter/SelectFormParameterLookup.cfm">	
				
		</cfcase>
		
		<!--- ----------------------------------------------------------------- --->
		<!--- EXTENDED single/multiple selected  (can now be clustered) ------- --->
		<!--- ----------------------------------------------------------------- --->
		
		<cfcase value="Extended">
		
		  <!--- check if fields were defined --->
		  
		  	<cfquery name="check" 
				datasource="AppsSystem" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
		  	    SELECT   *
				FROM     Ref_ReportControlCriteriaField
				WHERE    ControlId    = '#URL.ControlId#' 
				AND      CriteriaName = '#CriteriaName#' 
			</cfquery>	

			<cfif check.recordcount gte "1">			
			    <cfinclude template="InputParameter/SelectFormParameterExtended.cfm">			  
			</cfif>  
					
		</cfcase>
								
		<cfcase value="Tree">
	
				<cfquery name="query#CriteriaName#" 
				 datasource="AppsOrganization" 
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">
				   SELECT DISTINCT Mission
				   FROM  OrganizationAuthorization
				   WHERE Mission is not NULL
				   <cfif SESSION.isAdministrator eq "No">
				   AND UserAccount = '#SESSION.acc#'
				   AND   Role IN (SELECT Role 
				                  FROM   System.dbo.Ref_ReportControlRole 
								  WHERE  ControlId = '#ControlId#')
				   </cfif>	 			   

				</cfquery>
				
			    <cfif LookupMultiple eq "0">
				
					<cfselect name="#CriteriaName#" 
					selected="#CriteriaDefault#"
			    	size="1" 
					class="#cl#"
					id="#fldid#"
					multiple="No"
				    message="#Error#" 
				   	required="#ob#"
					width="#sizeU#"
					tooltip="#CriteriaMemo#"
					label="#CriteriaDescription#:"
					query="query#CriteriaName#"
					queryPosition="below"
					value="Mission"
					display="Mission"/>
								
				<cfelse>
				
					<cfselect name="#CriteriaName#" 
					selected="#CriteriaDefault#"
			    	size="#s#" 
					class="#cl#"
					id="#fldid#"
					multiple="Yes"
				    message="#Error#" 
				   	required="#ob#"
					width="#sizeU#"
					tooltip="#CriteriaMemo#"
					label="#CriteriaDescription#:"
					query="query#CriteriaName#"
					queryPosition="below"
					value="Mission"
					display="Mission"/>
								
				</cfif>
															
		</cfcase>
			
		<cfcase value="Unit">
		
				<cfparam name="url.val" default="">
				<cfif url.val neq "">
					<cfset mission = url.val>
				<cfelse>
				    <cfset mission = LookupUnitTree>
				</cfif>
								
				<cfinclude template="InputParameter/SelectFormParameterUnit.cfm">
																												
		</cfcase>
								
</cfswitch>

