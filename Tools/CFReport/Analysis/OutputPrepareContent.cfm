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
<cfparam name="URL.debug" default="0">
<cfparam name="URL.Context" default="Initial">
<cfif URL.Context eq "Drill">
	<cfset node  = "99">
<cfelse>
	<cfset node  = "1">
</cfif>

<cfset outputid = "#URL.OutputId#">
<cfset ds       = "#URL.ds#">

<cfparam name="URL.table" default="">
<cfset table    = "#URL.table#">

<cfif table eq "">
	
	   <cf_message message="A problem occurred in your browser/flash player. We recommend you restart your computer" return="no">
	   <cfabort>

</cfif>

<!--- check if table exists --->

<cftry>

 	<cfquery name="Check" 
	datasource="#ds#" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT TOP 1 * FROM #table#
	</cfquery>
	
	<cfcatch>
		 
	   <cf_message message="An error has occurred. Please press button CRITERIA and open your report again" return="no">
	   <cfabort>
	
	</cfcatch>
	
</cftry>	

<!--- check if pivor record exists --->
	
	<cfquery name="Check" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT * FROM UserPivot
			WHERE  Account   = '#SESSION.acc#'
		  	   AND OutputId  = '#OutputId#' 
		   	   AND Node      = '#Node#'
	</cfquery>
	
	<cfif check.recordcount eq "0">
			   
	   <cf_message message="An error has occurred. Please press button CRITERIA and open your report again" return="no">
	   <cfabort>
	
	</cfif>
	
<cfparam name="URL.Source" default="Form">
<cfset source   = "#URL.source#">

<!--- user could have activated several nodes to be displayed in one screen --->

