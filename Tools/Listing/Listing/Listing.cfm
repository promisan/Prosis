
<!--- 

	values for fields	

	display           : yes:no
	label             : header label
	field             : fieldname in table
	align             : left, right, center
	function          : a function name that has the field content in it to be passed
	functionfield     : if blank takes default field
	functioncondition : adds to the function attributes
	formatted         : the script for formatting the field value
	alias             : the alias to be used to detect the correct field
	search            : the option to add the field to the search, keep "" to no show, otherwise use number, mail, default, text
	searchfield       : the alternate field used for searching
	searchalias       : the alias used for the alternate field used for searching
	filtermode        : use with search = text, mode 2 : dropdown, 1 combo box (use field searchtypeahead to enable this)
	
--->



<cfparam name="url.systemfunctionid"        default="">
<cfparam name="url.height"                  default="#client.height#">

<cfif not isValid("GUID", url.systemfunctionid)>
	<cfset url.systemfunctionid = "">
</cfif>

<cfparam name="attributes.showlist"           default="Yes">
<cfparam name="attributes.banner"             default="">
<cfparam name="attributes.listingshow"        default="Yes">
<cfparam name="attributes.headershow"         default="Yes">
<cfparam name="attributes.filtershow"         default="No">
<cfparam name="attributes.excelshow"          default="No">
<cfparam name="attributes.printshow"          default="Yes">
<cfparam name="attributes.printshowrows"      default="500">
<cfparam name="attributes.printshowtitle"     default="">

<cfparam name="attributes.AnalysisModule"     default="">
<cfparam name="attributes.AnalysisReportname" default="">
<cfparam name="attributes.AnalysisPath"       default="">
<cfparam name="attributes.AnalysisTemplate"   default="">
<cfparam name="attributes.QueryString"        default="">

<cfparam name="attributes.screentop"          default="No">
<cfparam name="attributes.html"               default="No">

<cfparam name="attributes.header"             default="">
<cfparam name="attributes.menu"               default="">
<cfparam name="attributes.link"               default="">  
<cfparam name="attributes.linkform"           default=""> 
<cfparam name="attributes.box"                default="detail">
<cfparam name="attributes.calendar"           default="9">

<cfparam name="attributes.scroll"             default="No">
<cfparam name="CLIENT.PageRecords"            default="35"> 
<cfparam name="attributes.show"               default="#CLIENT.PageRecords#">

<cfparam name="attributes.tableborder"        default="1">
<cfparam name="attributes.font"               default="">

<cfparam name="attributes.classheader"        default="labelnormal">
<cfparam name="attributes.classsub"           default="labelnormal line">
<cfparam name="attributes.classcell"          default="listingcell">

<cfparam name="attributes.tablewidth"         default="100%">
<cfparam name="attributes.tableheight"        default="100%">
<cfparam name="attributes.datasource"         default="AppsSystem">
<cfparam name="attributes.listtype"           default="SQL">
<cfparam name="attributes.listpath"           default="#SESSION.rootpath#">

<cfparam name="attributes.listfilter"         default="">  

<cfparam name="attributes.listorderalias"     default="">
<cfparam name="attributes.listorder"          default="">
<cfparam name="attributes.listorderfield"     default="#attributes.listorder#">
<cfparam name="attributes.listorderformat"    default="">  <!--- applied based on the main variable --->
<cfparam name="attributes.listorderdir"       default="ASC">

<cfparam name="attributes.listgroupalias"     default="">
<cfparam name="attributes.listgroup"          default="">
<cfparam name="attributes.listgroupformat"    default="">
<cfparam name="attributes.listgroupfield"     default="#attributes.listgroup#">
<cfparam name="attributes.listgroupdir"       default="ASC">

<cfparam name="attributes.listlayout"         default="">   <!--- these are the fields --->
<cfparam name="attributes.headercolor"        default="white">
<cfparam name="attributes.annotation"         default="">
<cfparam name="attributes.drillbox"           default="drilldetail">
<cfparam name="attributes.drillrow"           default="Yes">
<cfparam name="attributes.selectmode"         default="">
<cfparam name="attributes.isFiltered"         default="No">

<!--- drillmode and edit mode --->
<cfparam name="attributes.navtarget"          default="">
<cfparam name="attributes.navtemplate"        default="">

<!--- drillmode and edit mode --->
<cfparam name="attributes.drillmode"          default="">
<cfparam name="attributes.drillargument"      default="940;940;false;false;true">  <!--- height, width, modal, centered, excel drill --->
<cfparam name="attributes.drilltemplate"      default="">
<cfparam name="attributes.drillstring"        default="">
<cfparam name="attributes.drillkeyalias"      default="">
<cfparam name="attributes.drillkey"           default="">

<!--- delete mode --->
<cfparam name="attributes.deletetable"      default="">

<cfparam name="attributes.refresh"          default="0">

<!--- Added by Armin on 13th July 2011 --->

<cfparam name="attributes.allowgrouping"    default="Yes">

<cfparam name="box"                         default="#attributes.box#">

<cfparam name="scroll"                      default="#attributes.scroll#">

