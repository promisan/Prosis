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

<cfquery name="YearList" 
  datasource="AppsSystem" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
      SELECT   DISTINCT YEAR(Created) as Year
      FROM     ReportBatchLog
	  WHERE    ProcessClass != 'Trial'
	  AND      YEAR(Created) >= '#year(now())-1#'	  
	  ORDER BY Year DESC	  	  
</cfquery>

<cf_UItree
	id="root"
	title="<span style='font-size:16px;color:gray;padding-bottom:3px'>Log</span>"	
	expand="Yes">

	<cfoutput>
			
	  <cfloop query="YearList">	 
		  
	  <cfif YEAR(now())>
	      <cfset exp = "Yes">
	  <cfelse>
	      <cfset exp = "No"> 
	  </cfif>
	  
	   <cf_UItreeitem value="#year#"
	        display="<span style='font-size:18px;padding-top:5px;padding-bottom:5px;font-weight:bold' class='labelmedium'>#Year#</span>"														
			parent="root"							
	        expand="#exp#">	
	 	     
	     <cfset yr = year>
		 		 	    
		 <cfquery name="Month" 
		  datasource="AppsSystem" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
		      SELECT   DISTINCT Month(Created) as Month 
		      FROM     ReportBatchLog
			  WHERE    YEAR(Created) = #yr#
			  AND      ProcessClass != 'Trial'
			  ORDER BY Month DESC
		 </cfquery>
		  	         	   	  	  
		 <cfloop query="Month">
		 
		    <cfset mt  = Month.Month>
		    <cfset mtS = monthAsString(Month.Month)>
			
			 <cf_UItreeitem value="#yr##mts#"
		        display="<span style='font-size:15px;' class='labelit'>#mtS#</span>"														
				parent="#yr#"							
		        expand="No">			
						
			 <cfquery name="Date" 
		      datasource="AppsSystem" 
		      username="#SESSION.login#" 
		      password="#SESSION.dbpw#">
			      SELECT   DISTINCT DAY(Created) as DAY
			      FROM     ReportBatchLog
				  WHERE    YEAR(Created)  = #yr#
				  AND      MONTH(Created) = #mt#
				  AND      ProcessClass  != 'Trial'
				  ORDER BY DAY DESC
		     </cfquery>	
		   
		     <cfloop query="Date">
			
			    <cfset dy   = Date.Day>
									
			    <cfquery name="Check" 
			    datasource="AppsSystem" 
			    username="#SESSION.login#" 
			    password="#SESSION.dbpw#">
			      SELECT *
			      FROM    ReportBatchLog
				  WHERE   YEAR(Created)  = #yr#
				  AND     MONTH(Created) = #mt#
				  AND     DAY(Created)   = #dy#
				  AND     ProcessClass != 'Trial'
			   </cfquery>	
			   
			    <cfif len(dy) eq "1">
				  <cfset dy = "0#dy#">
				</cfif>
			   		    
				<cfset dyS  = dayOfWeek(Check.Created)>
				<cfset dyS  = dayOfWeekAsString(dyS)>
			   
			   <cfif Check.recordcount eq "1">	
			   
			   		 <cf_UItreeitem value="#yr##mts##dy#"
				        display="<span style='font-size:13px;' class='labelit'>#dy# [#dys#]</span>"														
						parent="#yr##mts#"		
						target="right"
			            href="DistributionLog.cfm?ID=#Check.BatchId#"					
				        expand="No">				   			  
			  			
				<cfelse>
				
					 <cf_UItreeitem value="#yr##mts##dy#"
				        display="<span style='font-size:13px;' class='labelit'>#dy# [#dys#]</span>"														
						parent="#yr##mts#"		
						target="right"
			            href="DistributionLog.cfm?ID=#Check.BatchId#"					
				        expand="No">		
																
					<cfloop query="Check">
					
						 <cf_UItreeitem value="#yr##mts##dy#_#currentrow#"
				        display="<span style='font-size:12px;' class='labelit'>#timeformat(ProcessEnd, "HH:MM")#</span>"														
						parent="#yr##mts##dy#"		
						target="right"
			            href="DistributionLog.cfm?ID=#Check.BatchId#"					
				        expand="No">	
														
					</cfloop>
				
				</cfif>
			
			</cfloop>  
			
			</cfloop>  
									   
		   </cfloop>  
		   		 
	</cfoutput>

</cf_UItree>
