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

<cfcomponent name="DataDictionary"> 

	 <cffunction name="refreshDictionary" access="remote">
	 
	 <cfinvoke component="Service.Audit.DataDictionaryInit"  
			  method="refreshDictionary"
			  datasource = "#datasource#">
			  	  	 
	 </cffunction>	 
	 
	 <cffunction name="refreshDatabase" access="remote" returnType="struct">
	 
	 <cfargument name="datasource" type="string" default="" required="yes">
	 
			<cfinvoke component="Service.Audit.DataDictionaryInit"  
			  method="initDictionary"
			  DataSource = "#datasource#"/>
			  
			<cfinvoke
             component="Service.Audit.DataDictionary"
             method="showDBInfo"
             returnvariable="tableinfo" ds="#datasource#"/> 		  
			  
		    <cfreturn tableinfo>	    
				 
	 </cffunction>
	   	
	 <cffunction name="showTableTree" access="remote" returntype="XML">
	 
		<cfargument name="ds" type="string" default="" required="yes">
						
		<cfsavecontent variable="tree">
		
			<cfquery name="srv" 
				datasource="appsControl">
				SELECT DISTINCT ServerName
				FROM   Dictionary
				WHERE LastUpdateStatus = '1'
			</cfquery>
			
			<list>
			
			<cfoutput query="srv">
			
				<cfset name = "#ServerName#">
		
				<server cls="server" server="#name#" datasource="" label="#ServerName#">
			
				<cfquery name="database" 
					datasource="appsControl">
					SELECT DISTINCT D.DataBaseName, D.DataSource, count(*) as Counted
					FROM Dictionary D, DictionaryTable DT
					WHERE D.DataSource = DT.DataSource
					AND ServerName = '#name#'
					AND TableName NOT IN ('dtProperties')					  
					AND TableName NOT LIKE 'IMP_%'
					AND TableName NOT LIKE 'TMP_%'
					AND DT.Operational = 1
					AND D.LastUpdateStatus = '1'
					GROUP BY D.DataBaseName, D.DataSource
				</cfquery>
		
				<cfloop query="database">
				
				<cfset ds = DataSource>
		
			    <databases cls="database" server="#name#" datasource="#ds#" label="#databasename# (#counted#)">
							
					<cfquery name="table" 
						datasource="appsControl">
						SELECT DISTINCT TableName
						FROM DictionaryTable
						WHERE DataSource = '#DataSource#'
						AND TableName NOT IN ('dtProperties')					  
						AND TableName NOT LIKE 'IMP_%'
						AND TableName NOT LIKE 'TMP_%'
						AND Operational = 1
						ORDER BY TableName
					</cfquery>
									
					<cfloop query="table">
				
						 <tables cls="table" server="#name#" datasource="#ds#" label="#TableName#"/>
				 
					</cfloop> 
				
				</databases>	
							
				</cfloop>	
			
			</server>
			
			</cfoutput>
            
			</list>
								
		</cfsavecontent>
		
		<cfreturn tree>
		
	</cffunction>
	