<cfparam name="drillbox"                    default="#attributes.drillbox#">
<cfparam name="drillrow"                    default="#attributes.drillrow#">
<cfparam name="drillmode"                   default="#attributes.drillmode#">
<cfparam name="drilltemplate"               default="#attributes.drilltemplate#">
<cfparam name="drillstring"                 default="#attributes.drillstring#">

<!--- not needed if the the info is passed directly in the fields of the caller under isKey=Yes --->
<cfparam name="drillkeyalias"               default="#attributes.drillkeyalias#">
<cfparam name="drillkey"                    default="#attributes.drillkey#">

<cfif drillkeyalias neq "">
    <cfset qdrillkey = "#drillkeyalias#.#drillkey#">
<cfelse>	
	<cfset qdrillkey = "#drillkey#">
</cfif>

<cfparam name="datasource"                 default="#attributes.datasource#">
<cfparam name="deletetable"                default="#attributes.deletetable#">
<cfparam name="argument"                   default="#attributes.drillargument#">

<!--- pass dialog argument into a an array --->
<cfset row = 0>
<cfloop index="itm" list="#argument#" delimiters=";">
   <cfset row = row+1>
   <cfset setting[row] = itm>	
</cfloop>

<cfparam name="url.link"                   default="#attributes.link#">
<cfparam name="url.linkform"               default="#attributes.linkform#">
<cfparam name="URL.content"                default="0">
<cfparam name="url.filter"                 default="all">
<cfparam name="URL.page"                   default="1">
<cfparam name="URL.selfld"                 default="">
<cfparam name="URL.treefield"              default="">

<!--- default sorting --->

<cfset listclass = "embedded">
	
<cfparam name="URL.listorder"              default="#attributes.listorder#">
<cfparam name="URL.listorderfield"         default="#attributes.listorderfield#">
<cfparam name="URL.listorderalias"         default="#attributes.listorderalias#">
<cfparam name="URL.listorderdir"           default="#attributes.listorderdir#">

<cfif url.systemfunctionid neq "">

	<!--- capture the sorting which has been selected --->
		
	<cfquery name="get" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   UserModule
		WHERE  Account          = '#SESSION.acc#'
		AND    SystemFunctionId = '#url.SystemFunctionId#'			
	</cfquery>
	
	<cfif get.recordcount eq "0">
	
		<cftry>
			
			<cfquery name="setUserEntry" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				INSERT INTO UserModule (Account,SystemFunctionId)
				VALUES ('#SESSION.acc#','#url.SystemFunctionId#')			
			</cfquery>
		
		<cfcatch></cfcatch>		
		</cftry>
			
	</cfif>
						
	<cfquery name="getListClass" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   Ref_ModuleControlDetail
		WHERE  SystemFunctionId = '#URL.SystemFunctionId#'
		AND    FunctionSerialNo = '1'
	</cfquery>
	
	<cfif getListClass.recordcount gte "1">
	    <cfset listclass = "listing">
	<cfelse>
		<cfset listclass = "embedded">
	</cfif>

	<cfparam name="URL.listorderfield"  default="">

	<cfif URL.listorderfield neq "">   
  
		<!--- we capture the selection of the user for the sorting into the table ---> 
		<cf_ListingUserSet systemfunctionid="#url.systemfunctionid#" modefield="Sorting">
	   
	</cfif>	
    
	<!--- we then we GET the selection of the user for the sorting into the table 
	    and we overwrite the standard settings as passed from the calling listing 
		script ---> 		
		
    <cf_ListingUserGet systemfunctionid="#url.systemfunctionid#" listlayout="#attributes.listlayout#" modefield="Sroup">	
		
</cfif>	

<!--- default group --->

<cfparam name="URL.listgroup"     default="">

<cfif url.listgroup eq "">

    <cfset URL.listgroup         = attributes.listgroup>
	<cfset URL.listgroupfield    = attributes.listgroupfield>
	<cfset URL.listgroupalias    = attributes.listgroupalias>
	<cfset URL.listgroupdir      = attributes.listgroupdir>

<cfelse>
	
	<cfparam name="URL.listgroup"              default="#attributes.listgroup#">
	<cfparam name="URL.listgroupfield"         default="#attributes.listgroupfield#">
	<cfparam name="URL.listgroupalias"         default="#attributes.listgroupalias#">
	<cfparam name="URL.listgroupdir"           default="#attributes.listgroupdir#">
	
</cfif>	



