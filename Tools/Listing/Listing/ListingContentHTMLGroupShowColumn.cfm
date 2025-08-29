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
<cfparam name="attributes.mode"          default="header">

<!--- identify the column content field: transactiondate_mth --->

<!--- we obtain data from the grouped data, later we have to add the formula in case we have more than one column level potentiall  --->

<cfif attributes.mode eq "header">

    <cfset cell = 0>	
	<!--- we determine how many cells within a period cell --->
    <cfset cnt = 1>
	<cfloop index="itm" list="#URL.datacell1formula#">
		 <cfset cnt = cnt+1>		 	
	</cfloop>		
	
<cfelse>
	
	<cftry>
					
	     <cfquery name="cellsub" dbtype="query">
				 SELECT * FROM  SearchGroup <cfif gridcontent neq "total">WHERE  #url.listgroupfield# = '#val#'</cfif>			 
		  </cfquery>			  
		  
		  <cfif cellsub.recordcount eq "0"> 			  			  								  
		  
			  <cfquery name="cellsub" dbtype="query">
				 SELECT * FROM  SearchGroup <cfif gridcontent neq "total">WHERE  #url.listgroupfield# LIKE '%#val#%'</cfif>			 
			  </cfquery>			  		  
			  
		   </cfif>
		  
		  <!--- query-of-query does not mix integer and strings --->	
				  
		  <cfcatch>		
		  		  
		  	<cfif val eq "">
				 <cfset val = 0>
			</cfif>				    	
			<cfquery name="cellsub" dbtype="query">
			    SELECT  * FROM SearchGroup <cfif gridcontent neq "total">WHERE #url.listgroupfield# = #val#</cfif>									 					 
			</cfquery>																  
			
		  </cfcatch>
		    
	</cftry>	
			
	<cfset myVal = ArrayNew(2)>
	<cfset ArrayClear(myVal)>
	<cfset myTot = ArrayNew(1)>
	
	<!--- ------------------------------------------------------------------ --->
	<!--- we pass the result per month into ARRAY to preempt running queries --->
	<!--- ------------------------------------------------------------------ --->
		
	<cfoutput query="cellsub">
		
	    <cfset cnt = 1>		
															
		<!--- this contains a reference to the month --->
		<cfset myval[currentrow][cnt] = evaluate("#url.listcolumn1#")>	
						    
		<!--- the contains the values (SUM, AVG, MIN, MAX, PERC) for that month for the selected field --->
		
			<cfloop index="itm" list="#URL.datacell1formula#">
							
				<cfset cnt = cnt+1>		
				<cfparam name="myTot[#cnt#]" default="0">
				 	
			    <cfif itm eq "SUM"> 
				
				   <cfset val = evaluate("#url.datacell1#")>					   
				   <cfset myval[currentrow][cnt] = numberformat(val,",")>	
				   <cfif val neq "">			   
					   <cfset myTot[cnt] = myTot[cnt] + val>				   				   				   
				   </cfif>
										
				<cfelseif itm eq "PER"> 	
				
					<!--- percentage --->			
					<cfset val = evaluate("#url.datacell1#")>	
					<cfset myval[currentrow][cnt] = val>	
					<cfif val neq "">
						<cfset myTot[cnt] = myTot[cnt] + val>
					</cfif>
													
					<cfif myval[currentrow][cnt] neq "">	
														
						<!--- better to read this into an array memory --->	
										
						<cfquery name="getTotal" dbtype="query">
							  SELECT #url.datacell1# as Total
							  FROM   SearchGroupTotal
							  WHERE  #url.listcolumn1# = '#myval[currentrow][1]#'			 		  										
						</cfquery>	
										
					    <cfif getTotal.total gt "0">			
							<cfset val = numberformat((myval[currentrow][cnt]*100/getTotal.total),'._')>							
							<cfif val gt "0">
								<cfset myval[currentrow][cnt] = "#val# %">								
							<cfelse>	
							    <cfset myval[currentrow][cnt] = "">	
							</cfif>
						</cfif>	
						
					</cfif>	
				
				<cfelseif itm eq "MIN"> 
					
					<cfset val = evaluate("#url.datacell1#_#itm#")>	
				    <cfset myval[currentrow][cnt] = numberformat(val,",")>						
					<cfif myTot[cnt] gt val or myTot[cnt] eq "0">					
						<cfset myTot[cnt] = val>
					</cfif>				
					
				<cfelseif itm eq "MAX"> 
						
					<cfset val = evaluate("#url.datacell1#_#itm#")>	
				    <cfset myval[currentrow][cnt] = numberformat(val,",")>	
					<cfif myTot[cnt] lt val>
						<cfset myTot[cnt] = val>
					</cfif>					
					
				<cfelseif itm eq "AVG"> 
					
					<cfset val = evaluate("#url.datacell1#_#itm#")>	
				    <cfset myval[currentrow][cnt] = numberformat(val,",")>	
					<cfif val neq "">
						<cfset myTot[cnt] = myTot[cnt] + val>
					</cfif>
					
				</cfif>	
					
			</cfloop>
				
	</cfoutput>	
			
	<!--- ----------------------------------------------- --->
	<!--- now we also add overall totals for the formulas --->
	<!--- ----------------------------------------------- --->
	
	<cfif cellsub.recordcount gte "1">
				
		<cfset rec = cellsub.recordcount +1>			
		<cfset cnt = 1>	
				
		<cfloop index="itm" list="#URL.datacell1formula#">
			
			<cfset cnt = cnt+1>	
				 	
		    <cfif itm eq "SUM"> 				
			   <cfset myTot[cnt] = numberformat(myTot[cnt],",")>					   							   											
			<cfelseif itm eq "PER">	
			   <cfif SearchOverall.Total gt "0">
				   <cfset val = myTot[cnt]*100/SearchOverall.Total>				     		   
				   <cfif val gt "0">
				        <cfset val = numberformat(val,"._")>
						<cfset myTot[cnt] = "#val# %">								
				   <cfelse>				   
					    <cfset myTot[cnt] = "0">	
				   </cfif>			   
			   <cfelse>
			      <cfset myTot[cnt] = "0">	
			   </cfif>	   
			<cfelseif itm eq "MIN">			
				<cfset myTot[cnt] = numberformat(myTot[cnt],",")>				
			<cfelseif itm eq "MAX"> 			
				<cfset myTot[cnt] = numberformat(myTot[cnt],",")>	
			<cfelseif itm eq "AVG">			
				<cfset myTot[cnt] = myTot[cnt]/cellsub.recordcount>	
				<cfset myTot[cnt] = numberformat(myTot[cnt],",")>						
			</cfif>	
				
		</cfloop>	
		
	</cfif>	
	
</cfif>	

<cfoutput>

<!--- ------------------------------------------------- --->
<!--- LATER we do this on the fly with different colums --->

<cfif url.listcolumn1_type eq "period">

	<cfinclude template="ListingContentHTMLGroupShowColumnPeriod.cfm">

<cfelse>
	
	<cfinclude template="ListingContentHTMLGroupShowColumnCommon.cfm">
				
</cfif>	

</cfoutput>
