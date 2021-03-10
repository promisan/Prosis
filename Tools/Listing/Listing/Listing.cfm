
<!--- 

	values for fields	
	
	display           : yes:no
	label             : header label
	navigation        : modality of paging or auto scroll : paging/auto
	field             : fieldname in table
	align             : left, right, center
	function          : a function name that has the field content in it to be passed
	functionfield     : if blank takes default field
	functioncondition : adds to the function attributes
	formatted         : the script for formatting the field value
	precision         : the field that contains the precision of the number field 
	alias             : the alias to be used to detect the correct field
	search            : the option to add the field to the search, keep "" to no show, otherwise use number, mail, default, text
	searchfield       : the alternate field used for searching
	searchalias       : the alias used for the alternate field used for searching
	filtermode        : use with search = text, mode 2 : dropdown, 1 combo box (use field searchtypeahead to enable this)
	
--->

<cfparam name="url.ajaxid"                 default="content">

<cfparam name="url.systemfunctionid"        default="">
<cfparam name="url.height"                  default="#client.height#">

<cfif not isValid("GUID", url.systemfunctionid)>
	<cfset url.systemfunctionid = "">
</cfif>

<cfparam name="attributes.showlist"           default="Yes">   <!--- option to hide the listing, not recommended --->
<cfparam name="attributes.banner"             default="">      <!--- show text in the top of the listing --->
<cfparam name="attributes.filtershow"         default="No">    <!--- allow to filter the dataset --->
<cfparam name="attributes.headershow"         default="Yes">   <!---  show the listing header and options to sort etc. should be yes --->
<cfparam name="attributes.navigation"         default="auto">  <!--- auto | paging if we have 2/3 rows or we have annotation it is reset -> paging --->
<cfparam name="attributes.excelshow"          default="No">
<cfparam name="attributes.printshow"          default="Yes">
<cfparam name="attributes.printshowrows"      default="500">
<cfparam name="attributes.printshowtitle"     default="">

<!--- deprecated --->

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

<cfparam name="CLIENT.PageRecords"            default="100"> 
<cfparam name="attributes.show"               default="#CLIENT.PageRecords#">

<cfparam name="attributes.tableborder"        default="1">
<cfparam name="attributes.font"               default="">

<cfparam name="attributes.tablewidth"         default="100%">
<cfparam name="attributes.tableheight"        default="100%">
<cfparam name="attributes.datasource"         default="AppsSystem">
<cfparam name="attributes.listtype"           default="SQL">
<cfparam name="attributes.listpath"           default="#SESSION.rootpath#">

<cfparam name="attributes.classheader"        default="labelnormal">
<cfparam name="attributes.classsub"           default="labelnormal line">
<cfparam name="attributes.classcell"          default="listingcell">

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
<cfparam name="attributes.listgroupsort"      default="#attributes.listgroup#">
<cfparam name="attributes.listgroupdir"       default="ASC">

<!--- not sure what this field is for --->
<cfparam name="attributes.listgrouptotal"     default="0">

<!--- 21/12/2020 : future 2nd dimension --->
<cfparam name="attributes.listgroup2alias"    default="">
<cfparam name="attributes.listgroup2"         default="">
<cfparam name="attributes.listgroup2format"   default="">
<cfparam name="attributes.listgroup2field"    default="#attributes.listgroup#">
<cfparam name="attributes.listgroup2sort"     default="#attributes.listgroup#">
<cfparam name="attributes.listgroup2dir"      default="ASC">

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
<cfparam name="attributes.deletetable"        default="">
<cfparam name="attributes.deletescript"       default="">
<cfparam name="attributes.deletecondition"    default="">

<cfparam name="url.contentmode"               default="1">

<!--- option to control the default mode of taking fresh data--->
<cfparam name="attributes.refresh"            default="1">

<!--- ----------------------------- --->
<!--- convert into simple variables --->
<!--- ----------------------------- --->

<cfparam name="box"                         default="#attributes.box#">

<cfif box eq "">
	<cfset box = attributes.box>	
</cfif>

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
<cfparam name="deletescript"               default="#attributes.deletescript#">
<cfparam name="argument"                   default="#attributes.drillargument#">

<!--- pass dialog argument into a an array --->
<cfset row = 0>
<cfloop index="itm" list="#argument#" delimiters=";">
   <cfset row = row+1>
   <cfset setting[row] = itm>	
