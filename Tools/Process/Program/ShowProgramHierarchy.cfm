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

<cfparam name="Attributes.ParentCode" default="">
<cfparam name="Attributes.Period" default="">

<cfset par = Attributes.ParentCode>
<cfset sel = Attributes.ParentCode>
<cfset Indent = "&nbsp;&nbsp;">

<table cellspacing="0" cellpadding="0">
	
			<cfloop condition="Par neq ''">
		   
			   <cfquery name="LevelUp" 
		          datasource="AppsProgram" 
		          username="#SESSION.login#" 
		          password="#SESSION.dbpw#">
				  SELECT *
				  FROM   ProgramPeriod
				  WHERE  ProgramCode = '#Par#'
				  AND    Period = '#attributes.period#'
			   </cfquery>	  
				  
				 <!---  
		          SELECT *, 
				         (SELECT Reference 
						  FROM   ProgramPeriod 
						  WHERE  ProgramCode = P.ProgramCode 
						  AND    Period = '#attributes.period#') as Reference
		          FROM   Program P
		          WHERE  ProgramCode = '#Par#'			
				  
				  --->
			   
			   
			   <cfset Par = LevelUp.PeriodParentCode>			   			  
			   <cfset sel = "#par#,#sel#">
			  		   
		   </cfloop>	  		 
		   
		   <cfloop index="itm" list="#sel#">
		   
			   <cfquery name="ProgramSel" 
		          datasource="AppsProgram" 
		          username="#SESSION.login#" 
		          password="#SESSION.dbpw#">				  
				  SELECT Pe.Reference, 
				         P.ProgramCode, 
						 P.ProgramName
				  FROM   ProgramPeriod Pe, Program P
				  WHERE  Pe.ProgramCode = P.ProgramCode
				  AND    Pe.ProgramCode = '#itm#'
				  AND    Pe.Period = '#attributes.period#'				  
			   </cfquery>	    
			   
			   <cfoutput query="ProgramSel">
						
			       <tr>
			          <td style="padding-left:5px">#Indent# 
					  <img src="#SESSION.root#/Images/join.gif" alt="" width="14" height="15" border="0" align="absmiddle">			        
			          </td>
					  <td class="labelit" style="height:10px;padding-left:5px"><cfif reference neq "">#Reference# (#Programcode#)<cfelse>#Programcode#</cfif></td>
			          <td class="labelit" style="height:10px;padding-left:5px">#ProgramName#</td>			              
			       </TR>
				   
			   </cfoutput>
			   
			   <cfset Indent = "&nbsp;&nbsp;&nbsp;"&#Indent#>
		   
		   </cfloop>
		   
		   <cfif sel neq "">
		   
		       <tr><td height="2"></td></tr>
		   						   
		   </cfif>
		   
</table>	   