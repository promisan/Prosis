<!--
    Copyright © 2025 Promisan B.V.

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
	 
	 
	 
		
	 