</cfloop>

<!--- those variables come from the interface when selecting sorting and tree on the fly and
we keep them in form field for easy pickup and are in listingshow.cfm --->

<cfparam name="url.link"                   default="#attributes.link#">
<cfparam name="url.linkform"               default="#attributes.linkform#">

<cfparam name="URL.content"                default="0">
<cfparam name="URL.filter"                 default="all">
<cfparam name="URL.page"                   default="1">
<cfparam name="URL.selfld"                 default="">
<cfparam name="URL.treefield"              default="">

<!--- default sorting | filter form  => url --->

<cfparam name="form.listorder"             default="#attributes.listorder#">
<cfparam name="Form.listorderfield"        default="#attributes.listorderfield#">
<cfparam name="form.listorderalias"        default="#attributes.listorderalias#">
<cfparam name="form.listorderdir"          default="#attributes.listorderdir#">
	
<cfparam name="URL.listorder"              default="#form.listorder#">
<cfparam name="URL.listorderfield"         default="#form.listorderfield#">
<cfparam name="URL.listorderalias"         default="#form.listorderalias#">
<cfparam name="URL.listorderdir"           default="#form.listorderdir#">

<cfif attributes.annotation neq "">
	<cfset attributes.navigation = "paging">
</cfif>

<!--- we time the openen moment --->
<cfset listingtimestart = now()>

<cfset listclass = "embedded">

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
		
    <cf_ListingUserGet systemfunctionid="#url.systemfunctionid#" listlayout="#attributes.listlayout#" modefield="Sorting">	
				
</cfif>	

<!--- default group --->

<cfparam name="URL.listgroup"     default="">

<cfif url.listgroup eq "">

    <cfset URL.listgroup              = attributes.listgroup>
	<cfset URL.listgroupfield         = attributes.listgroupfield>
	<cfset URL.listgroupsort          = attributes.listgroupsort>
	<cfset URL.listgroupalias         = attributes.listgroupalias>
	<cfset URL.listgroupdir           = attributes.listgroupdir>
	<cfset URL.listgrouptotal         = attributes.listgrouptotal>	
	<cfset url.listcolumn1            = "">
	<cfset url.listcolumn1_type       = "period">
	<cfset url.listcolumn1_typemode   = "">
	<cfset url.datacell1              = "">
	<cfset url.datacell1formula       = "">

<cfelse>
	
	<cfparam name="URL.listgroup"              default="#attributes.listgroup#">
	<cfparam name="URL.listgroupfield"         default="#attributes.listgroupfield#">
	<cfparam name="URL.listgroupsort"          default="#attributes.listgroupsort#">
	<cfparam name="URL.listgroupalias"         default="#attributes.listgroupalias#">
	<cfparam name="URL.listgroupdir"           default="#attributes.listgroupdir#">
	<cfset url.listcolumn1            = "">
	<cfset url.listcolumn1_type       = "period">
	<cfset url.listcolumn1_typemode   = "">
	<cfset url.datacell1              = "">
	<cfset url.datacell1formula       = "">
	
</cfif>	

<!--- -------------------------------------------------------------------------------- ---> 
<!--- we check if we have something in memory that we can use for this box  and person --->
<!--- -------------------------------------------------------------------------------- ---> 

<cfparam name="form.useCache" default="">  <!--- requested --->

<cftry>
	<cfset session.listingdata[box]['timestamp']        = now()>	
<cfcatch></cfcatch>	
</cftry>

<cfif url.contentmode eq "5">

	<!--- we force refresh as we want to see new records --->
	<cfset attributes.refresh = "1">	

<cfelse>
	
	<cfif datediff("d",now(),session.listingdata[box]['timestamp']) gte 1> 
		<!--- listing has expired 24 hours so we refresh per definition --->  	
		<cfset attributes.refresh = "1">				
	<cfelseif attributes.refresh eq "1" and form.useCache eq "">
		<!--- this is the default value upon opening --->
	<cfelse>
	    <!--- interface enforces the refresh --->
		<cfif form.useCache eq "0">
			<cfset attributes.refresh = "1">			
		<cfelse>
			<cfset attributes.refresh = "0">			
		</cfif>
	</cfif>	
	
</cfif>	