<cffunction name="showServerInfo"  returntype="struct" access="remote">
	 
		<cfargument name="name" type="string" default="" required="yes">
		
		<cfquery name="Result" 
			datasource="appsControl">
			SELECT *
			FROM   Dictionary
			WHERE  ServerName   = '#name#'  
		</cfquery>	
		
		<cfquery name="Database" 
			datasource="appsControl">
			SELECT count(*) as Total
			FROM   Dictionary
			WHERE  ServerName   = '#name#'  
		</cfquery>	
		
		<cfquery name="Tables" 
			datasource="appsControl">
			SELECT count(*) as Total
			FROM   DictionaryTable
			WHERE  DataSource   IN (SELECT DataSource FROM Dictionary WHERE ServerName = '#name#')
			AND    Operational = 1
			AND    TableName NOT IN ('dtProperties')					  
			AND    TableName NOT LIKE 'IMP_%'
			AND    TableName NOT LIKE 'TMP_%'
		</cfquery>	
		
		<cfquery name="Fields" 
			datasource="appsControl">
			SELECT count(*) as Total
			FROM   DictionaryTableField
			WHERE  DataSource  IN (SELECT DataSource FROM Dictionary WHERE ServerName = '#name#')
			AND    TableName NOT IN ('dtProperties')					  
			AND    TableName NOT LIKE 'IMP_%'
			AND    TableName NOT LIKE 'TMP_%'
			AND    Operational = 1
		</cfquery>	
				
		<cfset tableinfo = structNew()>
		<cfset StructInsert(tableinfo, "ServerName", "#Result.ServerName#")>
		<cfset StructInsert(tableinfo, "ServerVendor", "#Result.ServerVendor#")>
		<cfset StructInsert(tableinfo, "NoFields", "#Fields.Total#")>
		<cfset StructInsert(tableinfo, "NoTables", "#Tables.Total#")>
		<cfset StructInsert(tableinfo, "NoDatabases", "#Database.Total#")>
		<cfreturn tableinfo>
		
</cffunction>		
	
<cffunction name="showDBInfo"  returntype="struct" access="remote">
	 
		<cfargument name="ds" type="string" default="" required="yes">
		
		<cfquery name="Result" 
			datasource="appsControl">
			SELECT *, convert(varchar,LastUpdated,112) as LastUpdateDate
			FROM   Dictionary
			WHERE  DataSource   = '#ds#'  
		</cfquery>	
		
		<cfquery name="Tables" 
			datasource="appsControl">
			SELECT count(*) as Total
			FROM   DictionaryTable
			WHERE  DataSource   = '#ds#'  
			AND    TableName NOT IN ('dtProperties')					  
			AND    TableName NOT LIKE 'IMP_%'
			AND    TableName NOT LIKE 'TMP_%'
			AND    Operational = 1
		</cfquery>	
		
		<cfquery name="Fields" 
			datasource="appsControl">
			SELECT count(*) as Total
			FROM   DictionaryTableField
			WHERE  DataSource   = '#ds#'  
			AND    TableName NOT IN ('dtProperties')					  
			AND    TableName NOT LIKE 'IMP_%'
			AND    TableName NOT LIKE 'TMP_%'
			AND    Operational = 1
		</cfquery>	
		
		<!---
		
		<cfquery name="Template" 
			datasource="appsSystem">
			SELECT TOP 1 *
			FROM   Ref_TemplateContent	
			WHERE FileName = 'error.cfm'
		</cfquery>	
		
		--->
				
		<cfset tableinfo = structNew()>
		<cfset StructInsert(tableinfo, "DataSource", "#Result.DataSource#")>
		<cfset StructInsert(tableinfo, "DatabaseName", "#Result.DatabaseName#")>
		<cfset StructInsert(tableinfo, "ServerName", "#Result.ServerName#")>
		<cfset StructInsert(tableinfo, "ServerVendor", "#Result.ServerVendor#")>
		<cfset StructInsert(tableinfo, "LastUpdateDate", "#Result.LastUpdated#")>
		<cfset StructInsert(tableinfo, "LastUpdateMemo", "#Result.LastUpdateMemo#")>
		<cfset StructInsert(tableinfo, "NoFields", "#Fields.Total#")>
		<cfset StructInsert(tableinfo, "NoTables", "#Tables.Total#")>
		<!---
		<cfset StructInsert(tableinfo, "Template", "#Template.TemplateContent#")>
		--->
		<cfreturn tableinfo>
		
</cffunction>	
	
