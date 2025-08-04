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

<!--- year, month, moments --->

<cfparam name="Attributes.Period" default="FY05">
<cfparam name="Attributes.Program" default="1234">
<cfparam name="Attributes.Mode" default="Details">

<cfoutput>

<cfquery name="SubPeriod" 
  datasource="AppsProgram" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
      SELECT *
      FROM Ref_SubPeriod
	  WHERE SubPeriod IN (SELECT SubPeriod 
	  					FROM Ref_Audit 
					    WHERE Period = '#Attributes.Period#'
		 			    AND AuditDate <= getDate())
	 ORDER BY DisplayOrder 					
</cfquery>

<cfif SubPeriod.recordcount eq "0">

<font color="FF0000">No audit moments defined</font>

<cfelse>

<cftree name="root"
   	
   bold="No"   
   format="html"    
   required="No">   

  <cfloop query="SubPeriod">
  
  <cfset sub = subperiod>
  
	 <cfquery name="QMonth" 
	  datasource="AppsProgram" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	      SELECT DISTINCT Year(AuditDate) as Year, Month(AuditDate) as Month 
	      FROM Ref_Audit
		  WHERE Period = '#Attributes.Period#'
		    AND SubPeriod = '#sub#' 
			AND AuditDate <= getDate()+15							 
	 </cfquery>
	 
	 <cfif QMonth.recordcount gte "1">	
	 
		 <cftreeitem value="#sub#"
	        display="<b>#Description#"
			parent="Root"				
			expand="Yes">		
			
			<!---
			href="IndicatorAuditClearance.cfm?ID=PRG&ProgramCode=#Attributes.Program#&Period=#Attributes.Period#&Subperiod=#SubPeriod.subperiod#"
	        --->
	 
	  <cfelse>
	 
		  <cftreeitem value="#sub#"
	        display="<b>#Description#"
			parent="Root"			
			expand="Yes">		
	 	
	 </cfif>	 
	     	  	         	   	  	  
	 <cfloop query="QMonth">
	 
	    <cfset yr = QMonth.Year>
		<cfset mt = QMonth.Month>
		<cfif #len(mt)# eq "1">
		    <cfset mt = "0"&#mt#>
		</cfif>
		<cfset dte = CreateDate(#QMonth.Year#, #QMonth.Month#, 1)>
		<cfset day = DaysInMonth(dte)>
	 
	   <cfquery name="Check" 
	    datasource="AppsProgram" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
	      SELECT DISTINCT *
	      FROM Ref_Audit 
		  WHERE Period = '#Attributes.Period#'
		  AND SubPeriod = '#sub#'
		  AND AuditDate >= '#yr##mt#01' AND AuditDate <= '#yr##mt##day#' 
		  ORDER BY AuditDate 
	   </cfquery>	
	   
	   <cfif Check.recordcount gt "1">
	   
	   	   <!---
	 
		   ['#MonthAsString(month)# #year#',null,					
		   
		   <cfquery name="Audit" 
		    datasource="AppsProgram" 
		    username="#SESSION.login#" 
		    password="#SESSION.dbpw#">
		      SELECT DISTINCT *
		      FROM Ref_Audit 
			  WHERE Period = '#Attributes.Period#'
			  AND SubPeriod = '#sub#'
			  AND AuditDate >= '#yr##mt#01' AND AuditDate <= '#yr##mt##day#' 
			  AND AuditDate <= getDate()+15 
			  ORDER BY AuditDate 
		   </cfquery>
	  
		     <cfloop query="Audit">
			 		 
			 <cfif #Attributes.Mode# eq "Audit">
			 		 
				 ['#dateformat(auditdate, CLIENT.DateFormatShow)#','IndicatorAudit.cfm?ID=PRG&ProgramCode=#Attributes.Program#&Period=#Attributes.Period#&AuditId=#AuditId#'],			
			 
			 <cfelse>
			 		 
				 ['#dateformat(auditdate, CLIENT.DateFormatShow)#','DetailViewBase.cfm?ID=PRG&Targetid=#Attributes.TargetId#&AuditId=#AuditId#'],			
					 				 
			 </cfif>
			 		 		 
		     </cfloop>], 
			 
			 --->  
		 
		<cfelse>
		
			<cfif Attributes.Mode eq "Audit">
			
				 <cftreeitem value="#sub#_#currentrow#"
		        display="#MonthAsString(month)# #year#"
				parent="#sub#"
				target="right"
				href="IndicatorAudit.cfm?ID=PRG&ProgramCode=#Attributes.Program#&Period=#Attributes.Period#&AuditId=#Check.AuditId#"
		        expand="Yes">	
				 
			 <cfelse>
				 
				  <cftreeitem value="#sub#_#currentrow#"
		        display="#MonthAsString(month)# #year#"
				parent="#sub#"				
				href="javascript:showindicator('#Check.AuditId#')"
		        expand="Yes">	
					 				 
			 </cfif>
							
		</cfif> 
	   
	   </cfloop>
	   					  
  </cfloop>
  
</cftree>   

</cfif>
  
</cfoutput>