<cfif url.systemfunctionid neq "">

	<!--- inspect declaration fields --->
	
	<!--- relevant field --->
		
	<cfset declaredfields = "''">
	
	<cfloop array="#attributes.listlayout#" index="fields">	
		
		<cfparam name="fields.searchfield"  default="#fields.field#">	
	    <cfparam name="fields.fieldsort"    default="#fields.field#">	
	    <cfparam name="fields.alias"        default="">		
		<cfparam name="fields.fieldentry"   default="">	
		<cfparam name="fields.searchalias"  default="#fields.alias#">	
							
		<cfif not findNoCase(fields.field,declaredfields)>			
			 <cfset declaredfields = "#declaredfields#,'#fields.field#'">			
		</cfif>
		
		<cfif not findNoCase(fields.fieldsort,declaredfields)>
			 <cfset declaredfields = "#declaredfields#,'#fields.fieldsort#'">
		</cfif>
		
		<cfif not findNoCase(fields.searchfield,declaredfields)>
			 <cfset declaredfields = "#declaredfields#,'#fields.searchfield#'">
		</cfif>		
		
		<cfif fields.fieldentry eq "1">
			<cfif fields.alias neq "">
			    <cfset qentrykey = "#fields.alias#.#fields.field#">
			<cfelse>	
				<cfset qentrykey = "#fields.field#">
			</cfif>	
		</cfif>				
									
	</cfloop>
	
	<cfquery name="clean" 
	   datasource="AppsSystem" 
	   username="#SESSION.login#" 
	   password="#SESSION.dbpw#">
			DELETE FROM UserModuleCondition
			WHERE       SystemFunctionId = '#url.systemfunctionid#' 
			AND         ConditionField IN ('listorderfield', 'listorder', 'listgroupsort', 'listgroupfield', 'listgroup','listcolumn1') 
			AND         ConditionValue NOT IN (#preserveSingleQuotes(declaredfields)#) 
	</cfquery>

	<cfparam name="form.groupfield"           default="">					
	<cfparam name="form.grouptotal"           default="0">  <!--- explore / pivot --->	
	<cfparam name="form.colfield1"            default="">
	
	<!--- obtain from the passed setting the type of the column --->
			
	<cfparam name="form.listcolumn1_type"     default = "period">
	<cfparam name="form.listcolumn1_typemode" default = "">
	
	<cfparam name="form.datacell1"            default = "">
	<cfparam name="form.datacell1formula"     default = "SUM">	
	
	<!--- we capture the selection of the user for the grouping into the table ---> 
		
	<cfif form.groupfield eq "None">  
		
		<cfquery name="check" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				DELETE FROM UserModuleCondition
				WHERE  Account = '#SESSION.acc#'
				AND    SystemFunctionId = '#url.systemfunctionid#'	
				AND    ConditionClass   = 'Group'								
		</cfquery>		
				
		<cfset url.listgroup             = "">
		<cfset url.listgroupfield        = "">
		<cfset url.listgroupsort         = "">
		<cfset url.listgroupalias        = "">
		<cfset url.listgroupdir          = "">
		<!--- enable pivit / explore --->
		<cfset url.listgrouptotal        = "">
		
		<cfset url.listcolumn1           = "">	
		<cfset url.listcolumn1_type      = "">	
		<cfset url.listcolumn1_typemode  = "">  
		
		<cfset url.datacell1             = "">
		<cfset url.datacell1formula      = "">
							
	<cfelseif form.groupfield neq "">
				
		<cfset url.listgroup             = "#form.groupfield#">
		<cfset url.listgroupfield        = "#form.groupfield#">	
		<cfset url.listgroupsort         = "#form.groupfield#">	
		<cfset url.listgroupalias        = "">	
			
		<cfloop array="#attributes.listlayout#" index="fields">	
		
			<cfparam name="fields.searchfield"  default="#fields.field#">	
		    <cfparam name="fields.fieldsort"    default="#fields.field#">	
		    <cfparam name="fields.alias"        default="">		
			<cfparam name="fields.searchalias"  default="#fields.alias#">	
		
			<cfif fields.field eq form.groupfield>
			
			   <cfif fields.search eq "">	
			   					  			  
				  <cfset url.listgroupalias = fields.alias>						  
				   
			   <cfelse>
			   				       
				   <!--- provision to work correctly for the sorting and grouping and show the evaluated field--->
				   <cfset url.listgroup         = fields.searchfield>  <!--- apply grouping --->
				   <cfset url.listgroupalias    = fields.searchalias>  <!--- apply grouping --->	
				   <cfset url.listgroupfield    = fields.field>        <!--- outputting --- --->
				   <cfset url.listgroupsort     = fields.fieldsort>    <!--- order in outputting based on the setting --- --->
				 					   					  		   
				</cfif> 
				  
			</cfif>
					
			<cfparam name="fields.column" default="">
			
			<cfif fields.field eq form.colfield1>
			    <cfif fields.column eq "month">
					<cfset form.listcolumn1_type = "period">
				<cfelse>
					<cfset form.listcolumn1_type = fields.column>
				</cfif>
			</cfif>
						
		</cfloop>	
		
		<!--- added function to clean invalid subscriptions based on the pass format --->
						
		<cfparam name="form.GroupDir" default="ASC">			
		<cfset url.listgroupdir   = form.groupdir>
		
		<!--- enable pivot / explore --->
		
		<cfif url.contentmode eq "5">
			<cfset url.listgrouptotal        = "0">
		<cfelse>
			<cfset url.listgrouptotal        = "#form.grouptotal#">	
		</cfif>			
		
		<!--- enable columns --->
		<cfset url.listcolumn1           = "#form.colfield1#">          <!--- i.e transactiondate                   --->
		<cfset url.listcolumn1_type      = "#form.listcolumn1_type#">     <!--- period | common                       --->
		<cfset url.listcolumn1_typemode  = "#form.listcolumn1_typemode#"> <!--- period { year, quarter, month, week } --->
								
		<!--- future 	
			<cfset url.listcolumn2    = "#form.colfield2#">
		--->
		
		<!--- cell content field & formula --->
		<cfset url.datacell1             = "#form.datacell1#">
		<cfset url.datacell1formula      = "#form.datacell1formula#">
		
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

<!--- ---------------------- --->
<!--- ---- obtain settings - --->
<!--- ---------------------- --->

<cfif attributes.headershow eq "Yes">
	
	<!--- apply possible filter --->
	
	<cfif url.treefield neq "undefined" and url.treefield neq "">
		<cfset condition   = " AND #url.treefield# = '#url.treevalue#' ">			
	<cfelseif form.treefield neq "" and form.treevalue neq "">		
		<cfset condition   = " AND #form.treefield# = '#form.treevalue#' ">	
	<cfelse>
	   	<!--- nada --->
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
				
		<cfparam name="current.isKey"             default="0">			
		<cfparam name="current.display"           default="Yes">	
		<cfparam name="current.displayfilter"     default="Yes">	
		<cfparam name="current.isAccess"          default="0">	
		
		<cfparam name="current.field"             default="">	
		<cfparam name="current.fieldsort"         default="#current.field#">			
		<cfparam name="current.column"            default="">	
		<cfparam name="current.alias"             default="">	
		<cfparam name="current.rowlevel"          default="1">	
		
		<cfparam name="current.search"            default="">	
		<cfparam name="current.searchfield"       default="">
		<cfparam name="current.searchalias"       default="">	
		
		<cfparam name="current.filtermode"        default="">	
		<cfparam name="current.filterforce"       default="0">
		<cfparam name="current.lookupQuery"       default="">	
		<cfparam name="current.lookupGroup"       default="">
		
		<cfparam name="current.functionscript"    default="">			
		<cfparam name="current.functionfield"     default="">	
		<cfparam name="current.functioncondition" default="">	
		
		<cfparam name="current.processmode"       default="">	
		
		<cfif current.isKey eq "1">
		
			<cfset drillkeyalias  = current.alias>
			<cfset drillkey       = current.field>
			
			<cfif drillkeyalias neq "">
			    <cfset qdrillkey = "#drillkeyalias#.#drillkey#">
			<cfelse>	
				<cfset qdrillkey = "#drillkey#">
			</cfif>		
		
		</cfif>		
		
		<cfif current.rowLevel gte "2">		
			<cfset attributes.navigation = "paging">		
		</cfif>
				
		<cfparam name="accesslevel" default="0">					
		<cfif current.isAccess eq "1">		
			<cfset accessLevel = current.field>		
		</cfif>
		
		<!--- saving filter values only if this indeed is intended 
		for other fields no saving--->
		
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
				
					<cfif current.filtermode neq "3">																													
						<cf_getUserFilter systemfunctionid="#url.systemfunctionid#" field="#current.field#" filter="#savefilter#">												
					<cfelse>									
					    <cf_getUserFilter systemfunctionid="#url.systemfunctionid#" field="#current.field#" filter="#savefilter#" delimiter="|">
					</cfif>	
																																		
					<!--- declare the form filter field and populate it with the save value --->				   								
					<cfparam name="form.filter#current.field#" default="#getval#">	
															
					<cfset val = evaluate("form.filter#current.field#")>					
					<cfset val = replace( val,"'", "''", "ALL")>
					<cfset val = trim(val)>
																																	
					<cfif val neq "" and len(val) gte "3">															
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
						
						<!--- idealyy we know here if this is a checkbox or kendo multi-select 
						
						<cfif evaluate("form.filter#current.field#_checkbox") eq "Yes">
							<cfset del = ",">
						<cfelse>
						    <cfset del = "|">
						</cfif>		
						---> 			
																																			
						<cfloop index="itm" list="#val#" delimiters="|">
						
							<!--- 30/12/2021 likely we can remove the like as well --->
						
							<cfif thiscondition eq "">							
								<cfset thiscondition   = "#fld# LIKE ('%#itm#%') #CLIENT.Collation#">												
							<cfelse>									                                                         
								<cfset thiscondition   = "#thiscondition# OR #fld# LIKE ('%#itm#%') #CLIENT.Collation#">					
							</cfif> 
							
							<!--- 30/12/2020 : we tuned the filtering using | so this seems to be no longer needed 
						
							<cfif thiscondition eq "">							
								<cfset thiscondition   = "CONVERT(VARCHAR,#fld#) LIKE ('%#itm#%') #CLIENT.Collation#">												
							<cfelse>									                                                         
								<cfset thiscondition   = "#thiscondition# OR CONVERT(VARCHAR,#fld#) LIKE ('%#itm#%') #CLIENT.Collation#">					
							</cfif> 
							
							--->
							
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
						
						<!---
						<cfoutput>#thiscondition#</cfoutput>			
						--->
											
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


<!--- ---------------------- --->
<!--- ------obtain data----- --->
<!--- ---------------------- --->

<!--- correction --->
<cfif url.datacell1 eq "total">
	<cfset url.datacell1formula = "SUM">
</cfif>

<cfinclude template="ListingData.cfm">

<!--- ---------------------- --->
<!--- PRESENTING the result  --->
<!--- ---------------------- --->

<cfset box = attributes.box>  <!--- set by hanno 12/9/19 as box was blank --->

<cfif url.ajaxid eq "content">
  
	<cfif attributes.showlist eq "Yes">				
		<!--- shows the listing as HTML and header --->			
		<cfinclude template="ListingShow.cfm">																			
	</cfif>		

<cfelseif url.ajaxid eq "new">
  
	<cfif attributes.showlist eq "Yes">				
		<!--- shows the listing as HTML and header --->			
		<cfinclude template="ListingShow.cfm">																			
	</cfif>		
	
<cfelseif url.ajaxid eq "append">	

	<!--- shows the listing as HTML and header --->	
	<cfinclude template="ListingContentAJAX_ADD.cfm">			  
		
<cfelse>	

    <cfset dkey = url.ajaxid>
	<!--- performs only an update action --->	
	<cfinclude template="ListingContentAJAX_UPDATE.cfm">		

</cfif>	


<cfset session.listingdata[box]['listingpreparation'] = round((now()- listingtimestart)*100000000)/1000>


<cfsavecontent variable="myscript">
 	_cf_loadingtexthtml='';				
	ptoken.navigate('#session.root#/tools/listing/Listing/setTime.cfm?box=#box#','#attributes.box#_performance');
    ptoken.navigate('#session.root#/tools/listing/Listing/setFilter.cfm?box=#box#','#attributes.box#_ajax'); 
	$('##_divContentFields').scroll(function() {  $(this).find('.sticky').css('left', $(this).scrollLeft());});	
</cfsavecontent>

<cfset AjaxOnLoad("function(){#myscript#}")>

</cfoutput>

<cfparam name="appliedfilter" default="0">

<cfif appliedfilter eq "1" and attributes.calendar eq "9">
	<cfset ajaxonload("doCalendar")>	
</cfif>

