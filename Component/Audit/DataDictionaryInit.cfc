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

<cfcomponent name="DataDictionaryInit"> 
	
 <cffunction name="refreshDictionary" access="remote" output="yes">
	 
	<cfargument name="datasource" type="string" default="" required="yes">
			
	<!--- loop through datasources --->
	
	<cfquery name="Set" 
			 datasource="AppsSystem">
			 SELECT *
			 FROM   Parameter			
	</cfquery>	
	
	<cfif Set.DataBaseServer eq Set.ControlServer>
	
		<cfoutput>
		
		<CFOBJECT ACTION="CREATE"
				TYPE="JAVA"
				CLASS="coldfusion.server.ServiceFactory"
				NAME="factory">
				<!--- Get datasource service --->
				<CFSET dsService=factory.getDataSourceService()>			
				<!--- Extract names into an array --->
				<cfset dsNames = dsService.getNames()>
				
		<cfquery name="Param" 
				 datasource="AppsInit">
				 SELECT * 
				 FROM   Parameter
				 WHERE  HostName = '#CGI.HTTP_HOST#'
		</cfquery>			
		
		<cfset cfusr = Param.CFAdminUser>	
		<cfset cfpw  = Param.CFAdminPassword>	
			
		<cfif Len(Trim(cfpw)) gt 20> 	    
		      <cf_decrypt text = "#cfpw#">
			  <cfset cfpw = Decrypted>      
		</cfif>	  	
							
		<cfset adminObj = createObject("component","cfide.adminapi.administrator").login("#cfpw#","#cfusr#")> 	
		<cfset myObj    = createObject("component","cfide.adminapi.datasource")>   	
		
		<cfset dsFull = myObj.getDataSources()>				
					   
		<CFLOOP INDEX="i"FROM="1" TO="#ArrayLen(dsNames)#">
			
			<cfset ds = dsNames[i]>
				
			<cfif left(dsNames[i],9) eq "AppsQuery">
			
			<cfelseif left(dsNames[i],15) eq "AppsTransaction">
						
			  <!--- exclude userquery --->
			
			<cfelse>
						
				<cfif left(ds,4) eq "Apps" or  left(ds,4) eq "Ware">
				
					<cfset host   = dsFull[ds].urlmap.host>
					<cfset dbname = dsFull[ds].urlmap.database>				
					<cfset vendor = "sqlserver">
								
					<cfquery name="Check" 
					datasource="appsControl">					
					SELECT * FROM Dictionary
					WHERE    DataSource = '#ds#'
					</cfquery>
					
					<cfif Check.recordcount eq "0">
					
						<cfquery name="Check" 
						datasource="appsControl">
						INSERT INTO Dictionary
			                   		(DataSource, ServerVendor, ServerName, DatabaseName)
						VALUES      ('#ds#','#vendor#','#host#','#dbname#')
						</cfquery>
					
					<cfelse>
					
						<cfquery name="Check" 
						datasource="appsControl">
						UPDATE    Dictionary
						SET       ServerVendor  = '#vendor#', 
						          ServerName    = '#host#', 
								  DatabaseName  = '#dbname#',
								  LastUpdated   = getDate()
						WHERE DataSource = '#ds#'
						</cfquery>
							
					</cfif>
					
					<cfinvoke component="Service.Audit.DataDictionaryInit"  
							  method="initDictionary"						  
							  DataSource  = "#ds#"/>						 
				</cfif>	  
							
								
			</cfif>	
			
		</cfloop>
		
		</cfoutput>
	
	</cfif>
	
	<cfquery name="Insert" 
	datasource="appsControl">
	INSERT INTO  DictionaryElement (ElementName)
	SELECT       DISTINCT FieldName
	FROM         DictionaryTableField R
	WHERE        FieldName NOT IN
     	            (SELECT   ElementName
	                 FROM     DictionaryElement
					 WHERE    ElementName = R.FieldName)
	ORDER BY FieldName
	</cfquery>
	
	<cfquery name="Update" 
	datasource="appsControl">
	UPDATE     DictionaryTableField
	SET        DataElementId = E.DataElementId
	FROM       DictionaryTableField D, DictionaryElement E
	WHERE      D.FieldName = E.ElementName 
	AND        D.DataElementId IS NULL
	</cfquery>
	
			
