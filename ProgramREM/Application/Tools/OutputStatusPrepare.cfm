 
 <cfparam name="ProgramFilter" default="O.ProgramCode = 'PC5329'">
 <cfparam name="UnitFilter" default="">
 <cfparam name="DateFilter" default="">
 <cfparam name="FileNo" default="">
  
 <cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#LastProgress#FileNo#"> 
 <cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#Output#FileNo#"> 
 <cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#ActivityPending#FileNo#"> 
		
 <!--- define last output progress --->
 <cfquery name="LastOutput" 
     datasource="AppsProgram" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
	 SELECT   DISTINCT O.OutputId, MAX(O.Created) AS LastSubmitted 
	 INTO     userQuery.dbo.#SESSION.acc#LastProgress#FileNo#
	 FROM     ProgramActivityProgress O 
	 WHERE    #preserveSingleQuotes(ProgramFilter)#		
	 <cfif DateFilter neq "">
	 AND #preserveSingleQuotes(DateFilter)# 
	 </cfif> 
	 AND      O.RecordStatus != '9' 
	 GROUP BY O.OutputId
    </cfquery>
	
     <!--- retrieve valid output + status--->	
     <cfquery name="OutputStatus" 
     datasource="AppsProgram" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
	 SELECT DISTINCT Pr.ProgramCode, Pr.OutputId,  Pr.ProgressStatus 
	 INTO     userQuery.dbo.#SESSION.acc#Output#FileNo#
	 FROM     ProgramActivityProgress Pr INNER JOIN
                 userQuery.dbo.#SESSION.acc#LastProgress#FileNo# Last ON Pr.OutputId = Last.OutputId 
			                                  AND Pr.Created = Last.LastSubmitted
	 WHERE    Pr.RecordStatus != '9' 
     </cfquery>
	 
	 <!--- complement records for not reported output at that moment --->
	 
	 
	 <!--- make a subtable for each status --->
	 
	 <cfquery name="OutputStatus" 
     datasource="AppsProgram" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
	 SELECT     *
	 INTO    userQuery.dbo.#SESSION.acc#Status#FileNo#
	 FROM         Ref_Status
	 WHERE     (ClassStatus = 'Progress')
	 </cfquery>
	 
	 
	 
		
	 