<cfif url.systemfunctionid neq "">
	
	<cfparam name="form.groupfield"  default="">

	<!--- we capture the selection of the user for the grouping into the table ---> 
	
	<cfif form.groupfield eq "None">  
	
		<cfquery name="check" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				DELETE FROM UserModuleCondition
				WHERE Account = '#SESSION.acc#'
				AND   SystemFunctionId = '#url.systemfunctionid#'	
				AND   ConditionClass   = 'Group'								
		</cfquery>		
				
		<cfset url.listgroup      = "">
		<cfset url.listgroupfield = "">
		<cfset url.listgroupalias = "">
		<cfset url.listgroupdir   = "">
					
	<cfelseif form.groupfield neq "">
		
		<cfset url.listgroup      = "#form.groupfield#">
		<cfset url.listgroupfield = "#form.groupfield#">		
		<cfset url.listgroupalias = "">		
	
			<cfloop array="#attributes.listlayout#" index="fields">	
				<cfif fields.field eq form.groupfield>
				
				   <cfif fields.search eq "">	
				   			     
					  <cfparam name="fields.alias"  default="">						  
					  <cfset url.listgroupalias = fields.alias>						  
					  <cfparam name="fields.searchalias"  default="#fields.alias#">			
					   
				   <cfelse>
				   				   
				       <cfparam name="fields.searchfield"  default="#fields.field#">	
					   <cfparam name="fields.alias"  default="">		
					   <cfparam name="fields.searchalias"  default="#fields.alias#">	
					   <!--- provision to work correctly for the sorting and grouping and show the evaluated field--->
					   <cfset url.listgroup      = fields.searchfield>  <!--- apply grouping --->
					   <cfset url.listgroupalias = fields.searchalias>	<!--- apply grouping --->	
					   <cfset url.listgroupfield = fields.field>  <!--- outputting --->
					  		   
					</cfif>   
				</cfif>
			</cfloop>	
			
		<cfparam name="form.GroupDir" default="ASC">	
		
		<cfset url.listgroupdir   = "#form.groupdir#">
		
		<!--- we capture the selection of the user for the sorting into the table ---> 
	    <cf_ListingUserSet systemfunctionid="#url.systemfunctionid#" modefield="Group">		
	
	</cfif>
	
	<!--- we then we GET the selection of the user for the sorting into the table 
	    and we overwrite the standard settings as passed from the calling listing 
		script ---> 	
				
	<cf_ListingUserGet systemfunctionid="#url.systemfunctionid#" listlayout="#attributes.listlayout#" modefield="Group">	
					
</cfif>

<cfparam name="URL.listorderformat"        default="">
<cfparam name="URL.listgroupformat"        default="">

<cfparam name="url.annotation"             default="#attributes.annotation#">
<cfparam name="url.ajaxid"                 default="content">

<cfquery name="System"
	datasource="AppsSystem"
	username="#SESSION.login#"
	password="#SESSION.dbpw#">
		SELECT  *
		FROM    Parameter		
</cfquery>		

<cfif url.annotation neq "">

	<cfquery name="doc"
		datasource="AppsOrganization"
		username="#SESSION.login#"
		password="#SESSION.dbpw#">
			SELECT  *
			FROM    Ref_Entity			
			WHERE   EntityCode = '#url.annotation#'	 	  
	</cfquery>				

</cfif>


<cfif find("?", url.link)>
	  <cfset sign = "&">
<cfelse>
	  <cfset sign = "?">
</cfif>  

<cfset currrow = 0>

<cfoutput>

<cfset condition = "">

<cfparam name="form.treefield" default="">
<cfparam name="form.treevalue" default="">

