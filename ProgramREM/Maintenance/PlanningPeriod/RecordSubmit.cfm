
<cfparam name="Form.PeriodOld" default="">

<cfset dateValue = "">
<CF_DateConvert Value="#Form.DateEffective#">
<cfset STR = dateValue>

<cfset dateValue = "">
<cfif Form.DateExpiration neq ''>
    <CF_DateConvert Value="#Form.DateExpiration#">
    <cfset END = dateValue>
<cfelse>
    <cfset END = 'NULL'>
</cfif>	

<cfset dateValue = "">
<cfif Form.DateExpiration neq ''>
    <CF_DateConvert Value="#Form.isPlanningPeriodExpiry#">
    <cfset EXP = #dateValue#>
<cfelse>
    <cfset EXP = 'NULL'>
</cfif>	
<cfif EXP lt END and END neq 'NULL'>
   <cfset EXP = END>
</cfif>

<cfif ParameterExists(Form.Insert)> 

<cfquery name="Verify" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   Ref_Period
	WHERE  Period  = '#Form.period#' 
</cfquery>

   <cfif Verify.recordCount is 1>
   
   <script language="JavaScript">
   
     alert("a record with this code has been registered already!")
     
   </script>  
  
   <cfelse>  
		
		<cfquery name="Insert" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		INSERT INTO Ref_Period
		         (Period,
				 Description,
				 PeriodClass,
				 DateEffective,
				 DateExpiration,
				 IncludeListing,
				 Procurement,
				 isPlanningPeriod,
				 isPlanningPeriodExpiry,
				 OfficerUserId,
				 OfficerLastName,
				 OfficerFirstName)
		  VALUES ('#Form.Period#',
		          '#Form.Description#', 
				  '#Form.PeriodClass#',
				  #STR#,
				  #END#,
				  '#Form.IncludeListing#',		
				  '#form.Procurement#',	 
				  '#Form.isPlanningPeriod#',
				  #EXP#,
				  '#SESSION.acc#',
		    	  '#SESSION.last#',		  
			  	  '#SESSION.first#')
		</cfquery>
				  
    </cfif>		  
	           
</cfif>

