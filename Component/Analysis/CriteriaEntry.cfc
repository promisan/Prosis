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
<cfcomponent name="Variant"> 

    <cffunction name="initDataSet" access="remote" returntype="query">
	
	  <cfargument name="controlid"  required="true"  type="string">
	  
	  <cfquery name="TableOutput" 
		datasource="appsSystem">
		SELECT   *
	    FROM     Ref_ReportControlOutput
		WHERE    ControlId = '#controlid#'  
		ORDER BY ListingOrder 
	  </cfquery>
	  
	  <cfif TableOutput.recordcount eq "0">
	  
		  <cfquery name="TableOutput" 
			datasource="appsSystem">
			SELECT   *
		    FROM     Ref_ReportControlOutput
			WHERE    OutputId = '#controlid#'
			ORDER BY ListingOrder 
		  </cfquery>
	  	  
	  </cfif>
	  
	  <cfif TableOutput.recordcount gte "1">
	     <cfset s = "#TableOutput.recordcount#">
	  <cfelse>
	     <cfset s = "1">
	  </cfif>
	  
	  <cfset dataset = queryNew("OutputId,OutputName,DataSource,TableName,Counted", "CF_SQL_VARCHAR, CF_SQL_VARCHAR,CF_SQL_VARCHAR,CF_SQL_VARCHAR,CF_SQL_VARCHAR")>
										
			<!--- add rows --->
		    			
			<cfif TableOutput.recordcount gte "1">
			
				<cfloop query="TableOutput">
				
				    <cfparam name="CLIENT.#variableName#_ds"  default="">
					<cfparam name="SESSION.#variableName#_ds" default="#evaluate('CLIENT.#VariableName#_ds')#">
					
					<cfif OutputClass eq "variable">
				   		 <cfset tbl = evaluate("SESSION.#VariableName#_ds")>
					<cfelse>
					   	 <cfset tbl = VariableName>
				  	</cfif>	
					
					<cfquery name="Check" 
						datasource="#DataSource#">
						SELECT  C.name
						FROM    sysobjects S INNER JOIN
			                    syscolumns C ON S.id = C.id
						WHERE   S.name = '#tbl#' 
						AND     (C.name = 'FactTableId' or c.name LIKE '%_dim') 
					</cfquery>
								
					<cfif tbl neq "" and check.recordcount gte "1">
					
					  <cfset queryaddrow(dataset, 1)>
					
					   <cfquery name="NoRecords" 
						datasource="#DataSource#">						
						SELECT   count(*) as Total  
					    FROM     #tbl#
				       </cfquery>
				   
				        <cfset cnt = "#NoRecords.Total#">
						
						<!--- set values in cells --->
						<cfset querysetcell(dataset, "OutputId", "#OutputId#", currentRow)>
						<cfset querysetcell(dataset, "OutputName", "#OutputName# (#cnt#)", currentRow)>
						<cfset querysetcell(dataset, "DataSource", "#DataSource#", currentRow)>
						<cfset querysetcell(dataset, "TableName", "#tbl#", currentRow)>
						<cfset querysetcell(dataset, "Counted", "#cnt#", currentRow)>
					
					</cfif>
						
				</cfloop>
			
			<cfelse>
			
			</cfif>
												
			<cfreturn dataset>
	
	</cffunction>

    <cffunction name="initInstance" access="remote">
	
	    <cfargument name="outputid"       required="true"  type="string">
		<cfargument name="ds"             required="true"  type="string">
		<cfargument name="table"          required="true"  type="string">
		
		<!--- set fieldnames for output --->
		
		<!--- populate output fields --->
		
		<cfquery name="fields" 
			datasource="#ds#">
				SELECT   C.name, 
				         C.usertype, 
						 systypes.name AS fieldtype, 
						 C.length
				FROM     sysobjects S INNER JOIN
			             syscolumns C ON S.id = C.id INNER JOIN
			             systypes ON C.xtype = systypes.xtype
			    WHERE    S.id = C.id
				AND      S.name = '#table#'
				AND      C.UserType NOT IN ('20','3','19','4') AND C.Name != 'FactTableid'
			    ORDER BY C.colid  
		</cfquery>
						
		<cfquery name="Param" 
		datasource="appsSystem">
			SELECT * FROM Parameter
		</cfquery>
			
		<cfquery name="Clean" 
		datasource="#ds#">
			DELETE FROM [#Param.DatabaseServer#].System.dbo.UserReportOutput
			WHERE  OutputId = '#OutputID#'
			AND   FieldName NOT IN 	(SELECT c.Name
									 FROM   sysobjects S, 
			        					    syscolumns C 
								     WHERE  S.id = C.id
									 AND    S.name = '#table#') 
			</cfquery>

			<cfset ord = 0>

			<cfoutput query="fields">

			<cfif find("_",name)>
			   <cfset output = 0>
			   <cfset order = "99">
			<cfelse>
			   <cfset output = 1> 
			   <cfset ord = ord+1>
			   <cfset order = ord>
		    </cfif>   
	
			<cftry> 
		
				<cfif findNoCase("_dim",name) or findNoCase("_nme",name) or findNoCase("_ord",name) or findNoCase("_frm",name)>
				  <cfset l = len(name)>		
				  <cfset head = left("#name#",l-4)>
				<cfelse>
				  <cfset head = name>  
				</cfif>  
				
				<cfquery name="Populate" 
					datasource="AppsSystem">
					INSERT INTO UserReportOutput
					(UserAccount,
					 OutputId,
					 OutputClass,
					 FieldName,
					 OutputFormat, 
					 OutputWidth, 
					 OutputEnabled,
					 FieldNameOrder,
					 OutputHeader)
					VALUES 
					('#SESSION.acc#',
					 '#outputid#',
					 'Detail',
					 '#name#',
					 '#fieldtype#',
					 '#length#',
					 '#output#',
					 '#order#',
					 '#head#') 
				</cfquery>
						
				<cfcatch></cfcatch>
				
				</cftry>
					
		</cfoutput>	
				
		<!--- create instance --->
		
		<cfquery name="Check" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT * FROM UserPivot
			WHERE  Account   = '#SESSION.acc#'
		  	   AND OutputId  = '#OutputId#' 
		</cfquery>
		
		<cfloop query="Check">
		
			<!--- drop old tables --->
			<CF_DropTable dbName="#DataSource#"  tblName="#TableName#_CrossTabData"> 
			<CF_DropTable dbName="#DataSource#"  tblName="#TableName#_Summary"> 
			<CF_DropTable dbName="#DataSource#"  tblName="#TableName#_Summary_Detail"> 
		
		</cfloop>
		
		<cfquery name="InsertInstance" 
					datasource="appsSystem">
					DELETE FROM UserPivot
					WHERE  OutputId = '#OutputId#' 
					AND    Account = '#SESSION.acc#'
										
		</cfquery>
		
		<cfset FileNo = round(Rand()*20)>
		
		<cfloop index="Node" from="1" to="3">
		
			<cf_assignId>
			
			<cfquery name="InsertInstance" 
					datasource="appsSystem">
					INSERT INTO UserPivot
			        (ControlId, Account, OutputId, Node, Datasource, FileNo, TableName)
			        VALUES
				    ('#rowguid#','#SESSION.acc#','#outputid#','#Node#','#ds#','#FileNo#','#SESSION.acc#_#fileNo#_#Node#')
			</cfquery>
							
		</cfloop>	
		
	</cffunction>
	
	<!--- DIMENSION --->

    <cffunction name="initDimension" access="remote" returnType="struct">

        <cfargument name="ds"    required="true"  default="userquery"                 type="string">
		<cfargument name="table" required="true"  default="dbo.administratorPosition" type="string">
		
		<cfset dimensioninfo = structNew()>
				
			<cfquery name="fields" 
				datasource="#ds#">				
				SELECT   C.name, 
				         C.usertype, 
						 systypes.name AS fieldtype,
						 C.length,
						 0 as counted
				FROM     sysobjects S INNER JOIN
			             syscolumns C ON S.id = C.id INNER JOIN
			             systypes ON C.xtype = systypes.xtype
			    WHERE    S.id = C.id
				AND      S.name = '#table#'	
				AND      C.UserType NOT IN ('0','20','3','19','4') 
			    ORDER BY C.colid 
			</cfquery>
				
		    <cfset qry = "">
						
			<cfloop query="fields">
			
			    <cfif findnocase("_dim",name)>
			
					<cfif qry neq ""> 
						<cfset qry = "#qry# UNION ">
					</cfif>
					<cfset qry = "#qry# SELECT '#name#' as Name, '#length#' as Length, '#usertype#' as UserType, '#fieldtype#' as FieldType, COUNT(DISTINCT #Name#) AS Counted FROM #table#">
							
				</cfif>
					
			</cfloop>
						
			<cfquery name="dim" 
			datasource="#ds#"
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    #preserveSingleQuotes(qry)#				
				ORDER BY Name <!--- Counted --->
			</cfquery>
			
			<cfset Dimension = queryNew("Name,Display,Counted", "CF_SQL_VARCHAR, CF_SQL_VARCHAR,CF_SQL_VARCHAR")>
			
			<!--- add rows --->
		    <cfset queryaddrow(Dimension, dim.recordcount)>
			
			<cfloop query="dim">
							
				<cfif findNoCase("_dim",name)>
			      <cfset l = #len(name)#>		
			      <cfset head = left("#name#",l-4)>
			    <cfelse>
	    		  <cfset head = name>  
		    	</cfif>  
					
				<!--- set values in cells --->
				<cfset querysetcell(Dimension, "Name", "#name#", currentRow)>
				<cfset querysetcell(Dimension, "Display", "#head# (#counted#)", currentRow)>
				<cfset querysetcell(Dimension, "Counted", "#counted#", currentRow)>
			
			</cfloop>
			
			<cfset StructInsert(dimensioninfo, "RowColumns", "#dimension#")>
			
			<!--- 2 cell formulas --->
			
			<cfquery name="fields" 
				datasource="#ds#">				
				SELECT   C.name, 
				         C.usertype, 
						 systypes.name AS fieldtype,
						 C.length
				FROM     sysobjects S INNER JOIN
			             syscolumns C ON S.id = C.id INNER JOIN
			             systypes ON C.xtype = systypes.xtype
			    WHERE    S.id = C.id
				AND      S.name = '#table#'	 
				AND      ((C.UserType >= '7' and C.userType <= '11') or C.UserType = '24')
				AND      C.Name NOT LIKE '%_ord' 
			    ORDER BY C.name  
			</cfquery>
			
			<cfif fields.recordcount eq "0">
			
			    <cfset StructInsert(dimensioninfo, "CellColumns", "")>
			
			<cfelse>
					
				<cfset Cellcols = queryNew("Name,Display", "CF_SQL_VARCHAR, CF_SQL_VARCHAR")>
														
				<cfset queryaddrow(Cellcols, fields.recordcount)>
										
				<cfloop query="fields">
					
					<cfif findNoCase("_dim",name)>
				      <cfset l = len(name)>		
				      <cfset head = left("#name#",l-4)>
				    <cfelse>
		    		  <cfset head = name>  
			    	</cfif>  
						
					<!--- set values in cells --->
					<cfset querysetcell(Cellcols, "Name", "#name#", currentRow)>
					<cfset querysetcell(Cellcols, "Display", "#head#", currentRow)>
								
				</cfloop>
													
				<cfset StructInsert(dimensioninfo, "CellColumns", "#cellcols#")>
			
			</cfif>
						
			<!--- 3 cell formula --->
			
			<cfset Formula = queryNew("Name,Display,Label", "CF_SQL_VARCHAR,CF_SQL_VARCHAR,CF_SQL_VARCHAR")>
			
				<cfif fields.recordcount eq "0">
				
					<cfset queryaddrow(Formula, 1)>				
								
					<!--- set values in cells --->
					<cfset querysetcell(Formula, "Name", "COUNT", 1)>
					<cfset querysetcell(Formula, "Display", "COUNT (Records)", 1)>
					<cfset querysetcell(Formula, "Label", "Counted", 1)>						
				
				<cfelse>
					   				
					<cfset queryaddrow(Formula, 8)>				
								
					<!--- set values in cells --->
					<cfset querysetcell(Formula, "Name", "COUNT", 1)>
					<cfset querysetcell(Formula, "Display", "COUNT (Records)", 1)>
					<cfset querysetcell(Formula, "Label", "Counted", 1)>		
					
					<!--- set values in cells --->
					<cfset querysetcell(Formula, "Name", "DISTINCT", 2)>
					<cfset querysetcell(Formula, "Display", "DISTINCT (Field)", 2)>
					<cfset querysetcell(Formula, "Label", "Counted", 2)>				
						
					<!--- set values in cells --->
					<cfset querysetcell(Formula, "Name", "SUM", 3)>
					<cfset querysetcell(Formula, "Display", "SUM (Total value)", 3)>
					<cfset querysetcell(Formula, "Label", "Total", 3)>													
									
					<!--- set values in cells --->
					<cfset querysetcell(Formula, "Name", "MIN", 4)>
					<cfset querysetcell(Formula, "Display", "MIN (Minimum value)", 4)>
					<cfset querysetcell(Formula, "Label", "Minimum", 4)>
					
					<!--- set values in cells --->
					<cfset querysetcell(Formula, "Name", "MAX", 5)>
					<cfset querysetcell(Formula, "Display", "MAX (Maximum value)", 5)>
					<cfset querysetcell(Formula, "Label", "Maximum", 5)>
					
					<!--- set values in cells --->
					<cfset querysetcell(Formula, "Name", "AVG", 6)>
					<cfset querysetcell(Formula, "Display", "AVG (Average value)", 6)>
					<cfset querysetcell(Formula, "Label", "Average", 6)>			
					<!--- set values in cells --->
					<cfset querysetcell(Formula, "Name", "VAR", 7)>
					<cfset querysetcell(Formula, "Display", "VAR (Variance)", 7)>
					<cfset querysetcell(Formula, "Label", "Variance", 7)>
					
					<!--- set values in cells --->
					<cfset querysetcell(Formula, "Name", "STDEV", 8)>
					<cfset querysetcell(Formula, "Display", "STD (Standard deviation)", 8)>
					<cfset querysetcell(Formula, "Label", "Std", 8)>
					
				</cfif>	
											
			<cfset StructInsert(dimensioninfo, "CellFormula", "#formula#")>
			
			<!--- 4 cell formatting --->
			
			<cfset format = queryNew("Name,Display", "CF_SQL_VARCHAR, CF_SQL_VARCHAR")>
					   				
				<cfset queryaddrow(format, 5)>
											
				<!--- set values in cells --->
				<cfset querysetcell(format, "Name", "Amount0", 1)>
				<cfset querysetcell(format, "Display", "Number (0.000)", 1)>
				
				<!--- set values in cells --->
				<cfset querysetcell(format, "Name", "Amount2", 2)>
				<cfset querysetcell(format, "Display", "Amount (0.000,00)", 2)>
				
				<!--- set values in cells --->
				<cfset querysetcell(format, "Name", "Integer", 3)>
				<cfset querysetcell(format, "Display", "Integer (0000)", 3)>
				
				<!--- set values in cells --->
				<cfset querysetcell(format, "Name", "Currency", 4)>
				<cfset querysetcell(format, "Display", "Currency (USD)", 4)>
				
				<!--- set values in cells --->
				<cfset querysetcell(format, "Name", "Percentage", 5)>
				<cfset querysetcell(format, "Display", "Percentage (%)", 5)>
				
			<cfset StructInsert(dimensioninfo, "CellFormat", "#format#")>	
														
			<cfreturn dimensioninfo>
			
	</cffunction>
	
			
	<cffunction name="saveDimension" access="remote" returnType="query">
	
	    <cfargument name="outputid"        required="true"  type="string">
		<cfargument name="node"            required="true"  type="string">
		<cfargument name="fieldname"       required="true"  type="string">
		
		<!--- check contents sofar --->
		
		<cfquery name="Control" 
			datasource="appsSystem">
			SELECT * 
			FROM UserPivot 
			WHERE OutputId = '#outputid#'
			AND   Node     = '#node#'
			AND   Account  = '#SESSION.acc#'
		</cfquery>
		
		<cfquery name="Exist" 
			datasource="appsSystem">
			SELECT *
			FROM   UserPivotDimension
			WHERE  ControlId = '#Control.ControlId#'	
			AND    Presentation IN ('Y-ax','Grouping1','Grouping2','Grouping3')
			AND    FieldName = '#fieldname#'
			ORDER BY ListingOrder
	    </cfquery>	  
				
		<cfif Exist.recordcount eq "0">
			  
			<cfquery name="Check" 
				datasource="appsSystem">
				SELECT *
				FROM   UserPivotDimension
				WHERE  ControlId = '#Control.ControlId#'	
				AND    Presentation IN ('Y-ax','Grouping1','Grouping2','Grouping3')
				ORDER BY ListingOrder
			</cfquery>	  
			
			<!--- allow dimensions to be selected --->
			
			<cfif Check.recordcount lte "3">
			
				<cfloop query="Check">
				
					<cfquery name="UpdateField" 
						datasource="appsSystem">
						UPDATE UserPivotDimension
						SET Presentation   = 'Grouping#currentrow#'
						WHERE  ControlId   = '#Control.ControlId#'	
						AND   ListingOrder = '#Check.ListingOrder#'	
					</cfquery>
				
				</cfloop>
					
				<cftry>	
					<cfif fieldname neq "">
					<cfquery name="InsertField" 
						datasource="appsSystem">
						INSERT INTO UserPivotDimension
					       (ControlId, Presentation, FieldName,ListingOrder)
					       VALUES
					       ('#Control.ControlId#', 'Y-ax','#fieldname#','#check.recordcount+1#')
					</cfquery>
					</cfif>
				<cfcatch></cfcatch>
				</cftry>		
			
			</cfif>
			
			<!--- the last one entered is always the Y, correct the listing --->
		
			<cfquery name="List" 
				datasource="appsSystem">
				SELECT *
				FROM   UserPivotDimension
				WHERE  ControlId = '#Control.ControlId#'						
				ORDER BY ListingOrder
		    </cfquery>	  
			
			<cfloop query = "List">		
							 		  				
				<cfquery name="UpdateField" 
					datasource="appsSystem">
					UPDATE UserPivotDimension
					<cfif currentrow neq recordcount>
					SET    Presentation = 'Grouping#currentrow#'
					<cfelse>
					SET    Presentation = 'Y-ax'
					</cfif>
					WHERE  ControlId    = '#Control.ControlId#'	
					AND    ListingOrder = '#ListingOrder#'	
				</cfquery>
									
			</cfloop>
			 
			<cfquery name="List" 
				datasource="appsSystem">
				SELECT *
				FROM   UserPivotDimension
				WHERE  ControlId = '#Control.ControlId#'						
				ORDER BY ListingOrder
		    </cfquery>	  
			
			<cfloop query="List">
			
				<cfquery name="Update" 
					datasource="appsSystem">
					UPDATE UserPivotDimension
					SET    ListingOrder  = '#currentrow#'
					WHERE  ControlId     = '#Control.ControlId#'	
					AND    Presentation  = '#Presentation#'				
			    </cfquery>			
			
			</cfloop>
		
		</cfif>
		
		<cfquery name="Dim" 
			datasource="appsSystem">
			SELECT   FieldName as name
			FROM     UserPivotDimension
			WHERE    ControlId = '#Control.ControlId#'	
			AND      Presentation IN ('Y-ax','Grouping1','Grouping2','Grouping3','Grouping4')
			ORDER BY ListingOrder
		</cfquery>
		
		<cfset Dimension = queryNew("Display", "CF_SQL_VARCHAR")>
							
			<!--- add rows --->
		    <cfset queryaddrow(Dimension, dim.recordcount)>
			
			<cfloop query="dim">
				
				<cfif findNoCase("_dim",name)>
			      <cfset l = len(name)>		
			      <cfset head = left("#name#",l-4)>
			    <cfelse>
	    		  <cfset head = name>  
		    	</cfif>  
					
				<!--- set values in cells --->
				<cfset querysetcell(Dimension, "Display", "#head#", currentRow)>
			
			</cfloop>
									
			<cfreturn Dimension>
		
				
	</cffunction>
	
	<cffunction name="delDimension" access="remote" returnType="query">
	
	    <cfargument name="outputid"        required="true"  type="string">
		<cfargument name="node"            required="true"  type="string">
		<cfargument name="fieldname"       required="true"  type="string">
		
		<!--- check contents sofar --->
					
		<cfquery name="Control" 
			datasource="appsSystem">
			SELECT * 
			FROM UserPivot 
			WHERE OutputId = '#outputid#'
			AND   Node     = '#node#' 
			AND   Account  = '#SESSION.acc#'
		</cfquery>
		
		<!--- remove entry --->
		
		<cfquery name="Delete" 
			datasource="appsSystem">
			DELETE FROM UserPivotDimension 
			WHERE  ControlId = '#Control.ControlId#'
			AND    FieldName IN ('#fieldname#','#fieldname#_dim')
		</cfquery>
		
		<!--- reorder the presentation layers --->
		
		<cfquery name="Select" 
			datasource="appsSystem">
			SELECT   * 
			FROM     UserPivotDimension 
			WHERE    ControlId = '#Control.ControlId#'
			AND      Presentation IN ('Y-ax','Grouping1','Grouping2','Grouping3','Grouping4')		
			ORDER BY ListingOrder
		</cfquery>
									
		<cfloop query = "select">		
						 		  				
			<cfquery name="UpdateField" 
				datasource="appsSystem">
				UPDATE UserPivotDimension
				<cfif currentrow neq recordcount>
				SET    Presentation = 'Grouping#currentrow#'
				<cfelse>
				SET    Presentation = 'Y-ax'
				</cfif>
				WHERE  ControlId    = '#Control.ControlId#'	
				AND    ListingOrder = '#ListingOrder#'	
			</cfquery>
								
		 </cfloop>
		 
		 <cfquery name="Select" 
			datasource="appsSystem">
			SELECT   * 
			FROM     UserPivotDimension 
			WHERE    ControlId = '#Control.ControlId#'
			AND      Presentation IN ('Y-ax','Grouping1','Grouping2','Grouping3','Grouping4')		
			ORDER BY ListingOrder
		</cfquery>
		 
		 <cfloop query="Select">
		
			<cfquery name="Update" 
				datasource="appsSystem">
				UPDATE UserPivotDimension
				SET    ListingOrder  = '#currentrow#'
				WHERE  ControlId     = '#Control.ControlId#'	
				AND    Presentation  = '#Presentation#'				
		    </cfquery>			
		
		</cfloop>
		 
		 <!--- render result set again --->
				
		<cfquery name="Dim" 
			datasource="appsSystem">
			SELECT FieldName as name
			FROM   UserPivotDimension
			WHERE  ControlId = '#Control.ControlId#'	
			AND    Presentation IN ('Y-ax','Grouping1','Grouping2','Grouping3','Grouping4')
			ORDER BY ListingOrder
		</cfquery>
		
		<cfif dim.recordcount eq "0">
		
		    <cfreturn Dim>
		
		<cfelse>
		
			<cfset Dimension = queryNew("Display", "CF_SQL_VARCHAR")>
							
			<!--- add rows --->
		    <cfset queryaddrow(Dimension, dim.recordcount)>
			
			<cfloop query="dim">
				
				<cfif findNoCase("_dim",name)>
			      <cfset l = #len(name)#>		
			      <cfset head = left("#name#",l-4)>
			    <cfelse>
	    		  <cfset head = name>  
		    	</cfif>  
					
				<!--- set values in cells --->
				<cfset querysetcell(Dimension, "Display", "#head#", currentRow)>
			
			</cfloop>
			
			<cfreturn Dimension>
			
		</cfif>	
				
	</cffunction>
		
	<!--- VARIANT --->
	
	<cffunction name="getVariant" access="remote" returnType="query">
	
	<cfargument name="outputId" required="true" type="string">
				
	<!--- run query once --->
	<cfquery name="VariantList" 
	    datasource="appsSystem">
		SELECT  Description, AccessMode,OutputFormat,SettingId, 
		         convert(varchar,S.Created,3) as Created, 
		         U.FirstName + ' '+ U.LastName as Name
		FROM UserViewSetting S, UserNames U
		WHERE U.Account = S.Account
		AND   S.OutputId = '#outputId#'
		AND   (S.Account = '#SESSION.acc#' or S.AccessMode != 'Personal')
		ORDER BY S.Created DESC 
	</cfquery>
	
	<cfreturn VariantList>
		
	</cffunction>
	
	<cffunction name="delVariant" output="false" access="remote" returntype="query">
	
		<cfargument name="outputId" required="true" type="string">
		<cfargument name="settingid" required="true" type="string">
		
		<cfquery name="qDelete" datasource="AppsSystem">
			DELETE FROM dbo.UserViewSetting
			WHERE  SettingId = '#settingid#'
		</cfquery>
		
		<!--- run query once --->
		<cfquery name="VariantList" 
	    datasource="appsSystem">
		SELECT   Description, AccessMode,OutputFormat,SettingId, 
		         convert(varchar,S.Created,3) as Created, 
		         U.FirstName + ' '+ U.LastName as Name
		FROM     UserViewSetting S, UserNames U
		WHERE    U.Account = S.Account
		AND      S.OutputId = '#outputId#'
		AND      (S.Account = '#SESSION.acc#' or S.AccessMode != 'Personal')
		ORDER BY S.Created DESC
		</cfquery>
	
	  <cfreturn VariantList>

	</cffunction>
	
	<cffunction name="save" output="false" access="remote" returntype="void">
		<cfargument name="variantname" required="true" type="string">
		<cfargument name="variantaccess" required="true" type="string">
				
		<cf_AssignId>
	
		<cfquery name="Pivot" 
		 datasource="appsSystem" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
		 SELECT TOP 1 * FROM UserPivot
    	</cfquery>
		
		<cfquery name="Insert" 
		 datasource="appsSystem" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
		 INSERT INTO UserViewSetting
		 (SettingId,Account,OutputId,OutputFormat,Description,AccessMode) 
		 VALUES
		 ('#rowguid#','#SESSION.acc#','#Pivot.OutputId#','Pivot','#VariantName#','#VariantAccess#')
		</cfquery>
		
	</cffunction>	
	
	<cffunction name="saveSetting" access="remote">
	
	 <cfargument name="outputid"      required="true"  type="string">
	 <cfargument name="variantname"    required="true"  type="string">
	 <cfargument name="variantaccess"  required="true"  type="string">
	
		<!--- disabled to other section --->

		<cf_AssignId>
	
		<cftransaction>
			
		<cfquery name="Insert" 
		 datasource="appsSystem">		 
		 INSERT INTO UserViewSetting
		 (SettingId,Account,OutputId,OutputFormat,Description,AccessMode)
		 VALUES 
		 ('#rowguid#','#SESSION.acc#','#OutputId#','Pivot','#VariantName#','#VariantAccess#')		 
		</cfquery>
			
		<!--- save fields/dimensions --->
		
		<cfquery name="Insert" 
		 datasource="appsSystem">
		 INSERT INTO UserViewSettingDetail
		             (SettingId,Node,Presentation,PresentationOrder,FieldName,FieldValue,FieldHeader,FieldFormat,FieldOrder)
			SELECT   '#rowguid#', 
			         Pvt.Node, 
			         PvD.Presentation, 
					 MAX(Pvd.PresentationOrder),
					 PvD.FieldName, 
					 MAX(Pvd.FieldValue),
					 PvD.FieldHeader, 
					 MAX(PvD.FieldDataType), 
					 MAX(PvD.ListingOrder) as ListingOrder
			FROM     UserPivotDetail PvD INNER JOIN
	                 UserPivot Pvt ON PvD.ControlId = Pvt.ControlId
			WHERE    Pvt.OutputId = '#OutputId#' 
			AND      Pvt.Account = '#SESSION.acc#'			
			AND      Pvt.Node < 90		
			GROUP BY Pvt.Node, 
			         PvD.Presentation, 					
					 PvD.FieldName, 					
					 PvD.FieldHeader
		</cfquery>
		
		<!--- save filters --->
			 
		  <cfquery name="InsertDetail" 
		 datasource="appsSystem">
		 INSERT INTO UserViewSettingFilter
				(SettingId,FilterSerialNo,FilterMode,FieldName,FilterOperator,FilterValue)
				
		 SELECT  DISTINCT '#rowguid#',
			      FilterSerialNo, 
			      FilterMode,
				  FieldName,
				  FilterOperator,
				  FilterValue
		 FROM    UserPivotFilter PvD 
		 WHERE   Pvd.ControlId IN (SELECT ControlId FROM UserPivot WHERE Account = '#SESSION.acc#' and OutputId = '#OutputId#')
		 </cfquery>
				 
		 </cftransaction>

	</cffunction>
	
	<cffunction name="lookupmode" access="remote" returnType="query">
		<cfset myquery = queryNew("mode", "CF_SQL_VARCHAR")>

		<!--- add rows --->
		<cfset queryaddrow(myquery, 3)>

		<!--- set values in cells --->
		<cfset querysetcell(myquery, "mode", "Personal", 1)>
		<cfset querysetcell(myquery, "mode", "Public", 2)>
		<cfset querysetcell(myquery, "mode", "Global", 3)>
		
   		<cfreturn myquery>
		
	</cffunction>
	
	<!--- FILTER SHOW --->
	
	<cffunction name="criteriaField" access="remote" returnType="query">
	
	    <cfargument name="ds"    required="true"  default="userquery"                 type="string">
		<cfargument name="table" required="true"  default="dbo.administratorPosition" type="string">
				
		<cfquery name="fields" 
			datasource="#ds#">
			SELECT   DISTINCT '--select--' as name, 0 as colid
			UNION
			SELECT   DISTINCT C.name, colid
			FROM     sysobjects S INNER JOIN
		             syscolumns C ON S.id = C.id INNER JOIN
		             systypes ON C.xtype = systypes.xtype
		    WHERE    S.id = C.id
			AND      S.name = '#table#'	
			AND      C.UserType NOT IN ('0','20','3','19','4') 
			<!---
			AND      C.Name NOT LIKE '%_nme' 
			--->
			AND      C.Name NOT LIKE '%_ord'
		    ORDER BY colid  
		</cfquery>
		
		<cfset Dimension = queryNew("Name,Display", "CF_SQL_VARCHAR, CF_SQL_VARCHAR")>
							
			<!--- add rows --->
		    <cfset queryaddrow(Dimension, fields.recordcount)>
			
			<cfloop query="fields">
				
				<cfif findNoCase("_dim",name)>
			      <cfset l = #len(name)#>		
			      <cfset head = left("#name#",l-4)>
				<cfelseif findNoCase("_nme",name)>
			      <cfset l = #len(name)#>		
			      <cfset head = left("#name#",l-4)>	
			      <cfset head = "#head# Name">  
			    <cfelse>
	    		  <cfset head = name>  
		    	</cfif>  
					
				<!--- set values in cells --->
				<cfset querysetcell(Dimension, "Name", "#name#", currentRow)>
				<cfset querysetcell(Dimension, "Display", "#head#", currentRow)>
			
			</cfloop>
			
			<cfreturn Dimension>
				
	</cffunction>
	
	<cffunction name="criteriaValue" access="remote" returnType="query">
	
		<cfargument name="outputid"  required="true"  type="string">
	    <cfargument name="ds"    required="true"  default="userquery"                 type="string">
		<cfargument name="table" required="true"  default="dbo.administratorPosition" type="string">
		<cfargument name="field" required="true"  default="FunctionName" type="string">		
		
		<cfquery name="output" 
			 datasource="appsSystem">
					SELECT  TOP 1 OutputFormat
					FROM    UserReportOutput
					WHERE   UserAccount = '#SESSION.acc#'
					AND     OutputId    = '#OutputId#'
					AND     FieldName   = '#field#' 
			</cfquery>		
			
			 <cfif output.OutputFormat eq "DateTime" or output.OutputFormat eq "SmallDateTime">
				   <cfset v = "convert(varchar,#Field#,112)"> 
			   <cfelse>
			       <cfset v = "#Field#">
			   </cfif>
		
		<cfif field eq "--select--">
		
			<cfset fields = queryNew("fields", "CF_SQL_VARCHAR")>
			<cfset queryaddrow(fields, 1)>
		
		<cfelse>
				
				<cfif output.OutputFormat eq "float">
					<cfset frm = "int">
				<cfelse>
				    <cfset frm = output.OutputFormat>	
				</cfif>
		
				<cfquery name="fields" 
					datasource="#ds#">
					SELECT   DISTINCT TOP 1000 
							   #v# as FieldValue, 
			                  '#frm#' as Format 
							  
					FROM     #table#
					WHERE #field# <> '' and #field# is not NULL
				    ORDER BY FieldValue 
				</cfquery>			
		
		</cfif>
		
		<cfreturn fields>
		
	</cffunction>
	
	<cffunction name="criteriaOperator" access="remote" returnType="query">
		<cfset operator = queryNew("name, display", "CF_SQL_VARCHAR, CF_SQL_VARCHAR")>
		
		<!--- add rows --->
		<cfset queryaddrow(operator, 8)>
		
		<!--- set values in cells --->
		<cfset querysetcell(operator, "name", "CONTAINS", 1)>
		<cfset querysetcell(operator, "name", "BEGINS_WITH", 2)>
		<cfset querysetcell(operator, "name", "ENDS_WITH", 3)>
		<cfset querysetcell(operator, "name", "IS", 4)>
		<cfset querysetcell(operator, "name", "IS_NOT", 5)>
		<cfset querysetcell(operator, "name", "GREATER_THAN", 6)>
		<cfset querysetcell(operator, "name", "SMALLER_THAN", 7)>
		<cfset querysetcell(operator, "name", "IN", 8)>
		<cfset querysetcell(operator, "display", "contains", 1)>
		<cfset querysetcell(operator, "display", "begins with", 2)>
		<cfset querysetcell(operator, "display", "ends with", 3)>
		<cfset querysetcell(operator, "display", "is", 4)>
		<cfset querysetcell(operator, "display", "not equal", 5)>
		<cfset querysetcell(operator, "display", "more than", 6)>
		<cfset querysetcell(operator, "display", "less than", 7)>
		<cfset querysetcell(operator, "display", "in", 8)>
   		<cfreturn operator>
		
	</cffunction>
	
	<!--- FILTER OUTPUT SHOW --->
	
	<cffunction name="outputFilterField" access="remote" returnType="query">
		<cfset outputfilter = queryNew("Name, Display", "CF_SQL_VARCHAR, CF_SQL_VARCHAR")>
		
		<!--- add rows --->
		<cfset queryaddrow(outputfilter, 3)>
		
		<!--- set values in cells --->
		<cfset querysetcell(outputfilter, "Name", "N/A", 1)>
		<cfset querysetcell(outputfilter, "Name", "Top", 2)>
		<cfset querysetcell(outputfilter, "Name", "Bottom", 3)>
		<cfset querysetcell(outputfilter, "Display", "N/A", 1)>
		<cfset querysetcell(outputfilter, "Display", "TOP", 2)>
		<cfset querysetcell(outputfilter, "Display", "BOTTOM", 3)>
		
   		<cfreturn outputfilter>
		
	</cffunction>
	
	
	<!--- DATA FILTER table --->
		
	
	<cffunction name="filterSave" access="remote">
	
	    <cfargument name="outputid"        required="true"  type="string">
		<cfargument name="fieldname"       required="true"  type="string">
		<cfargument name="filteroperator"  required="true"  type="string">
		<cfargument name="filtervalues"    required="true"  type="array">
		
		<cfquery name="Control" 
			 datasource="appsSystem" 
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
			 SELECT *
			 FROM   UserPivot
			 WHERE  OutputId = '#outputid#'
			 AND    Account = '#SESSION.acc#' 
    	</cfquery>
		
		<cfloop index="i" from="1" to="#ArrayLen(filtervalues)#" step="1">
	
	      <cfset filtervalue = "#filtervalues[i].FieldValue#">
		 		
			<cfloop query="Control">
					
				<cfquery name="Last" 
				 datasource="appsSystem" 
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">
				 SELECT Max(FilterSerialNo) as No
				 FROM UserPivotFilter
				 WHERE ControlId = '#ControlId#'
				 AND  FilterMode = 'Data'
		    	</cfquery>
				
				<cfif Last.No eq "">
				   <cfset ser = 1>
				<cfelse>
				   <cfset ser = #Last.No#+1>
				</cfif>
				
				<cfquery name="Check" 
				 datasource="appsSystem" 
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">
				 SELECT *
				 FROM UserPivotFilter
				 WHERE ControlId = '#controlid#'
				 AND   FilterMode = 'Data'
				 AND   FieldName = '#FieldName#'
				 AND   FilterOperator = '#filteroperator#'
				 AND   FilterValue = '#filtervalue#' 
				</cfquery>
				
				<cfif check.recordcount eq "0">								
						
					<cfquery name="Insert" 
					 datasource="appsSystem" 
					 username="#SESSION.login#" 
					 password="#SESSION.dbpw#">
					 INSERT INTO UserPivotFilter
					 (ControlId, FilterSerialNo, FilterMode, FieldName, FilterOperator, FilterValue)
					 VALUES
					 ('#controlid#',#ser#,'Data','#fieldname#','#filteroperator#','#filtervalue#')
					</cfquery>
				
				</cfif>
				
			</cfloop>	
			
		</cfloop>	
		
		<cfquery name="List" 
		 datasource="appsSystem" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
		 SELECT F.*, O.OutputFormat as Format
		 FROM   UserPivot P,
		        UserPivotFilter F, 
				UserReportOutput O
		 WHERE  P.ControlId = '#control.ControlId#'
		 AND    P.ControlId = F.ControlId
		 AND    F.FieldName = O.FieldName
		 AND    O.OutputId = P.OutputId
		 AND    O.UserAccount = P.Account
		 AND    F.FilterMode = 'Data'
		 ORDER BY F.FieldName, F.FilterValue
    	</cfquery>
		
		<cfreturn List>
				
	</cffunction>
	
	<cffunction name="filterDelete" access="remote">
	
	    <cfargument name="outputid"    required="true"  type="string">
		<cfargument name="selected"    required="true"  type="array">
		
		<cfloop index="i" from="1" to="#ArrayLen(selected)#" step="1">
					
			<cfquery name="Delete" 
			 datasource="appsSystem" 
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
			 DELETE FROM UserPivotFilter
			 WHERE ControlId IN (SELECT ControlId 
			                     FROM UserPivot 
								 WHERE OutputId = '#outputid#')
			 AND FilterSerialNo = '#selected[i].FilterSerialNo#'
	    	</cfquery>
		
		</cfloop>
		
		<cfquery name="Control" 
			 datasource="appsSystem" 
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
			 SELECT *
			 FROM   UserPivot
			 WHERE  OutputId = '#outputid#'
			 AND    Account = '#SESSION.acc#'
    	</cfquery>
		
		<cfquery name="List" 
		 datasource="appsSystem" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
		 SELECT *
		 FROM UserPivotFilter
		 WHERE ControlId = '#Control.ControlId#'
		 AND  FilterMode = 'Data'
		 ORDER BY FilterSerialNo
    	</cfquery>
		
		<cfreturn List>
				
	</cffunction>
	
		
</cfcomponent>