<cfif attributes.headershow eq "Yes">
	
	<!--- apply possible filter --->
	
	<cfif url.treefield neq "undefined" and url.treefield neq "">
			<cfset condition   = " AND #url.treefield# = '#url.treevalue#' ">			
	<cfelseif form.treefield neq "" and form.treevalue neq "">		
			<cfset condition   = " AND #form.treefield# = '#form.treevalue#' ">	
	<cfelse>
	   	
	</cfif>
	
	<cfparam name="url.listorderformat" default="Standard">	
		
	<cfparam name="form.savefilter" default="">	
			
	<!--- get the old value --->	
					
	<cfif url.systemfunctionid neq ""  and form.savefilter eq "1">
				
		<cfquery name="cleanPriorFilter" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				DELETE FROM UserModuleCondition
				WHERE  Account = '#SESSION.acc#'
				AND    SystemFunctionId = '#url.systemfunctionid#'	
				AND    ConditionClass   = 'Filter'									
		</cfquery>	
		
		<cfif isValid("array",attributes.listFilter)>

			<cfloop array="#attributes.listfilter#" index="current">
			
			    <!--- populate the filter --->
														
				<cfquery name="setfilter" 
						datasource="AppsSystem" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							INSERT INTO UserModuleCondition
									(Account,
									 SystemFunctionId,
									 ConditionClass,								 
									 ConditionField,
									 ConditionValue,
									 ConditionValueAttribute1)
							VALUES ('#SESSION.acc#',
							        '#url.SystemFunctionId#',
									'Filter',
									'#current.field#',
									'#current.value#',
									'initial filter')			
				</cfquery>	
		
		    </cfloop>	
		
		</cfif>
								
	</cfif>
													
	<cfloop array="#attributes.listlayout#" index="current">
	
	    <!--- remove group fields --->	

		<cfif current.field eq url.listgroup or current.field eq url.listgroupfield>
			<cfset current.display = "No">	
			<cfset current.displayfilter = "yes">	
		</cfif>	
				
		<cfparam name="current.isKey"            default="0">			
		<cfparam name="current.display"          default="Yes">		
		<cfparam name="current.isAccess"         default="0">	
		
		<cfparam name="current.field"            default="">	
		<cfparam name="current.fieldsort"        default="#current.field#">			
		<cfparam name="current.alias"            default="">	
		
		<cfparam name="current.search"           default="">	
		<cfparam name="current.searchfield"      default="">
		<cfparam name="current.searchalias"      default="">	
		
		<cfparam name="current.filtermode"       default="0">	
		<cfparam name="current.filterforce"      default="0">
		<cfparam name="current.lookupQuery"      default="">	
		<cfparam name="current.lookupGroup"      default="">
		<cfparam name="current.functionscript"   default="">	
		<cfparam name="current.displayfilter"    default="Yes">
		<cfparam name="current.functionfield"    default="">	
		<cfparam name="current.functioncondition"  default="">	
		<cfparam name="current.processmode"      default="">	
		
		<cfif current.isKey eq "1">
		
			<cfset drillkeyalias  = current.alias>
			<cfset drillkey       = current.field>
			
			<cfif drillkeyalias neq "">
			    <cfset qdrillkey = "#drillkeyalias#.#drillkey#">
			<cfelse>	
				<cfset qdrillkey = "#drillkey#">
			</cfif>		
		
		</cfif>		
		
		<cfparam name="accesslevel" default="0">
					
		<cfif current.isAccess eq "1">		
			<cfset accessLevel = current.field>		
		</cfif>
		
		<!--- saving filter values --->
		
		<cfif current.display eq "1" or 
		      current.display eq "yes" or 
			  current.displayFilter eq "yes">
			  
				<cfset savefilter = "Yes">
				
		<cfelse>
		
				<cfset savefilter = "No">		
				
		</cfif>
				
		<!--- set the type of order or grouping field --->
		
		<cfif current.field eq url.listgroupfield>
		
			<cfif current.search eq "date">
				<cfset url.listgroupformat = "Date">
	    	</cfif>	
		
		</cfif>
		
		<cfif current.field eq url.listorderfield>
		
			<cfif current.search eq "date">
				<cfset url.listorderformat = "Date">
	    	</cfif>	
		
		</cfif>
								
		<cfif current.searchfield neq "">
			 <cfset fld = current.searchfield> 				 
		<cfelse>
			 <cfset fld = current.field>
		</cfif>	
						
		<cfif current.searchalias neq "">
			 <cfset fld = "#current.searchalias#.#fld#">			
		</cfif>
		
		<cfif current.fieldsort eq "">
		
		    <cfset current.fieldsort = current.field>
			
		</cfif>
				
		<!--- ------------------------------------------------------ --->
		<!--- --retrieve initial values if the form is loaded------- --->
		<!--- ------------------------------------------------------ --->	
															
		<cfif current.search neq "">		    
						
			<cfswitch expression="#Current.search#">
																	
				<cfcase value="text">
																			
					<cf_getUserFilter systemfunctionid="#url.systemfunctionid#" field="#current.field#" filter="#savefilter#">												
																													
					<!--- declare the form filter field and populate it with the save value --->				   								
					<cfparam name="form.filter#current.field#" default="#getval#">	
															
					<cfset val = evaluate("form.filter#current.field#")>					
					<cfset val = replace( val,"'", "''", "ALL" )>
					<cfset val = trim(val)>
																												
					<cfif val neq "" and val neq ",">															
					    <!--- determine that the interface should show the selected values --->
					    <cfset attributes.isfiltered = "Yes">
						
					</cfif>
															
					<cfif current.filtermode eq "4">	
															
						<cf_getUserFilter systemfunctionid="#url.systemfunctionid#" field="#current.field#_operator" filter="#savefilter#">	
						
						<cfif getVal eq "">
							 <cfset getVal = "CONTAINS">
						</cfif>
						
						<cfparam name="form.filter#current.field#_operator" default="#getval#">							
						<cfset getval = evaluate("form.filter#current.field#_operator")>													
						
						<CFIF getval is 'EQUAL'>    						    
							<CFSET Crit = " = '#val#'">
						<CFELSEIF getval is 'NOT_EQUAL'>   <CFSET Crit = " <> '#val#'">			
						<CFELSEIF getval is 'CONTAINS'>    <CFSET Crit = " LIKE '%#Replace(val,' ','%','ALL')#%'">
						<CFELSEIF getval is 'BEGINS_WITH'> <CFSET Crit = " LIKE '#val#%'">
						<CFELSEIF getval is 'ENDS_WITH'>   <CFSET Crit = " LIKE '%#val#'">							
						</CFIF>		
						
						<cfif val neq "">					
							<cfset length   = len(val)>                                                            
							<cfset condition   = "#condition# AND CONVERT(VARCHAR(100),#fld#) #crit# #CLIENT.Collation#">					
						</cfif>  	
											
						<cfif form.savefilter eq "1" and savefilter eq "Yes">
						
							<cf_setUserFilter systemfunctionid="#url.systemfunctionid#" 
							         field="#current.field#" 
									 value="#val#">
									
							<cf_setUserFilter systemfunctionid="#url.systemfunctionid#" 
							         field="#current.field#_operator" 
									 value="#getVal#">		 
									 
						</cfif>	
					
					<cfelseif current.filtermode neq "3">	
																																	
						<cfif val neq "">					
							<cfset length   = len(val)>                                                            
							<cfset condition   = "#condition# AND CONVERT(VARCHAR(100),#fld#) LIKE ('%#val#%') #CLIENT.Collation#">												
						</cfif>    
																		
						<cfif form.savefilter eq "1" and savefilter eq "Yes">
						
							<cf_setUserFilter systemfunctionid="#url.systemfunctionid#" 
							         field="#current.field#" 
									 value="#val#">
									 									 
						</cfif>	
					
					<cfelse>
									
						<!--- multi-select --->		
																																
						<cfset thiscondition = "">
																		
						<cfloop index="itm" list="#val#">
						
							<cfif thiscondition eq "">							
								<cfset thiscondition   = "CONVERT(VARCHAR,#fld#) LIKE ('%#itm#%') #CLIENT.Collation#">												
							<cfelse>									                                                         
								<cfset thiscondition   = "#thiscondition# OR CONVERT(VARCHAR,#fld#) LIKE ('%#itm#%') #CLIENT.Collation#">					
							</cfif> 
							
							<!--- declare the form filter field and populate it with the save value 			   								
							<cfparam name="form.filter#current.field#" default="#getval#">	 
							--->								
							
							<cfif form.savefilter eq "1" and savefilter eq "Yes">
																												
								<cf_setUserFilter systemfunctionid="#url.systemfunctionid#" 
								    field = "#current.field#" 
									mode  = "multi"
									value = "#itm#">
										 
							</cfif>	
											
						</cfloop>		
						
						<cfif thiscondition neq "">						
							<cfset condition   = "#condition# AND (#thiscondition#)">											
						</cfif>					
											
					</cfif>
																					
				</cfcase>
				
				<cfcase value="number">
								
					<cf_getUserFilter systemfunctionid="#url.systemfunctionid#" field="#current.field#" filter="#savefilter#">					
									
					<cfparam name="form.filter#current.field#" default="#getVal#">	
					<cfset val = evaluate("form.filter#current.field#")>	
					<cfset val = Replace( val, "'", "''", "ALL" )>				
					<cfset val = trim(val)>			
					<cfset val = replace(val,",","")>		
										
					<cfif val neq "" and LSIsNumeric(val)>					
					     <cfset condition   = "#condition# AND #fld# >= #val#">							
						 <cfset attributes.isfiltered = "Yes">					
					</cfif>  
					
					<cfif form.savefilter eq "1" and savefilter eq "Yes">
						<cf_setUserFilter systemfunctionid="#url.systemfunctionid#" 
						       field="#current.field#" 
							   value="#val#">
					</cfif>	
					
					<!--- UNTIL --->
										
					<cf_getUserFilter systemfunctionid="#url.systemfunctionid#" field="#current.field#_to">
															
					<cfparam name="form.filter#current.field#_to" default="#getVal#">	
					<cfset val = evaluate("form.filter#current.field#_to")>
					<cfset val = Replace( val, "'", "''", "ALL" )>				
					<cfset val = trim(val)>		
					<cfset val = replace(val,",","")>					
										
					<cfif val neq "" and LSIsNumeric(val)>													
					     <cfset condition   = "#condition# AND #fld# <= #val#">						 
						 <cfset attributes.isfiltered = "Yes">					
					</cfif>  
					
					<cfif form.savefilter eq "1" and savefilter eq "Yes">
						<cf_setUserFilter systemfunctionid="#url.systemfunctionid#" 
						        field="#current.field#_to" 
								value="#val#">
					</cfif>	
				
				
				</cfcase>
				
				<cfcase value="amount">
				
					<cf_getUserFilter systemfunctionid="#url.systemfunctionid#" field="#current.field#" filter="#savefilter#">					
									
					<cfparam name="form.filter#current.field#" default="#getVal#">	
					<cfset val = evaluate("form.filter#current.field#")>	
					<cfset val = Replace( val, "'", "''", "ALL" )>				
					<cfset val = trim(val)>			
					<cfset val = replace(val,",","")>		
										
					<cfif val neq "" and LSIsNumeric(val)>					
					     <cfset condition   = "#condition# AND #fld# >= #val#">							
						 <cfset attributes.isfiltered = "Yes">					
					</cfif>  
					
					<cfif form.savefilter eq "1" and savefilter eq "Yes">
						<cf_setUserFilter systemfunctionid="#url.systemfunctionid#" 
						       field="#current.field#" 
							   value="#val#">
					</cfif>	
					
					<!--- UNTIL --->
										
					<cf_getUserFilter systemfunctionid="#url.systemfunctionid#" field="#current.field#_to">
															
					<cfparam name="form.filter#current.field#_to" default="#getVal#">	
					<cfset val = evaluate("form.filter#current.field#_to")>
					<cfset val = Replace( val, "'", "''", "ALL" )>				
					<cfset val = trim(val)>		
					<cfset val = replace(val,",","")>					
										
					<cfif val neq "" and LSIsNumeric(val)>													
					     <cfset condition   = "#condition# AND #fld# <= #val#">							 
						 <cfset attributes.isfiltered = "Yes">					
					</cfif>  
					
					<cfif form.savefilter eq "1" and savefilter eq "Yes">
						<cf_setUserFilter systemfunctionid="#url.systemfunctionid#" 
						        field="#current.field#_to" 
								value="#val#">
					</cfif>	
				
				</cfcase>
				
				<cfcase value="mail">
				
					<cf_getUserFilter systemfunctionid="#url.systemfunctionid#" field="#current.field#" filter="#savefilter#">
					
					<cfif getval neq "">					
					    <!--- determine that the interface should show the selected values --->
					    <cfset attributes.isfiltered = "Yes">						
					</cfif>
				
					<cfparam name="form.filter#current.field#" default="#getVal#">	
					<cfset val = evaluate("form.filter#current.field#")>
					<cfset val = Replace( val, "'", "''", "ALL" )>
										
					<cfif val neq "">					
						 <cfset condition   = "#condition# AND #fld# LIKE ('%#val#%') #CLIENT.Collation#">	
					</cfif>   
					
					<cfif form.savefilter eq "1" and savefilter eq "Yes">
						<cf_setUserFilter systemfunctionid="#url.systemfunctionid#" 
						       field="#current.field#" 
							   value="#val#">
					</cfif>	 
						
				</cfcase>
				
				<cfcase value="date">				
								
					<!--- FROM --->
				
					<cf_getUserFilter systemfunctionid="#url.systemfunctionid#" field="#current.field#_from" filter="#savefilter#">
									
					<cfparam name="form.filter#current.field#_from" default="#getVal#">						
					<cfset val = evaluate("form.filter#current.field#_from")>								
					
					<cfset val = Replace( val, "'", "''", "ALL" )>					
					<cfif val neq "">	
						 <cfset dateValue = "">
						 <CF_DateConvert Value="#val#">
						 <cfset datevalue = dateAdd("d",  0,  datevalue)>
						 <cfset condition = "#condition# AND #fld# >= #dateValue#">
						 <cfset attributes.isfiltered = "Yes">						
					</cfif>	 
					
					<cfif form.savefilter eq "1" and savefilter eq "Yes">
						<cf_setUserFilter systemfunctionid="#url.systemfunctionid#" 
						        field="#current.field#_from"
								value="#val#">
					</cfif>	
					
					<!--- UNTIL --->
										
					<cf_getUserFilter systemfunctionid="#url.systemfunctionid#" field="#current.field#_to" filter="#savefilter#">
															
					<cfparam name="form.filter#current.field#_to" default="#getVal#">	
					<cfset val = evaluate("form.filter#current.field#_to")>
					<cfset val = Replace( val, "'", "''", "ALL" )>		
					<cfif val neq "">	
						 <cfset dateValue = "">
						 <CF_DateConvert Value="#val#">
						 <cfset datevalue = dateAdd("d",  1,  datevalue)>						
						 <cfset condition = "#condition# AND #fld# < #dateValue#">						 						
						 <cfset attributes.isfiltered = "Yes">
					</cfif>	 
					
					<cfif form.savefilter eq "1" and savefilter eq "Yes">
						<cf_setUserFilter systemfunctionid="#url.systemfunctionid#" 
						        field="#current.field#_to" 
								value="#val#">
					</cfif>	
					<!---
					<cfoutput>#condition#</cfoutput>									
					--->
				</cfcase>
						
			</cfswitch>		
			
			<!--- if we find an enforced filter without value we ensure the result = 0 --->
			
			<cfif current.filterforce eq "1" and val eq "">
			     <cfset condition = "AND 1=0">
			</cfif>
							
		</cfif>	
								
		<!--- -------------------------------------------------- --->
		<!--- -------------------------------------------------- --->
		<!--- -------------------------------------------------- --->
		
	</cfloop>
					
	<cfif url.systemfunctionid neq "">
				
		<cfquery name="cleanBlank" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				DELETE FROM UserModuleCondition
				WHERE  Account = '#SESSION.acc#'
				AND    SystemFunctionId = '#url.systemfunctionid#'	
				AND    ConditionClass   = 'Filter'
				AND    (ConditionValue = '' or ConditionValue is NULL)
							
		</cfquery>	
	
	</cfif>
	