<cfloop index="node" from="1" to="3">

 	<cfparam name="GroupingLabel"     default="Analysis">
	
	<!--- determine which mode to prepare saved/FORM--->
	
	<cfif source eq "Variant"> 
	
		<!--- ------------- --->		
		<!--- SAVED VARIANT --->
		<!--- ------------- --->	
	
		<cfset FileNo = round(Rand()*20)>

		<cf_AssignId>
		<cfset id    = rowGuid>
	
		<!--- prepare output by CREATING an active record dbo.USERVIEW --->
		
		<cfquery name="Check" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT * FROM UserPivot
			WHERE  Account   = '#SESSION.acc#'
		  	   AND OutputId  = '#OutputId#' 
		   	   AND Node      = '#Node#'
		</cfquery>
		
		<!--- drop old tables --->
		<CF_DropTable dbName="#Check.DataSource#"  tblName="#Check.TableName#_CrossTabData"> 
		<CF_DropTable dbName="#Check.DataSource#"  tblName="#Check.TableName#_Summary"> 
		<CF_DropTable dbName="#Check.DataSource#"  tblName="#Check.TableName#_Summary_Detail"> 
		
		<cfquery name="ClearPrior" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			DELETE FROM UserPivot
			WHERE  Account   = '#SESSION.acc#'
		  	   AND OutputId  = '#OutputId#' 
		   	   AND Node      = '#Node#'
			   AND Source    = 'Variant'   
		</cfquery>
		
		<!--- INSERT --->
		
		<cfquery name="Insert" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			INSERT INTO UserPivot
				   (ControlId,
				    OutputId,
					Account,
					Node,
					DataSource,
					Source,
					FileNo,
					TableName)
			VALUES('#id#',
			       '#OutputId#',
				   '#SESSION.acc#',
				   '#node#',
				   '#ds#',
				   'Variant',
				   '#FileNo#',
				   '#SESSION.acc#_#fileNo#_#Node#')
		</cfquery>
			
		<!--- identify output destination settings --->
				
		<cfquery name="Setting" 
				 datasource="appsSystem" 
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">
				 SELECT * 
				 FROM    UserViewSetting 
				 WHERE   SettingId = '#URL.SettingId#' 
		</cfquery>
		
		<cfset PvtFormat = Setting.OutputFormat>
		
		<!--- retrieve saved values here --->
					
		<cfquery name="Saved" 
			 datasource="appsSystem" 
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
			 SELECT   DISTINCT Presentation, FieldName
			 FROM     UserViewSettingDetail
			 WHERE    SettingId    = '#URL.SettingId#'
			 AND      Node         = '#node#'
			 AND      (Presentation IN ('X-ax','Y-ax')
				 OR    Presentation LIKE 'Grouping%'
				 OR    Presentation LIKE 'Formula%') 
		</cfquery>
		
		<cfif saved.recordcount eq "0">
		
				<cfquery name="ClearPrior" 
					datasource="AppsSystem" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					DELETE FROM UserPivot
					WHERE  Account   = '#SESSION.acc#'
				  	   AND OutputId  = '#OutputId#' 
				   	   AND Node      = '#Node#'
					   AND Source    = 'Variant'
				</cfquery>
				
				<!--- stop --->
				<cfabort>
				
		</cfif>
					
		<cfloop query="Saved">
		
				<cfset item  = "#FieldName#">

				<cfset l = #len(FieldName)#>		
										
			    <cfset f = left("#FieldName#",l-4)>
				<cfparam name="Form.n#node#_#replaceNoCase(presentation,"-","")#item" default="#FieldName#"> 
				
				<cfquery name="Field" 
				 datasource="appsSystem" 
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">
						SELECT  *
						FROM    UserReportOutput
						WHERE   UserAccount = '#SESSION.acc#'
						AND     OutputId    = '#OutputId#'
						AND     OutputClass = 'Detail' 
						AND     FieldName   = '#f#_nme'
				</cfquery>
				
				<cfif field.recordcount eq "0">
					<cfparam name="Form.n#node#_#replaceNoCase(presentation,"-","")#Description"  default="#item#">
				<cfelse>
				    <cfparam name="Form.n#node#_#replaceNoCase(presentation,"-","")#Description"  default="#f#_nme"> 
				</cfif>
				
				<cfquery name="Field" 
				 datasource="appsSystem" 
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">
						SELECT  *
						FROM    UserReportOutput
						WHERE   UserAccount = '#SESSION.acc#'
						AND     OutputId    = '#OutputId#'
						AND     OutputClass = 'Detail' 
						AND     FieldName   = '#f#_ord'
				</cfquery>
				
				<cfif field.recordcount eq "0">
					<cfparam name="Form.n#node#_#replaceNoCase(presentation,"-","")#Order"        default="#item#">
				<cfelse>
				    <cfparam name="Form.n#node#_#replaceNoCase(presentation,"-","")#Order"        default="#f#_ord"> 
				</cfif>
				
				<cfquery name="Field" 
				 datasource="appsSystem" 
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">
					SELECT  *
					FROM    UserReportOutput
					WHERE   UserAccount = '#SESSION.acc#'
					AND     OutputId    = '#OutputId#'
					AND     OutputClass = 'Detail' 
					AND     FieldName   = '#f#_nme'
				</cfquery>
				
				<cfparam name="Form.n#node#_#replaceNoCase(presentation,"-","")#Width"        default="#Field.OutputWidth#"> 
																	
		</cfloop>
		
		
		<cfloop index="itm" list="Formula1,Formula2,Formula3" delimiters=",">
		
			<cfquery name="Saved" 
				 datasource="appsSystem" 
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">
				 SELECT   * 
				 FROM     UserViewSettingDetail
				 WHERE    SettingId    = '#URL.SettingId#'
				  AND     Node = '#node#'
				 AND      Presentation = '#itm#'  
			</cfquery>
					
			<cfif saved.recordcount eq "1">
			
				<cfinvoke component="Service.Analysis.CrossTab"  
				  method               = "Dimension"
				  ControlId            = "#Id#"
				  Presentation         = "#itm#"
				  PresentationOrder    = "#200+Saved.PresentationOrder#"
				  ListingOrder         = "#Saved.PresentationOrder#"
				  FieldName            = "#Saved.FieldName#"
				  FieldHeader          = "#Saved.FieldHeader#"
				  FieldDataType        = "#Saved.FieldFormat#"
				  FieldValue           = "#Saved.FieldValue#"/> 
			
			</cfif>
				
		</cfloop>
		
		  <!--- 4b. record filter values --->
		
		  <cfquery name="Insert" 
			 datasource="appsSystem" 
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
				 INSERT INTO UserPivotFilter
				         (ControlId,FilterSerialNo,FilterMode,FieldName,FilterOperator,FilterValue)
				 SELECT  '#id#',FilterSerialNo,FilterMode,FieldName,FilterOperator,FilterValue 
				 FROM    UserViewSettingFilter
				 WHERE   SettingId    = '#URL.SettingId#'
				 <!--- removed this criteria as it is not needed
				 AND     FilterMode   = 'Output'
				 --->
		  </cfquery>
		  
		  <!--- 4a. data filter values ---> 
		
		  <cfinvoke component="Service.Analysis.CrossTab"  
			  method="Filter"
			  ControlId            = "#Id#"
			  returnVariable       = "condition"/> 
			  
			  <!--- set temp filter values --->
						  
		  <cfset client.pvtFilter = condition>
									
	<cfelse> 
	
		<cfquery name="ClearPrior" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			update UserPivot
			set TableFilter = NULL
			WHERE  Account   = '#SESSION.acc#'
		  	   AND OutputId  = '#OutputId#' 
		   	   AND Node      = '#Node#'
			   AND Source    = 'Criteria'   
		</cfquery>
	
		<!--- retrieve node id --->
	
		<cfquery name="Check" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT * FROM UserPivot
			WHERE  Account   = '#SESSION.acc#'
		  	   AND OutputId  = '#OutputId#' 
		   	   AND Node      = '#Node#'
			   AND Source    = 'Criteria'
		</cfquery>
		
		<cfquery name="ClearPrior" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			DELETE FROM UserPivotDetail
			WHERE  ControlId = '#Check.ControlId#'
		  	   AND Presentation != 'Details' 
		</cfquery>
		
		<cfset fileNo = "#Check.FileNo#">
		
		<cfset id    = "#Check.ControlId#">
	
		<!--- ------------------------------------------ --->	
		<!--- user pressed from the current input screen --->
		<!--- ------------------------------------------ --->	
		
		<cfparam name="URL.analysis" default="Pivot">
		
		<cfparam name="URL.column1" default="">
		
		<cfparam name="URL.enableFormula1" default="0">
		<cfparam name="URL.enableFormula2" default="0">
		<cfparam name="URL.enableFormula3" default="0">
		
		<cfparam name="URL.formula1formula" default="count">
		<cfparam name="URL.formula1" default="">
		<cfparam name="URL.formula1type" default="integer">
		
		<cfparam name="URL.formula2formula" default="count">
		<cfparam name="URL.formula2" default="">
		<cfparam name="URL.formula2type" default="integer">
	
		<cfparam name="URL.formula3formula" default="count">
		<cfparam name="URL.formula3" default="">
		<cfparam name="URL.formula3type" default="integer">
		
		<cfset PvtFormat = URL.analysis>
				
		<!--- retrieve FORM inputs to process user request
		1. Rows
		2. Columns
		3. Cells
		4. Filters
		--->
		
		<cfset dim = "">
		
		<!--- 1a. retrieve rows and grouping (enabled for nodes 1..3) --->
		
		<cfquery name="Select" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT * FROM UserPivot U,
			              UserPivotDimension D
			WHERE U.ControlId = D.ControlId
			AND   U.Node = '#Node#'
			AND   U.Account   = '#SESSION.acc#'
		  	AND   U.OutputId  = '#OutputId#'  
		   	ORDER BY ListingOrder
		</cfquery>
		
		<cfif (node eq "1" and select.recordcount eq "0") or URL.column1 eq "null">
		  
		   <cf_message message="You must define one or more Row/column fields." return="No">
	       <cfabort>

		<cfelseif select.recordcount eq "0">
		
		   	   <cfabort>
			   
		</cfif>
							
		<cfloop query="Select">
		  <cfset pr = replace("#Presentation#","-","")>
		  <cfparam name="Form.n#node#_#pr#_item" default="#fieldname#"> 
		  <cfset dim = "#dim#,n#node#_#pr#">
		</cfloop>
										
		<!--- 1b. columns ---> 
		
		<cfparam name="Form.n#node#_Xax_item" default="#URL.column1#">
		
		<!--- 2. define complete dimensions --->
						
		<cfloop index="itm" list="n#node#_Xax#dim#" delimiters=",">
						
		    <cfset item  = evaluate("Form.#itm#_item")>
			
			<cfset l = len(item)>		
			
			<cfif l gt 4>
				
				<cfset f = left("#item#",l-4)>
															    
				<cfparam name="#itm#Item" default="#item#">
														
				<cfquery name="Field" 
				 datasource="appsSystem" 
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">
						SELECT  *
						FROM    UserReportOutput
						WHERE   UserAccount = '#SESSION.acc#'
						AND     OutputId    = '#OutputId#'
						AND     OutputClass = 'Detail' 
						AND     FieldName   = '#f#_nme'
				</cfquery>
					
				<cfif field.recordcount eq "0">
					<cfparam name="#itm#Description"  default="#item#">
				<cfelse>
				    <cfparam name="#itm#Description"  default="#f#_nme"> 
				</cfif>
				
				<cfquery name="Field" 
				 datasource="appsSystem" 
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">
						SELECT  *
						FROM    UserReportOutput
						WHERE   UserAccount = '#SESSION.acc#'
						AND     OutputId    = '#OutputId#'
						AND     OutputClass = 'Detail' 
						AND     FieldName   = '#f#_ord'
				</cfquery>
				
				<cfif field.recordcount eq "0">
					<cfparam name="#itm#Order"        default="#item#">
				<cfelse>
				    <cfparam name="#itm#Order"        default="#f#_ord"> 
				</cfif>
				
				<cfquery name="Field" 
				 datasource="appsSystem" 
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">
					SELECT  *
					FROM    UserReportOutput
					WHERE   UserAccount = '#SESSION.acc#'
					AND     OutputId    = '#OutputId#'
					AND     OutputClass = 'Detail' 
					AND     FieldName   = '#f#_nme'
				</cfquery>
				
				<cfparam name="#itm#Width"        default="#Field.OutputWidth#"> 
			
			</cfif>
		
		</cfloop>
								
		<!--- 3. register cell formulas --->
		
		<cfset ord = 0>
			
		<cfloop index="f" list="Formula1,Formula2,Formula3" delimiters=",">
		
		    <cfset ord = ord+1>
						
			<cfquery name="Clear" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			DELETE FROM UserPivotDetail
			WHERE ControlId    = '#id#'
			AND Presentation = '#f#'
			</cfquery>
			
			<cfset enab  = evaluate("URL.Enable#f#")>
			<cfset for   = evaluate("URL.#f#formula")>
			<cfset item  = evaluate("URL.#f#")>
			<cfset type  = evaluate("URL.#f#type")>
			<cfset head  = evaluate("URL.#f#name")>
			
			<cfif for eq "COUNT">
			   <cfset item = "COUNT(*)">
			<cfelse>			   
			   <cfset item = "#for#(CAST(#item# as Float))">
			   
			</cfif>
			
			<cfif head eq "">
			   <cfset head = for>
			</cfif>
			
			<cfif item neq "" and enab eq "1">			
										
				<cfinvoke component="Service.Analysis.CrossTab"  
				  method="Dimension"
				  ControlId            = "#Id#"
				  Presentation         = "#f#"
				  PresentationOrder    = "#200+ord#"
				  ListingOrder         = "#ord#"
				  FieldName            = "#item#"
				  FieldHeader          = "#head#"
				  FieldDataType        = "#type#"
				  FieldValue           = "#for#"/> 
			
			</cfif>
					
		</cfloop>
					 
		<!--- 4a. data filter values ---> 
		
		<cfinvoke component="Service.Analysis.CrossTab"  
			  method="Filter"
			  ControlId            = "#Id#"
			  returnVariable       = "condition"/> 
						  
		<cfset client.pvtFilter = condition>
				
		<cfparam name="URL.LimitDir"      default="N/A">
		<cfparam name="URL.LimitOperator" default="">
		<cfparam name="URL.LimitValue"    default="">
		  
		<!--- 4b. output filter values --->
		
		<cfif URL.LimitDir neq "N/A">
		
		 <cfquery name="Delete" 
			 datasource="appsSystem" 
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
				 DELETE FROM UserPivotFilter
				 WHERE ControlId = '#id#'
				 AND FilterMode = 'Output'
		  </cfquery>
		
		<cftry>
		
		  <cfquery name="Insert" 
			 datasource="appsSystem" 
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
				 INSERT INTO UserPivotFilter
				 (ControlId,FilterSerialNo,FilterMode,FieldName,FilterOperator,FilterValue)
				 VALUES
				 ('#id#','99','Output','#URL.LimitDir#','#URL.LimitOperator#','#URL.LimitValue#')
		  </cfquery>
		  
		  <cfcatch></cfcatch>
		  
		  </cftry>
		
		</cfif>
				
		<!--- determine if values need to be saved based on the user entry --->
		  	  
		<cfset label_grouping = "#GroupingLabel#">
			 
	</cfif>
	
	
	<!--- end of preparation --->
	
	<cfparam name="URL.HideYAx" default="1">
	<cfparam name="URL.Drill" default="0">
	<cfparam name="URL.LimitOutput" default="5000">
	<cfset client.PvtDrill   = "#URL.Drill#">
	<cfset client.PvtRecord  = "#URL.LimitOutput#">
			
	<!--- register Grouping fields --->
			
	<cfloop index="itm" from="1" to="4" step="1">
				
		<CFIF IsDefined("n#Node#_Grouping#itm#Item")>
						
			<cfinvoke component="Service.Analysis.CrossTab"  
			  method               = "GenerateDimension"
			  ControlId            = "#id#"
			  Dimension            = "Grouping#itm#"
			  DimensionOrder       = "#itm#"
			  factalias            = "#ds#"
			  facttable            = "#table#"
			  alias                = "#ds#"
			  table                = "#table# T"
			  condition            = "#condition#"
			  FieldName            = "#evaluate('n#node#_Grouping#itm#Item')#"
			  FieldValue           = "#evaluate('n#node#_Grouping#itm#Item')#"
			  FieldTooltip         = "#evaluate('n#node#_Grouping#itm#Description')#"
			  FieldListingOrder    = "#evaluate('n#node#_Grouping#itm#Order')#"
			  FieldHeader          = "#evaluate('n#node#_Grouping#itm#Description')#"
			  FieldDataType        = "varchar">	 
			  
		</cfif>	 
			
	</cfloop> 
		
	<!--- set Y-ax fields --->	 
	
	<cfquery name="Exist" 
			datasource="appsSystem">
			SELECT *
			FROM   UserPivotDimension
			WHERE  ControlId = '#id#'	
			AND    Presentation = 'Y-ax'									
	</cfquery>	  
		
	<cfif Exist.recordcount eq "0">
						 		  				
		<cfquery name="UpdateField" 
			datasource="appsSystem">
			UPDATE UserPivotDimension
			SET    Presentation = 'Y-ax'			
			WHERE  ControlId    = '#id#'	
			AND    ListingOrder = '#Exist.FieldName#'	
		</cfquery>
								
	</cfif>
							  
	<cfinvoke component="Service.Analysis.CrossTab"  
			  method="GenerateDimension"
			  ControlId            = "#id#"
			  Dimension            = "Y-ax"
			  DimensionOrder       = "99"
			  factalias            = "#ds#"
			  facttable            = "#table#"
			  alias                = "#ds#"
			  table                = "#table# T"
			  condition            = "#condition#"
			  FieldName            = "#evaluate('n#node#_YaxItem')#"
			  FieldValue           = "#evaluate('n#node#_YaxItem')#"
			  FieldWidth           = "#evaluate('n#node#_YaxWidth')#"
			  FieldTooltip         = "#evaluate('n#node#_YaxDescription')#"
			  FieldListingOrder    = "#evaluate('n#node#_YaxOrder')#"
			  FieldHeader          = "#evaluate('n#node#_YaxDescription')#"
			  FieldDataType        = "varchar">	 
	  			
			<cfinclude template="OutputPrepareFields.cfm">
			
	 <!--- register criteria in tmp table --->	
		 
	 <cfquery name="Delete" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			DELETE FROM UserPivotTemp
			WHERE  Account   = '#SESSION.acc#'
	 </cfquery>
	 
	 <cfquery name="INSERT" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			INSERT INTO UserPivotTemp
			(ControlId, Account, DataSource, TableName, Node, Frame,Filter)
			VALUES
			('#id#','#SESSION.acc#','#ds#','#table#','#node#','Grid','#condition#')
	 </cfquery>			
	 	
	 <cfif Pvtformat eq "Pivot">
		
			 <cfif Node eq "1">
			 	<cfif URL.debug eq 0>
				 	<div id="select" class="screen">
				<cfelse>
				 	<div id="select">
				</cfif>
			 </cfif>
						 
			 <!--- set X-ax fields --->
			
			<!--- determine width --->
			
			<!---
			<cfoutput>
			#evaluate('n#node#_XaxItem')#
			</cfoutput>
			--->
								
			<cfinvoke component="Service.Analysis.CrossTab"  
				  method="GenerateDimension"
				  ControlId            = "#id#"
				  Dimension            = "X-ax"
				  DimensionOrder       = "100"
				  factalias            = "#ds#"
				  facttable            = "#table#"
				  alias                = "#ds#"
				  table                = "#table# T"
				  condition            = "#condition#"
				  FieldName            = "#evaluate('n#node#_XaxItem')#"
				  FieldValue           = "#evaluate('n#node#_XaxItem')#"
				  FieldWidth           = "#evaluate('n#node#_XaxWidth')#"
				  FieldTooltip         = "#evaluate('n#node#_XaxDescription')#"
				  FieldListingOrder    = "#evaluate('n#node#_XaxOrder')#"
				  FieldHeader          = "#evaluate('n#node#_XaxDescription')#"
				  FieldDataType        = "varchar">				 
						  		
			<cfparam name="Form.pivot100" default="0">
			
			<cfif ParameterExists(Form.PrepareSaved)> 
			  	<cfset md = "#Form.SavedSelection#">
			<cfelse>
				<cfset md = "00000000-0000-0000-0000-000000000000">
			</cfif>
			
						  
			<!--- now prepare the cross-tab table --->	 
			
			<cfparam name="Form.hideYaxNULL" default="0"> 		
			
			   <cfif node eq "1">  

					 <table id="pivot"
					   width="100%"	
					   height="100%"						     					   			     					   			   			   
				       align="left">
						  	
					  <cfset controlid = id>		  			 
					  <cfinclude template="../../../Component/Analysis/CrossTab_Top.cfm">						   
					  
		  	 </cfif> 
			
			 <tr><td>	
						
			<cf_divscroll overflowx="auto" overflowy="scroll" style="width:100%;padding-right:10px">	
						   																			
			<cfinvoke component="Service.Analysis.CrossTab" method="Basic"
				  CrossTabName        = "Pivottable"
				  sourceid            = "#md#"
				  controlid           = "#id#"
				  fileNo              = "#fileNo#"
				  node                = "#node#"
				  alias               = "#ds#"
				  table               = "#table# T"
				  loadscript          = "No"
				  condition           = "#condition#"
				  SummaryColor        = "ffffdf"
				  colHeaderHeight     = "19"
				  hideYaxNULL         = "#URL.hideYAx#"
				  detail              = "1">				  
							 		 	 
			 <cfinvoke component="Service.Analysis.CrossTab" node="#node#" method="Footer">	
			 			
			 </cf_divscroll>	
						 
			 </td>
			 </tr>		
			 
			 <cfif node eq "3"> 
			 
			 </table>	
			 
			 </cfif>  
				 	
	 <cfelse>		 	 	
	 
	   <cfoutput>
	 	<table width="100%" height="100%" cellspacing="0" cellpadding="0">
		<tr>
		<td class="labelmedium" align="center">
		Function deprecated, use Pivot to generate a table grid.
		</td>
		</tr>	
		</cfoutput>
	 			 
		 </table>
	 	 
	 </cfif>
			
</cfloop>


