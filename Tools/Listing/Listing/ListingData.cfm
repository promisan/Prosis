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
<!--- we have 3 modes at this moment

	Obtain the data
	Use cached version once interface is pressed
	ajax version which takes a subset 
	
--->

<!--- -------------------------------------- --->
<!--- prepare the grouping and/or sort query --->
<!--- -------------------------------------- --->

<cfset ts = "0">



<cfoutput>

	<cfsavecontent variable="listsorting">
	
		<cfif url.listorder neq "" or url.listgroup neq "">										
					
			ORDER BY				
			
			<!--- grouping --->
			
			<cfif url.listgroup neq "">											
				<cfif url.listgroupformat eq "date" and attributes.refresh eq "1">				
					<cfif url.listgroupalias neq "">			
						CAST (#url.listgroupalias#.#url.listgroup# as Datetime) 
					<cfelse>
						CAST (#url.listgroup# as Datetime)  
					</cfif>											
				<cfelse>				
					<cfif url.listgroupalias neq "">								
						#url.listgroupalias#.#url.listgroupsort# 
					<cfelse>
						#url.listgroupsort# 
					</cfif>													
				</cfif>
							
			    #url.listgroupdir# 			
    			<cfif url.listorder neq "" and url.listorder neq url.listgroup>,</cfif>
			
			</cfif>		
			
			<!--- sorting --->
							
			<cfif url.listorder neq "" and url.listorder neq url.listgroup>											
				<cfif url.listgroupformat eq "date" and attributes.refresh eq "1">				
					<cfif url.listorderalias neq "">			
						CAST (#url.listorderalias#.#url.listorder# as Datetime) 
					<cfelse>
						CAST (#url.listorder# as Datetime)  
					</cfif>											
				<cfelse>				
					<cfif url.listorderalias neq "">			
						#url.listorderalias#.#url.listorder# 
					<cfelse>
						#url.listorder# 
					</cfif>													
				</cfif>			
				#url.listorderdir# 			
			</cfif>							
		
		</cfif>
	
	</cfsavecontent>				

</cfoutput>		


<cfif url.ajaxid eq "append">

	<!--- better to store this based on the box --->
	
	<cfset searchresult = session.listingdata[attributes.box]['dataset']>
						
	<cfif url.groupvalue1 eq "" or url.groupvalue1 eq "undefined">
	
		<!--- this is a generic refresh for the pure sequential table listing --->	
	
		<cfset start = session.listingdata[attributes.box]['recshow']+1>			
		<cfset end   = session.listingdata[attributes.box]['recshow']+session.listingdata[attributes.box]['pagecnt']>		
		<cfset rowdatatarget = "r">	
					
	<cfelse>
	
		<!--- we apply a filter for the result to be shown --->
		
		<cfif url.col1 eq "undefined">
			<cfset url.col1 = "">
		</cfif>
								
	    <cftry>		
	
			<cfquery name="getGroup1" dbtype="query">
				SELECT #url.listgroupfield# as FilterValue				
				FROM   Searchresult
				WHERE  #drillkey# = '#url.groupvalue1#'												
			</cfquery>	
						
			<cfcatch>	
				
				<cfquery name="getGroup1" dbtype="query">
					SELECT #url.listgroupfield# as FilterValue					
					FROM   Searchresult
					WHERE  #drillkey# = #url.groupvalue1#												
				</cfquery>
							
			</cfcatch>
			
		</cftry>
		
		<cftry>
						
			<cfquery name="searchResult" dbtype="query">
				SELECT * 
				FROM   Searchresult
				<cfif getGroup1.FilterValue neq "">
				WHERE  #url.listgroupfield# = '#getGroup1.FilterValue#'
				<cfelse>
				WHERE  #url.listgroupfield# is NULL							
				</cfif>				
				<cfif url.col1 neq "">
				AND    #url.col1#           = '#url.col1value#'			
				</cfif>
				<cfif url.listorderfield neq "" or url.listgroupsort neq "">
					ORDER BY 
					<cfif url.listgroupsort neq "">
					#url.listgroupsort#	<cfif url.listorderfield neq "">,</cfif>				
					</cfif>				
					<cfif url.listorderfield neq "">
					#url.listorderfield# #url.listorderdir#
					</cfif>
				</cfif>	
			</cfquery>	
										
			<cfcatch>	
										
				<cfquery name="searchResult" dbtype="query">
					SELECT * 
					FROM   Searchresult
					<cfif getGroup1.FilterValue neq "">
					WHERE  #url.listgroupfield# = #getGroup1.FilterValue#
					<cfelse>
					WHERE  #url.listgroupfield# is NULL							
					</cfif>		
					<cfif url.col1 neq "">
					AND    #url.col1#           = '#url.col1value#'
					</cfif>
					<cfif url.listorderfield neq "" or url.listgroupsort neq "">
					ORDER BY 
					<cfif url.listgroupsort neq "">
					#url.listgroupsort#	<cfif url.listorderfield neq "">,</cfif>				
					</cfif>				
					<cfif url.listorderfield neq "">
					#url.listorderfield# #url.listorderdir#
					</cfif>
					</cfif>
				</cfquery>	
														
			</cfcatch>
										
	    </cftry>
										
		<cfset start = "1">			
		<cfset end   = searchresult.recordcount>
		<!--- here is the name of the class to which we will add --->
		<cfset rowdatatarget = url.grouptarget>				
	
	</cfif>
		
<cfelseif attributes.listtype eq "SQL">  <!--- in case of append we use the same query object --->

	<cfoutput>
	
		 <cfset listquery =  attributes.listquery>
		 
		 <cfset basequery = listquery>
		
		<!--- NEW : we are going to add fields to support the dimensional presentation --->
		 
		<cfloop array="#attributes.listlayout#" index="fields">
						
			<cfparam name="fields.column" default="">
					
			<cfif fields.column eq "month">
												
			    <cfif fields.alias neq "">
				
					<cfif findNoCase("--,#fields.alias#.#fields.field#", listquery)>
						<cfset pre = "--,">
					<cfelse>
						<cfset pre = "">	
					</cfif>
				
		            <cfset fo = findNoCase("#pre##fields.alias#.#fields.field#", listquery)>	
					
				<cfelse>
				
					<cfif findNoCase("--,#fields.field#", listquery)>
						<cfset pre = "--,">
					<cfelse>
						<cfset pre = "">	
					</cfif>
					
				    <cfset fo = findNoCase("#pre##fields.field#", listquery)>	
				</cfif>
				
				<!---								
				<cfif session.acc eq "esdnyrs3">				
				<cfoutput>--#fo#-----#fields.alias#.#fields.field# : #listquery#--</cfoutput>
				</cfif>
				--->
				
				<cfif fo gt "1">
								
					<cfset qry1 = left(listquery, fo-1)>
					<cfif fields.alias neq "">
						<cfset start  = fo+len("#pre##fields.alias#.#fields.field#")>									
					<cfelse>
						<cfset start  = fo+len("#pre##fields.field#")>
					</cfif>
					<cfset qry2 = mid(listquery,start,len(listquery)+1-start)>
					
					<cfif fields.alias neq "">
						<cfset fld = "#fields.alias#.#fields.field#">
					<cfelse>
					    <cfset fld = "#fields.field#">
					</cfif>		
					
					<cfsavecontent variable="datedimension">
					     <cfif pre neq "">,</cfif>
						 CONVERT(varchar,DATEPART(yy,#fld#))                                 AS #fields.field#_YR,
						 CONVERT(varchar, DATEPART(yy, #fld#)) + '-' + (CASE 
						        WHEN MONTH(#fld#) >= 1   AND  MONTH(#fld#) <= 3  THEN 'Q1' 
								WHEN MONTH(#fld#) >= 4   AND  MONTH(#fld#) <= 6  THEN 'Q2' 
								WHEN MONTH(#fld#) >= 7   AND  MONTH(#fld#) <= 9  THEN 'Q3' 
								WHEN MONTH(#fld#) >= 10  AND  MONTH(#fld#) <= 12 THEN 'Q4' 
								END)                                                        AS  #fields.field#_QTR,								 
                         CONVERT(varchar(7), #fld#, 126)                                    AS  #fields.field#_MTH, 								
						 CONVERT(varchar,DATEPART(yy,#fld#))+'-'+CONVERT(varchar,Format(DATEPART(wk,#fld#),'00')) 
								                                                            AS #fields.field#_WKE					
					</cfsavecontent>					
										
					<cfif findNoCase("*",qry1)>
						 <cfset listquery = "#qry1# #preservesingleQuotes(datedimension)# #qry2#">
					<cfelse>
						 <cfset listquery = "#qry1# #fld#,#preservesingleQuotes(datedimension)# #qry2#"> 																	
					</cfif>
						
				</cfif>
				
				<cfset basequery = listquery>
									
			</cfif>			
		
		</cfloop> 
											 	
		<cfparam name="form.annotationsel" default="">			
		
		<!--- we are going to remove the ORDER BY that appears at the end of the query --->		
			
		<cfif findNoCase("ORDER BY",listquery)>	  		  
		   <cfset fo = findNoCase("ORDER BY", listquery)>		   
		   <cfloop condition="FindNoCase('ORDER BY', listquery, fo+1)">		  			           		   
		       <cfset fo = findNoCase("ORDER BY", listquery,fo+1)>					 		   
		   </cfloop>		
		   <cfif len(listquery) - fo gte 50>
		   		<!--- it is surely not the end but an embedded --->
				 <cfset listquery =  listquery>
		   <cfelse>    
			   <cfset listquery = left(listquery, fo-1)>		   
		   </cfif>	   
		<cfelse>		
		   <cfset listquery =  listquery>  		   
		</cfif>
			
		<cfif findNoCase("DISTINCT",  listquery)>
		    <cfset listquery = replaceNoCase(listquery,"SELECT DISTINCT ","SELECT DISTINCT TOP 100 PERCENT ")> 
		<cfelseif findNoCase("TOP",  listquery)> 
			<cfset listquery = replaceNoCase(listquery,"SELECT ","SELECT ")> 
		<cfelse>
			<cfset listquery = replaceNoCase(listquery,"SELECT ","SELECT TOP 100 PERCENT ")> 
		</cfif>			
								
		<!--- we are going to determine if the main portion of the query has a group by --->
													
		<cfif not findnocase("GROUP BY ",listquery) and not findnocase("--Condition",listquery)>	
				
			<cfif form.annotationsel neq "">
						
				<cfsavecontent variable="ann">	
				
				<cfif form.annotationsel neq "">		
				
					<cfif form.annotationsel EQ "none">
						AND  #qdrillkey# NOT IN
								 (SELECT <cfif doc.entityKeyField4 neq "">ObjectKeyValue4<cfelse>ObjectKeyValue1</cfif>
		                       	  FROM   [#System.DatabaseServer#].System.dbo.UserAnnotationRecord
							 	  WHERE  Account      = '#SESSION.acc#' 
							 	  AND    EntityCode   = '#annotation#')	
					<cfelse>							
						AND  #qdrillkey# IN
								 (SELECT <cfif doc.entityKeyField4 neq "">ObjectKeyValue4<cfelse>ObjectKeyValue1</cfif>
		                       	  FROM   [#System.DatabaseServer#].System.dbo.UserAnnotationRecord
							 	  WHERE  Account      = '#SESSION.acc#' 
							 	  AND    EntityCode   = '#annotation#' 
							 	  AND    AnnotationId = '#form.annotationsel#')	
					</cfif>		  
											
				</cfif>
				
				</cfsavecontent>
				
			<cfelse>
			
				<cfset ann = "">	
				
			</cfif>	
					
			<cfsavecontent variable="querylist">
									
			    #preserveSingleQuotes(listquery)# 	
				<cfif not findnocase("WHERE ",listquery)>
				WHERE 1=1
				</cfif>
				<cfif condition neq "">
				#preserveSingleQuotes(condition)# 
				</cfif>	
												
				<!--- filter on the ajax id only in order to refresh the row --->				
				<cfif url.ajaxid neq "content">				
				    AND #qdrillkey# = '#url.ajaxid#' 
				<!--- 7/2/2021 filter on the recently added record only --->										
				<cfelse>
				
					<cfif url.contentmode eq "5" and qentrykey neq "">	
					AND #qentrykey# > getDate() - 1
					</cfif>
					
				#ann#
				
				<cfif url.contentmode eq "5" and qentrykey neq "">	
				ORDER BY #qentrykey# DESC
				<cfelse>
				#listsorting#	
				</cfif>
				
				
				</cfif>											
			
			</cfsavecontent>													
				
		<cfelseif findnocase("--Condition",listquery)>	
				
			<!--- 16/6/2014 recompose the query that contains a --condition indicator to 
			
			 determine where the listing condition should go  --->			
			
			<cfset strlen  = len(listquery)>		
			
		    <cfset start = findnocase("--Condition",listquery)>
															
			<cfset strleft  = left(listquery,start-1)>
			<cfset strright = right(listquery,strlen-start+1)>
			
			<cfif form.annotationsel neq "">
						
				<cfsavecontent variable="ann">
					
					<cfif form.annotationsel EQ "none">
					AND  #qdrillkey# NOT IN
							 (SELECT <cfif doc.entityKeyField4 neq "">ObjectKeyValue4<cfelse>ObjectKeyValue1</cfif>
	                       	  FROM   System.dbo.UserAnnotationRecord
						 	  WHERE  Account      = '#SESSION.acc#' 
						 	  AND    EntityCode   = '#annotation#')	
					<cfelse>							
					AND  #qdrillkey# IN
							 (SELECT <cfif doc.entityKeyField4 neq "">ObjectKeyValue4<cfelse>ObjectKeyValue1</cfif>
	                       	  FROM   System.dbo.UserAnnotationRecord
						 	  WHERE  Account      = '#SESSION.acc#' 
						 	  AND    EntityCode   = '#annotation#' 
						 	  AND    AnnotationId = '#form.annotationsel#')	
					</cfif>	
					
					<!--- filter on the ajax id only --->				
					<cfif url.ajaxid neq "content">
					AND #qdrillkey# = '#url.ajaxid#'	
					<cfelse>										
						<cfif url.contentmode eq "5" and qentrykey neq "">	
						AND #qentrykey# > getDate() - 1
						</cfif>
					</cfif>	
										 
				</cfsavecontent>	
								
			<cfelse>
			
				<cfsavecontent variable="ann">
							
				<!--- filter on the ajax id only --->				
				<cfif url.ajaxid neq "content">
				AND #qdrillkey# = '#url.ajaxid#'	
				<cfelse>	
				
					<cfif url.contentmode eq "5">	
					AND #qentrykey# > getDate() - 1
					</cfif>			
												
				</cfif>	 
										 
				</cfsavecontent>								 
				
			</cfif>
												
			<cfif not findnocase("WHERE ",listquery)>
				<cfset strwhr = "WHERE 1=1">
			<cfelse>
				<cfset strwhr = "">	
			</cfif>
			
			<!--- compose the query --->
											
			<cfset querylist = "#strleft# #strwhr# #condition# #ann# #strright# #listsorting#">		
																			
		<cfelse>
				
		    <!--- recompose the query that contains a group --->
			
			<cfset strlen  = len(listquery)>
			<cfset start  = "1">
			
			<cfloop index="itm" from="1" to="4">
				<cfif findnocase("GROUP BY",listquery,start)>
				  <cfset start = findnocase("GROUP BY",listquery,start)>
				</cfif>
			</cfloop>
												
			<cfset strleft  = left(listquery,start-1)>
			<cfset strright = right(listquery,strlen-start+1)>
			
			<cfif form.annotationsel neq "">
			
				<cfsavecontent variable="ann">
					
				<cfif form.annotationsel EQ "none">
				AND  #qdrillkey# NOT IN
						 (SELECT <cfif doc.entityKeyField4 neq "">ObjectKeyValue4<cfelse>ObjectKeyValue1</cfif>
                       	  FROM   System.dbo.UserAnnotationRecord
					 	  WHERE  Account      = '#SESSION.acc#' 
					 	  AND    EntityCode   = '#annotation#')	
				<cfelse>							
				AND  #qdrillkey# IN
						 (SELECT <cfif doc.entityKeyField4 neq "">ObjectKeyValue4<cfelse>ObjectKeyValue1</cfif>
                       	  FROM   System.dbo.UserAnnotationRecord
					 	  WHERE  Account      = '#SESSION.acc#' 
					 	  AND    EntityCode   = '#annotation#' 
					 	  AND    AnnotationId = '#form.annotationsel#')	
				</cfif>	
				
				<!--- filter on the ajax id only --->				
				<cfif url.ajaxid neq "content">
				AND #qdrillkey# = '#url.ajaxid#'	
				<cfelse>	
				
					<cfif url.contentmode eq "5">	
					AND #qentrykey# > getDate() - 1
					</cfif>		
									
				</cfif>	  			
										 
				</cfsavecontent>		
				
			<cfelse>
			
				<cfset ann = "">					 
				
			</cfif>
			
			<cfif not findnocase("WHERE ",listquery)>
				<cfset strwhr = "WHERE 1=1">
			<cfelse>
				<cfset strwhr = "">	
			</cfif>
			
			<!--- compose the query --->
						
			<cfset querylist = "#strleft# #strwhr# #condition# #ann# #strright# #listsorting#">
									
		</cfif>
					
	</cfoutput>	
			
	<!--- ------------------------------------------ --->
	<!--- WE CHECK IF WE CAN TAKE THE CACHED VERSION --->
	<!--- ------------------------------------------ --->			
	
	<cfset applycache = "0">
	<cfparam name="ann"       default="">
	<cfparam name="condition" default="">		
	
	<cfset conditioncheck = "#condition# #ann#">
	
	<!--- check listing --->
				
	<cfparam name="session.listingdata['#box#']['sqlcondition']" default="x">
			
	<cfif attributes.refresh eq "0" 
	      and url.ajaxid eq "content" 
		  and conditioncheck eq session.listingdata[box]['sqlcondition']>	
		 		 		 				
		<!--- obtain the cache --->
		
		<cflock timeout="1" throwontimeout="No" name="mysession" type="EXCLUSIVE">
		    <cfset session.listingdata[box]['pagecnt']  = attributes.show>	         <!--- page count 1 of 20 from 300 1: --->
			<cfset session.listingdata[box]['recshow']  = attributes.show>	         <!--- page count 1 of 20 from 300 2: --->
			<cfset searchresult = session.listingdata[box]['dataset']>	
			<cfset session.listingdata[box]['dataprep']  = "-1">  <!--- cached --->
		</cflock>
		<cfset applycache = "1">	
																	
		<!--- only to apply if indeed the sorting had changed this will gain a bit --->
												
		<cfif not findNoCase("#listsorting#",session.listingdata[box]['sqlsorting'])>
								
		    <cfoutput>
			
				<cfsavecontent variable="listsortingcache">
			
				<cfif url.listorder neq "" or url.listgroup neq "">										
							
					ORDER BY					
					<!--- grouping --->				
					<cfif url.listgroup neq "">											
						#url.listgroupsort# #url.listgroupdir#		
						<cfif url.listorder neq "" and url.listorder neq url.listgroup>,</cfif>	
					</cfif>		    					
					<!--- sorting --->							
					<cfif url.listorder neq "" and url.listorder neq url.listgroup>																
						#url.listorder# #url.listorderdir#		
					</cfif>							
				
				</cfif>
			
			    </cfsavecontent>			
													
			<cfquery name="searchResult" dbtype="query">
				SELECT * FROM Searchresult WHERE 1=1 #listsortingcache# 					
			</cfquery>						
			
			</cfoutput> 		
			
			<cflock timeout="1" throwontimeout="No" name="mysession" type="EXCLUSIVE">						    	
						
				<cfset session.listingdata[box]['dataprepsort'] = "#cfquery.executiontime#">	
				<!--- Dev 20/1/2022 the below was giving an error in NY, I disabled it, effectively this did not mean that
				sorting would not work 
				<cfset session.listingdata[box]['sqlsorting']   = listsorting>			
				<cfset session.listingdata[box]['dataset']      = searchresult> 	
				--->		
			</cflock>
					
		</cfif>
							
	<!--- preparation of a standard recorded listing --->	
			
	<cfelseif listclass eq "Listing">
					
		<!--- outputting --->
						
		<cfquery name="Header" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT *
			FROM   Ref_ModuleControlDetail
			WHERE  SystemFunctionId = '#URL.SystemFunctionId#'
			AND    FunctionSerialNo = '1'
		</cfquery>
		
																	
		<cfif attributes.refresh eq "0" or url.content eq "0">
						
			<cfset fileNo = "#Header.DetailSerialNo#">	
			
			<!--- run the preparation queries with temp tables --->
			<cfinclude template="../../../System/Modules/InquiryBuilder/QueryPreparation.cfm">	
			
			<cfset sc = querylist>
			
			<!--- make some conversion on specific words --->
			<cfinclude template="../../../System/Modules/InquiryBuilder/QueryValidateReserved.cfm">	
						
			<cftry>
						
				<cftransaction isolation="read_uncommitted">									
			
					<cfquery name="SearchResult" 
						datasource="#attributes.datasource#" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#"> 			
						#preserveSingleQuotes(sc)#  
					</cfquery>		
				
				</cftransaction>
			
				<cfcatch>
					
					<cfquery name="SearchResult" 
						datasource="#attributes.datasource#" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#"> 			
						#preserveSingleQuotes(sc)#  
					</cfquery>	
				
				</cfcatch>
			</cftry>	
																
		<cfelse>	
		  		
			<cftry>					
							
				<cfset fileNo = Header.DetailSerialNo>							
				<cfinclude template="../../../System/Modules/InquiryBuilder/QueryPreparationVars.cfm">
				
				<cfset sc = querylist>			
				<cfinclude template="../../../System/Modules/InquiryBuilder/QueryValidateReserved.cfm">	
									
				<cftry>
				
					<cftransaction isolation="read_uncommitted">	
														
						<cfquery name="SearchResult" 
							datasource="#attributes.datasource#" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#"> 			
							#preserveSingleQuotes(sc)# 
						</cfquery>	
												
					</cftransaction>
				
					<cfcatch>
					
						<cfquery name="SearchResult" 
							datasource="#attributes.datasource#" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#"> 			
							#preserveSingleQuotes(sc)# 
						</cfquery>	
						
					</cfcatch>
					
				</cftry>
			
				<cfcatch>													
					
					<!--- is included in query preparation
					<cfinclude template="../../../System/Modules/InquiryBuilder/QueryPreparationVars.cfm">					
					---> 
					
				    <cfset sc = querylist>				
				    <cfinclude template="../../../System/Modules/InquiryBuilder/QueryValidateReserved.cfm">																						
					<cfinclude template="../../../System/Modules/InquiryBuilder/QueryPreparation.cfm">		
					
					<cftry>
											
						<cftransaction isolation="read_uncommitted">
															
							<cfquery name="SearchResult" 
								datasource="#attributes.datasource#" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#"> 			
								    #preserveSingleQuotes(sc)# 	
							</cfquery>	
						
						</cftransaction>
											
						<cfcatch>
													
							<cfquery name="SearchResult" 
								datasource="#attributes.datasource#" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#"> 			
								    #preserveSingleQuotes(sc)# 	
							</cfquery>		
						
						</cfcatch>
						
					</cftry>				
							
				</cfcatch>
			
			</cftry>
					
		</cfif>	
		
		<cfset ts = cfquery.executiontime>		
				
	<cfelse>
				
		<!--- outputting of an in the application embedded listing which does not have a prequery as this can be embedded --->			
										
		<cftry>
				
			<cfset fileNo = "0">			
		    <!--- prepare temp variables, is not really needed for this mode --->
			<cfinclude template="../../../System/Modules/InquiryBuilder/QueryPreparationVars.cfm">	
						
			<cfset sc = querylist>			
			<!--- convert reserved words in the query string like @user --->
		    <cfinclude template="../../../System/Modules/InquiryBuilder/QueryValidateReserved.cfm">		
																
			<cftry>
									
				<cftransaction isolation="read_uncommitted">				
															
					<cfquery name="SearchResult" 
						datasource="#attributes.datasource#" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#"> 										
						#preserveSingleQuotes(sc)# 					
					</cfquery>	
					
					<!---	
					<cfoutput>normal:#cfquery.executiontime#</cfoutput>					
					--->
																				
				</cftransaction>
			
				<cfcatch>
													
					<cfquery name="SearchResult" 
						datasource="#attributes.datasource#" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#"> 										
						#preserveSingleQuotes(sc)# 					
					</cfquery>	
									
				</cfcatch>
				
			</cftry>
			
			<cfset ts = cfquery.executiontime>
																																							
			<cfcatch>
							
				<CFIF url.systemfunctionid neq "">
				
					<cfquery name="set" 
					datasource="AppsSystem" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						DELETE FROM UserModuleCondition				
						WHERE Account          = '#SESSION.acc#'
						AND   SystemFunctionId = '#url.systemfunctionid#'								
					</cfquery>		
				
				</cfif>
			
				<cfoutput>		
				<table width="80%" align="center" class="formpadding">
					<tr><td height="10"></td></tr>
					<tr><td>Error:</td></tr>
					<tr><td bgcolor="ffffaf">
					#CFCatch.Message# - #CFCATCH.Detail#
					</td></tr>
					<cfif getAdministrator("*") eq "1">
					<tr><td><b><cf_tl id="Query">:</td></tr>
					<tr><td>
					#preserveSingleQuotes(querylist)# 	
					</td></tr>
					</cfif>
				</table>
							
				
				</cfoutput>		
				
				<script>
				Prosis.busy('no')
				Prosis.busyRegion('no','_divSubContent')		
				</script>
				<cfabort>
			
			</cfcatch>
				
		</cftry>
		
	</cfif>		
					
	<!---
		
	<cfif url.listorder neq "">
			
	<cftry>
			
		<cfquery name="CheckGroup" maxrows=1 dbtype="query">
			 SELECT #url.listorder#
			 FROM   SearchResult
		</cfquery>	
				
		<cfcatch>
		
		       <cfoutput>	  
					<table width="80%" align="center" class="formpadding">
					<tr><td height="10"></td></tr>
					<tr><td><b><cf_tl id="Error for Query">:</td></tr>
					<tr><td bgcolor="ffffaf">
					#CFCatch.Message# - #CFCATCH.Detail#
					</td></tr>
					<cfif getAdministrator("*") eq "1">
					<tr><td><b><cf_tl id="Query">:</td></tr>
					<tr><td>
					#preserveSingleQuotes(querylist)# 	
					</td></tr>
					</cfif>
					</table>
					</cfoutput>
					
					</cfcatch>	
		
		</cftry>
	
	</cfif>		
	
	--->
		
	<cfparam name="session.listingdata['#box#']['sqlsorting']" default="">
	
		
	<cfparam name="sc" default="">
	
	<!--- to help clearing cache during development 
	<cfset applycache = "0">
	--->	
											
	<cfif applycache eq "0" or (session.listingdata[box]['sqlsorting'] neq listsorting and sc neq "")>			
									
		<cfparam name="session.listingdata['#box#']['recordsinit']" default="-1">  	
						
		<!--- ---------------------------------------------------------------------- --->
		<!--- obtain relevant data of the query for adding on-the-fly is enabled     --->
		<!--- ---------------------------------------------------------------------- --->
		
		<cflock timeout="20" throwontimeout="No" name="mysession" type="EXCLUSIVE">
					
			<cfset session.listingdata[box]['timestamp']        = now()>		
			<cfset session.listingdata[box]['datasource']       = attributes.datasource>  
			<cfset session.listingdata[box]['annotation']       = attributes.annotation>		
			<cfset session.listingdata[box]['listlayout']       = attributes.listlayout>
			<cfset session.listingdata[box]['sqlorig']          = attributes.listquery>  	
			
			<cfset session.listingdata[box]['sqlbase']          = basequery>  	 <!--- the passed query with no conditions --->				
			<cfset session.listingdata[box]['sql']              = sc>                        <!--- the generated query --->		
			<cfset session.listingdata[box]['sqlcondition']     = conditioncheck>	
			<cfset session.listingdata[box]['sqlsorting']       = listsorting>							
			<cfif condition eq "" or session.listingdata[box]['recordsinit'] eq "-1">										
			    <cfset session.listingdata[box]['recordsinit']   = searchresult.recordcount> 
				<cfset session.listingdata[box]['datasetinit']   = searchresult>			     <!--- the generate data itself --->	
			</cfif>	
			<cfset session.listingdata[box]['dataprep']         = ts>      
			<cfset session.listingdata[box]['dataprepsort']     = 0>		    
			<cfset session.listingdata[box]['records']          = searchresult.recordcount>  <!--- page count 1 of 20 from 300 3: --->
			
			<cfset session.listingdata[box]['dataset']          = searchresult>			     <!--- the generate data itself --->			
			
			<cfset session.listingdata[box]['datasetgroup']     = "">                        <!--- the partially clustered data for grouping/ column to improve performance ---> 	 
			
			<cfset session.listingdata[box]['pagecnt']          = attributes.show>	         <!--- page count 1 of 20 from 300 1: --->
			<cfset session.listingdata[box]['recshow']          = attributes.show>	         <!--- page count 1 of 20 from 300 2: --->
			
			<cfset session.listingdata[box]['columns']          = "">                        <!--- the total columns in the grid --->
			<cfset session.listingdata[box]['colprefix']        = "">                        <!--- the total columns show before the first data column --->	
			<cfset session.listingdata[box]['firstsummary']     = "0">                       <!--- the column on which the first cell summary appears --->
			<cfset session.listingdata[box]['sqlgroup']         = ""> 
			<cfset session.listingdata[box]['aggregate']        = "">	                     <!--- the aggregate (SUM, count) formula to be applied on the grouping --->
			<cfset session.listingdata[box]['aggrfield']        = "">                        <!--- the fields that are to be aggregated --->  	
			
		</cflock>	
		
	<cfelse>
			
		
	</cfif>	
	
<cfelse>
	
	<cfdirectory action="LIST"
          directory = "#attributes.listpath#\#attributes.listquery#"
          name      = "SearchResult"
          sort      = "#url.listorder# #url.listorderdir#"
          type      = "all"
          listinfo  = "all">
		  
		  <!--- testing what is needed on the below --->
		  
	<cflock timeout="20" throwontimeout="No" name="mysession" type="EXCLUSIVE">
					
			<cfset session.listingdata[box]['timestamp']        = now()>	
			<cfset session.listingdata[box]['datasource']       = attributes.datasource>	
			<cfset session.listingdata[box]['annotation']       = attributes.annotation>	
			<cfset session.listingdata[box]['listlayout']       = attributes.listlayout>  		
			<cfset session.listingdata[box]['sqlorig']          = attributes.listquery>  				
				
			<cfset session.listingdata[box]['sql']              = "">                        <!--- the generated query --->		
			<cfset session.listingdata[box]['sqlcondition']     = "">	
			<cfset session.listingdata[box]['sqlsorting']       = "">							
			
			<cfif condition eq "" or session.listingdata[box]['recordsinit'] eq "-1">										
			    <cfset session.listingdata[box]['recordsinit']   = searchresult.recordcount> 
				<cfset session.listingdata[box]['datasetinit']   = searchresult>			     <!--- the generate data itself --->	
			</cfif>	
			<cfset session.listingdata[box]['dataprep']         = ts>      
			<cfset session.listingdata[box]['dataprepsort']     = 0>		    
			<cfset session.listingdata[box]['records']          = searchresult.recordcount>  <!--- page count 1 of 20 from 300 3: --->
			
			<cfset session.listingdata[box]['dataset']          = searchresult>			     <!--- the generate data itself --->			
			
			<cfset session.listingdata[box]['datasetgroup']     = "">                        <!--- the partially clustered data for grouping/ column to improve performance ---> 	 
			
			<cfset session.listingdata[box]['pagecnt']          = attributes.show>	         <!--- page count 1 of 20 from 300 1: --->
			<cfset session.listingdata[box]['recshow']          = attributes.show>	         <!--- page count 1 of 20 from 300 2: --->
			
			<cfset session.listingdata[box]['columns']          = "">                        <!--- the total columns in the grid --->
			<cfset session.listingdata[box]['colprefix']        = "">                        <!--- the total columns show before the first data column --->	
			<cfset session.listingdata[box]['firstsummary']     = "0">                       <!--- the column on which the first cell summary appears --->
			<cfset session.listingdata[box]['sqlgroup']         = ""> 
			<cfset session.listingdata[box]['aggregate']        = "">	                     <!--- the aggregate (SUM, count) formula to be applied on the grouping --->
			<cfset session.listingdata[box]['aggrfield']        = "">                        <!--- the fields that are to be aggregated --->  	
			
	</cflock>	

</cfif>