</cffunction>

<cffunction name="initDictionary" access="remote">
	 
	<cfargument name="datasource" type="string" default="" required="yes">
		
		<cfquery name="Param" 
			datasource="appsSystem">
			SELECT * FROM Parameter
		</cfquery>	
		
		<cfif Param.ControlServer neq Param.DatabaseServer>
		  <cfset dbcontrol = "[#Param.ControlServer#].">		
		<cfelse>
		  <cfset dbcontrol = "">			
		</cfif>	
	
	<!--- initial current data for operational status --->
	
		<cfquery name="Init" 
			datasource="appsControl">
			UPDATE DictionaryTable
			SET    Operational = 0
			WHERE  DataSource = '#datasource#'
		</cfquery>	
	
		<cfquery name="InitField" 
			datasource="appsControl">
			UPDATE DictionaryTableField
			SET    Operational = 0, 
			       KeyFieldNo = NULL
			WHERE  DataSource = '#datasource#'
		</cfquery>	
		
		<cfquery name="Init" 
			datasource="appsControl">
			SELECT * 
			FROM   DictionaryTable			
			WHERE  DataSource = '#datasource#'
		</cfquery>				
	
		 <cftry> 
		 											
			<cftransaction> 
			
			<!--- update existing tables for operational status --->
			
			<!---
			<cfif Param.ControlServer neq Init.ServerName>
			--->
			
			<cfquery name="Update" 
				datasource="#datasource#">
				UPDATE #dbcontrol#Control.dbo.DictionaryTable
				SET    Operational = 1
				WHERE  DataSource = '#datasource#'
				AND    TableName <> 'stDictionaryTableField'    
				AND    TableName IN (SELECT S.Name
									FROM   sysobjects S
									WHERE  xtype = 'U')
			</cfquery>
					
			<!--- add new tables and set operational = 1--->
			
			<cfquery name="Add" 
				datasource="#datasource#">
				INSERT INTO #dbcontrol#Control.dbo.DictionaryTable
				(DataSource,TableName,Operational)
					SELECT '#datasource#', S.Name, '1'
					FROM   sysobjects S
					WHERE  xtype = 'U'
					AND name NOT IN (SELECT TableName 
					                 FROM #dbcontrol#Control.dbo.DictionaryTable
									 WHERE Datasource = '#datasource#')
			</cfquery>
			
				
			<!--- update table field --->
			
			<cfquery name="Update" 
				datasource="#datasource#">
			    UPDATE  #dbcontrol#Control.dbo.DictionaryTableField
				SET     Operational  = 1,
				        FieldOrder   = C.colid,
						FieldType    = T.name,
						FieldLength  = C.length,
						FieldDefault = Def.text, 
						FieldNULL    = C.isnullable  
				FROM    sysobjects S INNER JOIN
                        #dbcontrol#Control.dbo.DictionaryTableField D ON S.name = D.TableName INNER JOIN
                        syscolumns C ON D.FieldName = C.name AND S.id = C.id INNER JOIN
                        systypes T ON C.xtype = T.xtype LEFT OUTER JOIN
                        syscomments Def ON C.cdefault = Def.id						
				WHERE   D.DataSource = '#datasource#'
				AND     S.xtype       = 'U'
				AND     T.name != 'sysname'
			</cfquery>
			
			 <cfquery name="DELETEME"
		   	  datasource="#datasource#">
			   if exists 
			  (SELECT * 
			   FROM dbo.sysobjects 
			   WHERE id = object_id(N'[stDictionaryTableField]') 
			   AND  OBJECTPROPERTY(id, N'IsUserTable') = 1)
				   
			   DROP table [stDictionaryTableField]
		    </cfquery>
									
			<cfquery name="Subset" 
				datasource="#datasource#">
			    SELECT * 
				INTO   stDictionaryTableField
				FROM   #dbcontrol#Control.dbo.DictionaryTableField
				WHERE  DataSource = '#datasource#' 
			</cfquery>
			
			 <cfquery name="Subset" 
				datasource="#datasource#">
				INSERT INTO #dbcontrol#Control.dbo.DictionaryTableField 
						(Datasource, 
					     TableName,
						 FieldName,
						 FieldOrder,
						 FieldType,
						 FieldLength,
						 FieldDefault,
						 FieldNULL) 
				SELECT   '#datasource#',
				         S.name  AS TableName, 
				         C.name  AS FieldName, 
						 C.colid AS FieldOrder,
						 T.name  AS fieldtype, 
						 C.length,
						 Def.text,
						 C.isnullable
				FROM     sysobjects S INNER JOIN
	                     syscolumns C ON S.id = C.id INNER JOIN
	                     systypes T ON C.xtype = T.xtype LEFT OUTER JOIN
	                     syscomments Def ON C.cdefault = Def.id LEFT OUTER JOIN
	                     stDictionaryTableField D ON S.name = D.TableName AND C.name = D.FieldName
				WHERE    (S.xtype = 'U') 
				AND      (T.name <> 'sysname') 
				AND      (S.name <> 'stDictionaryTableField') 
				AND      (D.DataSource IS NULL)					 				
				<!--- ensure the ds, table and field does not exist already --->
				ORDER BY S.name, C.colid 
				</cfquery>
				
				<!--- update PK --->
				<cfquery name="Insert" 
				datasource="#datasource#">
				UPDATE    #dbcontrol#Control.dbo.DictionaryTableField
				SET       KeyFieldNo = K.keyNo
				FROM      sysobjects S INNER JOIN
	                      syscolumns C ON S.id = C.id INNER JOIN
	                      systypes T ON C.xtype = T .xtype INNER JOIN
	                      #dbcontrol#Control.dbo.DictionaryTableField Dict ON S.name = Dict.TableName AND C.name = Dict.FieldName INNER JOIN
	                      sysindexkeys K ON C.colid = K.colid AND C.id = K.id
				WHERE     S.xtype = 'U' 
				AND       T.name <> 'sysname' 
				AND       Dict.DataSource = '#datasource#' 
				AND       K.indid = 1
				</cfquery>
				
				<!--- update dependency --->
				
				<cfquery name="InitDependency" 
				datasource="#datasource#">
					DELETE FROM #dbcontrol#Control.dbo.DictionaryDependency
					WHERE  DataSource = '#datasource#'
				</cfquery>	
				
				<cfquery name="Insert" 
				datasource="#datasource#">
				INSERT INTO #dbcontrol#Control.dbo.DictionaryDependency
						  (DataSource, TableName, FieldName, ParentDataSource, ParentTableName, ParentFieldName)
						  
				SELECT    DISTINCT '#datasource#',
				          FO.name AS TableName, 
						  FOC.name AS FieldName, 
						  '#datasource#',
						  O.name AS ParentTableName, 
						  OC.name AS ParentFieldName
				FROM      sysforeignkeys FK INNER JOIN
	                      sysobjects FO ON FK.fkeyid = FO.id INNER JOIN
	                      syscolumns FOC ON FK.fkeyid = FOC.id AND FK.fkey = FOC.colid INNER JOIN
	                      sysobjects O ON FK.rkeyid = O.id INNER JOIN
	                      syscolumns OC ON FK.rkeyid = OC.id AND FK.rkey = OC.colid
				</cfquery>
				
				<cfquery name="Check" 
				datasource="#datasource#">
					UPDATE    #dbcontrol#Control.dbo.Dictionary
					SET       LastUpdateStatus = '1', 
					          LastUpdateMemo   = 'Successfully updated', 
							  LastUpdated = getDate()
					WHERE     DataSource = '#datasource#'
				</cfquery>
				
				</cftransaction>
															
				<cfcatch>
								
					<cfquery name="Check" 
					datasource="appsControl">
					UPDATE    Dictionary
					SET       LastUpdateStatus = '9', 
					          LastUpdateMemo   = 'Error refreshing data dictionary', 
							  LastUpdated = getDate()
					WHERE DataSource = '#datasource#'
					</cfquery>
														
				</cfcatch>
				
			</cftry>
						
			<!---
			
			</cfif>
			
			--->
					
</cffunction>
	
</cfcomponent>	
	