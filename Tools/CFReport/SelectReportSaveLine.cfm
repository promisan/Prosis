<cfoutput>

<cfif CriteriaType eq "List" 
         and LookupMultiple eq "1"
      	 and CriteriaInterface eq "Checkbox">	
		  						  
		  <cfquery name="List" 
		     datasource="AppsSystem" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
			 SELECT *
			 FROM   Ref_ReportControlCriteriaList
			 WHERE  ControlId = '#URL.ControlId#'
			 AND   CriteriaName = '#CriteriaName#' 
		  </cfquery>
		  
		  <cfset fld = CriteriaName>
		  
		  <cfset value  = "">
		  
		  <cfloop query="list">
		  
		     <cfparam name="FORM.#fld#_#list.currentrow#" default="">
		  	 <cfset val  = Evaluate("FORM." & #fld# & "_#list.currentrow#")> 
			 <cfif val neq "false" and val neq "">
				<cfif value eq "">
				   <cfset value  = "#list.listvalue#">
				<cfelse>
				   <cfset value  = "#value#,#list.listvalue#">
				</cfif>
			 </cfif>
			 							 								 	
		  </cfloop>
		  
		  <cfif value eq "">
		       <cfset value = "0">
	      </cfif>
		  						  
		  <cfquery name="InsertParameter" 
		  datasource="AppsSystem"
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
			  INSERT INTO UserReportCriteria
			          (ReportId, CriteriaName, CriteriaValue)
			  VALUES ('#rep#', '#Criteria.CriteriaName#', '#value#')
		  </cfquery>
	
     <cfelseif CriteriaType eq "Extended" and LookupMultiple eq "1" and CriteriaInterface eq "Combo">
  
      <cfif LookupDataSource eq "">
	    <cfset ds = "appsQuery">
	  <cfelse>
	  	<cfset ds = "#LookupDataSource#">
	  </cfif>
  
        <cfquery name="InsertParameter" 
	  datasource="#ds#"
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	  INSERT INTO #autserver#.System.dbo.UserReportCriteria
	          (ReportId, CriteriaName, CriteriaValue, CriteriaValueDisplay)
	  SELECT  '#rep#', '#Criteria.CriteriaName#', PK, Display
	  FROM    userQuery.dbo.#SESSION.acc#_crit_#CriteriaName#
	  </cfquery> 
	  
	   <cfquery name="Delete" 
	  datasource="#ds#"
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	  DELETE FROM userquery.dbo.#SESSION.acc#_crit_#CriteriaName#
	  </cfquery> 
	  
	  
  <cfelseif CriteriaType eq "Date" and CriteriaDateRelative eq "1">
  
     <cfset value  = Evaluate("FORM." & #Criteria.CriteriaName# & "_num")>
					 				  
	  <cfif value gte "0">
	      <cfset sh = "today(#value#)">
	  <cfelse>
	      <cfset sh = "today(#value#)">  
	  </cfif>
	  		           	  	  
	  <cfquery name="InsertParameter" 
	  datasource="AppsSystem"
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	  INSERT INTO UserReportCriteria
	          (ReportId, CriteriaName, CriteriaValue, CriteriaValueDisplay)
	  VALUES ('#rep#', '#Criteria.CriteriaName#', '#value#','#sh#')
	  </cfquery>
	  
	  <cfif CriteriaDatePeriod eq "1">
	  
		  <cfset value  = Evaluate("FORM." & #Criteria.CriteriaName# & "_end_num")>
						 				  
		  <cfif value gte "0">
		      <cfset sh = "today(#value#)">
		  <cfelse>
		      <cfset sh = "today(#value#)">  
		  </cfif>
		  		           	  	  
		  <cfquery name="InsertParameter" 
		  datasource="AppsSystem"
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
		  INSERT INTO UserReportCriteria
		          (ReportId, CriteriaName, CriteriaValue, CriteriaValueDisplay)
		  VALUES ('#rep#', '#Criteria.CriteriaName#_end', '#value#','#sh#')
		  </cfquery>
	  
	  </cfif>
	  
  <cfelseif CriteriaType eq "Date">	  
  
	  <cfset value  = Evaluate("FORM." & #Criteria.CriteriaName#)>
	  	  	  	  
	  <cfset value=Replace(Value,"'",'','ALL')>
	  
	  <!--- value is received in the format of the server and would need to be converted to
	  the correct representation date format --->
	  
	  <cfquery name="Dformat" 
		   	 datasource="AppsSystem" 
			 maxrows=1>
			 SELECT *
			 FROM Parameter
		</cfquery>	
																	
	  <cfif dformat.DateFormat eq dFormat.DateFormatSQL>
	  
	  <cfelse>
	  
	  	<cfset value = dateformat(value,CLIENT.DateFormatShow)>
	  
	  </cfif>				  
	 			 				  
	  <cfquery name="InsertParameter" 
		  datasource="AppsSystem"
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">		  
		  INSERT INTO UserReportCriteria
		          (ReportId, 
				   CriteriaName, 
				   CriteriaValue, 
				   CriteriaValueDisplay)
		  VALUES ('#rep#', '#Criteria.CriteriaName#', '#value#','#value#') 
	 </cfquery>		
	 
	 <cfif CriteriaDatePeriod eq "1">  
  
	  	   <cfset value  = Evaluate("FORM." & #Criteria.CriteriaName# & "_end")>				 
		   <cfset value=Replace(Value,"'",'','ALL')>
																						
		   <cfif dformat.DateFormat eq dFormat.DateFormatSQL>
		  
		   <cfelse>
		  
		  	  <cfset value = dateformat(value,CLIENT.DateFormatShow)>
		  
		   </cfif>		
		
		   <cfquery name="InsertParameter" 
			  datasource="AppsSystem"
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">
			  INSERT INTO UserReportCriteria
			          (ReportId, 
					   CriteriaName, 
					   CriteriaValue, 
					   CriteriaValueDisplay)
			  VALUES ('#rep#', '#Criteria.CriteriaName#_end','#value#','#value#')
		   </cfquery>	
	   
	 </cfif>  		  	  
										  				  
  <cfelse>
  				  
    <cfset value  = Evaluate("FORM." & #Criteria.CriteriaName#)>
											
	<cfif Len(value) gt 700>
	
	  <cf_waitend frm="result">					
	  <cf_message message = "You selected too many criteria for #Criteria.CriteriaDescription#. Operation not allowed."
	  return = "No">
	  <cfabort>
	
	</cfif>
						
	 <cfset value=Replace(Value,"'",'','ALL')>
	 <!--- Hanno 4/4 disabled the removal of the space as it gave an issue for spaced PK selection 
	 <cfset value=Replace(Value," ",'','ALL')>
	 --->
	 <cfset value=Replace(Value,"#chr(10)#",',','ALL')>
	 <cfset value=Replace(Value,"#chr(13)#",'','ALL')>
	 <cfset value=Replace(Value,",,",',','ALL')>
			           	  	  
	 <cfquery name="InsertParameter" 
	  datasource="AppsSystem"
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	  INSERT INTO UserReportCriteria
	          (ReportId, CriteriaName, CriteriaValue) 
	  VALUES ('#rep#', '#Criteria.CriteriaName#', '#value#')
	  </cfquery>
	  
	  <cfif CriteriaDatePeriod eq "1" and criteriatype eq "Text">	
	  				  
	    <cfset value  = Evaluate("FORM." & #Criteria.CriteriaName# & "_end")>
											
		<cfif Len(value) gt 700>
		
		  <cf_waitend frm="result">					
		  <cf_tl id="You selected" var="1">
		  <cfset vLabel1=#lt_text#>
		  
		  <cf_tl id="too many criteria for" var="1">
		  <cfset vLabel2=#lt_text#>
		  
		  <cf_tl id="Operation not allowed" var="1">
		  <cfset vLabel3=#lt_text#>
		  
		  <cf_message message = "#vLabel1# #vLabel2# #Criteria.CriteriaDescription#. #vLabel3#."
		  return = "No">
		  <cfabort>
		
		</cfif>
						
		 <cfset value=Replace(Value,"'",'','ALL')>
		 <!--- Hanno 4/4 disabled the removal of the space as it gave an issue for spaced PK selection 
		 <cfset value=Replace(Value," ",'','ALL')>
		 --->
		 <cfset value=Replace(Value,"#chr(10)#",',','ALL')>
		 <cfset value=Replace(Value,"#chr(13)#",'','ALL')>
		 <cfset value=Replace(Value,",,",',','ALL')>
			           	  	  
		 <cfquery name="InsertParameter" 
		  datasource="AppsSystem"
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
		  INSERT INTO UserReportCriteria
		          (ReportId, CriteriaName, CriteriaValue) 
		  VALUES ('#rep#', '#Criteria.CriteriaName#_end', '#value#')
		  </cfquery>				  
	  
	  </cfif>
	  
	   <!--- store also select related --->

	  <cfif CriteriaType eq "Extended">

		  <cfquery name="SubFields" 
         datasource="AppsSystem" 
         username="#SESSION.login#" 
         password="#SESSION.dbpw#">
         SELECT   *
         FROM     Ref_ReportControlCriteriaField 
         WHERE    ControlId    = '#URL.ControlId#' 
         AND      CriteriaName = '#CriteriaName#'
         AND      Operational  = '1' 
		 ORDER BY FieldOrder 
        </cfquery>			
				
		<cfloop query="SubFields">
		
			<cfif currentrow neq recordcount>
					
				<cfparam name="FORM.#CriteriaName#_#FieldName#" default="">
				<cfset val = Evaluate("FORM.#CriteriaName#_#FieldName#")>
				<cfset Form["#CriteriaName#_#FieldName#"] = val>
				
				<cfset val = replace(val,"'","","ALL")>
				
				 <cfquery name="InsertParameter" 
				  datasource="AppsSystem"
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
				  INSERT INTO UserReportCriteria
				          (ReportId, CriteriaName, CriteriaValue)
				  VALUES ('#rep#', '#CriteriaName#_#FieldName#', '#val#') 
				  </cfquery>
			  
			  </cfif>
														
		</cfloop>
		
	  </cfif>
    
  </cfif>
	  
</cfoutput>	  