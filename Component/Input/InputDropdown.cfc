
<cfcomponent>

    <cfproperty name="name" type="string">
    <cfset this.name = "Select">
		
	<cffunction name="DropdownSelect"
             access="remote"
             returntype="array"
             displayname="DropdownSelected"
			 secureJSON = "yes" 
			 verifyClient = "yes">
						 		
		    <cfargument name="DataSource"      type="string" required="true">
			<cfargument name="Table"           type="string" required="true">
			<cfargument name="FieldKey"        type="string" required="true">
			<cfargument name="FieldSort"       type="string" required="true">
			<cfargument name="FieldName"       type="string" required="true">
			<cfargument name="Filter0Field"    type="string" required="true">
			<cfargument name="Filter0Value"    type="string" required="true">
			<cfargument name="Filter1Field"    type="string" required="true">
			<cfargument name="Filter1Value"    type="string" required="true">
			<cfargument name="Filter2Field"    type="string" required="true">
			<cfargument name="Filter2Value"    type="string" required="true">
			<cfargument name="Selected"        type="string" required="true">
			<cfargument name="Condition"       type="string" default="">
			<cfargument name="FieldKeyReturn"  type="string" default="#FieldKey#" required="false">
			<cfargument name="CodeInDisplay"   type="string" default="0">
			<cfargument name="Multiple"        type="string" default="no">
												
			<cfset cond = replace(condition, ";", "'", "ALL")>  
			<cfset cond = replace(cond, "$", ",", "ALL")> 
			<cfset cond = replace(cond, "^", "=", "ALL")>  		
			<cfset cond = replaceNoCase(cond, "WHERE", " AND ")> 
			
			<cfset sel = replace(selected, ";", "'", "ALL")>  
			<cfset sel = replace(sel, "$", ",", "ALL")> 
			<cfset sel = replace(sel, "^", "=", "ALL")>

			<cfset sel = replace(sel,"'","","ALL")> 	
			
			<cfset select = "">
					
			<cfloop index="itm" list="#sel#" delimiters=",">
			     <cfif select eq "">
				     <cfset select = "'#itm#'">
				 <cfelse>
					 <cfset select = "#select#,'#itm#'">
				 </cfif>	 
			 </cfloop> 
					 
			 <cfif select eq "">
			      <cfset select = "''">
			 </cfif>				
										
			<cfif Filter0Field eq "Parent">
					
				<cfset flyfilter = "">						
				<cfloop index="itm" list="#Filter0Value#" delimiters=",">
				
					 <cfset sitm = replace(itm,"'","","ALL")>
				     <cfif flyfilter eq "">
					     <cfset flyfilter = "'#sitm#'">
					 <cfelse>
						 <cfset flyfilter = "#flyfilter#,'#sitm#'">
					 </cfif>	 
				</cfloop> 
					 
				<cfif flyfilter eq "">
				      <cfset flyfilter = "''">
				</cfif>
				
			    <cfset cond = replaceNoCase("#cond#", "@userid", "#SESSION.acc#" , "ALL")>
				 
				<cfif flyfilter neq "'all'">
					<cfset cond = replaceNoCase("#cond#", "@parent", "#flyfilter#" , "ALL")>
				<cfelse>
					<cfset cond = replaceNoCase("#cond#", "IN (@parent)", "NOT IN ('')" , "ALL")>
				</cfif>	
				
			</cfif>					 
			
			<!--- filter1 --->
							
			<cfset filter1 = "">	
									
			<cfloop index="itm" list="#Filter1Value#" delimiters=",">
			     <cfif filter1 eq "">
				     <cfset filter1 = "'#itm#'">
				 <cfelse>
					 <cfset filter1 = "#filter1#,'#itm#'">
				 </cfif>	 
			 </cfloop> 
					 
			 <cfif filter1 eq "">
			      <cfset filter1 = "''">
			 </cfif>			
			
			<!--- filter2 --->
					
			<cfset filter2 = "">	
								
			<cfloop index="itm" list="#Filter2Value#" delimiters=",">
			     <cfif filter2 eq "">
				     <cfset filter2 = "'#itm#'">
				 <cfelse>
					 <cfset filter2 = "#filter2#,'#itm#'">
				 </cfif>	 
			 </cfloop> 
					 
			 <cfif filter2 eq "">
			      <cfset filter2 = "''">
			 </cfif>	
						
			<!--- ------- --->						
			<!--- TESTING --->	
			<!--- ------- --->	
			
			<!---
			
									
				<cfoutput>
				<cfsavecontent variable="testme">


						 SELECT DISTINCT 
					         'Selected' as Type,
					         #FieldKeyReturn# as PK, 
					         #FieldKey# as PKey, 
							 #FieldSort# as Sort,					         
					  		 <cfif fieldKey neq FieldName>
							 	<cfif CodeInDisplay eq "1">
								 #FieldKey#+' '+#FieldName# as Name 
								 <cfelse>
								 #FieldName# as Name 
								 </cfif>
							 <cfelse>
							 #FieldName# as Name   
							 </cfif>
				      FROM #Table#				  
					  WHERE 1=1					  			 				 
					  <cfif cond gte "">				  
						 #preservesingleQuotes(cond)#
					  </cfif>
					  <cfif Filter1Field neq "">		 
						 AND #Filter1Field# IN (#preservesinglequotes(Filter1)#)	
					  </cfif>						 				  				 
					  <cfif Filter2Field neq "">						  		  
						  <cfif Filter2Field neq "ParentOrgUnit">
						  	  AND #Filter2Field# IN (#preservesingleQuotes(Filter2)#)	
						  <cfelse>
						      AND ParentOrgUnit IN (SELECT OrgUnitCode 
							                        FROM Organization.dbo.Organization 
													WHERE OrgUnit = '#Filter2Value#')	  
						  </cfif>						  
					  </cfif>	
					 							 			 				  
					  AND #FieldKeyReturn# IN (#preservesinglequotes(select)#) 					  				  					  
					 
					  UNION ALL
					  
				      SELECT DISTINCT 
					         'Xtended' as Type,
					         #FieldKeyReturn# as PK, 
					         #FieldKey# as PKey, 
							 #FieldSort# as Sort,					         
					  		 <cfif fieldKey neq FieldName>
							 	<cfif CodeInDisplay eq "1">
								 #FieldKey#+' '+#FieldName# as Name 
								<cfelse>
								 #FieldName# as Name 
								</cfif>
							 <cfelse>
							 #FieldName# as Name   
							 </cfif>
				      FROM #Table#				  
					  WHERE 1=1					  			 				 
					  <cfif cond gte "">				  
						 #preservesingleQuotes(cond)#
					  </cfif>
					  <cfif Filter1Field neq "">		 
						 AND #Filter1Field# IN (#preservesinglequotes(Filter1)#)	
					  </cfif>						 				  				 
					  <cfif Filter2Field neq "">						  		  
						  <cfif Filter2Field neq "ParentOrgUnit">
						  	  AND #Filter2Field# IN (#preservesingleQuotes(Filter2)#)	
						  <cfelse>
						      AND ParentOrgUnit IN (SELECT OrgUnitCode 
							                        FROM Organization.dbo.Organization 
													WHERE OrgUnit = '#Filter2Value#')	  
						  </cfif>						  
					  </cfif>	
					  
					  AND #FieldKeyReturn# NOT IN (#preservesinglequotes(select)#)		
					  
					  ORDER BY Type, #FieldSort#						
				 </cfsavecontent>
				 </cfoutput>
				 
				<cffile action="WRITE" 
				file="#SESSION.rootpath#/#fieldname#.txt" 
				output="#testme#" 
				addnewline="Yes" 
				fixnewline="No">  	
				
				--->				  
				
							
			 <!--- selected values --->		
			 
			<cfquery name="Values" datasource="#DataSource#">
			
				      SELECT DISTINCT 
					         'Selected' as Type,
					         #FieldKeyReturn# as PK, 
					         #FieldKey# as PKey, 
							 #FieldSort# as Sort,					         
					  		 <cfif fieldKey neq FieldName>
							 	<cfif CodeInDisplay eq "1">
								 #FieldKey#+' '+#FieldName# as Name 
								 <cfelse>
								 #FieldName# as Name 
								 </cfif>
							 <cfelse>
							 #FieldName# as Name   
							 </cfif>
				      FROM #Table#				  
					  WHERE 1=1					  			 				 
					  <cfif cond gte "">				  
						 #preservesingleQuotes(cond)#
					  </cfif>
					  <cfif Filter1Field neq "" and Filter1Field neq "null">		 
						 AND #Filter1Field# IN (#preservesinglequotes(Filter1)#)	
					  </cfif>						 				  				 
					  <cfif Filter2Field neq "" and Filter2Field neq "null">						  		  
						  <cfif Filter2Field neq "ParentOrgUnit">
						  	  AND #Filter2Field# IN (#preservesingleQuotes(Filter2)#)	
						  <cfelse>
						      AND ParentOrgUnit IN (SELECT OrgUnitCode 
							                        FROM Organization.dbo.Organization 
													WHERE OrgUnit = '#Filter2Value#')	  
						  </cfif>						  
					  </cfif>	
					 							 			 				  
					  AND #FieldKeyReturn# IN (#preservesinglequotes(select)#) 					  				  					  
					 
					  UNION ALL
					  
				      SELECT DISTINCT 
					         'Xtended' as Type,
					         #FieldKeyReturn# as PK, 
					         #FieldKey# as PKey, 
							 #FieldSort# as Sort,					         
					  		 <cfif fieldKey neq FieldName>
							 	<cfif CodeInDisplay eq "1">
								 #FieldKey#+' '+#FieldName# as Name 
								<cfelse>
								 #FieldName# as Name 
								</cfif>
							 <cfelse>
							 #FieldName# as Name   
							 </cfif>
				      FROM #Table#				  
					  WHERE 1=1					  			 				 
					  <cfif cond gte "">				  
						 #preservesingleQuotes(cond)#
					  </cfif>
					  <cfif Filter1Field neq "" and Filter1Field neq "null">		 
						 AND #Filter1Field# IN (#preservesinglequotes(Filter1)#)	
					  </cfif>						 				  				 
					  <cfif Filter2Field neq "" and Filter2Field neq "null">						  		  
						  <cfif Filter2Field neq "ParentOrgUnit">
						  	  AND #Filter2Field# IN (#preservesingleQuotes(Filter2)#)	
						  <cfelse>
						      AND ParentOrgUnit IN (SELECT OrgUnitCode 
							                        FROM Organization.dbo.Organization 
													WHERE OrgUnit = '#Filter2Value#')	  
						  </cfif>						  
					  </cfif>	
					  
					  AND #FieldKeyReturn# NOT IN (#preservesinglequotes(select)#)		
					  
					  ORDER BY Type, #FieldSort#							 				  
			  </cfquery>	
			 			  
			  <cfset list = arraynew(2)>
			  
			  <cfif filter1field eq "" and multiple eq "no">			
			  			  		  
				  <cfset list[1][1]= "">
	       	      <cfset list[1][2]= "[select]">
				  <cfset list[1][3]= false>
				  
				  <cfset s = 1>		
			  
			  <cfelse>
			  
			      <cfset s = 0>	  			  
			   
			  </cfif> 
						  
			<!--- Convert results to array --->
	      	<cfloop index="i" from="1" to="#Values.RecordCount#">
			
			   	 <cfset list[i+s][1]= Values.PK[i]>
	        	 <cfset list[i+s][2]= Values.Name[i]>
				 <cfif Values.Type[i] eq "Selected">
					 <cfset list[i+s][3]= true>	
				 <cfelse>
					 <cfset list[i+s][3]= false>	
				 </cfif>
								 
	      	</cfloop>	
			
		
		<cfreturn list>	
		
	</cffunction>	
		
	<cffunction name="getlocation" access="remote" returntype="query" secureJSON = "yes" verifyClient = "yes">  
	
	 <cfargument name="warehouse" type="string" required="true" />  
	 <cfargument name="itemno" type="string" required="true" />  	 
		
	 <cfquery name="Location" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT TOP 1 '' as Description, '{00000000-0000-0000-0000-000000000000}' as StorageId
		    FROM   WarehouseLocation
			WHERE  Warehouse = '#Arguments.Warehouse#'			
		    UNION 
		    SELECT DISTINCT Description + ' ( ' + StorageCode + ' ) ' as Description, StorageId
		    FROM   WarehouseLocation D
			WHERE  Warehouse = '#Arguments.Warehouse#'
			<cfif itemno neq "">
			AND    Location IN (SELECT Location
			                    FROM   ItemWarehouseLocation
								WHERE  ItemNo    = '#Arguments.ItemNo#'
								AND    Warehouse = '#Arguments.Warehouse#'
								AND    Operational = 1
								AND    Location  = D.Location)								
			</cfif>					
			AND    Operational = 1		
			AND    StorageCode is not NULL		
		</cfquery>		

		<cfreturn Location />
	
	</cffunction> 
	
	<cffunction name="getStockRequestType" access="remote" returntype="query" secureJSON = "yes" verifyClient = "yes">  
	
	 <cfargument name="warehouse" type="string" required="true" />  
	 
	 		<cfquery name="RequestTypeList" 
					datasource="AppsMaterials" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT   Description,Code
						FROM     Ref_Request P
						WHERE    Operational = '1'	
						AND      Code IN (SELECT RequestType 
						                  FROM   Ref_RequestWorkflowWarehouse 
										  WHERE  Code      = P.Code 
										  AND    Warehouse = '#Arguments.warehouse#') 
						ORDER BY ListingOrder						
			</cfquery>
			
			<cfif RequestTypeList.recordcount eq "0">
			
				<cfquery name="RequestTypeList" 
						datasource="AppsMaterials" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							SELECT   Description,Code
							FROM     Ref_Request P
							WHERE    Operational = '1'							
							ORDER BY ListingOrder						
				</cfquery>
						
			</cfif>			
	
		<cfreturn RequestTypeList />
	
	</cffunction> 
	
</cfcomponent>	