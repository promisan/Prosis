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

<cfparam name="url.Operational"    default="true">
<cfparam name="url.FieldName"      default="">
<cfparam name="url.operational"    default="true">
<cfparam name="url.fieldorder"     default="1">
<cfparam name="url.lookupmultiple" default="0">
<cfparam name="url.CodeInDisplay"  default="false">

<cfif url.operational eq "true">
 <cfset op = 1>
<cfelse>
 <cfset op = 0> 
</cfif>

<cfif url.codeindisplay eq "true">
 <cfset cid = 1>
<cfelse>
 <cfset cid = 0> 
</cfif>

<cfif not IsNumeric(url.fieldorder)>
	<cfset url.fieldorder = "1">
</cfif>

<!---

<cfif URL.Multiple eq "0">

	<cfquery name="Check" 
	    datasource="AppsSystem" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
	    SELECT *
		FROM Ref_ReportControlCriteriaField 
		WHERE ControlId = '#URL.ID#'
		AND CriteriaName = '#URL.ID1#'
	</cfquery>

	<cfif #Check.recordcount# eq "3">
	
		<script language="JavaScript">
		
		alert("You may not enter more than 3 lookup values")
		history.back()
		
		</script>
		
	</cfif>

</cfif>

--->

<cfquery name="Check" 
    datasource="AppsSystem" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
    SELECT *
	FROM Ref_ReportControlCriteriaField 
	WHERE ControlId = '#URL.ID#'
	AND CriteriaName = '#URL.ID1#'
	AND FieldName = '#url.FieldName#' 
</cfquery>



<cfif Check.recordCount eq "1">

   <cfquery name="Update" 
     datasource="AppsSystem" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     UPDATE  Ref_ReportControlCriteriaField 
	  SET Operational     = '#op#',
	      FieldOrder      = '#url.FieldOrder#',
		  CodeInDisplay   = '#cid#',
		  FieldSorting    = '#URL.fieldSorting#',
		  LookupUnitTree  = '#url.LookupUnitTree#', 	
		  LookupMultiple  = '#url.lookupmultiple#',
	   <cfif URL.Multiple eq "1">
		  FieldDescription = '#url.FieldDescription#', 
	   </cfif>  
      FieldDisplay = '#url.FieldDisplay#' 
	   	  
	 WHERE ControlId = '#URL.ID#'
	 AND CriteriaName = '#URL.ID1#'
	 AND FieldName = '#URL.ID2#' 
   	</cfquery>

<cfelse>
	
	<cfif URL.ID2 eq "new">	
			
		<cfquery name="Insert" 
		     datasource="AppsSystem" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
		     INSERT INTO Ref_ReportControlCriteriaField 
		         (ControlId,
				 CriteriaName,
				 FieldName,
				 FieldSorting,
				 LookupUnitTree,
				 FieldDisplay,
				 CodeInDisplay,
				 <cfif URL.Multiple eq "1">
				 FieldDescription,
				 </cfif>
				 LookupMultiple,
				 FieldOrder,
				 FieldGlobal,
				 Operational)
		      VALUES ('#URL.ID#',
				  '#URL.ID1#', 
		      	  '#url.FieldName#',
				  '#url.FieldSorting#',
				  '#url.LookupUnitTree#',				  
				  <cfif url.fielddisplay eq "">
				  '#url.FieldName#',
				  <cfelse>
				  '#url.FieldDisplay#',
				  </cfif>
				  '#cid#',
				  <cfif URL.Multiple eq "1">
					 '#url.FieldDescription#',
				  </cfif>
				  '#url.lookupmultiple#',
				  '#url.FieldOrder#',
				  '#url.fieldGlobal#',
				  '1') 
		</cfquery>
				
	<cfelse>
		
		   <cfquery name="Update" 
		     datasource="AppsSystem" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
		     UPDATE  Ref_ReportControlCriteriaField 
			  SET Operational      = '#op#',
			      FieldOrder       = '#url.FieldOrder#',
				  FieldSorting     = '#URL.FieldSorting#',
				  CodeInDisplay    = '#cid#',
				  FieldGlobal      = '#url.fieldGlobal#',
				  LookupUnitTree   = '#url.LookupUnitTree#', 
				  LookupMultiple   = '#url.lookupmultiple#',
				  <cfif URL.Multiple eq "1">
				  FieldDescription = '#url.FieldDescription#', 
				  </cfif>	 
				  <cfif url.fielddisplay eq "">
				  FieldDisplay     = '#URL.ID2#' 
				  <cfelse>
			      FieldDisplay     = '#url.FieldDisplay#' 
				  </cfif>
				   
			 WHERE ControlId   = '#URL.ID#'
			 AND CriteriaName  = '#URL.ID1#'
			 AND FieldName     = '#URL.ID2#'
	    	</cfquery>
		
	</cfif>
	
</cfif>	

<cfset url.id2 = "">
<cfinclude template="CriteriaSubField.cfm">	
  