<cffunction name="showTableInfo"  returntype="struct" access="remote">
	 
		<cfargument name="ds" type="string" default="" required="yes">
		<cfargument name="tablename" type="string" default="" required="yes">
		
		<cfquery name="Result" 
			datasource="appsControl">
			SELECT *
			FROM   DictionaryTable
			WHERE  DataSource   = '#ds#'  
			AND    TableName    = '#tablename#'
			AND    TableName  <> 'stDictionaryTableField' 
			AND    Operational = 1
		</cfquery>	
		
		<cfquery name="Fields" 
			datasource="appsControl">
			SELECT count(*) as Total
			FROM   DictionaryTableField
			WHERE  DataSource   = '#ds#'  
			AND    TableName    = '#tablename#' 
			AND    Operational = 1
		</cfquery>	
		
		<cfquery name="Records" 
			datasource="#ds#">
			SELECT count(*) as Records 
			FROM   #tablename# 
		</cfquery>	
		
		<cfquery name="Parent" 
			datasource="appsControl">
			SELECT     D.DataSource, 
			           D.FieldName AS ForeignKey, 
					   DD.FieldType + ' (' + LTRIM(STR(DD.FieldLength)) + ')' AS FieldType, 
					   D.ParentTableName,
					   D.ParentFieldName, 
                       DP.FieldType + ' (' + LTRIM(STR(DP.FieldLength)) + ')' AS ParentFieldType					   
			FROM      DictionaryDependency D INNER JOIN
                      DictionaryTableField DD ON D.DataSource = DD.DataSource AND D.TableName = DD.TableName AND D.FieldName = DD.FieldName INNER JOIN
                      DictionaryTableField DP ON D.ParentDataSource = DP.DataSource AND D.ParentTableName = DP.TableName AND 
                      D.ParentFieldName = DP.FieldName
			WHERE     D.TableName = '#tablename#' 
			AND       D.DataSource = '#ds#'
			AND       DD.Operational = 1
			ORDER BY D.TableName, D.FieldName 
		</cfquery>		
		
		<cfquery name="Child" 
			datasource="appsControl">
			SELECT    DataSource,TableName, FieldName
			FROM      DictionaryDependency
			WHERE     ParentTableName = '#tablename#' 
			AND       DataSource = '#ds#'
			ORDER BY  TableName, FieldName 
		</cfquery>									
		
		<cfquery name="Field" 
			datasource="appsControl">
			SELECT   *, 
			         FieldType AS FieldTypeLength 
			FROM     DictionaryTableField
			WHERE    DataSource   = '#ds#'  
			AND      TableName    = '#tablename#'
			AND      Operational = 1
			AND      FieldType NOT IN ('varchar','char')
			UNION
			SELECT   *, 
			         FieldType + ' (' + LTRIM(STR(FieldLength)) + ')' AS FieldTypeLength 
			FROM     DictionaryTableField
			WHERE    DataSource   = '#ds#'  
			AND      TableName    = '#tablename#'
			AND      Operational = 1
			AND      FieldType IN ('varchar','char')
			ORDER BY FieldOrder
		</cfquery>
		
		<cfset tableinfo = structNew()>
		<cfset StructInsert(tableinfo, "DataSource", "#Result.DataSource#")>
		<cfset StructInsert(tableinfo, "TableName", "#Result.TableName#")>
		<cfset StructInsert(tableinfo, "TableDescription", "#Result.TableDescription#")>
		<cfset StructInsert(tableinfo, "TableMemo", "#Result.TableMemo#")>
		<cfset StructInsert(tableinfo, "TableClass", "#Result.TableClass#")>
		<cfset StructInsert(tableinfo, "NoFields", "#Fields.Total#")>
		<cfset StructInsert(tableinfo, "NoRecords", "#Records.Records#")>
		<cfset StructInsert(tableinfo, "Parent", "#parent#")>
		<cfset StructInsert(tableinfo, "Child", "#child#")>
		<cfset StructInsert(tableinfo, "Field", "#field#")>
		<cfreturn tableinfo>
		
</cffunction>

