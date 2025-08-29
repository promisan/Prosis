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
<!--- contain the following functions 

1.  initSelection : Retrieve base data for the view from HTLM link
2.  initTableGrid : Retrieve column/dimension information for grid and graph information as to be show to the user
3.  dataTableTree : Generate the Tree
4.  initField : Generate the drag and drop for columns to be shown
5.  fieldSave : Saves the selected values for columns
6.  exportTable : prepare Excel Export
7.  dataTable : prepare content for main table grid
8.  

--->

<cfcomponent name="CrossTabDetail"> 

	<!--- 1. retrieve where the user ended in the HTML pivot table --->

	<cffunction name="initSelection" access="remote" returntype="query">
			 
	<cfquery name="SELECT" 
			datasource="AppsSystem">
			SELECT * 
			FROM UserPivotTemp
			WHERE Account = '#SESSION.acc#'
	 </cfquery>	
	 
	 <cfreturn select>		 
			 
	</cffunction>			 

<cffunction name="initTableGrid" access="remote" returntype="struct">
		
	    <cfargument name="controlid"   required="true"  type="string">
		<cfargument name="node"        required="true"  type="string" default="1">
				
		<cfset tableinfo = structNew()>
						
		<!--- determine link to detail --->
		
		<cfquery name="report" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT TOP 1 U.*, '#SESSION.root#/'+DetailTemplate as Template
				FROM   UserPivot P, Ref_ReportControlOutput U
				WHERE  P.ControlId  = '#ControlId#'  
				AND    P.OutputId   = U.OutputId 				
		</cfquery>
				
		<cfset StructInsert(tableinfo, "GridDetailLink", "#report.template#")>
		    		
		<!--- identify the grid fields --->
		
		<cfquery name="control" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT *
				FROM   UserPivot
				WHERE  ControlId    = '#ControlId#'	
				AND    Node         = '#node#' 					
		</cfquery>
		
		<cfif control.recordcount eq "0">
		
			<cfquery name="control" 
				datasource="AppsSystem" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT *
					FROM   UserPivot
					WHERE  ControlId    = '#ControlId#'									
			</cfquery>
		
		</cfif>
		
		<cfquery name="fields" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT *
				FROM   UserPivotDetail
				WHERE  ControlId    = '#ControlId#'
				AND    Presentation = 'Details'
				AND    FieldName    = 'Details'  
				ORDER BY ListingOrder 
		</cfquery>
				
		<cfset StructInsert(tableinfo, "GridFields", "#fields#")>
		
		<!--- identify applied filters for grid --->
		
		<cfquery name="Filter" 
			 datasource="appsSystem" 
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
			 SELECT   *
			 FROM     UserPivotFilter
			 WHERE    ControlId = '#ControlId#'
			 AND      FilterMode = 'Subset'
			 ORDER BY FilterSerialNo
	   	</cfquery>
			
		<cfset StructInsert(tableinfo, "GridFilter", "#filter#")>	
		
		<!--- identify fields for graph grid --->
		
		<cfquery name="fieldsg" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT Presentation,FieldName,FieldValue,FieldHeader,FieldTooltip,FieldWidth,FieldDataType
				FROM   UserPivotDetail
				WHERE  ControlId    = '#ControlId#'
				AND    Presentation LIKE 'Formula%'
				AND    FieldDataType <> 'Percentage'	
		</cfquery>
		
		<cfif fieldsg.recordcount eq "0">
		
			<cfquery name="fieldsg" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT Presentation,FieldName,FieldValue,FieldHeader,FieldTooltip,FieldWidth,FieldDataType
				FROM   UserPivotDetail
				WHERE  ControlId    = '#ControlId#'
				AND    Presentation LIKE 'Formula%'				
			</cfquery>
		
		</cfif>
		
		<cfset StructInsert(tableinfo, "GridFieldsGraph", "#fieldsg#")>
		
		<!--- identify fields for graph grid --->
						
		<cfquery name="fieldsgd" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT FieldName
				FROM   UserReportOutput O
				WHERE  UserAccount = '#SESSION.acc#'
				AND    OutputId = '#Report.OutputId#'
				AND    FieldName LIKE '%_dim'								 
		</cfquery>
		
		<cfset dimension = "">
		<cfif control.datasource eq "">
			<cfset ds = "appsquery">
		<cfelse>
		  	<cfset ds = "#control.datasource#">
		</cfif>
		
		<cfloop query="fieldsgd">
		
			<cfquery name="getRelevant" 
				datasource="#ds#" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">				
				SELECT  DISTINCT(#FieldName#)
				FROM    #control.tablename#_summary 				
			</cfquery>	
			
			<!--- only relevant dimension --->
			
			<cfif getRelevant.recordcount gte "2" and getRelevant.recordcount lte "15">
			
			     <cfif dimension eq "">
				 	<cfset dimension = "'#fieldname#'">
				 <cfelse>
					 <cfset dimension = "#dimension#,'#fieldname#'">
				 </cfif>	 
			 
			</cfif>
				
		</cfloop>
		
		<cfif dimension neq "">
		
			<cfquery name="fieldsgd" 
				datasource="AppsSystem" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT FieldName  
					FROM   UserReportOutput O 
					WHERE  UserAccount = '#SESSION.acc#'
					AND    OutputId    = '#Report.OutputId#'
					AND    FieldName IN (#preservesinglequotes(dimension)#)					 
			</cfquery>
		
		</cfif>
		
		<cfset Dimension = queryNew("Label,Name,Display", "CF_SQL_VARCHAR,CF_SQL_VARCHAR,CF_SQL_VARCHAR")>
				
		<!--- add rows --->
		
		<cfset queryaddrow(Dimension, fieldsgd.recordcount)>
			
		<cfloop query="fieldsgd">
				
		      <cfset l = #len(FieldName)#>		
		      <cfset label = left("#FieldName#",l-4)>
			  
			  <cfquery name="check" 
				datasource="appsSystem">
				SELECT FieldName as Header
				FROM   UserReportOutput
				WHERE  UserAccount = '#SESSION.acc#'
				AND    OutputId = '#Report.OutputId#'
				AND    FieldName LIKE '#label#_nme'						
			   </cfquery>				   
			   <cfif check.recordcount eq "1">
			      <cfset head = "#check.Header#">
			   <cfelse>
    		      <cfset head = "#FieldName#">  
	    	   </cfif>  
				
			<!--- set values in cells --->
			<cfset querysetcell(Dimension, "Label", "#label#", currentRow)>
			<cfset querysetcell(Dimension, "Name", "#FieldName#", currentRow)>
			<cfset querysetcell(Dimension, "Display", "#head#", currentRow)>
					
		</cfloop>
	
		<cfset StructInsert(tableinfo, "FieldsGraphDimensionCount", "#fieldsgd.recordcount#")>
		<cfset StructInsert(tableinfo, "FieldsGraphDimension", "#dimension#")>
			
		<cfreturn tableinfo>
				
</cffunction>


<cffunction name="dataTableTree" access="remote" returntype="XML">

		<!--- show tree information --->

		<cfargument name="controlid"   required="true"  type="string">
		<cfargument name="alias"       type="string" default="AppsSystem" required="yes">
		<cfargument name="node"        required="true"  type="string">
		<cfargument name="frame"       required="true"  type="string">
		<cfargument name="table"       required="true"  type="string">
		
		<cfquery name="SystemParam" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT    * 
			FROM      Parameter 
		</cfquery>
		
		<cfset aut_server = "#SystemParam.AuthorizationServer#">
		
		<cfquery name="Pivot" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT * 
				FROM   UserPivot
				WHERE  ControlId    = '#ControlId#' 
		</cfquery>
		
		<cfset datasetfilter = "#replace(Pivot.Tablefilter,"^","'","ALL")#">
		
		<cfoutput>
		
		<!--- pending : update dimension --->
			
		<cfsavecontent variable="tree">
		
		 <node fld_1="" val_1="" label="Selection">
		 
		  <node label="All CELL records" fld_1="" val_1="" fld_2="" val_2="" fld_3="" val_3=""/>
		
		<cfquery name="dimension" 
			datasource="appsSystem">
			SELECT DISTINCT Presentation, 
			                PresentationOrder as ListingOrder, 
							FieldName 
			FROM   UserPivotDetail
			WHERE  ControlId = '#controlid#'
			AND   (Presentation IN ('Y-ax') OR Presentation LIKE 'Grouping%')
			ORDER BY PresentationOrder
		</cfquery>
		
		<cfloop query="dimension">	
		  <cfparam name="dim_#currentRow#" default="#Presentation#">
		  <cfparam name="dimfld_#currentRow#" default="#FieldName#">
		</cfloop>
		
			<cfquery name="val_1" 
					datasource="#alias#" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					SELECT * 
					FROM  [#aut_server#].System.dbo.UserPivotDetail
					WHERE ControlId   = '#controlid#'
					AND   Presentation LIKE '#dim_1#%'
					<cfif datasetfilter neq "">
					AND   FieldValue IN (SELECT #dimfld_1# 
						                      FROM #table# T
											  WHERE 1=1 #PreserveSingleQuotes(datasetfilter)#)
					</cfif>						  
					ORDER BY ListingOrder
			</cfquery>
		
			<cfloop query="val_1">		
				
				<cfset fld1 = FieldName>
				<cfset val1 = FieldValue>
				
			    <node label="#FieldHeader#" fld_1="#fld1#" val_1="#val1#" fld_2="" val_2="" fld_3="" val_3="">
				
				<cfif dimension.recordcount gte "2">
				
					<cfquery name="val_2" 
						datasource="#alias#"					 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						SELECT *
						FROM  [#aut_server#].System.dbo.UserPivotDetail
						WHERE ControlId   = '#controlid#'
						AND   Presentation = '#dim_2#' 
						AND   FieldValue IN (SELECT #dimfld_2# 
						                     FROM #table# T
											 WHERE #fld1# = '#val1#' #PreserveSingleQuotes(datasetfilter)#)
						ORDER BY ListingOrder
					</cfquery>
					
						<cfloop query="val_2">	
						
						    <cfset fld2 = FieldName>
						    <cfset val2 = FieldValue>
												
						    <node label="#FieldHeader#" fld_1="#fld1#" val_1="#val1#" fld_2="#fld2#" val_2="#val2#" fld_3="" val_3="">
							
								<cfif dimension.recordcount gte "3">
							
									<cfquery name="val_3" 
										datasource="#alias#" 
										username="#SESSION.login#" 
										password="#SESSION.dbpw#">
										SELECT * 
										FROM  [#aut_server#].System.dbo.UserPivotDetail
										WHERE ControlId   = '#controlid#'
										AND   Presentation = '#dim_3#'
										AND   FieldValue IN (SELECT #dimfld_3# 
										                     FROM   #table# T
										                     WHERE  #fld2# = '#val2#' 
															 AND    #fld1# = '#val1#'
															 #PreserveSingleQuotes(datasetfilter)#)
										ORDER BY ListingOrder
									</cfquery>
									
										<cfloop query="val_3">	
										
											<cfset fld3 = FieldName>
										    <cfset val3 = FieldValue>
									
											<node label="#FieldHeader#" fld_1="#fld1#" val_1="#val1#" fld_2="#fld2#" val_2="#val2#" fld_3="#fld3#" val_3="#val3#"></node>
										
										</cfloop>
									
								 </cfif>	
							
							</node>
										
					   </cfloop>
				   
				 </cfif>  
				
				</node>
								
			</cfloop>
					
        </node>
								
		</cfsavecontent>
		
		</cfoutput>
		
		<cfreturn tree>
		
</cffunction>



<cffunction name="initField" access="remote" returntype="struct">

	    <!--- allow user to select their own columns --->
		
	    <cfargument name="controlid"   required="true"  type="string">
		
		<cfquery name="Pivot" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT * 
				FROM UserPivot
				WHERE ControlId    = '#ControlId#' 
		</cfquery>
				
		<!--- create subset --->
		
		<cfquery name="fieldleft" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT   DISTINCT FieldName, OutputHeader, OutputFormat+' ('+LTRIM(STR(OutputWidth))+')' as OutputFormat, FieldNameOrder
				FROM     UserReportOutput
				WHERE    OutputId = '#Pivot.OutputId#'
				AND      UserAccount = '#SESSION.acc#'
				AND      OutputEnabled = 0
				ORDER BY FieldNameOrder
		</cfquery>
		
		<cfquery name="fieldright" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT   DISTINCT FieldName, OutputHeader, OutputFormat+' ('+LTRIM(STR(OutputWidth))+')' as OutputFormat, FieldNameOrder
				FROM     UserReportOutput
				WHERE    OutputId = '#Pivot.OutputId#'  
				AND      UserAccount = '#SESSION.acc#'
				AND      OutputEnabled = 1
				ORDER BY FieldNameOrder
		</cfquery>
		
		<cfset tableinfo = structNew()>
		<cfset StructInsert(tableinfo, "fieldleft", "#fieldleft#")>
		<cfset StructInsert(tableinfo, "fieldright", "#fieldright#")>
		<cfreturn tableinfo>
				
</cffunction>



<cffunction name="fieldSave" access="remote">

	<!--- save changes made by user to change the columns that are to be shown to him/her --->

	<cfargument name="controlid"   type="string" required="yes">
	<cfargument name="selected"    type="array" required="yes">
		
	<cfquery name="Pivot" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT * 
			FROM UserPivot
			WHERE ControlId    = '#ControlId#' 
	</cfquery>
	
	<cfquery name="Reset" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			UPDATE UserReportOutput
			SET    FieldNameOrder = '99', OutputEnabled = 0 
			WHERE  OutputId = '#Pivot.OutputId#'
			AND    UserAccount = '#SESSION.acc#'
	</cfquery>
					  
	<cfloop index="i" from="1" to="#ArrayLen(selected)#" step="1">
	
	      <cfset nme = "#selected[i].FieldName#">
		  <cfset hdr = "#selected[i].OutputHeader#">
		  
		  <cfquery name="Set" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				UPDATE UserReportOutput
				SET    FieldNameOrder = #i#, 
				       OutputEnabled = '1' 
				WHERE  OutputId = '#Pivot.OutputId#' 
				AND    FieldName = '#nme#' 
				AND    UserAccount = '#SESSION.acc#'
    	   </cfquery>
		   
		   <cfquery name="Select" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT *
				FROM   UserReportOutput
				WHERE  OutputId = '#Pivot.OutputId#' 
				AND    FieldName = '#nme#' 
				AND    UserAccount = '#SESSION.acc#'
    	   </cfquery>
		   
		   <cfif i eq "1">
						
			    <cfset value   = "#nme#">
						   
			    <cfif hdr eq "">
				     <cfset header  = "#FieldName#">
				<cfelse>
				     <cfset header  = "#hdr#">
				</cfif>
			
				<cfset order   = "#i#">
						   
				<cfif #Select.OutputWidth# lte "8">
					<cfset width   = "20">
			    <cfelse>
				    <cfset width   = "#Select.OutputWidth#">
			    </cfif>
						   
				 <cfif #Select.OutputFormat# eq "">
				     <cfset format  = "varchar">
				 <cfelse>
				     <cfset format  = "#Select.OutputFormat#">
				 </cfif>
						   
			     <cfset color   = "#Select.OutputColor#">
					    
			<cfelse>
			
				<cfset value   = "#value#|#nme#">
						   
			    <cfif hdr eq "">
				     <cfset header  = "#header#|#FieldName#">
				<cfelse>
				     <cfset header  = "#header#|#hdr#">
				</cfif>
			
				<cfset order   = "#order#|#i#">
						   
				<cfif #Select.OutputWidth# lte "8">
					<cfset width   = "#width#|30">
			    <cfelse>
				    <cfset width   = "#width#|#Select.OutputWidth#">
			    </cfif>
						   
				 <cfif #Select.OutputFormat# eq "">
				     <cfset format  = "#format#|varchar">
				 <cfelse>
				     <cfset format  = "#format#|#Select.OutputFormat#">
				 </cfif>
				    					   
				   <cfset color   = "#color#|#Select.OutputColor#"> 
					   
			</cfif>	
				   
			</cfloop>   
											  
			<cfinvoke component="Service.Analysis.CrossTab"  
				  method="Dimension"
				  ControlId            = "#controlid#"
				  Presentation         = "Details"
				  FieldName            = "Details"
				  ListingOrder         = "#order#"
				  FieldWidth           = "#width#"
				  FieldValue           = "#value#"
				  FieldDataType        = "#format#"
				  FieldHeader          = "#header#"
				  FieldColor           = "#color#"
				  FieldTooltip         = "#header#"/>	    
	
</cffunction>

<cffunction name="exportTable" access="remote" returntype="query">

		<!--- export table to excel --->
			 
		<cfargument name="controlid"   required="true"   type="string">
		<cfargument name="alias"       type="string"     default="AppsSystem" required="yes">
		<cfargument name="table"       required="true"   type="string">
		<cfargument name="selected"    type="array"      required="yes">
		<cfargument name="filter"      type="string"     required="yes">
		<cfargument name="field1"      required="false"  type="string" default="">
	    <cfargument name="field1val"   required="false"  type="string" default="">	
		<cfargument name="field2"      required="false"  type="string" default="">
	    <cfargument name="field2val"   required="false"  type="string" default="">	
		<cfargument name="field3"      required="false"  type="string" default="">
	    <cfargument name="field3val"   required="false"  type="string" default="">	
		<cfargument name="field4"      required="false"  type="string" default="">
	    <cfargument name="field4val"   required="false"  type="string" default="">	
		<cfargument name="field5"      required="false"  type="string" default="">
	    <cfargument name="field5val"   required="false"  type="string" default="">	
		<cfargument name="field6"      required="false"  type="string" default="">
	    <cfargument name="field6val"   required="false"  type="string" default="">			
		<cfargument name="valfil"      required="false"  type="string" default="">
	    <cfargument name="val"         required="false"  type="string" default="">	
	    <cfargument name="valfil1"     required="false"  type="string" default="">
	    <cfargument name="val1"        required="false"  type="string" default="">	
	    <cfargument name="valfil2"     required="false"  type="string" default="">
	    <cfargument name="val2"        required="false"  type="string" default="">	
	    <cfargument name="valfil3"     required="false"  type="string" default="">
	    <cfargument name="val3"        required="false"  type="string" default="">	
				
		<cfquery name="Pivot" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT * 
				FROM UserPivot
				WHERE ControlId    = '#ControlId#'  
		</cfquery>
		
		<cfquery name="SystemParam" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT    *
			FROM      Parameter
		</cfquery>
		
		<cfset aut_server = "#SystemParam.AuthorizationServer#">
		
		<cfset id = "">
				  
		  <cfloop index="i" from="1" to="#ArrayLen(selected)#">
			 <cfif id eq "">
			     <cfset id = "'#selected[i].FactTableId#'">
			 <cfelse>
			     <cfset id = "#id#,'#selected[i].FactTableId#'">
			 </cfif>
		</cfloop>	
		
		<cfset flds = "">
				
		<!--- primary group --->
		
		<cfquery name="Group2" 
			datasource="appsSystem">
			SELECT   TOP 1 *
		    FROM     UserPivotDimension
			WHERE    ControlId    = '#ControlId#'
			AND      Presentation = 'Grouping1' 
		</cfquery>
		
		<cfif Group2.recordcount neq "0">
				
			<cfset l = len(Group2.FieldName)>
			<cfset f = left(Group2.FieldName,l-4)>
																	
			<cfquery name="Field" 
			 datasource="appsSystem" 
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
					SELECT  *
					FROM    UserReportOutput
					WHERE   UserAccount = '#SESSION.acc#'
					AND     OutputId    = '#Pivot.OutputId#'
					AND     OutputClass = 'Detail' 
					AND     FieldName   = '#f#_nme'
			</cfquery>
			
			<cfif field.recordcount eq "1">
			  <cfset fld = "#Group2.FieldName#,#f#_nme">
			<cfelse>
			  <cfset fld = "#Group2.FieldName#">  
			</cfif>
					
			<cfset flds = "#fld#">
		
		</cfif>
		
		<!--- detail grpip --->
						
		<cfquery name="Group1" 
			datasource="appsSystem">
			SELECT   TOP 1 *
		    FROM     UserPivotDimension
			WHERE    ControlId    = '#ControlId#' 
			AND      Presentation = 'Y-ax' 	
		</cfquery>		
						
		<cfset l = len(Group1.FieldName)>		
		
		<cfif l gt "4">
		
			<cfset f = left(Group1.FieldName,l-4)>
																		
			<cfquery name="Field" 
			 datasource="appsSystem" 
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
			 
					SELECT  *
					FROM    UserReportOutput
					WHERE   UserAccount = '#SESSION.acc#'
					AND     OutputId    = '#Pivot.OutputId#'
					AND     OutputClass = 'Detail' 
					AND     FieldName   = '#f#_nme' 
			</cfquery>
			
			<cfif Field.recordcount eq "1">
			  <cfset fld = "#Group1.FieldName#,#f#_nme">
			<cfelse>
			  <cfset fld = "#Group1.FieldName#"> 
			</cfif>
			
			<cfif flds neq "">
				
				<cfset flds = "#flds#,#fld#">
				
			<cfelse>
			
				<cfset flds = "#fld#">
			
			</cfif>	
				
			<cfset ord = flds>
			
		<cfelse>
		
			<cfset ord = "">	
			
		</cfif>	
		
		
		<!--- create subset --->
		
		<cfquery name="Fields" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT *
			FROM UserPivotDetail
			WHERE  ControlId    = '#ControlId#'
			AND Presentation = 'Details'
			AND FieldName    = 'Details'  
			ORDER BY ListingOrder 
		</cfquery>
					   
		 <cfloop query="Fields">
									   
			   <cfset v = "#FieldValue#">
			   
			   <cfif find("#FieldValue#","#flds#")>
			  
			   <cfelse>
			    
			   <cfif flds eq "">
			       <cfset flds   = "#v#">
			   <cfelse>
			       <cfset flds   = "#flds#,#v#">
			   </cfif>	
			   
			   </cfif>
							
		 </cfloop>	
		 
		 <!--- add summary fields to SELECT --->
		 
		 <cfquery name="SummaryFields" 
			datasource="appsSystem"
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT   *
		    FROM     UserPivotDetail
			WHERE    ControlId = '#ControlId#'  
			AND      Presentation LIKE 'Formula%' 
			AND      FieldValue   LIKE 'SUM(%'  
		</cfquery>		
								
		<cfloop query = "SummaryFields">
		
	         <cfset l = #len(FieldName)#>
			 <cfset s = Mid(FieldName, 5, l-5)>
			 
			 <cfif find("#s#","#flds#")>
		  
			 <cfelse>
		    
			   	  <cfif flds eq "">
			          <cfset flds   = "#s#">
			      <cfelse>
			          <cfset flds   = "#flds#,#s#">
			      </cfif>	
			  
			 </cfif> 
								 
		</cfloop>
					
		<cf_droptable 
		  dbname="#alias#" 
		  tblname="#Table#_export">			  
		  				
		<cfquery name="dataset" 
			  datasource="#alias#"  
			  username="#SESSION.login#" 
		      password="#SESSION.dbpw#">
			 
				 SELECT    DISTINCT #flds# 
				 INTO      #Table#_export
				 FROM      #Table# T
				 WHERE     1=1
				 
				 <cfif ArrayLen(selected) gt "1">
					 AND       T.FactTableId IN (#preserveSingleQuotes(id)#)					 
				 </cfif>
				 
				 <cfif filter neq "">
			    	 #preserveSingleQuotes(filter)#
			     </cfif>
				 
				 <cfloop index="itm" list="field1,field2,field3,field4,field5" delimiters=",">
				   <cfif evaluate(itm) neq "" and evaluate("#itm#val") neq "">
				 	AND #evaluate(itm)# = '#evaluate("#itm#val")#'	
				   </cfif>			 
				 </cfloop>
				 				 
				 <cfif valfil neq "" and val neq "">
			      	AND #valfil# LIKE '#val#%'
				 </cfif>
				 
				 <cfif valfil1 neq "" and val1 neq "">
				    AND #valfil1# LIKE '#val1#%'
				 </cfif>
				 
				 <cfif valfil2 neq "" and val2 neq "">
				    AND #valfil2# LIKE '#val2#%'
				 </cfif>
				 
				 <cfif valfil3 neq "" and val3 neq "">
				    AND #valfil3# LIKE '#val3#%'
				 </cfif>
				 
				 <cfif ord neq "">
				 ORDER BY #ord#
				 </cfif>
		 </cfquery>	
			
		 <cfquery name="result" 
				  datasource="#alias#"  
				  username="#SESSION.login#" 
			      password="#SESSION.dbpw#">
					SELECT count(*) as Total
					FROM #Table#_export 
		 </cfquery>	
		
		 <cfreturn result>
   
</cffunction>	


<cffunction name="dataTable"
          access="remote"
          returntype="struct">
		
	    <cfargument name="controlid"   required="true"  type="string">
		<cfargument name="alias" type="string" default="AppsSystem" required="yes">
		<cfargument name="node"        required="true"  type="string">
		<cfargument name="frame"       required="true"  type="string">
		
		<!--- filter from HTMl pivot selection --->
		
		<cfargument name="af"          required="true"  type="string">
		<cfargument name="av"          required="true"  type="string">
		<cfargument name="as"          required="true"  type="string">
		
		<cfargument name="bf"          required="true"  type="string">
		<cfargument name="bv"          required="true"  type="string">
		<cfargument name="bs"          required="true"  type="string">
		
		<cfargument name="cf"          required="true"  type="string">
		<cfargument name="cv"          required="true"  type="string">
		<cfargument name="cs"          required="true"  type="string">
		
		<cfargument name="df"          required="true"  type="string">
		<cfargument name="dv"          required="true"  type="string">
		<cfargument name="ds"          required="true"  type="string">
		
		<cfargument name="yf"          required="true"  type="string">
		<cfargument name="yv"          required="true"  type="string">
		<cfargument name="ys"          required="true"  type="string">
		
		<cfargument name="xf"          required="true"  type="string">
		<cfargument name="xv"          required="true"  type="string">
		<cfargument name="xs"          required="true"  type="string">
		
		<cfargument name="table"       required="true"  type="string">
		
		<!--- filter from criteria selection --->
		<cfargument name="filter"      required="false"  type="string" default="">
		
		<!--- additional filter from tree selection in the detail screen --->
		<cfargument name="valfil"      required="false"  type="string" default="">
		<cfargument name="val"         required="false"  type="string" default="">	
		<cfargument name="valfil1"     required="false"  type="string" default="">
		<cfargument name="val1"        required="false"  type="string" default="">	
		<cfargument name="valfil2"     required="false"  type="string" default="">
		<cfargument name="val2"        required="false"  type="string" default="">	
		<cfargument name="valfil3"     required="false"  type="string" default="">
		<cfargument name="val3"        required="false"  type="string" default="">	
		
		<cfquery name="Pivot" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT * 
				FROM UserPivot
				WHERE ControlId    = '#ControlId#' 
		</cfquery>
				
		<cfif IsNumeric(xs)>
		
		<cfquery name="XValue" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT * 
				FROM   UserPivotDetail
				WHERE  ControlId    = '#ControlId#' 
				AND    Presentation = 'X-ax'
				AND    SerialNo     = '#xs#'
		</cfquery>
			
		<cfelse>
		
		<cfquery name="XValue" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT * 
				FROM   UserPivotDetail
				WHERE  ControlId    = '#ControlId#' 
				AND    Presentation = 'X-ax'
				AND    FieldName    = '#xf#'
				AND   (FieldValue   = '#xv#' or FieldHeader = '#xv#') 
		</cfquery>
		
		</cfif>
				
		<cfif IsNumeric(ys)>
		
			<cfquery name="YValue" 
				datasource="AppsSystem" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT * 
					FROM UserPivotDetail
					WHERE  ControlId    = '#ControlId#' 
					AND SerialNo     = '#ys#' 
			</cfquery>
						
		<cfelse>
		
			<cfquery name="YValue" 
				datasource="AppsSystem" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT *
					FROM UserPivotDetail
					WHERE  ControlId    = '#ControlId#' 
					AND   FieldName    = '#yf#' 
					AND   Presentation = 'Y-ax'
					AND  (FieldValue   = '#yv#' or FieldHeader = '#yv#')  
			</cfquery>
		
		</cfif>
		
		
		<cfquery name="Report" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT * 
				FROM Ref_ReportControlOutput
				WHERE OutputId   = '#Pivot.OutputId#' 
		</cfquery>
		
		<!--- create subset --->
				
		<cfquery name="Fields" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT *
				FROM UserPivotDetail
				WHERE  ControlId    = '#ControlId#'
				AND Presentation = 'Details'
				AND FieldName    = 'Details'  
				ORDER BY ListingOrder 
		</cfquery>
				  
		 <cfset value = "">
		   
		 <cfloop query="Fields">
						 
			   <cfif fielddatatype eq "DateTime" or fielddatatype eq "SmallDateTime">
				   <cfset v = "convert(varchar,#FieldValue#,112) as #FieldValue#"> 
			   <cfelse>
			       <cfset v = "#FieldValue#">
			   </cfif>
						   
			   <cfif currentRow eq "1">
			       <cfset value   = "#v#">
			   <cfelse>
			       <cfset value   = "#value#,#v#">
			   </cfif>	
							
		 </cfloop>
		 
		 <cfoutput>
		 
		 <cfset datasetfilter = "">
		 
		 <cfif Pivot.TableFilter neq "">
			   <cfset datasetfilter = "#replace(Pivot.Tablefilter,"^","'","ALL")#">
		 </cfif>
		 
		 <cfinvoke component="Service.Analysis.CrossTab"  
				  method="Filter"
				  ControlId            = "#controlId#"
				  returnVariable       = "condition"/> 
		 		 
		 <cfsavecontent variable="client.filter">
		 
		     <!--- additional filter still needed, I doubt it 
		     <cfif Pivot.TableFilter neq "">
			     #preserveSingleQuotes(datasetfilter)#
			 </cfif>
			 --->
		 		 
		 	 <cfif af neq "">
				   AND  T.#af# = '#av#'
			 </cfif>	
			   
			 <cfif bf neq "">
				   AND  T.#bf# = '#bv#'
			 </cfif>
			 
			 <cfif YValue.FieldValue neq "">
			 	AND T.#yf# = '#YValue.FieldValue#' 
			 </cfif>
			 
			 <cfif XValue.FieldValue neq "">
				AND T.#xf# = '#XValue.FieldValue#' 
			 </cfif>
			
			 <cfif #filter# neq "">
			    #preserveSingleQuotes(filter)#
			 </cfif>
			 
			 <cfif #condition# neq "">
				   	 #condition# 
				 </cfif>
			 
			 <cfif valfil neq "" and val neq "">
			    AND #valfil# LIKE '#val#%'
			 </cfif>
			 
			 <cfif valfil1 neq "" and val1 neq "">
			    AND #valfil1# LIKE '#val1#%'
			 </cfif>
			 
			  <cfif valfil2 neq "" and val2 neq "">
			    AND #valfil2# LIKE '#val2#%'
			 </cfif>
			 
			  <cfif valfil3 neq "" and val3 neq "">
			    AND #valfil3# LIKE '#val3#%'
			 </cfif>		
			 
			 </cfsavecontent>	  
			 
		</cfoutput>	
				
		<cfquery name="count" 
		datasource="#alias#"
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
             SELECT COUNT(*) as Total
			 FROM  #Table# T
			 WHERE 1=1
			 #PreserveSingleQuotes(client.filter)#			 			 
		</cfquery> 
					
		<cfset tableinfo = structNew()>
		
		<cfparam name="client.PvtRecord" default="10000">
				
		<cfif count.Total lte client.PvtRecord>
		
			 <cfquery name="details" 
			  datasource="#alias#"
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">
			
			     <!---
				 <cfif Frame eq "Grid">
				 --->
				 
					 SELECT   DISTINCT TOP #client.PvtRecord#  
					 <cfif Report.DetailKey neq "">
					          #Report.DetailKey# as DetailId,							 
					 <cfelse> NULL AS DetailId, 					         
					 </cfif>
					 FacttableId AS FactTableId,
					 #value#
					 
					 FROM   #Table# T 
					 
				 <!---	 
				 <cfelse>				
					 SELECT  DISTINCT TOP #client.PvtRecord# DetailId,#value# 
					 FROM   #Table# T 
				 </cfif>
				 --->
				 
				 WHERE 1=1
				 #PreserveSingleQuotes(client.filter)#				
			</cfquery>
			
			<cfset StructInsert(tableinfo, "Content", "#details#")>
								
			<cfquery name="count"
                dbtype="query">
				SELECT COUNT(*) as Total FROM details
			</cfquery> 
				
			<cfset StructInsert(tableinfo, "RecordCount", "#count.Total#")>
								
		<cfelse>
		
		    <cfset StructInsert(tableinfo, "RecordCount", "#count.Total#")>
			<cfset StructInsert(tableinfo, "Content", "0")>
			
		</cfif>
		
		<cfreturn tableinfo>
		
		
</cffunction>
  
<cffunction name="loadGraph" access="remote" returntype="query">
	
	  <cfargument name="controlid"   required="true"  type="string">	
	  <cfargument name="alias"       required="true"  type="string">	
	  <cfargument name="table"       required="true"  type="string">		 
	  <cfargument name="selected"    type="array" required="yes">
	  <cfargument name="filter"      required="false"  type="string">	
	  <cfargument name="valfil"      required="false"  type="string" default="">
	  <cfargument name="val"         required="false"  type="string" default="">	
	  <cfargument name="valfil1"     required="false"  type="string" default="">
	  <cfargument name="val1"        required="false"  type="string" default="">	
	  <cfargument name="valfil2"     required="false"  type="string" default="">
	  <cfargument name="val2"        required="false"  type="string" default="">	
	  <cfargument name="valfil3"     required="false"  type="string" default="">
	  <cfargument name="val3"        required="false"  type="string" default="">	
	  <cfargument name="dimension"   type="string" required="no" default="">
	 	 		
		<cfquery name="SystemParam" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT    * 
			FROM      Parameter 
		</cfquery>
						
		<cfset aut_server = "#SystemParam.AuthorizationServer#">
		
		<cfquery name="Pivot" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT * 
				FROM   UserPivot
				WHERE  ControlId    = '#ControlId#' 
		</cfquery>
		
		<cfset datasetfilter = "#replace(Pivot.Tablefilter,"^","'","ALL")#">
					 
		<cfif dimension eq "">
						
			<cfquery name="dim" 
			datasource="AppsSystem">
			    SELECT    DISTINCT FieldName
				FROM      UserPivotDimension D
				WHERE     Presentation = 'Y-ax' 
				AND       ControlId = '#ControlId#' 
			</cfquery>
			
			<cfset dimension = "#dim.fieldName#">
		
		</cfif>
					
		<cfset l = len(dimension)>	
		<cfset f = left("#dimension#",l-4)>
					
		<cfquery name="Field" 
			 datasource="appsSystem">
				SELECT  *   
				FROM    UserReportOutput
				WHERE   UserAccount = '#SESSION.acc#'
				AND     OutputId    = '#Pivot.OutputId#'
				AND     OutputClass = 'Detail' 
				AND     FieldName   = '#f#_nme'
			</cfquery>	
			
		<cfif field.recordcount eq "0">
			<cfset Desc = "#dimension#">
		<cfelse>
		    <cfset Desc = "#f#_nme"> 
		</cfif>		
				
		<cfquery name="Field" 
			 datasource="appsSystem">
					SELECT  *   
					FROM    UserReportOutput
					WHERE   UserAccount = '#SESSION.acc#'
					AND     OutputId    = '#Pivot.OutputId#'
					AND     OutputClass = 'Detail' 
					AND     FieldName   = '#f#_ord' 
			</cfquery>		
			
		<cfif field.recordcount eq "0">
			<cfset Ord  = "#dimension#">
		<cfelse>
		    <cfset Ord  = "#f#_ord"> 
		</cfif>		
		
		 <cfif Pivot.TableFilter neq "">
			   <cfset datasetfilter = "#replace(Pivot.Tablefilter,"^","'","ALL")#">
		 </cfif>
		
		<!--- generate dimension for Pie chart detail table --->
		
		<cfinvoke component="Service.Analysis.CrossTab"  
			  method="GenerateDimension"
			  ControlId            = "#controlid#"
			  Dimension            = "Graph1"
			  factalias            = "#alias#"
			  facttable            = "#table#"
			  alias                = "#alias#"
			  table                = "#table# T"
			  Condition            = "#datasetfilter#"
			  FieldName            = "#dimension#"
			  FieldValue           = "#dimension#"
			  FieldWidth           = "80"
			  FieldTooltip         = "#desc#"
			  FieldListingOrder    = "#ord#"
			  FieldHeader          = "#desc#"
			  FieldDataType        = "varchar">	 
		
		<cfset id = "">		
		
			<cfloop index="i" from="1" to="#ArrayLen(selected)#">
				 <cfif id eq "">
				     <cfset id = "'#selected[i].FactTableId#'">
				 <cfelse>
				     <cfset id = "#id#,'#selected[i].FactTableId#'">
				 </cfif>
			</cfloop>		
		
			<cfinvoke component="Service.Analysis.CrossTab"  
				  method="Filter"
				  ControlId            = "#controlId#"
				  returnVariable       = "condition"/> 
		
			<cfquery name="formula" 
			datasource="AppsSystem">
			    SELECT    DISTINCT * 
				FROM      UserPivotDetail D
				WHERE     Presentation LIKE 'Formula%' 
				AND       ControlId = '#ControlId#' 
			</cfquery>
			
		<cfoutput>	
			
			<cfsavecontent variable="filt">
			
				<!--- this is the initial filter from HTML --->	
				 <cfif datasetfilter neq "">
				     #datasetfilter#
				 </cfif>
						 				 				
				 <cfif condition neq "">
				   	 #condition# 
				 </cfif>
					 
				 <cfif valfil neq "" and val neq "">
				     AND #valfil# LIKE '#val#%'
				 </cfif>
					 
				 <cfif valfil1 neq "" and val1 neq "">
				    AND #valfil1# LIKE '#val1#%'
				 </cfif>
					 
				 <cfif valfil2 neq "" and val2 neq "">
					AND #valfil2# LIKE '#val2#%'
				 </cfif>
					 
				 <cfif valfil3 neq "" and val3 neq "">
					AND #valfil3# LIKE '#val3#%'
				 </cfif>
										
			</cfsavecontent>	
		
		</cfoutput>
			
		<cfquery name="summary" 
			  datasource="#alias#"  
			  username="#SESSION.login#" 
		      password="#SESSION.dbpw#">
				 SELECT    <cfloop query="formula">
						   #fieldname# as Total#currentRow# <cfif recordcount neq currentRow>,</cfif>
						   </cfloop>
				 FROM      #Table#
				 WHERE     1=1 
				 #preservesingleQuotes(filt)#
	    </cfquery>		
							
		<cfquery name="graph" 
			  datasource="#alias#"  
			  username="#SESSION.login#" 
		      password="#SESSION.dbpw#">
				 SELECT    D.FieldHeader, 
				 
						   <cfloop query="formula">
						   
						   <cfif fielddatatype neq "Percentage" or formula.recordcount eq "1">
							   #fieldname# as Formula#currentrow#, 
							   #fieldname# as Cell#currentrow#,		
							   					   
							   <cfif evaluate("summary.total#CurrentRow#") neq "">
							   	convert(float(2),#fieldname#)/convert(float(2),
								#evaluate("summary.total#CurrentRow#")#)*100 as Percent#currentRow#, 
							   <cfelse>
							    0 as Percent#currentRow# as Percent#currentRow#,
							   </cfif>
						   </cfif>
						   
						   </cfloop>
				           D.ListingOrder
					   
				 FROM      #Table# T,
				           [#aut_server#].System.dbo.UserPivotDetail D
				 WHERE     1=1
				 <cfif ArrayLen(selected) gt "1">
				 AND       T.FactTableId IN (#preserveSingleQuotes(id)#)
				</cfif>
				 AND       D.ControlId   = '#ControlId#'
				 AND       D.Presentation = 'Graph1'
				 AND       D.FieldValue =  #dimension# 
						 #preservesingleQuotes(filt)#
				 GROUP BY D.FieldHeader, D.ListingOrder
				 ORDER BY D.ListingOrder 		
				 
	    </cfquery>	
								 
		<cfreturn graph>
	  
  </cffunction>	  
 
    
  <!--- PENDING development DATA FILTER table --->
    
  <cffunction name="criteriaField" access="remote" returnType="XML">
	
	    <cfargument name="ds"    required="true"  default="userquery"                 type="string">
		<cfargument name="table" required="true"  default="administratorPosition" type="string">
				
		<cfquery name="fields" 
			datasource="#ds#">
			SELECT   DISTINCT C.name, colid
			FROM     sysobjects S INNER JOIN
		             syscolumns C ON S.id = C.id INNER JOIN
		             systypes ON C.xtype = systypes.xtype
		    WHERE    S.id = C.id
			AND      S.name = '#table#'	
			AND      C.UserType NOT IN ('0','20','3','19','4') 
			AND     ( C.Name LIKE '%_dim')
			<!--- AND      C.Name NOT LIKE '%_ord'  --->
		    ORDER BY C.Name  
		</cfquery>
		
		<cfsavecontent variable="tree">
		
		<list>
		
		<cfoutput query="fields">
		
		<!--- check if description field exists --->
				
			<cfif findNoCase("_dim",name)>
		      <cfset l = #len(name)#>		
		      <cfset head = left("#name#",l-4)>
			<cfelseif findNoCase("_nme",name)>
		      <cfset l = #len(name)#>		
		      <cfset head = left("#name#",l-4)>  
			  <cfset head = "#head# name">
		    <cfelse>
    		  <cfset head = name>  
	    	</cfif>  
	
			 <dimension Name="#name#" Drag="dragno" Load="0" Display="#head#"/>
							
		</cfoutput>
		
		</list>
		
		</cfsavecontent>
					
		<cfreturn tree>
				
	</cffunction>
	
	
	<!--- filtering --->

	<cffunction name="criteriaValue" access="remote" returnType="query">
	
		<cfargument name="controlid"  required="true"  type="string">
	    <cfargument name="ds"    required="true"  default="userquery"                 type="string">
		<cfargument name="table" required="true"  default="dbo.administratorPosition" type="string">
		<cfargument name="field" required="true"  default="xxxxx" type="string">		
		
		<cfquery name="Pivot" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT * 
				FROM UserPivot
				WHERE ControlId    = '#ControlId#' 
		</cfquery>
				
		<cfquery name="format" 
			 datasource="appsSystem">
					SELECT  TOP 1 OutputFormat
					FROM    UserReportOutput
					WHERE   UserAccount = '#SESSION.acc#'
					AND     OutputId    = '#Pivot.OutputId#'
					AND     FieldName   = '#field#' 
		</cfquery>		
			
		<cfif format.OutputFormat eq "DateTime" or format.OutputFormat eq "SmallDateTime">
		   <cfset v = "convert(varchar,#Field#,112)"> 
		   <cfset o = "#field#">
		   
		<cfelse>
		
			<!--- check if description field exists --->
			
			<cfset l = #len(field)#>	
			<cfset code = left("#field#",l-4)>
		
			<cfquery name="check" 
			datasource="#ds#">
				SELECT   *
				FROM     sysobjects S INNER JOIN
			             syscolumns C ON S.id = C.id INNER JOIN
			             systypes ON C.xtype = systypes.xtype
			    WHERE    S.id = C.id
				AND      S.name = '#table#'	
				AND      C.Name = '#code#_nme' 
			</cfquery>
			
			<cfif Check.recordcount eq "1">
				 <cfset v = "#code#_nme">		
				 <cfset o = "#code#_nme">
			<cfelse>
				 <cfset v = "#Field#">
				 <cfset o = "#field#">
			</cfif>
			
			<cfquery name="check" 
			datasource="#ds#">
				SELECT   *
				FROM     sysobjects S INNER JOIN
			             syscolumns C ON S.id = C.id INNER JOIN
			             systypes ON C.xtype = systypes.xtype
			    WHERE    S.id = C.id
				AND      S.name = '#table#'	
				AND      C.Name = '#code#_ord' 
			</cfquery>
			
			<cfif Check.recordcount eq "1">
				 <cfset o = "#code#_ord">
			<cfelse>
				 <cfset o = "#field#">
			</cfif>
		
		</cfif>
		
		 <cfif #Pivot.TableFilter# neq "">
			   <cfset datasetfilter = "#replace(Pivot.Tablefilter,"^","'","ALL")#">
		 </cfif>
			
		<cfquery name="fields" 
			datasource="#ds#"			 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT DISTINCT '#v#' as Field, 
			                #v# as Value, 
							#o# as ValueOrder,
			                '#format.OutputFormat#' as Format 
			FROM     #table#
			WHERE    #field# <> '' and #field# is not NULL
			<cfif #Pivot.TableFilter# neq "">
			     #preserveSingleQuotes(datasetfilter)#
			 </cfif>
		    ORDER BY #o# 
		</cfquery>
		
		<cfreturn fields>
		
	</cffunction>
	
	<cffunction name="filterSave" access="remote">
	
	    <cfargument name="controlid"       required="true"  type="string">
		<cfargument name="fieldname"       required="true"  type="string">
		<cfargument name="filteroperator"  required="true"  type="string">
		<cfargument name="filtervalue"     required="true"  type="string">
		
		<cfquery name="Check" 
			 datasource="appsSystem" 
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
			 SELECT *
			 FROM UserPivotFilter
			 WHERE ControlId   = '#ControlId#'
			 AND  FilterMode   = 'Subset'
			 AND  FieldName    = '#FieldName#'
			 AND  FilterValue  = '#filtervalue#' 
	    	</cfquery>
			
			<cfif check.recordcount eq "0">
						
				<cfquery name="Last" 
				 datasource="appsSystem" 
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">
				 SELECT Max(FilterSerialNo) as No
				 FROM UserPivotFilter
				 WHERE ControlId = '#ControlId#'
				 AND  FilterMode = 'Subset'
		    	</cfquery>
				
				<cfif Last.No eq "">
				   <cfset ser = 1>
				<cfelse>
				   <cfset ser = #Last.No#+1>
				</cfif>
						
				<cfquery name="Insert" 
				 datasource="appsSystem" 
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">
				 INSERT INTO UserPivotFilter
				 (ControlId, 
				  FilterSerialNo, 
				  FilterMode, 
				  FieldName, 
				  FilterOperator, 
				  FilterValue)
				 VALUES
				 ('#controlid#',
				  #ser#,
				  'Subset',
				  '#fieldname#',
				  '#filteroperator#',
				  '#filtervalue#')
				</cfquery>
			
			</cfif>
				
			<cfquery name="List" 
			 datasource="appsSystem" 
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
			 SELECT   *
			 FROM     UserPivotFilter
			 WHERE    ControlId = '#ControlId#'
			 AND      FilterMode = 'Subset'
			 ORDER BY FilterSerialNo
	    	</cfquery>
		
		<cfreturn List>
				
	</cffunction>	
	
	<cffunction name="filterDelete" access="remote">
	
	    <cfargument name="controlid"    required="true"  type="string">
		<cfargument name="selected"    required="true"  type="array">
					
		<cfloop index="i" from="1" to="#ArrayLen(selected)#" step="1">
					
			<cfquery name="Delete" 
			 datasource="appsSystem" 
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
			 DELETE FROM UserPivotFilter
			 WHERE ControlId = '#controlid#'
			 AND FilterSerialNo = '#selected[i].FilterSerialNo#'
	    	</cfquery>
		
		</cfloop>
		
		<cfquery name="List" 
		 datasource="appsSystem" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
		 SELECT *
		 FROM UserPivotFilter
		 WHERE ControlId = '#ControlId#'
		 AND  FilterMode = 'Subset'
		 ORDER BY FilterSerialNo
    	</cfquery>
		
		<cfreturn List>
				
	</cffunction>
	
</cfcomponent>		