</cfif>	


<!--- inspect the table to verify if there are proper index record --->

<cfif attributes.listtype eq "SQL">

	<cfoutput>
	
		<cfparam name="form.annotationsel" default="">	
	
		<cfif findNoCase("ORDER BY", attributes.listquery)>
		
		   <!--- we are going to remove the ORDER BY that appears at the end of the query --->
		  
		   <cfset fo = findNoCase("ORDER BY", attributes.listquery)>
		   
		   <cfloop condition="FindNoCase('ORDER BY', attributes.listquery, fo+1)">
		  			           
		       <cfset fo = findNoCase("ORDER BY", attributes.listquery,fo+1)>			    		   
			 		   
		   </cfloop>
		   
		   <cfset listquery = left(attributes.listquery, fo-1)>
		   
		<cfelse>
		
		   <cfset listquery =  attributes.listquery>  
		   
		</cfif>
	
		<cfif findNoCase("DISTINCT",  listquery)>
		    <cfset listquery = replaceNoCase(listquery,"SELECT DISTINCT ","SELECT DISTINCT TOP 100 PERCENT ")> 
		<cfelseif findNoCase("TOP",  listquery)> 
			<cfset listquery = replaceNoCase(listquery,"SELECT ","SELECT ")> 
		<cfelse>
			<cfset listquery = replaceNoCase(listquery,"SELECT ","SELECT TOP 100 PERCENT ")> 
		</cfif>		
				
		<!--- we are going to determine if the main portion of the query has a group by --->
							
		<cfif not findnocase("GROUP BY ",attributes.listquery) and not findnocase("--Condition",attributes.listquery)>		
					
			<cfsavecontent variable="querylist">
						
			    #preserveSingleQuotes(listquery)# 	
				<cfif not findnocase("WHERE ",attributes.listquery)>
				WHERE 1=1
				</cfif>
				<cfif condition neq "">
				#preserveSingleQuotes(condition)# 
				</cfif>	
										
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
				
				<!--- filter on the ajax id only --->
				
				<cfif url.ajaxid neq "content">
				AND #qdrillkey# = '#url.ajaxid#' 
				</cfif>
				
				<cfif url.listorder neq "" or url.listgroup neq "">										
				
				ORDER BY				
				
					<!--- grouping --->
					
					<cfif url.listgroup neq "">
													
						<cfif url.listgroupformat eq "date">
						
							<cfif url.listgroupalias neq "">			
								CAST (#url.listgroupalias#.#url.listgroup# as Datetime) 
							<cfelse>
								CAST (#url.listgroup# as Datetime)  
							</cfif>							
						
						<cfelse>
						
							<cfif url.listgroupalias neq "">								
								#url.listgroupalias#.#url.listgroup# 
							<cfelse>
								#url.listgroup# 
							</cfif>									
						
						</cfif>
					
					#url.listgroupdir# 
					
					<cfif url.listorder neq "" and url.listorder neq url.listgroup>,</cfif>
					
					</cfif>		
					
					<!--- sorting --->
									
					<cfif url.listorder neq "" and url.listorder neq url.listgroup>
													
						<cfif url.listorderformat eq "date">
						
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
				
		<cfelseif findnocase("--Condition",attributes.listquery)>	
						
			<!--- 16/6/2014 recompose the query that contains a --condition indicator to 
			
			 determine where the listing condition should go  --->
			
			<cfset strlen  = len(attributes.listquery)>		
			
		    <cfset start = findnocase("--Condition",attributes.listquery)>
															
			<cfset strleft  = left(attributes.listquery,start-1)>
			<cfset strright = right(attributes.listquery,strlen-start+1)>
			
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
				</cfif>	  			
										 
				</cfsavecontent>	
								
			<cfelse>
			
				<cfsavecontent variable="ann">
							
				<!--- filter on the ajax id only --->				
				<cfif url.ajaxid neq "content">
				AND #qdrillkey# = '#url.ajaxid#'											
				</cfif>	  			
										 
				</cfsavecontent>								 
				
			</cfif>
						
			<cfif not findnocase("WHERE ",attributes.listquery)>
				<cfset strwhr = "WHERE 1=1">
			<cfelse>
				<cfset strwhr = "">	
			</cfif>
			
			<!--- compose the query --->
			
			<cfset strqry = "#strleft# #strwhr# #condition# #ann# #strright#">			
		
			<cfsavecontent variable="querylist">
						
			    #preserveSingleQuotes(strqry)# 	
				
				<!--- grouping --->
				
				<cfif url.listgroup neq "" or url.listorder neq "">
								
				ORDER BY 
				
					<cfif url.listgroup neq "">
													
						<cfif url.listgroupformat eq "date">
						
							<cfif url.listgroupalias neq "">			
								CAST (#url.listgroupalias#.#url.listgroup# as Datetime) 
							<cfelse>
								CAST (#url.listgroup# as Datetime)  
							</cfif>							
						
						<cfelse>
												
							<cfif url.listgroupalias neq "">			
								#url.listgroupalias#.#url.listgroup# 
							<cfelse>
								#url.listgroup# 
							</cfif>									
						
						</cfif>
					
					    #url.listgroupdir# 
					
					<cfif url.listorder neq "" and url.listorder neq url.listgroup>,</cfif>
					
					</cfif>		
												
					<cfif url.listorder neq "" and url.listorder neq url.listgroup>
					
						<cfif url.listorderalias neq "">			
						#url.listorderalias#.#url.listorder# 
						<cfelse>
						#url.listorder# 
						</cfif>
						
						#url.listorderdir# 
						
					</cfif>		
					
				</cfif>													
			
			</cfsavecontent>
								
		<cfelse>
				
		    <!--- recompose the query that contains a group --->
			
			<cfset strlen  = len(attributes.listquery)>
			<cfset start  = "1">
			
			<cfloop index="itm" from="1" to="4">
				<cfif findnocase("GROUP BY",attributes.listquery,start)>
				  <cfset start = findnocase("GROUP BY",attributes.listquery,start)>
				</cfif>
			</cfloop>
												
			<cfset strleft  = left(attributes.listquery,start-1)>
			<cfset strright = right(attributes.listquery,strlen-start+1)>
			
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
				</cfif>	  			
										 
				</cfsavecontent>		
				
			<cfelse>
			
				<cfset ann = "">					 
				
			</cfif>
			
			<cfif not findnocase("WHERE ",attributes.listquery)>
				<cfset strwhr = "WHERE 1=1">
			<cfelse>
				<cfset strwhr = "">	
			</cfif>
			
			<!--- compose the query --->
						
			<cfset strqry = "#strleft# #strwhr# #condition# #ann# #strright#">
			
			<cfsavecontent variable="querylist">
			
			    #preserveSingleQuotes(strqry)# 	
				
				<!--- grouping --->
				
				<cfif url.listgroup neq "" or url.listorder neq "">
								
				ORDER BY 
				
					<cfif url.listgroup neq "">
													
						<cfif url.listgroupformat eq "date">
						
							<cfif url.listgroupalias neq "">			
								CAST (#url.listgroupalias#.#url.listgroup# as Datetime) 
							<cfelse>
								CAST (#url.listgroup# as Datetime)  
							</cfif>							
						
						<cfelse>
												
							<cfif url.listgroupalias neq "">			
								#url.listgroupalias#.#url.listgroup# 
							<cfelse>
								#url.listgroup# 
							</cfif>									
						
						</cfif>
					
					    #url.listgroupdir# 
					
					<cfif url.listorder neq "" and url.listorder neq url.listgroup>,</cfif>
					
					</cfif>		
												
					<cfif url.listorder neq "" and url.listorder neq url.listgroup>
					
						<cfif url.listorderalias neq "">			
						#url.listorderalias#.#url.listorder# 
						<cfelse>
						#url.listorder# 
						</cfif>
						
						#url.listorderdir# 
						
					</cfif>		
					
				</cfif>										
			
			</cfsavecontent>
			
		</cfif>
			
	</cfoutput>
	
	<!--- preparation of a standard recorded listing --->	
		
	<cfif listclass eq "Listing">
		
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
								
		<cfif attributes.refresh eq "1">
		
			<cfset fileNo = "#Header.DetailSerialNo#">	
			
			<!--- run the preparation queries with temp tables --->
			<cfinclude template="../../../System/Modules/InquiryBuilder/QueryPreparation.cfm">	
			
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
														
		<cfelse>		
						
		    <cfif url.content eq "0">			
						
			    <cfset fileNo = "#Header.DetailSerialNo#">	
			   						
				<cfinclude template="../../../System/Modules/InquiryBuilder/QueryPreparationVars.cfm">				
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
			
			<cfelse>
		
				<cftry>					
								
					<cfset fileNo = "#Header.DetailSerialNo#">							
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
						
						<cfinclude template="../../../System/Modules/InquiryBuilder/QueryPreparationVars.cfm">					
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
			
		</cfif>	
		
	<cfelse>
			
		<!--- outputting of an on-the-fly embedded listing --->	
		
						
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
				<table width="80%" align="center" cellspacing="0" cellpadding="0" class="formpadding">
					<tr><td height="10"></td></tr>
					<tr><td><b>Error:</td></tr>
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
				<cfabort>
			
			</cfcatch>
				
		</cftry>
			
	</cfif>		
	
	<cfif url.listorder neq "">
	
	<cftry>
			
		<cfquery name="CheckGroup"       
		      maxrows=1 
	         dbtype="query">
			 SELECT DISTINCT #url.listorder#
			 FROM   SearchResult
		</cfquery>	
				
		<cfcatch>
		
		       <cfoutput>
					<table width="80%" align="center" cellspacing="0" cellpadding="0" class="formpadding">
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
	
	<!--- --------------------------------------- --->
	<!--- set the client var to link to the table --->
	<!--- --------------------------------------- --->
		
	<cfset session.listingquery = sc>	

<cfelse>
	
	<cfdirectory action="LIST"
          directory = "#attributes.listpath#\#attributes.listquery#"
          name      = "SearchResult"
          sort      = "#url.listorder# #url.listorderdir# "
          type      = "all"
          listinfo  = "all">

</cfif>

<!--- ---------------------- --->
<!--- actually show the list --->
<!--- ---------------------- --->

<cfset box = attributes.box>  <!--- set by hanno 12/9/19 as box was blank --->

<cfif url.ajaxid eq "content">
  
	<cfif attributes.showlist eq "Yes">
			
		<cfinclude template="ListingShow.cfm">								
											
	</cfif>	
	
<cfelse>	

	<!--- we refresh the fields directly --->
	 
	<cfif searchResult.recordcount eq "1">	
			 
		<!--- we loop through the record with its query field row values --->	 
		<cfloop query="SearchResult">	
		
			<cfloop index="rowshow" from="1" to="3">		   						
				<cfinclude template="ListingContentField.cfm">				
			</cfloop>				
			
		</cfloop> 
								
	<cfelse>
		
		<cfoutput>
		
			<script language="JavaScript">
					 				 
			 line = document.getElementsByName('f#box#_#url.ajaxid#')														 
			 i = 0			
			 while (line[i]) {			   
			   line[i].className = "hide"
			   i++
			 }			 	 
			</script>
			
		</cfoutput>
		
	</cfif>	

</cfif>	

</cfoutput>

<cfparam name="appliedfilter" default="0">

<cfif appliedfilter eq "1" and attributes.calendar eq "9">
	<cfset ajaxonload("doCalendar")>	
</cfif>

