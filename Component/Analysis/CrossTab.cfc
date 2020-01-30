  
  <cfcomponent>

    <cfproperty name="name" type="string">
    <cfset this.name = "Crosstab">
	
	<cffunction access="public" name="ShowInquiry" 
	         output="true" 
			 returntype="string" 
			 displayname="Show a button to the user">		
			 			 			 
	<cfargument name="ButtonName"     		type="string"  required="yes"   default="Inquiry">		 
	<cfargument name="ButtonClass"    		type="string"  required="yes"   default="ButtonFlat">			 
	<cfargument name="ButtonIcon"     		type="string"  required="yes"   default="excel.png">			 
	<cfargument name="ButtonText"     		type="string"  required="yes"   default="">			 
	<cfargument name="ButtonStyle"    		type="string"  required="yes"   default="">			 
	<cfargument name="ButtonWidth"    		type="string"  required="yes"   default="180px">
	<cfargument name="ButtonHeight"   		type="string"  required="yes"   default="30px">
	<cfargument name="ButtonBGColor"  		type="string"  required="yes"   default="f4f4f4">
	<cfargument name="ButtonTextSize" 		type="string"  required="yes"   default="13px">
	<cfargument name="ButtonTextColor" 		type="string"  required="yes"   default="black">
	<cfargument name="ButtonBorderColor" 	type="string"  required="yes"   default="##6B6B6B">
	<cfargument name="ButtonBorderColorInit" type="string"  required="yes"   default="silver">
	<cfargument name="ButtonBorderRadius" 	type="string"  required="yes"   default="6px">
	<cfargument name="ButtonOnmouseover" 	type="string"  required="yes"   default="this.style.border='1px solid #ButtonBorderColor#';">
	<cfargument name="ButtonOnmouseout" 	type="string"  required="yes"   default="this.style.border='1px solid #ButtonBorderColorInit#';">
	
	
	<cfargument name="Module"         type="string"  required="yes"   default="Reporting">
	<cfargument name="ReportName"     type="string"  required="yes"   default="My report">
	<cfargument name="DataSource"     type="string"  required="yes"   default="AppsQuery">
	
	<cfargument name="OutputId"       type="string"  required="yes"   default="">
	
	<!--- pass the datasets NEW --->
	<cfargument name="datasets"       type="array"   required="no"    default="#ArrayNew(1)#">
	
	<!--- pass the datasets OLD --->
	<cfargument name="Table1Name"     type="string"  required="yes"   default="">
	<cfargument name="Table1Class"    type="string"  required="yes"   default="variable">
	<cfargument name="Table1"         type="string"  required="yes"   default="table1">
	<cfargument name="Table1Drill"    type="string"  required="yes"   default="">
	<cfargument name="Table1DrillField"  type="string"  required="yes"   default="">
	<cfargument name="Table2Name"     type="string"  required="yes"   default="">
	<cfargument name="Table2Class"    type="string"  required="yes"   default="variable">
	<cfargument name="Table2"         type="string"  required="yes"   default="table2">
	<cfargument name="Table2Drill"    type="string"  required="yes"   default="">
	<cfargument name="Table2DrillField"  type="string"  required="yes"   default="">
	<cfargument name="Table3Name"     type="string"  required="yes"   default="">
	<cfargument name="Table3Class"    type="string"  required="yes"   default="variable">
	<cfargument name="Table3"         type="string"  required="yes"   default="table3">
	<cfargument name="Table3Drill"    type="string"  required="yes"   default="">
	<cfargument name="Table3DrillField"  type="string"  required="yes"   default="">
	<cfargument name="Table4Name"     type="string"  required="yes"   default="">
	<cfargument name="Table4Class"    type="string"  required="yes"   default="variable">
	<cfargument name="Table4"         type="string"  required="yes"   default="table4">
	<cfargument name="Table4Drill"    type="string"  required="yes"   default="">
	<cfargument name="Table4DrillField"  type="string"  required="yes"   default="">
	<cfargument name="Table5Name"     type="string"  required="yes"   default="">
	<cfargument name="Table5Class"    type="string"  required="yes"   default="variable">
	<cfargument name="Table5"         type="string"  required="yes"   default="table5">
	<cfargument name="Table5Drill"    type="string"  required="yes"   default="">
	<cfargument name="Table5DrillField"  type="string"  required="yes"   default="">
	<cfargument name="Table6Name"     type="string"  required="yes"   default="">
	<cfargument name="Table6Class"    type="string"  required="yes"   default="variable">
	<cfargument name="Table6"         type="string"  required="yes"   default="table6">
	<cfargument name="Table6Drill"    type="string"  required="yes"   default="">
	<cfargument name="Table6DrillField"  type="string"  required="yes"   default="">
	<cfargument name="Table7Name"     type="string"  required="yes"   default="">
	<cfargument name="Table7Class"    type="string"  required="yes"   default="variable">
	<cfargument name="Table7"         type="string"  required="yes"   default="table7">
	<cfargument name="Table7Drill"    type="string"  required="yes"   default="">
	<cfargument name="Table7DrillField"  type="string"  required="yes"   default="">
	<cfargument name="Table8Name"     type="string"  required="yes"   default="">
	<cfargument name="Table8Class"    type="string"  required="yes"   default="variable">
	<cfargument name="Table8"         type="string"  required="yes"   default="table7">
	<cfargument name="Table8Drill"    type="string"  required="yes"   default="">
	<cfargument name="Table8DrillField"  type="string"  required="yes"   default="">
		
	<cfargument name="Target"         type="string"  required="yes"   default="_blank">
	<cfargument name="ReportPath"     type="string"  required="yes"   default="">
	<cfargument name="Data"           type="string"  required="yes"   default="1">
	<cfargument name="scriptfunction" type="string"  required="yes"   default="facttablexls">
	<cfargument name="SQLTemplate"    type="string"  required="yes"   default="">
	<cfargument name="QueryString"    type="string"  required="yes"   default="">
	<cfargument name="SelectedId"     type="string"  required="yes"   default="">
	<cfargument name="Filter"         type="string"  required="yes"   default="1">
	<cfargument name="Ajax"           type="string"  required="yes"   default="0">
	<cfargument name="Excel"          type="string"  required="yes"   default="0">
	<cfargument name="OLAP"           type="string"  required="yes"   default="0">
	<cfargument name="Report"         type="string"  required="yes"   default="0">
	<cfargument name="Fileno"         type="string"  required="yes"   default="">
	<cfargument name="Invoke"         type="string"  required="yes"   default="No">
						
	<!--- register this fact table --->
	
	<cfquery name="Layout" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT    ControlId
		FROM      Ref_ReportControl R
	    WHERE     FunctionName = '#ReportName#' 
		AND       TemplateSQL  = 'Application' 
		AND       SystemModule = '#Module#' 
	</cfquery>		
	
	<cfquery name="System" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT    *
		FROM      Parameter	 
	</cfquery>
		
	<cfset dbserver = system.databaseserver>
		
	<cfif Layout.recordcount gte "1">
	
		<cfset controlId = layout.controlId>
	
		<cfquery name="Update" 
		datasource="AppsSystem"
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			UPDATE Ref_ReportControl
			SET   ReportPath   = '#ReportPath#\#SQLTemplate#',
				  FunctionName = '#ReportName#' 
			WHERE ControlId    = '#controlid#' 
		</cfquery>	
		
	<cfelse>
			
		<cf_AssignId>
		
		<cfset controlid = "#rowguid#">
		
		<!--- create the menu if needed class --->
		
		<cftry>
	
		<cfquery name="classcheck" 
				datasource="appsSystem"
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT * FROM [#dbserver#].System.dbo.Ref_ReportMenuClass
				WHERE SystemModule = '#Module#'
				AND   MenuClass    = 'Reports'				
		</cfquery>		
			
		<cfif classcheck.recordcount eq "0">
			
			<cfquery name="insertclass" 
				datasource="appsSystem"
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				INSERT INTO [#dbserver#].System.dbo.Ref_ReportMenuClass
				(SystemModule,MenuClass,Description)
				VALUES	
				('#Module#','Reports','Reports')			
			</cfquery>		
			
		</cfif>
		
		<cfcatch></cfcatch>
		
		</cftry>
						
		<cfquery name="Insert" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		INSERT INTO Ref_ReportControl
				(ControlId,
				 SystemModule, 
				 FunctionClass, 
				 FunctionName, 
				 ReportRoot,
				 ReportPath,
				 TemplateSQL, 
				 OfficerUserId, 
				 OfficerLastName, 
				 OfficerFirstName)
		 VALUES ('#rowGuid#',
		         '#Module#',
		         'Reports',
				 '#ReportName#',
				 'Application',
				 '#ReportPath#\#SQLTemplate#',
				 'Application',
		         '#SESSION.acc#',
				 '#SESSION.last#',
				 '#SESSION.first#')
		</cfquery>	
		
	</cfif>	
	
	<cftransaction>
	
	<cfquery name="TableSet" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT    ControlId
		FROM      Ref_ReportControlLayout R
	    WHERE     ControlId = '#ControlId#'
		AND       TemplateReport = 'Excel' 
	</cfquery>
	
	<cfif TableSet.recordcount eq "0">
		
		<cfquery name="Insert" 
				datasource="AppsSystem" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				INSERT INTO Ref_ReportControlLayout
					(ControlId, 
					 LayoutName, 
					 TemplateReport, 
					 OfficerUserId, 
					 OfficerLastName, 
					 OfficerFirstName) 
				 VALUES
					 ('#controlId#',
					  'Export Fields to MS-Excel',
					   'Excel',
					   '#SESSION.acc#',
					   '#SESSION.last#',
					   '#SESSION.first#')
				</cfquery>
				
	</cfif>	
	
	<!--- record layouts 
	
	<cfloop index="itm" from="1" to="5">
			
		<cfset name   = evaluate("Report#itm#Name")>
					
		<cfif name neq "">
		
			<cfset mfile   = evaluate("Report#itm#File")>
		
			<cfif  UCase(Right(mFile,3)) eq ".CFM">
			  <cfset class = "View">
			<cfelse>
			  <cfset class = "Report">  
			</cfif>
		
			<cfquery name="Layout" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT    ControlId
				FROM      Ref_ReportControlLayout
			    WHERE     ControlId   = '#ControlId#'
				AND       LayoutName  = '#name#' 
			</cfquery>
		
			<cfif layout.recordcount eq "0">
					
				<cfquery name="Insert" 
				datasource="AppsSystem" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				INSERT INTO Ref_ReportControlLayout
					(ControlId, 
					 LayoutClass,
					 LayoutName, 
					 TemplateReport, 
					 OfficerUserId, 
					 OfficerLastName, 
					 OfficerFirstName) 
				 VALUES
				 ('#controlId#',
				  '#class#',
				  '#name#',
				  '#mfile#', 
				  '#SESSION.acc#',
				  '#SESSION.last#',
				  '#SESSION.first#')
				</cfquery>
			
			</cfif>	
			
		</cfif>
						
		</cfloop>	
		
	--->	
	
	<cfif arrayLen(datasets) gte "1">		
		
		<cfset len = arrayLen(datasets)>
		
	<cfelse>
	
		<cfset len = "8">	
		
	</cfif>
										
	<cfloop index="itm" from="1" to="#len#">	
			
		<cfparam name="Table#itm#Name" default="">
		
		<cfif arrayLen(datasets) gte "1">	
													
				<cfset tble     = "#datasets[itm].table#">
				<cfset clss     = "#datasets[itm].tableClass#">
				<cfset name     = "#datasets[itm].tableName#">
				<cfset drill    = "#datasets[itm].tableDrill#">
				<cfset field    = "#datasets[itm].TableField#">
						
		<cfelse>
		
				<cfset tble  = evaluate("Table#itm#")>		
				<cfset clss  = evaluate("Table#itm#Class")>		
				<cfset name  = evaluate("Table#itm#Name")>		
				<cfset drill = evaluate("Table#itm#Drill")>
				<cfset field = evaluate("Table#itm#DrillField")>
		
		</cfif>
				
		<cfif field eq "">
		   <cfset field = "facttableid">		
		</cfif>
											
		<cfif name neq "" and outputid eq "">
														
				<cfquery name="Layout" 
				datasource="AppsSystem" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				    SELECT    ControlId
					FROM      Ref_ReportControlOutput R
				    WHERE     ControlId    = '#ControlId#'				
					AND       VariableName = '#tble#' 				
				</cfquery>
			
				<cfif layout.recordcount eq "0">
						
					<cfquery name="Insert" 
					datasource="AppsSystem" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					INSERT INTO Ref_ReportControlOutput
							(ControlId, 
							 DataSource, 
							 OutputClass,
							 VariableName, 
							 OutputName, 
							 DetailTemplate,
							 DetailKey,
							 OfficerUserId, 
							 OfficerLastName, 
							 OfficerFirstName) 
					 VALUES
						    ('#controlId#',
							 '#DataSource#', 
							 '#clss#',
							 '#tble#', 
							 '#name#',
							 '#drill#',
							 '#field#',
							 '#SESSION.acc#',
							 '#SESSION.last#',
							 '#SESSION.first#')
					</cfquery>
					
					<cfquery name="Clean" 
					datasource="AppsSystem" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					    DELETE FROM Ref_ReportControlOutput 
					    WHERE     ControlId    = '#ControlId#'				
						AND       OutputClass  = 'variable' 	
						AND       Created < getdate()-1			
					</cfquery>
					
				<cfelse>
								
					<cfquery name="Layout" 
					datasource="AppsSystem" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					    UPDATE    Ref_ReportControlOutput
						SET       Created      = getDate(), 
						          Datasource   = '#datasource#'
					    WHERE     ControlId    = '#ControlId#'				
						AND       VariableName = '#tble#' 									
					</cfquery>				
				
				</cfif>	
				
				
		<cfelseif name neq "" and outputid neq "">			 
			
			 <cfquery name="Clean" 
				datasource="AppsSystem" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				    DELETE FROM Ref_ReportControlOutput
				    WHERE     OutputId     = '#OutputId#' 			
					AND       ControlId != '#controlid#'
			</cfquery>
							
			<cfquery name="Output" 
				datasource="AppsSystem" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				    SELECT    ControlId
					FROM      Ref_ReportControlOutput R
				    WHERE     OutputId     = '#OutputId#' 			
				</cfquery>
			
				<cfif output.recordcount eq "0">
						
					<cfquery name="Insert" 
					datasource="AppsSystem" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						INSERT INTO Ref_ReportControlOutput
							(ControlId, 
							 OutputId, 
							 DataSource, 
							 OutputClass,
							 VariableName, 
							 OutputName, 
							 OfficerUserId, 
							 OfficerLastName, 
							 OfficerFirstName) 
						 VALUES ('#controlId#',
							  '#OutputId#',
							  '#DataSource#',
							   'variable',
							   'table#itm#', 
							   '#name#',
							   '#SESSION.acc#',
							   '#SESSION.last#',
							   '#SESSION.first#')
					</cfquery>
					
				<cfelse>
				
					<cfquery name="Output" 
				datasource="AppsSystem" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				    UPDATE    Ref_ReportControlOutput
					SET       DataSource     = '#datasource#',
					          DetailTemplate = '#drill#'
				    WHERE     ControlId    = '#ControlId#'				
					AND       OutputId     = '#OutputId#'					 				
				</cfquery>
				
				</cfif>	
				
		</cfif>
						
		</cfloop>	
			
	</cftransaction>
	
	<cfoutput>		
	
	<!--- determine values on the fly in querystring { } --->
	
	<cfset start = "1">
	<cfset new   = "#querystring#">
	
	<cfloop condition="#start# lte #len(new)#">
		
		<cfif find("{","#new#",start)>
				
			<cfset str = find("{","#new#",start)>
			<cfset str = str+1>
			<cfset end = find("}","#new#",start)>
			<cfset end = end>
			
			<cfset fld = Mid(new, str, end-str)>
			<cfset qry = "'+document.getElementById('#fld#').value+'">			
			<cfset new = replace(new,"{#fld#}","#qry#")>  
			
			<cfset start = end>
			
		<cfelse>
		
			<cfset start = len(new)+1>	

		</cfif> 
	
	</cfloop>		
	
	<cfset querystring = new>
						
	<cfif ajax eq "0">	
			
		<script language="JavaScript">
				
			function facttable0(controlid,format,filter,qry) {
																		
				w = #CLIENT.widthfull# - 80;
			    h = #CLIENT.height# - 110;		
				
				<cfif invoke eq "Yes">
					<cfset target = "invokedetail">			
				</cfif>			
																																		
				if (qry == "undefined" || qry == "") {	
				    ptoken.open("#SESSION.root#/component/analysis/CrossTabLaunch.cfm?ts="+new Date().getTime()+"&#QueryString#&fileno=#fileno#&controlid="+controlid+"&filter="+filter+"&data=#Data#&format="+format, "#target#");  				   		
				} else {	
				    ptoken.open("#SESSION.root#/component/analysis/CrossTabLaunch.cfm?ts="+new Date().getTime()+"&fileno=#fileno#&controlid="+controlid+"&"+qry+"&filter="+filter+"&data=#Data#&format="+format, "#target#"); 							    
				}
			
			}
			
			<!--- save into a client variable at runtime --->
			
			function facttablexls0(controlid,format,filter,qry,dsn) {		
										
			    <cfif selectedid neq ''>								
				    ColdFusion.Ajax.submitForm('formselectedid','#SESSION.root#/component/analysis/CaptureSelectedId.cfm')						    				
				</cfif>
				w = #CLIENT.width# - 100;
			    h = #CLIENT.height# - 110;	
			    ptoken.open("#SESSION.root#/component/analysis/CrossTabLaunch.cfm?dsn="+dsn+"&fileno=#fileno#&controlid="+controlid+"&"+qry+"&filter="+filter+"&data=#data#&format="+format+"&ts="+new Date().getTime(), "ExcelExport");
			}
						
		</script>
	
	</cfif>
	
	<cfset scriptvalue = "">
	
	<!--- --------------- --->
	<!--- button for OLAP --->
	<!--- --------------- --->
	
	<cfif selectedid neq "">
		<!--- capture the selected values --->
		<form method="post" name="formselectedid" id="formselectedid">		
			<input type="hidden" name="fieldselectedid" id="fieldselectedid" value="#selectedid#">
		</form>
	</cfif>
			
	<cfif OLAP eq "1">	
			
			<cfif invoke eq "No">
			
				 <cfif buttonClass eq "td">
							
				<cfsavecontent variable="selectme">
				        style="cursor: pointer;padding:2px"
						onMouseOver="this.className='labelit highlight1'"
						onMouseOut="this.className='labelit'"
				</cfsavecontent>
												
				<td class="labelit" onclick="facttable#ajax#('#controlid#','analyse','#filter#','#querystring#')" #selectme#>
				   <img align="absmiddle" height="14" width="14" src="#ButtonIcon#" border="0">&nbsp;#ButtonText#							   				   
				</td>
			
				<cfelseif buttonClass neq "variable">
									
					<button name="#ButtonName#" 
						class="#Buttonclass#" 
						type="button"
						style="#ButtonStyle#" 
						onClick="facttable#ajax#('#controlid#','analyse','#filter#','#querystring#')">
					#ButtonText#
					<cfif ButtonIcon neq "">
					&nbsp;<img align="absmiddle" src="#ButtonIcon#" border="0">
					</cfif>
				</button>
							
				<cfelse>
				
				   <cfset scriptvalue = "facttable#ajax#('#controlid#','analyse','#filter#','#querystring#')">
				
				</cfif>
			
			<cfelse>
			
				<!--- directly invoke the analysis set --->
			
				<script>				
				  		facttable0('#controlid#','analyse','#filter#','#querystring#')					
				</script>
			
			</cfif>
			
	</cfif>
			
	<cfif Excel eq "1">
		
	        <cfif buttonClass eq "td">
							
				<cfsavecontent variable="selectme">
				        style="cursor: pointer;padding:2px"
						onMouseOver="this.className='labelit highlight1'"
						onMouseOut="this.className='labelit'"
				</cfsavecontent>
								
				<td class="labelit" onclick="#scriptfunction##ajax#('#controlid#','excel','#filter#','#querystring#','#datasource#')" #selectme#>
				   <img align="absmiddle" height="14" width="14" src="#SESSION.root#/images/excel.png" border="0">&nbsp;#ButtonText#							   				   
				</td>
			
			<cfelse>
			
				<cfif buttonclass eq "standard">
														
					<cf_button2 
						text        = "#ButtonText#" 
						image       = "#ButtonIcon#"
						onClick     = "#scriptfunction##ajax#('#controlid#','excel','#filter#','#querystring#','#datasource#')"					
						id          = "exportexcel"					
						width       = "#ButtonWidth#"
						height		= "#ButtonHeight#"
						textsize    = "#ButtonTextSize#"
						textColor	= "#ButtonTextColor#"
						bgColor     = "#ButtonBGColor#"
						style		= "#ButtonStyle#"
						borderColor = "#ButtonBorderColor#"
						borderRadius= "#ButtonBorderRadius#"
						onmouseover = "#ButtonOnmouseover#"  
						onmouseout 	= "#ButtonOnmouseout#">
				
				<cfelse>
																		
			    <button name="#ButtonName#" 
				    class="#Buttonclass#" 
					type="button"
					style="#ButtonStyle#" 
					onClick="#scriptfunction##ajax#('#controlid#','excel','#filter#','#querystring#','#datasource#')">
				    #ButtonText#<cfif ButtonIcon neq "">
					&nbsp;<img style="vertical-align:middle;top:-1px;position: relative;" align="absmiddle" height="24" width="auto" src="#session.root#/images/#ButtonIcon#" border="0">		
					</cfif>				
			    </button>
				
				</cfif>
							
			</cfif>
					
	</cfif>
	
	<cfif Report eq "1">
		
		    &nbsp;
		    <button name="#ButtonName#" type="button" class="#Buttonclass#" style="#ButtonStyle#" onClick="facttablexls#ajax#('#controlid#','report','#filter#','#querystring#')">
		    <cfif ButtonText eq "">Report<cfelse>#ButtonText#</cfif> 		  
		    </button>	   
			
	</cfif>
	
	<cfreturn scriptvalue>
	
			
	</cfoutput>
	
	<!--- buttons opens a new forms on the full width in which the variables are passed --->
			 			 
	</cffunction>		
			
	<!--- HEADER --->
	
	<cffunction access="public" name="Header" 
	         	output="true" 
				returntype="string" 
				displayname="Header">						
			 
		<cfargument name="ControlId"  type="string" required="yes"   default="">
		<cfargument name="SourceId"   type="string" required="no"    default=""> 	
		<cfargument name="Alias"      type="string" required="no"    default=""> 	
		<cfargument name="PivotTable" type="string" required="no"    default=""> 	
		<cfargument name="formulaM"   type="string" required="no"    default=""> 
		<cfargument name="Node"       type="string" required="no"    default=""> 
		<cfargument name="Format"     type="string" required="no"    default="HTML"> 
				
		<!---
		<cfargument name="Pivot100"   type="string" required="yes"   default="0">
		--->
		
		<!--- determine with of the Pivot output --->
		
		<!--- cols --->
		
			<cfquery name="Cols" 
				datasource="appsSystem">
				SELECT   count(*) as cols
			    FROM     UserPivotDetail
				WHERE    ControlId= '#ControlId#' 
				AND      Presentation IN ('X-ax')  
			</cfquery>
			
			<!--- forms --->
			
			<cfquery name="Frm" 
				datasource="appsSystem">
				SELECT   count(*) as cols
			    FROM     UserPivotDetail
				WHERE    ControlId = '#ControlId#' 
				AND      Presentation LIKE 'Formula%'  
			</cfquery>
												
			<cfquery name="Header" 
				datasource="appsSystem">
				SELECT   count(distinct Presentation) as counted
			    FROM     UserPivotDetail
				WHERE    ControlId = '#ControlId#' 
				AND      Presentation LIKE 'Grouping%' 
			</cfquery>
								
			<cfset cl = "#cols.cols*frm.cols#">
											
		<cfif Format eq "Excel">
		
			<CFHEADER NAME="content-disposition" VALUE="inline; filename=analysis_export1.xls">
			<cfcontent type="application/vnd.ms-excel" reset="no">
			
		<cfelse>	
				
			   <!--- disabled on sunday 2/11/2008 moved to OutputPrepareBox 
			   
			   <cfif Format eq "HTML">
			   			   
			       <cfif node eq "1">
				   											   			   			
				   <table id="pivot"
					   width="100%"		
					   border="0"	   					   			     					   			   			   
				       align="left">
				  			  			 
						   <cfinclude template="CrossTab_Top.cfm">
						   						  											   
					</cfif>
				   
			   </cfif>
				   
				   <tr><td>
				   
				 --->  
				  				  			  			  					   	
	    </cfif>
						  										
		<table style="width:100%" class="formpadding">	
							 
	</cffunction>	
	
	<!--- FOOTER --->	
	
	<cffunction access="public" name="Footer" 
	         output="true" 
			 returntype="string" 
			 displayname="Footer">
			 
			 <cfargument name="Lines"  type="string" required="no"   default="Yes">
									
			</table>
			
			<!---						
			</td></tr>
			
			</table>
			--->
			
									
			<!--- now put the holders here as well --->
	
	</cffunction>		
	
	<!--- DIMENSION --->
	
	<cffunction access="public" name="GenerateDimension" 
	         output="no" 
			 returntype="string" 
			 displayname="Generate a dimension from a query">
			 					 
		<cfargument name="ControlId"           type="string" required="no"   default="">
		<cfargument name="Dimension"           type="string" required="yes"  default="X-ax">
		<cfargument name="DimensionOrder"      type="string" required="yes"  default="1">
		<cfargument name="FactAlias"           type="string" required="yes"  default="">
		<cfargument name="FactTable"           type="string" required="yes"  default="">
		<cfargument name="Alias"               type="string" required="yes"  default="appsSystem">
		<cfargument name="Query"               type="string" required="yes"  default="">
		<cfargument name="Table"               type="string" required="yes"  default="">
		<cfargument name="Condition"           type="string" required="yes"  default="">
		<cfargument name="FieldName"           type="string" required="yes"  default="">
		<cfargument name="FieldDataType"       type="string" required="yes"  default="varchar">
		<cfargument name="FieldListingOrder"   type="string" required="yes"  default="">
		<cfargument name="FieldValue"          type="string" required="yes"  default="">
		<cfargument name="FieldWidth"          type="string" required="yes"  default="0">
		<cfargument name="FieldHeader"         type="string" required="yes"  default="#FieldValue#">
		<cfargument name="FieldTooltip"        type="string" required="yes"  default="#FieldValue#">
						
		<cfif FieldName eq "Total">
		
				<cfquery name="Clear" 
					datasource="AppsSystem" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					DELETE FROM UserPivotDetail
					WHERE  ControlId    = '#ControlId#'
					AND    Presentation = '#Dimension#'  
				</cfquery>
				
		<cfelse>
				
				<cfif FactAlias neq "">
				
				    <cftry>
				
					<cfquery name="resetNULLS" 
					datasource="#FactAlias#"					 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">	
						UPDATE #Facttable#
						SET    #FieldName#   = '_[Undefined]'
						       <cfif FieldValue neq FieldName>
						       ,#FieldValue#  = '_[Undefined]'
							   </cfif>
							   <cfif FieldHeader neq FieldValue and FieldHeader neq FieldName>
							   ,#FieldHeader# = '_[Undefined]'
							   </cfif>
						WHERE  #FieldName# is NULL
					</cfquery>
					
					<cfcatch></cfcatch>
					
					</cftry>
						
				</cfif>
							
				<cfif query neq "">	
				
					<cfquery name="List" 
					datasource="#alias#"					 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">						
					#preserveSingleQuotes(Query)#
					</cfquery>
				
				<cfelse>
													
					<cfquery name="List" 
					datasource="#alias#" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">	
					
						SELECT DISTINCT #FieldName# 
						                <cfif FieldName neq FieldValue>
						                ,#FieldValue#
										</cfif>
										<cfif FieldName neq FieldTooltip and FieldValue neq FieldTooltip>
										,#FieldToolTip#
										</cfif>
										<cfif FieldListingOrder neq "" and FieldName neq FieldListingOrder and FieldValue neq FieldListingOrder>
										,#FieldListingOrder#
										</cfif>										
										<cfif FieldName neq FieldHeader and FieldValue neq FieldHeader and FieldHeader neq FieldTooltip>
										,#FieldHeader#
										</cfif>
						FROM   #table# 
						<cfif condition neq "">
						WHERE  1=1 #preserveSingleQuotes(condition)# 
						</cfif>
						ORDER BY <cfif FieldListingOrder neq "">
										#FieldListingOrder#
								 <cfelse>#FieldHeader#		
								 </cfif>
						 
					</cfquery>
				
				</cfif>
				
				<cfif list.recordcount eq "0">
				   
					<cf_message message="No records found" return="No">
					<cfabort>
				</cfif>
				
				<cfset order = "">
				<cfset value = "">
				<cfset head  = "">
				<cfset tool  = "">
				
				<cfif List.recordcount gt "2000">
							
					<cf_alert message="Your selection resulted in more than 750 columns or rows. Operation not supported. Please contact your administrator" return="no">
					<cfabort>
				
				</cfif>
				
				<cfloop query="List">
				   
				  <cfif FieldListingOrder eq "">
				      <cfset ord = "#currentRow#">
				  <cfelse>	 
					  <cfset ord = "#currentRow#">
				  </cfif>	
				   
				  <cfif order neq "">
				   	  <cfset order = "#order#|#ord#">
					  <cfset value = "#value#|#evaluate(FieldValue)#">
					  <cfset head  = "#head#|#evaluate(FieldHeader)#">
					  <cfset tool  = "#tool#|#evaluate(FieldTooltip)#">
				  <cfelse>
				      <cfset order = "#ord#">
					  <cfset value = "#evaluate(FieldValue)#">
					  <cfset head  = "#evaluate(FieldHeader)#">
					  <cfset tool  = "#evaluate(FieldTooltip)#">
				  </cfif>	  
				  
				</cfloop>
				
				<cfif fieldWidth eq "0">
								
					<cfquery name="Field" 
						datasource="AppsSystem" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						SELECT * 
						FROM   UserReportOutput
						WHERE  UserAccount = '#SESSION.acc#' 
						  AND  OutputId    = '#ControlId#'
						  AND  FieldName   = '#FieldName#' 
					</cfquery>
					
					<cfset fieldWidth = "#Field.OutputWidth#">
				
				</cfif>
				
				<cfinvoke component="Service.Analysis.CrossTab"  
					  method="Dimension"
					  ControlId            = "#ControlId#"
					  Presentation         = "#dimension#"
					  PresentationOrder    = "#dimensionOrder#"
					  FieldName            = "#FieldName#"
					  FieldDataType        = "#FieldDataType#"
					  ListingOrder         = "#order#"
					  FieldValue           = "#value#"
					  FieldHeader          = "#head#"
					  FieldWidth           = "#FieldWidth#"
					  FieldTooltip         = "#tool#"/>
					  
		</cfif>		
					  
	</cffunction>	  
	
	<!--- DIMENSION registration --->
	
	<cffunction access="public" name="Dimension" 
	         output="no" 
			 returntype="string" 
			 displayname="Dimension">
					 
		<cfargument name="ControlId"          type="string" required="no"  default="">
		<cfargument name="Presentation"       type="string" required="yes" default="Y-ax">
		<cfargument name="PresentationOrder"  type="string" required="yes" default="1">
		<cfargument name="FieldName"          type="string" required="yes" default="MyName">
		<cfargument name="ListingOrder"       type="string" required="yes" default="0">
		<cfargument name="FieldValue"         type="string" required="yes" default="MyValue">
		<cfargument name="FieldHeader"        type="string" required="yes" default="MyHeader">
		<cfargument name="FieldTooltip"       type="string" required="yes" default="MyTooltip">
		<cfargument name="FieldWidth"         type="string" required="yes" default="80">
		<cfargument name="FieldDataType"      type="string" required="yes" default="varchar">
											
		<cfif ControlId eq "">
		
			<cfinvoke component="Service.Analysis.CrossTab"  
			  method="Report"
			  returnVariable="ControlId">
											
		</cfif>
		
		<!--- determine columns --->
		
		<cfset col = "0">
		<cfloop index="str" list="#ListingOrder#" delimiters="|">
		   <cfset col = col+1>
		   <cfparam name="ListingOrder#col#" default="#col#">
		</cfloop>
																
		<cfset col = "0">
		<cfloop index="str" list="#FieldHeader#" delimiters="|">
		   <cfset col = col+1>
		   <!--- provision for & sign as this was not accepted in tree --->
		   <cfset str = replaceNoCase(str,"&","-","ALL")>  
		   <cfparam name="FieldHeader#col#" default="#str#">
		   <cfparam name="FieldWidth#col#" default="#FieldWidth#">
		</cfloop>		
						
		<cfset col = "0">
		
		<cfloop index="str" list="#FieldTooltip#" delimiters="|">
		   <cfset col = col+1>		   
		   <cfparam name="FieldTooltip#col#" default="#str#">
		</cfloop>		
				
		<cfset col = "0">
		<cfloop index="str" list="#FieldDataType#" delimiters="|">
		   <cfset col = col+1>
		   <cfparam name="FieldDataType#col#" default="#str#">
		</cfloop>
		
		<cfset col = "0">
		<cfloop index="str" list="#FieldWidth#" delimiters="|">
		   <cfset col = col+1>
		   <cfset "FieldWidth#col#" = "#str#">		  
		</cfloop>
		
		<cfset col = "0">
		<cfloop index="str" list="#FieldValue#" delimiters="|">
		   <cfset col = col+1>
		   <cfparam name="FieldValue#col#" default="#str#">
		</cfloop>
						
		<cfquery name="Clear" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			DELETE FROM UserPivotDetail
			WHERE ControlId    = '#ControlId#' 
			AND Presentation = '#Presentation#'
		</cfquery>
					
		<cfloop index="val" from="1" to="#col#">
		
			<cfparam name="FieldHeader#val#"  default="undefined">
			<cfparam name="FieldTooltip#val#" default="">
			<cfparam name="FieldWidth#val#"   default="30">
			
			<cfset fieldval = evaluate("FieldValue#val#")>
			<cfset fieldval = replace(fieldval,"'","","ALL")> 
			<cfset fieldhea = evaluate("FieldHeader#val#")>
			<cfset fieldhea = replace(fieldhea,"'","","ALL")> 
			<cfset fieldtoo = evaluate("FieldTooltip#val#")>
			<cfset fieldtoo = replace(fieldtoo,"'","","ALL")> 
									
			<cfquery name="Insert" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			INSERT INTO UserPivotDetail 
				   (ControlId, 
					Presentation,
					PresentationOrder,
					FieldName,
					ListingOrder,
					FieldValue,
					FieldHeader,
					FieldTooltip,   
					FieldWidth,
					FieldDataType)
			VALUES  ('#ControlId#',
					'#Presentation#', 
					'#PresentationOrder#',
					'#FieldName#',
					'#evaluate("ListingOrder#val#")#',
					'#fieldval#',
					'#fieldhea#',
					'#fieldtoo#',
					'#evaluate("FieldWidth#val#")#',
					<cfif Presentation eq "Details">
					'#evaluate("FieldDataType#val#")#'
					<cfelse>
					'#FieldDataType#'
					</cfif>
					)
			</cfquery>
								
		</cfloop> 
				
							 
	</cffunction>		
	
	<cffunction access="public" name="Filter" 
	         output="no" 
			 returntype="string" 
			 displayname="Dimension">
		
		<cfargument name="ControlId"     type="string" required="no"  default="">
	
			<cfquery name="Filter" 
			 datasource="appsSystem" 
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
			 SELECT F.*, O.OutputFormat as Format
		 	 FROM   UserPivot P,
		     	    UserPivotFilter F, 
					UserReportOutput O
			 WHERE  P.ControlId = '#ControlId#'
			 AND    P.ControlId = F.ControlId
			 AND    F.FieldName = O.FieldName
			 AND    O.OutputId = P.OutputId
			 AND    O.UserAccount = P.Account
			 AND    F.FilterMode IN ('Data','Subset')
			 ORDER BY F.FieldName, F.FilterValue
			</cfquery>
					
			<cfset condition = "">   

			<cfoutput query="Filter" group="FieldName">

			<cfset se = "">

			<cfoutput>
		   
			   <cfset value = "#FilterValue#">			   
			  			   
			   <cfif Format eq "datetime">
			   
			     <cfset dts = CreateODBCDate(CreateDate(Mid(value, 1, 4), Mid(value, 5, 2), Mid(value, 7, 2)))>
			     <cfset dte = CreateODBCDate(CreateDate(Mid(value, 1, 4), Mid(value, 5, 2), Mid(value, 7, 2))+1)>
			  		   
			   	<cfswitch expression="#FilterOperator#">
			   
					   <cfcase value="IS">
						   <CFSET fil = "#FieldName# > #dts#' AND #FieldName# < #dte# ">
					   </cfcase>
					   <cfcase value="IS_NOT">
					       <CFSET fil = "#FieldName# < #dts# AND #FieldName# >= #dte#">
					   </cfcase>
					   <cfcase value="CONTAINS">
						   <CFSET fil = "#FieldName# > #dts# AND #FieldName# <  #dte# ">
					   </cfcase>
					   
					   <!---
					   <cfcase value="GREATER_THAN">
						  <CFSET fil = "#FieldName# >= #dte#>
					   </cfcase>
					   <cfcase value="SMALLER_THAN">
					       <CFSET fil = "#FieldName# < #dts#">
					   </cfcase>
					   --->
					   
					   <cfdefaultcase>
					    <CFSET fil = "#FieldName# > #dts# AND #FieldName# < #dte# ">
					   </cfdefaultcase>				  					  
			   
				  </cfswitch>
			   
			   <cfelse>
	   
				   <cfswitch expression="#FilterOperator#">
			   
					   <cfcase value="IS">
						   <CFSET fil = "#FieldName# = '#Value#' ">
					   </cfcase>
					   <cfcase value="IS_NOT">
					       <CFSET fil = "#FieldName# <> '#Value#' ">
					   </cfcase>
					   <cfcase value="CONTAINS">
						   <CFSET fil = "#FieldName# LIKE '%#Value#%'">
					   </cfcase>
					   <cfcase value="BEGINS_WITH">
						   <CFSET fil = "#FieldName# LIKE '#Value#%'">
					   </cfcase>
					   <cfcase value="ENDS_WITH">
						   <CFSET fil = "#FieldName# LIKE '%#Value#'">
					   </cfcase>
					   <cfcase value="GREATER_THAN">
						   <CFSET fil = "#FieldName# > '#Value#'">
					   </cfcase>
					   <cfcase value="SMALLER_THAN">
					       <CFSET fil = "#FieldName# < '#Value#'">
					   </cfcase>
					   <cfcase value="IN">
					       <cfset fil = "">
					       <cfloop index="itm" list="#Value#" delimiters=",">
						     <cfif fil eq "">
							     <cfset fil = "'#itm#'">
							 <cfelse>
							     <cfset fil = "#fil#,'#itm#'">
							 </cfif>
						    
						   </cfloop>
						   <cfset fil = "#FieldName# IN (#fil#)">
					      
					   </cfcase>
			   
				  </cfswitch>
			  
			  </cfif>
		  	   
		   		<cfif se eq "">
			      <cfset se = "#fil#">
				<cfelse>
			      <cfset se = "#se# OR #fil#">
			   </cfif>	   
		  		  		  		   
	    	</cfoutput>		

	        <cfset condition = "#condition# AND (#se#)">   
	  	     
    	  </cfoutput>
	
		 <cfreturn condition>
	 
	</cffunction> 
		
	<!--- CROSS TAB HEADER --->
	
	<cffunction access="public" name="Section" 
	         output="true" 
			 returntype="string" 
			 displayname="Header">
			 
		<cfargument name="SectionLabel"   type="string" required="no" default="1">
		
		<tr><td>
			<table><tr><td>#sectionLabel#</td></tr></table>
		</td></tr>
		 
	</cffunction>				
	
<!--- work is done here --->	
<!---   CROSS TAB       --->								
				
	<cffunction access="public" name="Basic" 
	         output="true" 
			 returntype="string" 
			 displayname="PivotTable">
			 
		<cfargument name="SourceId"             type="string" required="no" default=""> 			 								
		<cfargument name="ControlId"            type="string" required="no" default="">
		<cfargument name="FileNo"               type="string" required="no" default="7">
		<cfargument name="Node"                 type="string" required="no" default="">
		<cfargument name="crossTabName"         type="string" required="no" default="crossTab">
		<cfargument name="Alias"                type="string" required="no" default="AppsSystem">
		<cfargument name="loadScript"           type="string" required="Yes" default="Yes">
		<cfargument name="table"                type="string" required="no" default="">
		<cfargument name="summaryColor"         type="string" required="no" default="EAEAEA">
		<cfargument name="hideGraph"            type="string" required="no" default="0">
		<cfargument name="hideYaxNULL"          type="string" required="no" default="0">
		<cfargument name="condition"            type="string" required="no" default="">
		<cfargument name="colHeaderHeight"      type="string" required="no" default="20">
		<cfargument name="colFooterHeight"      type="string" required="no" default="#colHeaderHeight#">
		<cfargument name="colCellHeight"        type="string" required="no" default="20">
		<cfargument name="Detail"               type="string" required="no" default="1">
		<cfargument name="Format"               type="string" required="no" default="HTML"> 
								
		<cfquery name="Pivot" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT  *
			FROM    userPivot
			WHERE   ControlId = '#ControlId#'
		</cfquery>	 
		
		<cfset outputId = Pivot.OutputId>
				
		<cfquery name="SystemParam" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT    *
			FROM      Parameter
		</cfquery>
		
		<cfset aut_server = "#SystemParam.AuthorizationServer#">
					
		<cfif ControlId eq "">
		
			<cfinvoke component="Service.CrossTab"  
			  method="Report"
			   returnVariable="ControlId">
											
		</cfif>
		
		<!--- random --->
				
		<!--- clean values --->
		<cf_droptable 
		  dbname="#alias#" 
		  tblname="#SESSION.acc#_#fileNo#_#node#_CrossTabData">	
		  
		<!--- clean values --->
		<cf_droptable 
		  dbname="#alias#" 
		  tblname="#SESSION.acc#_#fileNo#_#node#_CrossTabTmp">	  
		  
		<!--- clean values --->
		<cf_droptable 
		  dbname="#alias#" 
		  tblname="#SESSION.acc#_#fileNo#_#node#_CrossTabDataDimension">			  
				
		<!--- generate and store values --->
		
		<cfquery name="Fields" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT    DISTINCT FieldName,Presentation
			FROM      UserPivotDetail
			WHERE     ControlId = '#ControlId#' 
			AND       Presentation IN ('Grouping1','Grouping2','Grouping3','X-ax','Y-ax')
		</cfquery>
		
		<cfset sel = "">
		
		<cfloop query="Fields">
		  <cfif sel eq "">
		     <cfset sel   = "#FieldName# as '#replace(Presentation,'-','')#'">
			 <cfset grpby = "#FieldName#">
		  <cfelse>
		     <cfset sel   = "#sel#,#FieldName# as '#replace(Presentation,'-','')#'"> 
			 <cfset grpby = "#grpby#,#fieldName#">
		  </cfif>
		</cfloop>	
									
		<cfquery name="Formula" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT *
			FROM      UserPivotDetail
			WHERE     ControlId = '#ControlId#' 
			AND       Presentation LIKE 'Formula%' 
			ORDER BY PresentationOrder
		</cfquery>
						
		<cfloop query="Formula">
		
			<!--- create formula for the cell --->
		
			<cfif FieldValue eq "Count">
					<cfset for  = "'#FieldValue#' as Cell#currentRow#,#FieldName# as CellValue#currentRow#, cast(0 as float) as CellValue#currentrow#Total, '#FieldDataType#' as CellValue#currentRow#Format">					
			<cfelseif FieldValue eq "DISTINCT">
					<cfset for  = "'#FieldValue#' as Cell#currentRow#,COUNT (#FieldName#) as CellValue#currentRow#, cast(0 as float) as CellValue#currentrow#Total, '#FieldDataType#' as CellValue#currentRow#Format">						
			<cfelseif FieldValue eq "AVG" or FieldValue eq "STDEV" or FieldValue eq "VAR">	
					<cfset for  = "'#FieldValue#' as Cell#currentRow#,count(*) as CellWeight#currentRow#, cast(0 as float) as CellValue#currentrow#Total, #FieldName# as 'CellValue#currentRow#', count(*)*#FieldName# as CellWeightValue#currentRow#,'#FieldDataType#' as CellValue#currentRow#Format">
			<cfelse>
					<cfset for  = "'#FieldValue#' as Cell#currentRow#,#FieldName# as CellValue#currentRow#, cast(0 as float) as CellValue#currentrow#Total, '#FieldDataType#' as CellValue#currentRow#Format">
			</cfif>
		
		    <cfset sel   = "#sel#, #for#"> 		
			
		</cfloop>	
							
		<!--- 1.	Select from UserView the records with Grouping1, Grouping2, Xax listed by order --->
						
		<!--- cell formulas --->
			
		<cfset formulaC = "">
		<cfset formulaT = "">
		<cfset formulaF = "">
		<cfset formulaM = "">
		
		<cfloop query="Formula">
		
				<!--- create formula for the totals --->
		
				<cfif FieldValue eq "Count">
					<cfset for  = "#FieldValue#(*) as CellValue#currentRow#">
										
				<cfelseif FieldValue eq "DISTINCT">
					<cfset for  = "COUNT(DISTINCT CellValue#currentRow#) as CellValue#currentRow#">
					
				<cfelseif FieldValue eq "AVG" or FieldValue eq "STDEV" or FieldValue eq "VAR">	
					<cfset for  = "count(*) as CellWeight#currentRow#, 
					                 #FieldValue#(CellValue#currentRow#) as CellValue#currentRow#, 
					                 count(*)*#FieldValue#(CellValue#currentRow#) as CellWeightValue#currentRow#">
				<cfelse>
					<cfset for  = "#FieldValue#(CellValue#currentRow#) as CellValue#currentRow#">
				</cfif>
				
				
				<cfif FieldValue eq "Count">
					<cfset f  = "SUM(CellValue#currentRow#) as CellValue#currentRow#">
					
				<cfelseif FieldValue eq "DISTINCT">	
					<cfset f  = "SUM(CellValue#currentRow#) as CellValue#currentRow#">
					
				<cfelseif FieldValue eq "AVG" or FieldValue eq "STDEV" or FieldValue eq "VAR">	
					<cfset f  = "SUM(CellWeight#currentRow#) as CellWeight#currentRow#, 
					               SUM(CellValue#currentRow#) as CellValue#currentRow#, 
					               SUM(CellWeightValue#currentRow#) as CellWeightValue#currentRow#">
				<cfelse>
					<cfset f  = "#FieldValue#(CellValue#currentRow#) as CellValue#currentRow#">
				</cfif>
		  
		   <cfif formulaC eq "">
				<cfset formulaC   = "CellValue#currentRow#, CellValue#currentrow#Total ">
				<cfset formulaT   = "MIN(Cell#currentRow#) as Cell#currentRow#, MIN(CellValue#currentrow#Total) as CellValue#currentrow#Total, #for#">
				<cfset formulaF   = "MIN(Cell#currentRow#) as Cell#currentRow#, MIN(CellValue#currentrow#Total) as CellValue#currentrow#Total, #f#">
				<cfset formulaM   = "MAX(CellValue#currentRow#) as max#currentRow#">
			<cfelse>
				<cfset formulaC   = "#formulaC#,CellValue#currentRow#,CellValue#currentrow#Total ">
				<cfset formulaT   = "#formulaT#,MIN(Cell#currentRow#) as Cell#currentRow#, MIN(CellValue#currentrow#Total) as CellValue#currentrow#Total, #for#">
				<cfset formulaF   = "#formulaF#,MIN(Cell#currentRow#) as Cell#currentRow#, MIN(CellValue#currentrow#Total) as CellValue#currentrow#Total, #f#">
				<cfset formulaM   = "#formulaM#,MAX(CellValue#currentRow#) as max#currentRow#">
			</cfif>
			
		</cfloop>
		
								
		<!--- generate crosstab table that can be queried at runtime --->
		
		<cfquery name="DimensionArray" 
			datasource="#alias#" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT   Presentation,FieldValue,Max(Listingorder) as ListingOrder
			INTO     dbo.#SESSION.acc#_#fileNo#_#node#_CrossTabDataDimension
			FROM     [#aut_server#].System.dbo.UserPivotDetail
			WHERE    ControlId     = '#ControlId#' 
			AND      ((Presentation LIKE 'Grouping%') OR (Presentation IN ('X-ax', 'Y-ax')))
			GROUP BY Presentation,FieldValue
			ORDER BY Presentation,ListingOrder
		</cfquery>		
						
		<cfquery name="Report" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT * 
				FROM Ref_ReportControlOutput
				WHERE OutputId   = '#OutputId#'
		</cfquery>
				
		<cfquery name="CrossTabTmp" 
			datasource="#alias#" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT     #preserveSingleQuotes(sel)#		  
			INTO       dbo.#SESSION.acc#_#fileNo#_#node#_CrossTabTmp
			FROM       #table#
			<cfif #condition# neq "">		   
			WHERE 1=1 #preserveSingleQuotes(condition)#
			</cfif>
			GROUP BY   #preserveSingleQuotes(grpby)#		
		</cfquery>	
		
		<cfloop query="Formula">
		
			<cfquery name="UpdateTotal" 
				datasource="#alias#" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				UPDATE  #SESSION.acc#_#fileNo#_#node#_CrossTabTmp
				SET     CellValue#currentrow#Total = (SELECT sum(CellValue#currentrow#) FROM #SESSION.acc#_#fileNo#_#node#_CrossTabTmp)			
			</cfquery>	
		
		</cfloop>
		
		<!--- generate an Array ready table --->
		
		<cfquery name="Ax" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT DISTINCT Presentation as Itm
			FROM       UserPivotDetail
			WHERE      ControlId     = '#ControlId#'
			AND        ((Presentation LIKE 'Grouping%') OR (Presentation IN ('X-ax', 'Y-ax')))
			ORDER BY   Presentation
		</cfquery>	
		
		<cfquery name="CrossTabCreated" 
			datasource="#alias#" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			
				SELECT    CT.*, 'Display' as Output 
				           <cfloop query="Ax">
						   ,#replaceNoCase(itm,"-","")#.Listingorder AS #replaceNoCase(itm,"-","")#Array 
						   </cfloop> 		  
				INTO       dbo.#SESSION.acc#_#fileNo#_#node#_CrossTabData
				FROM       #SESSION.acc#_#fileNo#_#node#_CrossTabTmp CT
				 		   <cfloop query="Ax">
						   ,#SESSION.acc#_#fileNo#_#node#_CrossTabDataDimension #replaceNoCase(itm,"-","")#
						   </cfloop>
				WHERE 1=1 
				      <cfloop query="Ax">
				  AND CT.#replaceNoCase(itm,"-","")# = #replaceNoCase(itm,"-","")#.FieldValue
				  AND #replaceNoCase(itm,"-","")#.Presentation = '#itm#'
					  </cfloop>
				
				ORDER BY  <cfloop query="Ax"><cfif currentrow neq "1">,</cfif>#replaceNoCase(itm,"-","")#Array</cfloop>   
		</cfquery>
		
		<!--- create the index for faster query --->			
									
		<cfinvoke component="Service.Analysis.CrossTab"  
			  method              = "Header"
			  controlid           = "#controlid#"
			  sourceid            = "#sourceid#"
			  formulaM            = "#formulaM#"
			  alias               = "#alias#"
			  node                = "#node#"
			  PivotTable          = "#SESSION.acc#_#fileNo#_#node#_CrossTabData"
			  Format              = "#format#">
			  
		<!--- calculate dimensions and output filters --->
		
		<cfset fil = "0">
		
		<cfquery name="OutputFilter" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT * 
			FROM   UserPivotFilter
			WHERE  ControlId     = '#ControlId#'
			AND    FilterMode    = 'Output'
		</cfquery>  
								
		<cfloop query="Ax">
					
			<!--- first dimension is filtered for the output top/bottom --->
			
				<cfif OutputFilter.recordcount eq "0" or fil eq "1" or itm is "X-ax">
			
					<cfquery name="#replaceNoCase(itm,"-","")#" 
					datasource="AppsSystem" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT   * 
						FROM     UserPivotDetail
						WHERE    ControlId    = '#ControlId#'
						AND      Presentation = '#itm#' 
						ORDER BY ListingOrder
					</cfquery>
						
				<cfelse>
				
					<cfif OutputFilter.FieldName eq "TOP">
					   <cfset dir = "DESC">
					<cfelse>
					   <cfset dir = "ASC">  
					</cfif>
					<cfif OutputFilter.FilterOperator eq "Number">
					   <cfset val = "#OutputFilter.FilterValue#">
					<cfelse>
					   <cfset val = "#OutputFilter.FilterValue# PERCENT">  
					</cfif>
							
					<cfquery name="#replaceNoCase(itm,"-","")#" 
						datasource="#alias#" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						SELECT TOP #val# D.FieldName, 
						                 D.FieldValue, 
										 D.SerialNo, 
										 D.FieldHeader, 
										 D.ListingOrder, 
										 D.FieldWidth,
										 SUM(CellValue1) AS Total 
						FROM     [#aut_server#].System.dbo.UserPivotDetail D, 
						         #SESSION.acc#_#fileNo#_#node#_CrossTabData N
						WHERE    ControlId     = '#ControlId#'
						AND      Presentation  = '#itm#'
						AND      D.ListingOrder = N.#replaceNoCase(itm,"-","")#Array 
						GROUP BY D.FieldName, D.FieldValue, D.SerialNo, D.FieldHeader, D.ListingOrder, D.FieldWidth
						ORDER BY Total #dir#
					</cfquery>
					
					<cfset fil = "1">
				
				</cfif>	
						
		</cfloop>				
		
		<cfif Ax.recordcount eq "5">
		   <cfset mode = "3">		   
		   		
			<cfquery name="Index" 
			datasource="#alias#" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			CREATE  INDEX [GroupingInd] 
			   ON dbo.#SESSION.acc#_#fileNo#_#node#_CrossTabData([Grouping1],[Grouping2],[Grouping3]) ON [PRIMARY]
			</cfquery>		
			   		   
		<cfelseif Ax.recordcount eq "4">
		   <cfset mode = "2">		   
		   		
			<cfquery name="Index" 
			datasource="#alias#" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			CREATE  INDEX [GroupingInd] 
			   ON dbo.#SESSION.acc#_#fileNo#_#node#_CrossTabData([Grouping1],[Grouping2]) ON [PRIMARY]
			</cfquery>		
		   
		<cfelseif Ax.recordcount eq "3">   
		
		   <cfset mode = "1">
		   		   		
			<cfquery name="Index" 
			datasource="#alias#" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			CREATE  INDEX [GroupingInd] 
			   ON dbo.#SESSION.acc#_#fileNo#_#node#_CrossTabData([Grouping1]) ON [PRIMARY]
			</cfquery>		
		   
		<cfelseif Ax.recordcount eq "2">
		   <cfset mode = "0">
		</cfif>
		
		<cfparam name="Xax.recordcount" default="0">
		<cfparam name="Yax.recordcount" default="0">
				
		<cfif Xax.recordcount eq "0" or Yax.recordcount eq "0">
					
			<cf_message message="Dimensions were not defined" return="No">
			<cfexit method="EXITTEMPLATE">
			
		</cfif>
		
		<!--- clean values --->
		<cf_droptable 
		  dbname="#alias#" 
		  tblname="#SESSION.acc#_#fileNo#_#node#_CrossTabDataDimension">		
		  
		<!--- clean values --->
		<cf_droptable 
		  dbname="#alias#" 
		  tblname="#SESSION.acc#_#fileNo#_#node#_CrossTabTmp">	
							 				  
		 <!--- Output to the screen in a tab format --->
		
		<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">
		
		<!--- read into memory --->	
						
		<cfquery name="Formula" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT * 
			FROM   UserPivotDetail
			WHERE  ControlId    = '#ControlId#'
			AND    Presentation LIKE 'Formula%'
			ORDER BY ListingOrder
		</cfquery>		
						
		<!--- generate the actual output cross-tab-tree --->		
				
		<cfswitch expression="#mode#">
			
			<cfcase value="0">
						
			    <!--- output without grouping --->
			
				<cfset cols   = "#2+Xax.recordcount#">				
				<cfinclude template="CrossTab_Header.cfm">
				
				<cfset formulaT = formulaF>
				
				<cfset group1  = "">				
				<cfset group2  = "">				
				<cfset group3  = "">
								
				<cfset xyshow = "Yes">
								
				<cfinclude template="CrossTabOutput.cfm">
					
			</cfcase>	
															
			<cfcase value="1">
			
				<cfset cols   = "#2+Xax.recordcount#">
				<cfinclude template="CrossTab_Header.cfm">
				
				<!--- output with one grouping --->				
								
				<cfoutput query="Grouping1">
				
					<cfif HideYaxNULL eq "1">
					
						<cfquery name="Yax" 
							datasource="#alias#" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
							SELECT * 
							FROM [#aut_server#].System.dbo.UserPivotDetail T
							WHERE ControlId    = '#ControlId#'
							AND Presentation = 'Y-ax'
							AND FieldValue IN (SELECT Yax 
							                   FROM   #SESSION.acc#_#fileNo#_#node#_CrossTabData
											   WHERE  Grouping1    = '#FieldValue#'
											   AND    Yax = T.FieldValue)
							ORDER BY ListingOrder
						</cfquery>
					
					</cfif>
					
					<!--- group total, and show XY --->
										
					<cfset formulaT = formulaF>
				
					<cfset group1   = "#FieldValue#">
					<cfset grp1Nme  = "#FieldName#">
					<cfset grp1Hdr  = "#FieldHeader#">
					<cfset grp1Ser  = "#SerialNo#">
					<cfset grp1Ord  = "#ListingOrder#">
					<cfset grp1Rec  = "#CurrentRow#">
					<cfset grp1Wid  = "#FieldWidth#">
										
					<cfset group2   = "">				
					<cfset group3   = "">				
					<cfset xyshow = "Yes">
							
				    <cfinclude template="CrossTabOutput.cfm">					
				
				</cfoutput>
				
			</cfcase>	
															
			<cfcase value="2">
					
				<cfset cols   = "#3+Xax.recordcount#">
				<cfinclude template="CrossTab_Header.cfm">
								
				<cfset formulaT = formulaF>
									
				<cfoutput query="Grouping1">
				
					<cfif HideYaxNULL eq "1">
					
						<cfquery name="Yax" 
							datasource="#alias#" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
							SELECT * 
							FROM [#aut_server#].System.dbo.UserPivotDetail T
							WHERE  ControlId    = '#ControlId#'
							AND Presentation = 'Y-ax'
							AND FieldValue IN (SELECT Yax 
							                   FROM   #SESSION.acc#_#fileNo#_#node#_CrossTabData
											   WHERE  Grouping1    = '#FieldValue#'
											   AND    Yax = T.FieldValue)
							ORDER BY ListingOrder
						</cfquery>
					
					</cfif>		
				
					<cfset group1   = "#FieldValue#">
					<cfset grp1Nme  = "#FieldName#">
					<cfset grp1Hdr  = "#FieldHeader#">
					<cfset grp1Ser  = "#SerialNo#">
					<cfset grp1Ord  = "#ListingOrder#">
					<cfset grp1Rec  = "#CurrentRow#">
					<cfset grp1Wid  = "#FieldWidth#">
					
					<cfset group2   = "">				
					<cfset group3   = "">				
					<cfset xyshow = "No">
																	
				    <cfinclude template="CrossTabOutput.cfm">						
																								
					<cfloop query="Grouping2">
					
						<!--- second group total and show also xy --->
									
						<cfif HideYaxNULL eq "1">
						
							<cfquery name="Yax" 
								datasource="#alias#" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">
								SELECT * 
								FROM [#aut_server#].System.dbo.UserPivotDetail T
								WHERE ControlId    = '#ControlId#'
								AND Presentation = 'Y-ax'
								AND FieldValue IN (SELECT Yax 
								                   FROM   #SESSION.acc#_#fileNo#_#node#_CrossTabData
												   WHERE  Grouping1    = '#group1#'
													AND   Grouping2    = '#FieldValue#'
													AND   Yax = T.FieldValue)
								ORDER BY ListingOrder
							</cfquery>
						
						</cfif>
						
						<cfset group2   = "#FieldValue#">
						<cfset grp2Nme  = "#FieldName#">
						<cfset grp2Hdr  = "#FieldHeader#">
						<cfset grp2Ser  = "#SerialNo#">
						<cfset grp2Ord  = "#ListingOrder#">
						<cfset grp2Rec  = "#CurrentRow#">
						<cfset grp2Wid  = "#FieldWidth#">
						
						<cfset xyshow = "Yes">
													
					    <cfinclude template="CrossTabOutput.cfm">									
														
					</cfloop>	
														
				</cfoutput>
				
				</cfcase>
								
				<cfcase value="3">			
										
					<cfset cols   = "#4+Xax.recordcount#">
					<cfinclude template="CrossTab_Header.cfm">
					
					<cfset formulaT = formulaF>
										
					<cfoutput query="Grouping1">
					
						<cfif HideYaxNULL eq "1">
						
							<cfquery name="Yax" 
								datasource="#alias#" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">
								SELECT * 
								FROM [#aut_server#].System.dbo.UserPivotDetail T
								WHERE  ControlId    = '#ControlId#'
								AND Presentation = 'Y-ax'
								AND FieldValue IN (SELECT Yax 
								                   FROM   #SESSION.acc#_#fileNo#_#node#_CrossTabData
												   WHERE  Grouping1    = '#FieldValue#'
												   AND   Yax = T.FieldValue)
								ORDER BY ListingOrder
							</cfquery>
						
						</cfif>
						
						<cfset group1   = "#FieldValue#">
						<cfset grp1Nme  = "#FieldName#">
						<cfset grp1Hdr  = "#FieldHeader#">
						<cfset grp1Ser  = "#SerialNo#">
						<cfset grp1Ord  = "#ListingOrder#">
						<cfset grp1Rec  = "#CurrentRow#">
						<cfset grp1Wid  = "#FieldWidth#">					
						<cfset group2   = "">				
						<cfset group3   = "">				
						
						<cfset xyshow = "No">
							
						
				   	    <cfinclude template="CrossTabOutput.cfm">	
																					
						<cfloop query="Grouping2">
						
							<!--- second group total and show also xy --->
										
							<cfif HideYaxNULL eq "1">
							
								<cfquery name="Yax" 
									datasource="#alias#" 
									username="#SESSION.login#" 
									password="#SESSION.dbpw#">
									SELECT * 
									FROM [#aut_server#].System.dbo.UserPivotDetail T
									WHERE ControlId    = '#ControlId#'
									AND Presentation = 'Y-ax'
									AND FieldValue IN (SELECT Yax 
									                   FROM   #SESSION.acc#_#fileNo#_#node#_CrossTabData
													   WHERE  Grouping1    = '#group1#'
														AND  Grouping2    = '#FieldValue#'
														AND   Yax = T.FieldValue)
									ORDER BY ListingOrder
								</cfquery>
							
							</cfif>
							
							<cfset xyshow   = "No">
							
							<cfset group2   = "#FieldValue#">
							<cfset grp2Nme  = "#FieldName#">
							<cfset grp2Hdr  = "#FieldHeader#">
							<cfset grp2Ser  = "#SerialNo#">
							<cfset grp2Ord  = "#ListingOrder#">
							<cfset grp2Rec  = "#CurrentRow#">
							<cfset grp2Wid  = "#FieldWidth#">
							<cfset group3   = "">								
																																	
							<cfinclude template="CrossTabOutput.cfm">	
																												
							<cfloop query="Grouping3">		
																	
								<!--- third group total and show also xy --->
											
								<cfif HideYaxNULL eq "1">
								
									<cfquery name="Yax" 
										datasource="#alias#" 
										username="#SESSION.login#" 
										password="#SESSION.dbpw#">
											SELECT * 
											FROM [#aut_server#].System.dbo.UserPivotDetail T
											WHERE ControlId    = '#ControlId#'
											AND Presentation = 'Y-ax'
											AND FieldValue IN (SELECT Yax 
											                   FROM   #SESSION.acc#_#fileNo#_#node#_CrossTabData
															   WHERE  Grouping1    = '#group1#'
															    AND   Grouping2    = '#group2#'
																AND   Grouping3     = '#FieldValue#'
																AND   Yax = T.FieldValue)
											ORDER BY ListingOrder
									</cfquery>
								
								</cfif>
								
								<cfset group3   = "#FieldValue#">
								<cfset grp3Nme  = "#FieldName#">
								<cfset grp3Hdr  = "#FieldHeader#">
								<cfset grp3Ser  = "#SerialNo#">
								<cfset grp3Ord  = "#ListingOrder#">
								<cfset grp3Rec  = "#CurrentRow#">
								<cfset grp3Wid  = "#FieldWidth#">
								
								<cfset xyshow = "Yes">
								
								<cfinclude template="CrossTabOutput.cfm">
																			
							</cfloop>			
									
						</cfloop>	
															
					</cfoutput>
					
				</cfcase>
				
				<cfcase value="4">
				
					<cfset cols   = "#5+Xax.recordcount#">
					<cfinclude template="CrossTab_Header.cfm">
					
					<cfset formulaT = formulaF>
										
					<cfoutput query="Grouping1">
					
						<cfif HideYaxNULL eq "1">
						
							<cfquery name="Yax" 
								datasource="#alias#" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">
								SELECT * 
								FROM [#aut_server#].System.dbo.UserPivotDetail T
								WHERE  ControlId    = '#ControlId#'
								AND Presentation = 'Y-ax'
								AND FieldValue IN (SELECT Yax 
								                   FROM   #SESSION.acc#_#fileNo#_#node#_CrossTabData
												   WHERE  Grouping1    = '#FieldValue#'
												   AND   Yax = T.FieldValue)
								ORDER BY ListingOrder
							</cfquery>
						
						</cfif>
						
						<cfset group1   = "#FieldValue#">
						<cfset grp1Nme  = "#FieldName#">
						<cfset grp1Hdr  = "#FieldHeader#">
						<cfset grp1Ser  = "#SerialNo#">
						<cfset grp1Ord  = "#ListingOrder#">
						<cfset grp1Rec  = "#CurrentRow#">
						<cfset grp1Wid  = "#FieldWidth#">					
						<cfset group2   = "">				
						<cfset group3   = "">	
						<cfset group4   = "">					
						
						<cfset xyshow = "No">						
								
				   	    <cfinclude template="CrossTabOutput.cfm">	
																											
						<cfloop query="Grouping2">
						
							<!--- second group total and show also xy --->
										
							<cfif HideYaxNULL eq "1">
							
								<cfquery name="Yax" 
									datasource="#alias#" 
									username="#SESSION.login#" 
									password="#SESSION.dbpw#">
									SELECT * 
									FROM [#aut_server#].System.dbo.UserPivotDetail T
									WHERE ControlId    = '#ControlId#'
									AND Presentation = 'Y-ax'
									AND FieldValue IN (SELECT Yax 
									                   FROM   #SESSION.acc#_#fileNo#_#node#_CrossTabData
													   WHERE  Grouping1    = '#group1#'
														AND   Grouping2    = '#FieldValue#'
														AND   Yax = T.FieldValue)
									ORDER BY ListingOrder
								</cfquery>
							
							</cfif>
							
							<cfset xyshow   = "No">
							
							<cfset group2   = "#FieldValue#">
							<cfset grp2Nme  = "#FieldName#">
							<cfset grp2Hdr  = "#FieldHeader#">
							<cfset grp2Ser  = "#SerialNo#">
							<cfset grp2Ord  = "#ListingOrder#">
							<cfset grp2Rec  = "#CurrentRow#">
							<cfset grp2Wid  = "#FieldWidth#">
							<cfset group3   = "">
							<cfset group4   = "">							
																															
							<cfinclude template="CrossTabOutput.cfm">	
																												
							<cfloop query="Grouping3">		
																	
								<!--- third group total and show also xy --->
											
								<cfif HideYaxNULL eq "1">
								
									<cfquery name="Yax" 
										datasource="#alias#" 
										username="#SESSION.login#" 
										password="#SESSION.dbpw#">
											SELECT * 
											FROM [#aut_server#].System.dbo.UserPivotDetail T
											WHERE ControlId    = '#ControlId#'
											AND Presentation = 'Y-ax'
											AND FieldValue IN (SELECT Yax 
											                   FROM   #SESSION.acc#_#fileNo#_#node#_CrossTabData
															   WHERE  Grouping1    = '#group1#'
															    AND   Grouping2    = '#group2#'
																AND   Grouping3     = '#FieldValue#'
																AND   Yax = T.FieldValue)
											ORDER BY ListingOrder
									</cfquery>
								
								</cfif>
								
								<cfset group3   = "#FieldValue#">
								<cfset grp3Nme  = "#FieldName#">
								<cfset grp3Hdr  = "#FieldHeader#">
								<cfset grp3Ser  = "#SerialNo#">
								<cfset grp3Ord  = "#ListingOrder#">
								<cfset grp3Rec  = "#CurrentRow#">
								<cfset grp3Wid  = "#FieldWidth#">
								<cfset group4   = "">
																
								<cfset xyshow = "No">
																
								<cfinclude template="CrossTabOutput.cfm">
														
								<cfloop query="Grouping4">		
																		
									<!--- third group total and show also xy --->
												
									<cfif HideYaxNULL eq "1">
									
										<cfquery name="Yax" 
											datasource="#alias#" 
											username="#SESSION.login#" 
											password="#SESSION.dbpw#">
												SELECT * 
												FROM [#aut_server#].System.dbo.UserPivotDetail T
												WHERE ControlId    = '#ControlId#'
												AND Presentation = 'Y-ax'
												AND FieldValue IN (SELECT Yax 
												                   FROM   #SESSION.acc#_#fileNo#_#node#_CrossTabData
																   WHERE  Grouping1    = '#group1#'
																    AND   Grouping2    = '#group2#'
																	AND   Grouping3    = '#group3#'
																	AND   Grouping4     = '#FieldValue#'
																	AND   Yax = T.FieldValue)
												ORDER BY ListingOrder
										</cfquery>
									
									</cfif>
									
									<cfset group4   = "#FieldValue#">
									<cfset grp4Nme  = "#FieldName#">
									<cfset grp4Hdr  = "#FieldHeader#">
									<cfset grp4Ser  = "#SerialNo#">
									<cfset grp4Ord  = "#ListingOrder#">
									<cfset grp4Rec  = "#CurrentRow#">
									<cfset grp4Wid  = "#FieldWidth#">
									
									<cfset xyshow = "Yes">
									
									<cfinclude template="CrossTabOutput.cfm">
																					
								</cfloop>		
											
							</cfloop>			
									
						</cfloop>	
															
					</cfoutput>
				
				</cfcase>
									
		</cfswitch>
				
		<!--- overall total --->
		
		<cfif mode gte "1">
		
				<cfset group1  = "">				
				<cfset group2  = "">				
				<cfset group3  = "">
								
				<cfset xyshow = "No">
												
				<cfinclude template="CrossTabOutput.cfm">
			
		</cfif>	
																																		
		<cfif detail eq "1">
						
			<!--- details-ax --->
	
			<cfquery name="Fields" 
				datasource="AppsSystem" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				
				SELECT   FieldName as Field 
				FROM     UserReportOutput
				WHERE    UserAccount    = '#SESSION.acc#'
				AND      OutputId       IN (SELECT OutputId FROM UserPivot WHERE ControlId = '#ControlId#')
				AND      OutputClass = 'Detail'
				ORDER BY FieldNameorder
								
			</cfquery>
			
			<cfset list = "">		
			<cfoutput query="Fields" group="Field">
			  
			       <cfif Fields.field neq "DetailId" and Fields.field neq "FactTableId">
					   <cfif list eq "">
						 <cfset list = "#Fields.field#">
					   <cfelse>
						 <cfset list = "#list#,#Fields.field#">
					   </cfif>	
				   </cfif>
				  			  							
			</cfoutput>
						
			<cf_droptable 
			 dbname = "#alias#" 
			 tblname= "#SESSION.acc#_#fileNo#_#node#_summary">	
			 
			 <cftry>
														
				<cfquery name="details" 
					  datasource="#alias#"
					  username="#SESSION.login#" 
					  password="#SESSION.dbpw#">
							 SELECT    FactTableid,
							           <cfif Report.DetailKey neq "">
										   #Report.DetailKey# as DetailId, 
									   <cfelse>
										   NULL as DetailId, 
				    			       </cfif>
									   #list# 
							 INTO      dbo.#SESSION.acc#_#fileNo#_#node#_summary
							 FROM      #table#
							   
							 <cfif condition neq "">
								WHERE 1=1 #preserveSingleQuotes(condition)#
							 </cfif>
													 															
				</cfquery>
			
			<cfcatch>
			
				<cfquery name="details" 
					  datasource="#alias#"
					  username="#SESSION.login#" 
					  password="#SESSION.dbpw#">
							 SELECT    newid() as FactTableId,
							           <cfif Report.DetailKey neq "">
										   #Report.DetailKey# as DetailId, 
									   <cfelse>
										   NULL as DetailId, 
				    			       </cfif>
									   #list# 
							 INTO      dbo.#SESSION.acc#_#fileNo#_#node#_summary
							 FROM      #table#
							   
							 <cfif condition neq "">
								WHERE 1=1 #preserveSingleQuotes(condition)#
							 </cfif>
													 															
				</cfquery>
			
			</cfcatch>
			
			</cftry>
								
		 </cfif>	
		 
		    <!--- prevent incorrect passing 21/12/2006 --->
		    <cfset tablereset = replace(table, " T", "")> 
			
			<cfif LoadScript eq "Yes">
			
				<!--- disabled part of opening ajax --->
			    <cfinclude template="CrossTabHolder.cfm">
			</cfif>
			
			
		</cffunction>
				
		<!--- make default entry here --->
				
		<cffunction access="public" name="Report" 
	         output="no" 
			 returntype="string" 
			 displayname="Report">
		
		<!--- locate default --->
			
			<cfquery name="Crosstab" 
				datasource="AppsSystem" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT    *
				FROM      Ref_ReportControl
				WHERE     FunctionName = 'CrossTab'
			</cfquery>	
			
			<cfif Crosstab.recordcount eq "0">
			
				<!--- insert report --->
				
				<cf_assignId>
				
				<cfquery name="Insert" 
				datasource="AppsSystem" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				INSERT INTO Ref_ReportControl 
				  (ControlId,
				   SystemModule,
				   FunctionName,
				   TemplateSQL,
				   Operational, 
				   OfficerUserId, 
				   OfficerLastName, 
				   OfficerFirstName, 
				   Created)
				VALUES ('#RowGuid#',
						'System',
						'CrossTab',
						'Application', 
						'0',
						'#SESSION.acc#', 
						'#SESSION.last#', 
						'#SESSION.first#', 
						getDate())
				</cfquery>
				
				<!--- insert table --->
				
				<cfquery name="Insert" 
				datasource="AppsSystem" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				INSERT INTO Ref_ReportControlOutput
					  (ControlId, OutputName, Operational, OfficerUserId, OfficerLastName, OfficerFirstName, Created)
				VALUES ('#rowGuid#', 'Detailed table','1','#SESSION.acc#', '#SESSION.last#', '#SESSION.first#', getDate())
				</cfquery>
				
				<cfset controlid = rowGuid>
				
			<cfelse>	
			
				<cfset controlid = CrossTab.controlId>
								
			</cfif>
			
			<cfreturn controlId>
			
		</cffunction>	
			
</cfcomponent>