<cffunction name="saveTableInfo" access="remote">

	 <cfargument name="table"   required="true"  type="struct">
	 
	 <cfquery name="Update" 
			datasource="appsControl">
			UPDATE DictionaryTable
			SET TableDescription = '#table.TableDescription#',
			TableMemo = '#Table.TableMemo#',
			TableClass = '#Table.TableClass#',
			TableReference = '#Table.TableReference#'
			WHERE DataSource = '#Table.DataSource#'
			AND TableName = '#Table.TableName#' 
	</cfquery>		
	 
</cffunction>

<cffunction name="showTableContent" access="remote"  returntype="struct">

	 <cfargument name="ds"      required="true"  type="string">
	 <cfargument name="table"   required="true"  type="string">
	 <cfargument name="fields"   required="true"  type="array">
	 
	 <!--- create subset --->
	 
	   <cfset id = "">
	 
	   <cfloop index="i" from="1" to="#ArrayLen(fields)#">
			 <cfif id eq "">
			     <cfset id = "'#fields[i].fieldname#'">
			 <cfelse>
			     <cfset id = "#id#,'#fields[i].fieldname#'">
			 </cfif>
		</cfloop>	
				
		<cfquery name="Fields" 
			datasource="appsControl" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT *
				FROM DictionaryTableField
				WHERE DataSource = '#ds#'
				AND TableName = '#table#'
				AND FieldName IN (#preserveSingleQuotes(id)#)
				ORDER BY FieldOrder 
		</cfquery>
				  
		 <cfset value = "">
		 <cfset sort = "">
		   
		 <cfloop query="Fields">
						 
			   <cfif fieldtype eq "DateTime" or fieldtype eq "SmallDateTime">
			     
				   <cfset v = "convert(varchar,#FieldName#,111) as #FieldName#"> 
			   <cfelse>
			       <cfset v = "#FieldName#">
			   </cfif>
						   
			   <cfif currentRow eq "1">
			       <cfset value   = "#v#">
				   <cfif fieldtype neq "text" and fieldtype neq "ntext">
					    <cfset sort   = "#FieldName#">
					</cfif>
			   <cfelse>
			       <cfset value   = "#value#,#v#">
				   <cfif fieldtype neq "text" and fieldtype neq "ntext">
				    <cfset sort   = "#sort#,#FieldName#">
				   </cfif>	
			   </cfif>	
							
		 </cfloop>
		 
		 <cftry>
				
		 <cfquery name="details" 
		  datasource="#ds#">
			 SELECT DISTINCT TOP 2000  #value#
			 FROM   #Table# T 
			 <cfif sort neq "">
			 ORDER BY #sort#
			 </cfif>
		 </cfquery>
		 
		 <cfcatch>
		 
		 <cfquery name="details" 
		  datasource="#ds#">
			 SELECT 2000  #value#
			 FROM   #Table# T 
			 <cfif sort neq "">
			 ORDER BY #sort#
			 </cfif>
		 </cfquery>
		 		 
		 </cfcatch>
		 
		 </cftry>
		 
		<cfset tabledata = structNew()>
		<cfset StructInsert(tabledata, "data", "#details#")>
		<cfset StructInsert(tabledata, "cols", "#fields#")>
							
		<cfreturn tabledata>
	 
</cffunction>
		
<cffunction name="criteriaGet" access="remote" returnType="struct">

		 <cfquery name="database" 
		  datasource="appsControl">
		     SELECT ' All' as DatabaseName, 'All' as DataSource
			 UNION
			 SELECT DISTINCT DatabaseName, max(DataSource) as DataSource
			 FROM   Dictionary 
			 WHERE DatabaseName > ''
			 GROUP BY DatabaseName
			 ORDER BY DatabaseName
		 </cfquery>

		<cfset operator = queryNew("name, display", "CF_SQL_VARCHAR, CF_SQL_VARCHAR")>
		
		<!--- add rows --->
		<cfset queryaddrow(operator, 3)>
		
		<!--- set values in cells --->
		<cfset querysetcell(operator, "name", "IS", 1)>
		<cfset querysetcell(operator, "name", "CONTAINS", 2)>
		<cfset querysetcell(operator, "name", "IS_NOT", 3)>
		<cfset querysetcell(operator, "display", "is", 1)>
		<cfset querysetcell(operator, "display", "contains", 2)>
		<cfset querysetcell(operator, "display", "not equal", 3)>
		
		<cfset filt = queryNew("name,display", "CF_SQL_VARCHAR, CF_SQL_VARCHAR")>
		<cfset queryaddrow(filt, 3)>
		<cfset querysetcell(filt, "name", "ALL", 1)>
		<cfset querysetcell(filt, "name", "TABLE", 2)>
		<cfset querysetcell(filt, "name", "FIELD", 3)>
		<cfset querysetcell(filt, "display", "Table & Field", 1)>
		<cfset querysetcell(filt, "display", "Table name", 2)>
		<cfset querysetcell(filt, "display", "Field name", 3)>
								
		<cfset tableinfo = structNew()>
		<cfset StructInsert(tableinfo, "Database", "#database#")>
		<cfset StructInsert(tableinfo, "Criteria", "#operator#")>
		<cfset StructInsert(tableinfo, "Scope", "#filt#")>
				
		
		<cfreturn tableinfo>
		
</cffunction>
 
<cffunction name="searchResult" access="remote" returntype="query">
	
	    <cfargument name="search"   required="true"  type="string">
		<cfargument name="operator" type="string" default="LIKE" required="yes">
		<cfargument name="filter"   type="string" default="ALL" required="no">
		<cfargument name="ds"       type="string" default="" required="yes">
				
		<cfquery name="Result" 
					datasource="appsControl">
										
					SELECT DD.DatabaseName, D.* 
					FROM   DictionaryTableField D, Dictionary DD
					WHERE DD.DataSource = D.DataSource
					
					AND    TableName NOT IN ('dtProperties')				  
					AND    TableName NOT LIKE 'IMP_%'
					AND    TableName NOT LIKE 'TMP_%'
					
					<cfif operator eq "Contains">
					
						<cfswitch expression="#filter#">
							<cfcase value="All">
							AND  ( TableName LIKE '#search#%' OR  FieldName LIKE '#search#%' )
							</cfcase>
							<cfcase value="TABLE">
							AND  ( TableName LIKE '#search#%' )
							</cfcase>
							<cfcase value="FIELD">
							AND  ( FieldName LIKE '#search#%' )
							</cfcase>
						</cfswitch>
																
					<cfelse>
					
						<cfswitch expression="#filter#">
							<cfcase value="All">
							AND  ( TableName = '#search#' OR  FieldName = '#search#' )
							</cfcase>
							<cfcase value="TABLE">
							AND  ( TableName = '#search#' )
							</cfcase>
							<cfcase value="FIELD">
							AND  ( FieldName = '#search#' )
							</cfcase>
						</cfswitch>
						
					</cfif>
					
					<cfif ds neq "All">
					AND   DD.DataSource = '#ds#' 
					</cfif>
					ORDER BY DD.DataSource,TableName,FieldOrder
		</cfquery>
		
		<cfreturn result>
		
</cffunction>
	
<cffunction name="getElementList" access="remote">
	  		
		<cfquery name="Result" 
					datasource="appsControl">
					SELECT *
					FROM DictionaryElement E
					ORDER BY ElementName
		</cfquery>
		
		<cfreturn result>
		
</cffunction>
	
<cffunction name="getElement" access="remote">
	
	    <cfargument name="id"         type="string" default="" required="yes">
				
		<cfquery name="Result" 
					datasource="appsControl">
					SELECT *
					FROM DictionaryElement E
					WHERE DataElementId = '#id#'
		</cfquery>
		
		<cfreturn result>
		
</cffunction>
		
</cfcomponent>

