
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
	
		<cfset vCondition = vCondition= " AND (T.PositionParentId IN ( SELECT PositionParentId FROM Employee.dbo.PositionParentFunding PPF WHERE PPF.PositionParentId = T.PositionParentId and PPF.Fund IN (#preservesinglequotes(val)#)))">
					
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
	
	<!---	
	<cfif Form.EntityClass neq "">
		<cfset vCondition = vCondition & " AND (T.EntityClass = '#FORM.EntityClass#')">
	</cfif>	
	--->
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
		
		<cfset vCondition = vCondition & " AND (Left(T.HierarchyCode,2) IN (#preservesinglequotes(val)#))">
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

	