<cfif ParameterExists(Form.Update)>

	<!--- clean --->

	<cfquery name="MissionSelect" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		DELETE Ref_MissionPeriod
		FROM   Ref_MissionPeriod P
		WHERE  Period  = '#Form.PeriodOld#' 
		AND    Mission NOT IN (
		                      SELECT Mission
                  		      FROM   Ref_MissionModule
							  WHERE  Mission = P.Mission
                     		  AND    SystemModule IN ('Program') 
							  )
	</cfquery>	
	
	<cfquery name="Update" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE Ref_Period
		SET    DateEffective          = #STR#,
			   DateExpiration         = #END#,
			   PeriodClass            = '#form.PeriodClass#',			  
		       Description            = '#Form.Description#',
			   Procurement            = '#form.Procurement#',
			   IncludeListing         = '#IncludeListing#',			  
			   isPlanningPeriodExpiry = #EXP#,
			   isPlanningPeriod       = '#Form.isPlanningPeriod#'			  
		WHERE  Period                 = '#Form.PeriodOld#'
	</cfquery>
	
	<cfquery name="LogPeriod" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		INSERT Ref_PeriodLog(
				   Period
			      ,PeriodClass
			      ,Description
			      ,DateEffective
			      ,DateExpiration
			      ,isPlanningPeriod
			      ,isPlanningPeriodExpiry
			      ,IncludeListing
			      ,Procurement
			      ,OfficerUserId
			      ,OfficerLastName
			      ,OfficerFirstName)
		SELECT 
		   Period
	      ,PeriodClass
	      ,Description
	      ,DateEffective
	      ,DateExpiration
	      ,isPlanningPeriod
	      ,isPlanningPeriodExpiry
	      ,IncludeListing
	      ,Procurement
		  ,'#SESSION.acc#' 
		  ,'#SESSION.last#' 
		  ,'#SESSION.first#'	
		FROM Ref_Period
		WHERE Period = '#Form.PeriodOld#'
	</cfquery>	
	
	<cfloop index="itm" from="1" to="#form.lines#" step="1">
	
	    <cfparam name="FORM.mandate_#itm#" default="">
		<cfparam name="FORM.default_#itm#" default="">
		<cfparam name="FORM.PlanningPeriod_#itm#" default="">
		<cfparam name="FORM.editionid_#itm#" default="">
		<cfparam name="FORM.editionidalternate_#itm#" default="">
		<cfparam name="FORM.accountperiod_#itm#" default="">
		<cfparam name="FORM.isPlanPeriod_#itm#" default="1">
		
	    <cfset mis = Evaluate("FORM.mission_" & #itm#)>
	    <cfset man = Evaluate("FORM.mandate_" & #itm#)>
		<cfset acc = Evaluate("FORM.accountperiod_" & #itm#)>		
		<cfset def = Evaluate("FORM.default_" & #itm#)>
		<cfset pln = Evaluate("FORM.PlanningPeriod_" & #itm#)>
		<cfset edi = Evaluate("FORM.EditionId_" & #itm#)>
		<cfset eda = Evaluate("FORM.EditionIdAlternate_" & #itm#)>
		<cfset ipl = Evaluate("FORM.isPlanPeriod_" & #itm#)>		
					
		<cfif man neq "">
		
			<cfquery name="Delete" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				DELETE FROM  Ref_MissionPeriod
				WHERE  Period  = '#Form.PeriodOld#'
				AND    Mission = '#mis#'
		    </cfquery>
			
			<cfif pln eq "">
			    <cfset pln = Form.PeriodOld>
			</cfif>
			
			<cfquery name="Insert" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			INSERT INTO Ref_MissionPeriod
		            (Mission, 
					 MandateNo, 
					 Period, 
					 PlanningPeriod,
					 isPlanPeriod,
					 EditionId, 
					 EditionIdAlternate,
					 AccountPeriod,
					 OfficerUserId, 
					 OfficerLastName, 
					 OfficerFirstName)
		    VALUES ('#mis#', 
			        '#man#', 
					'#Form.PeriodOld#', 
					'#pln#', 
					'#ipl#',
					'#edi#', 
					'#eda#',
					'#acc#',
					'#SESSION.acc#', 
					'#SESSION.last#', 
					'#SESSION.first#') 
		    </cfquery>
		
		</cfif>
		
		<cfif def neq "">
		
			<cfquery name="Delete" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				UPDATE Ref_MissionPeriod
				SET    DefaultPeriod = '0'
				WHERE  Mission = '#mis#'
		    </cfquery>
			
			<cfquery name="Set" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				UPDATE Ref_MissionPeriod
				SET    DefaultPeriod = '1'
				WHERE  Mission = '#mis#'
				AND    Period  = '#Form.PeriodOld#'
		    </cfquery>	
			
		</cfif>
				
		
		<cfif def eq "" and man eq "">	
		  
			<cfquery name="Set" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				DELETE  FROM  Ref_MissionPeriod		
				WHERE   Mission = '#mis#'
				AND     Period  = '#Form.PeriodOld#'
		    </cfquery>	
				
		</cfif>	
		
		<cfquery name="LogMissionPeriod" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		INSERT INTO Ref_MissionPeriodLog
	            (Mission, 
				 MandateNo, 
				 Period, 
				 PlanningPeriod,
				 isPlanPeriod,
				 EditionId, 
				 AccountPeriod,
				 OfficerUserId, 
				 OfficerLastName, 
				 OfficerFirstName)
	     SELECT  Mission, 
				 MandateNo, 
				 Period, 
				 PlanningPeriod,
				 isPlanPeriod,
				 EditionId, 
				 AccountPeriod,
				 '#SESSION.acc#', 
				 '#SESSION.last#', 
				 '#SESSION.first#'
	     FROM Ref_MissionPeriod
			WHERE   Mission = '#mis#'
			AND     Period  = '#Form.PeriodOld#'
	    </cfquery>		
		
		   	
</cfloop>	

</cfif>	

<cfif ParameterExists(Form.Delete)> 

	<cfquery name="CountRec" 
      datasource="AppsProgram" 
      username="#SESSION.login#" 
      password="#SESSION.dbpw#">
      SELECT  Period
      FROM    ProgramPeriod
      WHERE   Period  = '#Form.PeriodOld#'
    </cfquery>
	
	<cfquery name="CountAll" 
      datasource="AppsProgram" 
      username="#SESSION.login#" 
      password="#SESSION.dbpw#">
      SELECT  Period
      FROM    Ref_AllotmentEdition
      WHERE   Period  = '#Form.PeriodOld#'
    </cfquery>

    <cfif CountRec.recordCount gt 0>
		 
     <script language="JavaScript">    
	   alert("Period is in use as a planning period. Operation aborted.")	        
     </script> 
	 
	<cfelseif CountAll.recordcount gt 0>
	
	  <script language="JavaScript">    
	   alert("Period is in use as an execution edition period. Operation aborted.")	        
     </script> 
	 
    <cfelse>
			
		<cfquery name="Delete" 
			datasource="AppsProgram" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			DELETE FROM Ref_Period
			WHERE Period = '#FORM.PeriodOld#'
		</cfquery>
	
	</cfif>		
</cfif>	

<script language="JavaScript">
   
     window.close()
     opener.history.go()
     	         
</script>  
