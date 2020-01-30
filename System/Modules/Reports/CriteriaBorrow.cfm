
<cfquery name="find" 
 	 datasource="appsSystem">
			SELECT   TOP 1 * 
		    FROM     Ref_ReportControlCriteria 
			WHERE    CriteriaName =  '#URL.ID1#'
			AND      ControlId IN (SELECT ControlId FROM Ref_ReportControl WHERE SystemModule = '#URL.ID2#') 
</cfquery>

<cfset list   = "Ref_ReportControlCriteria,Ref_ReportControlCriteriaField,Ref_ReportControlCriteriaList">

<cfloop index="tbl" list="#list#" delimiters=",">
   
	<cfquery name="table" 
	datasource="appsSystem">
			SELECT   C.name, C.userType 
		    FROM     SysObjects S, SysColumns C 
			WHERE    S.id = C.id
			AND      S.name = '#Trim(tbl)#'	
			AND      S.name != 'CriteriaValues'
			ORDER BY C.ColId
	</cfquery>
	

	
	
	<cfset field = "">
	<cfloop query="table">
	
	    <cfset field = "#field#,#name#">
		<cfset last = "#name#">
			
	</cfloop>
	
    <cfquery name="content" 
 	 datasource="appsSystem">
			SELECT   * 
		    FROM     #tbl# 
			WHERE    ControlId = '#Find.controlId#'
			AND      CriteriaName =  '#URL.ID1#'
    </cfquery>
	
			 
	<cfloop query="Content">

		<cfset t = "">
		<cfloop index="nme" list="#field#" delimiters=",">
		
			<cfif nme eq "ControlId">
			  <cfset val = "'#URL.ID#'">
			<cfelseif nme eq "CriteriaValues">  
			  <cfset val = "''">
			<cfelseif nme eq "CriteriaName">  
			  <cfset val = "'_#evaluate(nme)#'">
			  <cfset vID1 = "'_#evaluate(nme)#'">
			<cfelse>
			  <cfset val = "'#evaluate(nme)#'">
			</cfif>
			
			
			<cfif t eq "">
			   <cfset t = "#val#">
			<cfelse>
			   <cfset t = "#t#,#val#">
			</cfif>
			
		</cfloop>
	
		
		<cfif t neq "">
	
		<cftry>
		    <cfquery name="insert" 
		 	 datasource="appsSystem">
				INSERT INTO System.dbo.#tbl#
				(<cfloop query="table">#name#<cfif currentRow neq recordcount>,</cfif></cfloop>)
				VALUES
				(#preserveSingleQuotes(t)#)   
					
		    </cfquery>

		<cfcatch>
			Error getting information from criteria
			<br>
			<cfoutput>#CFCatch.Message# - #CFCATCH.Detail#</cfoutput>
			<cf_logpoint>
			<cfoutput>
				INSERT INTO System.dbo.#tbl#
				(<cfloop query="table">#name#<cfif currentRow neq recordcount>,</cfif></cfloop>)
				VALUES
				(#preserveSingleQuotes(t)#)   
			</cfoutput>					
			</cf_logpoint>
			
			
		</cfcatch>	
		</cftry>
		
		<cfquery name="update" 
	 	 datasource="appsSystem">
			UPDATE  Ref_ReportControlCriteria 
			SET     RecordStatus = 0, 
			        CriteriaValues = NULL, 
					CriteriaNameParent = NULL
			WHERE   ControlId = '#URL.ID#'
			AND     CriteriaName =  '#vID1#'
		</cfquery>
	
		</cfif>
	</cfloop> 	
	
</cfloop>

<cfset URL.ID1=Replace(vID1,"'","","all")>

<cfset url.borrow = "1">
<cfinclude template="CriteriaEditForm.cfm">