
<!--- --------------------------------------------------------------- --->
<!--- -----------generating content from the config tables----------- --->
<!--- --------------------------------------------------------------- --->

<cfparam name="URL.selfld" default="">
<cfparam name="URL.functionSerialNo" default="1">
<cfparam name="URL.refresh" default="0">
<cfparam name="URL.showlist" default="Yes">
<cfparam name="URL.height" default="500">

<cfquery name="Menu" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   xl#Client.LanguageId#_Ref_ModuleControl R
	WHERE  SystemFunctionId = '#URL.SystemFunctionId#'	
</cfquery>

<cfquery name="Main" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   Ref_ModuleControlDetail
	WHERE  SystemFunctionId = '#URL.SystemFunctionId#'
	AND    FunctionSerialNo = '#url.FunctionSerialNo#'
</cfquery>

<cfset fields=ArrayNew(1)>

<cfquery name="MyFields" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   *
	FROM     Ref_ModuleControlDetailField
	WHERE    SystemFunctionId = '#URL.SystemFunctionId#'
	AND      FunctionSerialNo = '#url.FunctionSerialNo#'
	ORDER BY FieldRow,
	         ListingOrder
</cfquery>

<cfoutput query="MyFields">
	
	<cfset formatted = "#fieldName#">
	
	<cfswitch expression="#FieldOutputFormat#">
						
		<cfcase value="Date">	
			<cfset formatted = "dateformat(#fieldname#,CLIENT.DateFormatShow)">	
		</cfcase>
		
		<cfcase value="Time">	
			<cfset formatted = "timeformat(#fieldname#,'HH:MM')">	
		</cfcase>
		
		<cfcase value="DateTime">	
			<cfset formatted = "datetimeformat(#fieldname#,'#CLIENT.DateFormatShow# HH:NN')">	
		</cfcase>
						
		<cfcase value="Amount">	
			<cfset formatted = "numberformat(#fieldname#,',.__')">	
		</cfcase>
		
		<cfcase value="Amount0">	
			<cfset formatted = "numberformat(#fieldname#,',__')">	
		</cfcase>
		
		<cfcase value="Number">	
			<cfset formatted = "numberformat(#fieldname#,',__')">	
		</cfcase>
		
		<cfcase value="Attachment">	
			<cfset formatted = "attachment">	
		</cfcase>
	
	</cfswitch>
	
	<cfif fieldHeaderLabel eq "">
	  <cfset lbl = fieldName>
	<cfelse>
	  <cfset lbl = fieldHeaderLabel>  
	</cfif>
	
	<cfif fieldFilterLabel eq "">
	  <cfset lblfilter = lbl>
	<cfelse>
	  <cfset lblfilter = fieldFilterLabel>  
	</cfif>
		
	<cfif url.selfld eq "">	
	 	  <cfset grid = fieldInGrid>
	<cfelse>
	
	      <cftry>
		  <cfif findNoCase(fieldName,url.selfld)>
		     <cfset grid = "1">
		  <cfelse>
		     <cfset grid = "0">	
		  </cfif>	  
		  <cfcatch>		  
		  <cfset grid = "1">
		  </cfcatch>
		  </cftry>
	</cfif>
	
	<cfif FieldSort eq "3">
	     <cfset agg = "sum">
	<cfelse>
	     <cfset agg = "">
	</cfif>

	<cfset fields[currentrow] = 
           {label           = "#lbl#", 
		    labelfilter     = "#lblfilter#",
            width           = "#fieldWidth#", 
			field           = "#fieldName#",
			fieldsort       = "#fieldNameSort#",
			formatted       = "#formatted#",
			column          = "#fieldcolumn#",
			display         = "#grid#",		
			align           = "#fieldalignment#",		
			alias           = "#fieldaliasquery#",
			isKey           = "#fieldIskey#",
			rowlevel        = "#fieldrow#",
			colspan         = "#fieldColspan#",
			aggregate       = "#agg#",
			processmode     = "#FieldEditInputType#",
			processtemplate = "#FieldEditTemplate#",
			search          = "#FieldFilterClass#",
			filterforce     = "#FieldFilterForce#",
			filtermode      = "#FieldFilterClassMode#"}>		
					
