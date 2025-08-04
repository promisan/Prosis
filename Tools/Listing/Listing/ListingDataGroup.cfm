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

<!--- --------------------------------------------------------------------------------- --->  
<!--- obtain the data for this row in one query Instead of repeating this for each sum) --->
<!--- -----------------------------------------                                         --->
<!--- --------------------------------------------------------------------------------- --->
	    	
<cfset aggregate    = "COUNT(*) as total">	
<cfset aggrfield    = "total">	
<cfset colnfield    = "">
<cfset col          = 0>
	
<cfloop array="#attributes.listlayout#" index="fields">
  			  
	<cfparam name="fields.aggregate"   default="">	
	<cfparam name="fields.column"      default="">							
	<cfparam name="fields.display"     default="yes">	
	
	<!--- need to rework this a bit so we can have several different column dimension --->
				
	<cfif fields.field neq url.listgroupfield>  <!--- fields to be shown and is not grouping field itself --->
	
	    <cfset col = col + 1> 				
		<!--- SUM metric --->						
		<cfif fields.aggregate eq "SUM">				
			<cfif session.listingdata[box]['firstsummary'] eq "0">												
				<cfset session.listingdata[box]['firstsummary'] = col>														
			</cfif>					    
			<cfset aggregate = "#aggregate#,SUM(#fields.field#) as #fields.field#, AVG(#fields.field#) as #fields.field#_AVG, MIN(#fields.field#) as #fields.field#_MIN, MAX(#fields.field#) as #fields.field#_MAX">
			<cfset aggrfield = "#aggrfield#,#fields.field#">												
		 </cfif>			 
					
	</cfif>
				
</cfloop>	
	
<cfset session.listingdata[box]['explore']    = url.listgrouptotal>
<cfset session.listingdata[box]['aggregate']  = aggregate>	
<cfset session.listingdata[box]['aggrfield']  = aggrfield>       <!--- contains the field that are summed in the table in order to be shown --->
<cfset session.listingdata[box]['colnfield']  = url.listcolumn1>	<!--- contains the date                --->
<cfset session.listingdata[box]['datacell1']  = url.datacell1>	<!--- contains the field to be shown   --->
		
<!--- we prepare a BASE query content  with both row (group) and column dimension which will speed up the presentation later 
we should not apply this is if the grouping has not changed, this will then save more time 
---> 	

<cfparam name="url.listcolumn1_type"     default="period">
<cfparam name="url.listcolumn1_typemode" default="">

<cfif url.listcolumn1_type eq "">
	<cfset url.listcolumn1_type = "period">
</cfif>		

