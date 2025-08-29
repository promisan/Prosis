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
<cfset vFund       = "">
<cfset vCondition  = "">
<cfset vCondition2 = "">

<cfif URL.Criteria eq "Yes">

	<cfif Form.FunctionNo neq "">
		<cfset vCondition = vCondition & " AND (T.FunctionNo = '#FORM.FunctionNo#')">
	</cfif>	
	<cfif Form.PositionNo neq "">
		<cfset vCondition = vCondition & " AND (T.PostNumber like '%#FORM.PositionNo#%' OR T.PositionNo like '%#FORM.PositionNo#%')">
	</cfif>	
	<cfif Form.Fund neq "">
	
	    <cfset val = ""> 		
	    <cfloop index="itm" list="#form.Fund#" delimiters=",">
		     <cfif val eq "">
			     <cfset val = "'#itm#'">	
			 <cfelse>
		 	     <cfset val = "#val#,'#itm#'">		
			 </cfif>	 
		</cfloop>		
	
		<cfset vCondition = vCondition= " AND (T.DocumentNo IN ( SELECT DP.DocumentNo FROM Vacancy.dbo.Document AS D INNER JOIN Vacancy.dbo.DocumentPost AS DP INNER JOIN
                      Employee.dbo.Position AS P ON DP.PositionNo = P.PositionNo INNER JOIN
                      Employee.dbo.PositionParent AS PP ON P.PositionParentId = PP.PositionParentId ON D.DocumentNo = DP.DocumentNo
					WHERE     PP.Fund IN (#preservesinglequotes(val)#) AND D.Mission = '#url.mission#'))">
					
	</cfif>			
	<cfif Form.PostGrade neq "">
	
	 <cfset val = ""> 		
	    <cfloop index="itm" list="#form.PostGrade#" delimiters=",">
		     <cfif val eq "">
			     <cfset val = "'#itm#'">	
			 <cfelse>
		 	     <cfset val = "#val#,'#itm#'">		
			 </cfif>	 
		</cfloop>	
	
		<cfset vCondition = vCondition & " AND (T.PostGrade IN (#preservesinglequotes(val)#))">
	</cfif>			
	<cfif Form.EntityClass neq "">
		<cfset vCondition = vCondition & " AND (T.EntityClass = '#FORM.EntityClass#')">
	</cfif>	
	<cfif Form.DocumentType neq "">
	    <cfset val = ""> 		
	    <cfloop index="itm" list="#form.DocumentType#" delimiters=",">
		     <cfif val eq "">
			     <cfset val = "'#itm#'">	
			 <cfelse>
		 	     <cfset val = "#val#,'#itm#'">		
			 </cfif>	 
		</cfloop>		
		<cfset vCondition = vCondition & " AND (T.DocumentType IN (#preservesinglequotes(val)#))"> 
	</cfif>				
	
	<cfif Form.ParentCode neq "">
	
	    <cfset val = ""> 		
	    <cfloop index="itm" list="#Form.ParentCode#" delimiters=",">
		     <cfif val eq "">
			     <cfset val = "'#itm#'">	
			 <cfelse>
		 	     <cfset val = "#val#,'#itm#'">		
			 </cfif>	 
		</cfloop>	
		
		<cfset vCondition = vCondition & " AND (Left(T.OrgUnitHierarchy,2) IN (#preservesinglequotes(val)#))">
	</cfif>		
	
	<cfif Form.ReferenceNo neq "">
		<cfset vCondition = vCondition & " AND ( EXISTS (SELECT 'X' FROM Applicant.dbo.FunctionOrganization F WHERE F.ReferenceNo like '%#FORM.ReferenceNo#%' AND F.DocumentNo = T.DocumentNo) OR (T.ReferenceNo = '#FORM.ReferenceNo#' OR CAST(T.DocumentNo as varchar(10)) = '#Form.ReferenceNo#'))">
	</cfif>		
	<cfif Form.DateEffective neq "">
	    <CF_DateConvert Value="#FORM.DateEffective#">		
		<cfset vCondition = vCondition & " AND (DatePosted >= #datevalue#)">	
	</cfif>
	<cfif Form.DateExpiration neq "">
	    <CF_DateConvert Value="#FORM.DateExpiration#">	
		<cfset vCondition = vCondition & " AND (DatePosted <= #datevalue#)">	
	</cfif>	
		
</cfif>		

<cfinclude template="ControlListingTrackQuery.cfm">		