</cfoutput>		

<cfif main.drillmode eq "None">
 <cfset md = "">
<cfelse>
 <cfset md = main.drillmode> 
</cfif>		

 <cfquery name="filter" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM  Ref_ModuleControlDetailField
		WHERE SystemFunctionId = '#url.SystemFunctionId#'
		AND   FunctionSerialNo = '#url.FunctionSerialNo#'
		AND   FieldFilterClass > ''		
</cfquery>

<cfif filter.recordcount eq "0">
	  <cfset fshow = "No">
<cfelse>
	  <cfset fshow = "#main.filtershow#">  
</cfif>

<cfquery name="MySort" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   *
	FROM     Ref_ModuleControlDetailField
	WHERE    SystemFunctionId = '#URL.SystemFunctionId#'
	AND      FunctionSerialNo = '#url.FunctionSerialNo#'	
	AND      FieldSort = '1'	
</cfquery>

<cfquery name="MyGroup" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   *
	FROM     Ref_ModuleControlDetailField
	WHERE    SystemFunctionId = '#URL.SystemFunctionId#'
	AND      FunctionSerialNo = '#url.FunctionSerialNo#'	
	AND      FieldSort = '2'		
</cfquery>

<cfquery name="Key" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT TOP 1 *
	FROM   Ref_ModuleControlDetailField
	WHERE  SystemFunctionId = '#URL.SystemFunctionId#'
	AND    FunctionSerialNo = 1	
	AND    FieldName = '#main.drillfieldkey#'	
</cfquery>

<cfif key.fieldName neq "">
	<cfset thiskey = key.fieldName>
<cfelse>
    <cfset thiskey = main.drillfieldkey>
</cfif> 

<cfif main.InsertTemplate neq "">		
														
	<cfset addrecord[1] = {label = "Add Record", icon = "add.png", script = "#main.InsertTemplate#"}>				 		
	
<cfelse>

	<cfparam name="addrecord" default="">
	
</cfif>	

<cfparam name="url.mission" default="">

<cfset boxname = "box_#replaceNoCase(menu.FunctionName,' ','','ALL')#">
					
<cf_listing
    header         = "#menu.FunctionName# #url.mission#"
    box            = "#boxname#_#url.mission#"
	link           = "#SESSION.root#/Tools/Listing/Listing/InquiryListing.cfm?height=#url.height#&systemfunctionid=#url.systemfunctionid#&functionserialNo=#url.functionserialNo#&mission=#url.mission#"
    html           = "No"	
	showlist       = "#url.showlist#"	
	datasource     = "#main.querydatasource#"
	listquery      = "#main.queryscript#"
	refresh        = "0" <!--- system will determine if cache needs to be used at loading --->
	
	listgroupalias = "#MyGroup.FieldAliasQuery#"
	listgroup      = "#MyGroup.FieldName#"
	listgroupfield = "#MyGroup.FieldName#"
	listgroupdir   = "ASC"
	
	listorderalias = "#MySort.FieldAliasQuery#"
	listorder      = "#MySort.FieldName#"
	listorderfield = "#MySort.FieldName#"
	listorderdir   = "ASC"
		
	tablewidth     = "100%"
	headercolor    = "ffffff"
	listlayout     = "#fields#"
	drillmode      = "#md#"
	menu           = "#addrecord#"
	filtershow     = "#fshow#"
	
	annotation     = "#main.entitycode#"
	drillargument  = "#main.drillargument#"	
	drilltemplate  = "#main.drilltemplate#"
	deletetable    = "#main.querytable#"
	drillkeyalias  = "#key.FieldAliasQuery#"
	drillkey       = "#thiskey#">
	


		

		