<cfif url.listcolumn1 neq "" and url.listcolumn1 neq "summary">

	<cfswitch expression="#url.listcolumn1_type#">
	
		<cfcase value="period">		
	
	        <!--- we determine the column detail for  presentation : mth, yer, qtr --->
		 		 
		    <!--- we determine the period cell --->
	
			<cfloop index="itm" list="#url.listcolumn1#"> 
				
				<cfquery name="getRange" dbtype="query">
					 SELECT   MIN(#url.listcolumn1#) as ColStart,
					          MAX(#url.listcolumn1#) as ColEnd			  
					 FROM     SearchResult 
					 WHERE    #url.listcolumn1# is not NULL <!--- this is the base content which we generated or kept in memory --->										
				</cfquery>
				
				<!--- Hanno this we need to make quicker and see if we can get it 
				 from the grouped information already <cfoutput>aaaaa:#cfquery.executiontime#</cfoutput>
				--->
						
			</cfloop>
			
			<cfif not isValid("date",getRange.colStart)>
			
				<!--- clean --->
				
				<cfquery name="clean" 
				   datasource="AppsSystem" 
				   username="#SESSION.login#" 
				   password="#SESSION.dbpw#">
						DELETE FROM UserModuleCondition
						WHERE       SystemFunctionId = '#url.systemfunctionid#' 
						AND         Account = '#session.acc#'			
				</cfquery>
								
				<script>
				opener.history.go()
				</script>
				
				<cfabort>
			
			</cfif>
			
			<cfparam name="period" default="month">
				
			<cfif getRange.recordcount eq "0">
										
				<table><tr><td><cf_tl id="No records found"></td></tr></table>
				
			<cfelse>
				
			    <cfset range = datediff("m",getRange.colStart,getRange.colEnd)>
				
				<cfif findNoCase(url.listcolumn1_typemode,"year,quarter,month,week")>
								
					<cfset period = url.listcolumn1_typemode>					
					
				<cfelse>
								
					<cfif range lte "4">
						<cfset period = "week">
					<cfelseif range lte "18">
						<cfset period = "month">
					<cfelseif range lte "30">	
						<cfset period = "quarter">
					<cfelseif range gt "30">
						<cfset period = "year">
					</cfif>
				
				</cfif>
				
				<cfif period eq "week">
														
					<cfset yrs = year(getRange.ColStart)>				
					<cfset mts = week(getRange.ColStart)>				
					<cfset yre = year(getRange.ColEnd)>
					<cfset mte = week(getRange.ColEnd)>	
					
					<cfset columnperiod = "#url.listcolumn1#_WKE">		
					
				<cfelseif period eq "month">
														
					<cfset yrs = year(getRange.ColStart)>				
					<cfset mts = month(getRange.ColStart)>				
					<cfset yre = year(getRange.ColEnd)>
					<cfset mte = month(getRange.ColEnd)>	
					
					<cfset columnperiod = "#url.listcolumn1#_MTH">	
										
				<cfelseif period eq "quarter">	
										
					<cfset yrs = year(getRange.ColStart)>				
					<cfset mts = month(getRange.ColStart)>		
					<cfif mts lte "3">
						<cfset mts = "1">
					<cfelseif mts lte "6">
					    <cfset mts = "2">
					<cfelseif mts lte "9">
						<cfset mts = "3">
					<cfelse>
						<cfset mts = "4">						
					</cfif>			
					
					<cfset yre = year(getRange.ColEnd)>
					<cfset mte = month(getRange.ColEnd)>
					<cfif mte lte "3">
						<cfset mte = "1">
					<cfelseif mte lte "6">
					    <cfset mte = "2">
					<cfelseif mte lte "9">
						<cfset mte = "3">
					<cfelse>
						<cfset mte = "4">						
					</cfif>		
					
					<cfset columnperiod = "#url.listcolumn1#_QTR">
					
					<!--- adjust the query on the level of the quarter --->
					
				<cfelse>
										
					<cfset yrs = year(getRange.ColStart)>	
					<cfset yre = year(getRange.ColEnd)>
					
					<cfset columnperiod = "#url.listcolumn1#_YR">
										
				</cfif>
									
			</cfif>		
		
		</cfcase>	
		
		<cfcase value="common">
			
		
			<cfset columnperiod = "#url.listcolumn1#">
			
			<cfquery name="getRange" dbtype="query">
					 SELECT    #url.listcolumn1# as Col						           	  
					 FROM      SearchResult <!--- this is the base content which we generated or kept in memory --->	
					 GROUP BY  #url.listcolumn1#
					 <!--- we can sort this by fieldsort --->
					 ORDER BY  #url.listcolumn1#									
			</cfquery>
				
		</cfcase>			
				
	</cfswitch>
	
<cfelse>	
	
	<cfset columnperiod = "#url.listcolumn1#_YR">	
			
</cfif>

<!--- we read the pivot data into memory --->

<cfoutput>		
			
	<cfsavecontent variable="groupsql">		
			
		SELECT    <cfif url.listgroupsort neq url.listgroupfield 
						 and url.listgroupsort neq "">#url.listgroupsort#,#url.listgroupfield#
				  <cfelse>#url.listgroupfield#	 
		          </cfif>	
				           			      
	              <!--- we add this field to present the correct sorting of the group as well --->
				  <cfif drillkey neq "">,MIN(#drillkey#) as GroupKeyValue <!--- we take a random value of the key so we can easily find the content ---></cfif>	
				  <!--- pivot fields : this query will fire each time you can from month, year and will take some time --->		
				    			 
				  <cfif url.listcolumn1 neq "" and url.listcolumn1 neq "summary">,#columnperiod# as #url.listcolumn1#</cfif>				     
				  
				  ,#preserveSingleQuotes(aggregate)#  <!--- totals and count --->
				  
		FROM      SearchResult <!--- this is the base content which we generated or kept in memory --->				
		GROUP BY  <cfif url.listgroupsort neq url.listgroupfield 
						  and url.listgroupsort neq "">#url.listgroupsort#,#url.listgroupfield# 
			      <cfelse>#url.listgroupfield#
				  </cfif>
			      <cfif url.listcolumn1 neq "" and url.listcolumn1 neq "summary">,#columnperiod#</cfif>						
		<cfif findNoCase(url.listorderfield,aggrfield) and url.listorderfield neq "" and url.listgroupsort neq ""> 
		ORDER BY #url.listorderfield# #url.listorderdir# <cfif url.listorderfield neq url.listgroupsort>, #url.listgroupsort# #url.listgroupdir#</cfif>	
		<cfelseif url.listgroupsort neq "">		 						  
	    ORDER BY #url.listgroupsort# #url.listgroupdir#		
		</cfif>
		
	</cfsavecontent>	
					
</cfoutput>		
	
<!--- allow to sort the aggregated result on highest and lowest --->

<!---
<cfdump var="#SearchResult#">
--->
	
<cfif groupsql neq session.listingdata[box]['sqlgroup']>	

	<cftry>
	
		<cfquery name="SearchGroup" dbtype="query">
			  #preservesinglequotes(groupsql)#				  													 
		</cfquery>
		
		<cflock timeout="20" throwontimeout="No" type="EXCLUSIVE" scope="SESSION">
			<cfset session.listingdata[box]['dataprepgroup']    = cfquery.executiontime> <!--- time perform - --->
			<cfset session.listingdata[box]['datasetgroup']     = searchgroup>           <!--- query object - ---> 			
			<cfset session.listingdata[box]['sqlgroup']         = groupsql>              <!--- query itself - --->
		</cflock>
	
	<cfcatch>
			
		<!---
		<cfdump var="#SearchResult#">
		--->
					
		<script>
			Prosis.busy('no')
			Prosis.busyRegion('no','_divSubContent')		
		</script>
	
		GROUP ERROR: <cfoutput>#preservesinglequotes(groupsql)#</cfoutput>	 
		
		<cfabort>
		
	</cfcatch>
	
	</cftry>
			
	<!---
	<cfoutput>x:#cfquery.executiontime#</cfoutput>			
	<cfdump var="#searchresult#" output="browser">		
	<cfdump var="#searchgroup#" output="browser">
	<cfabort>
	--->			

<cfelse>
		
	<cfset session.listingdata[box]['dataprepgroup']        = 0>  <!--- time perform - --->	
	<cfset searchgroup                                      =  session.listingdata[box]['datasetgroup']> 			

</cfif>


<!--- ATTENTION Hann this query is slower but is more accurate for the AVG and PERC as this has to be a weighted formula   
	<cfquery name="SearchGroupTotal" dbtype="query">
		  SELECT #aggregate#, #columnperiod# as #url.#url.listcolumn1#_period
		  FROM   SearchResult
		  GROUP BY #columnperiod#				  										
	</cfquery>		
--->

<cfif url.listcolumn1 neq "">

	<cfquery name="SearchGroupTotal" dbtype="query">
		SELECT   SUM(Total) as Total, #aggregate#, #url.listcolumn1# 
		FROM     SearchGroup
		GROUP BY #url.listcolumn1#				  										
	</cfquery>	
		
</cfif>

<!--- get data for the total column at the end 
<cfquery name="SearchColumnTotal" dbtype="query">
   	 SELECT    #aggregate#, #url.listgroupsort#  <cfif url.listgroupsort neq url.listgroupfield>, #url.listgroupfield# </cfif>
     FROM      SearchGroup
	 GROUP BY  #url.listgroupsort# <cfif url.listgroupsort neq url.listgroupfield>, #url.listgroupfield# </cfif>			  										
</cfquery>	
--->

<cfif url.datacell1 neq "">
	
	<cfquery name="SearchOverall" dbtype="query">
    	 SELECT    SUM(#url.datacell1#) as Total
	     FROM      SearchGroup		 	  										
	</cfquery>
		
</cfif>