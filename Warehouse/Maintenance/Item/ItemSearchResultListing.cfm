
<cfset session.fmission   = url.fmission>
<cfset session.programcode = url.programcode>
<cfset session.fbarcode   = "">

<cfoutput>
<cfsavecontent variable="myquery">

<!---

<cfquery name="SearchResult" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
	--->
	
		SELECT 	*
		FROM
			(
				SELECT 	I.ItemNo, 
				        I.ItemDescription, 
						I.ItemNoExternal,
						Make, Model, ProgramCode, ItemMaster,  
                        Classification, 
						Destination, 
						ItemPrecision, 
						I.ValuationCode, 
						DepreciationScale, 
						ItemClass, 
                        ParentItemNo, 
						I.Operational, 		
						'#url.fmission#' as Mission,			
									
						C.Description as CategoryDescription, 
						RC.CategoryItemName, 
						RC.CategoryItemOrder,
						(SELECT ProgramName FROM Program.dbo.Program WHERE ProgramCode = I.ProgramCode) as ProgramName,
						
						left(Destination,1) AS DestinationCode,
				
					    (SELECT count(*)
						 FROM   ItemTransaction 						 
						 WHERE  ItemNo = I.ItemNo
						 <cfif url.fmission neq "">
						 AND    Mission = '#url.fmission#' 
						 </cfif>) as InUse,
						 
						 (SELECT COUNT(*)
						  FROM   ItemUoM
						  WHERE  ItemNo = I.ItemNo) as UoMs,										
																			 
						 (SELECT  ROUND(SUM(TransactionQuantityBase),I.ItemPrecision)
						  FROM    ItemTransaction 
						  <cfif url.fmission neq ""> 
						  WHERE   Mission = '#url.fmission#'
						  <cfelse> 
						  WHERE   1=1
						  </cfif>
						  AND     ItemNo = I.ItemNo ) as OnHand,
							 
						 (SELECT  COUNT(*)
						  FROM    ItemUoMMission 
						  WHERE   ItemNo = I.ItemNo 
						  <cfif url.fmission neq ""> 
						  AND     Mission = '#url.fmission#'							 
						  </cfif>							
						  AND     Operational = 1) as Used, 					
												
						(SELECT COUNT(*)
						 FROM   Item 
						 WHERE  ParentItemNo = I.ItemNo) as Children,
						
						I.OfficerUserId, I.OfficerLastName, I.OfficerFirstName,  
						I.Created										 
						 
				FROM 	#CLIENT.LanPrefix#Item I 
				        INNER JOIN #CLIENT.LanPrefix#Ref_Category C ON I.Category = C.Category  
						INNER JOIN Ref_CategoryItem RC ON I.Category = RC.Category AND I.CategoryItem = RC.CategoryItem
						
				WHERE	1 = 1				
				<cfif session.search neq "">				
					AND #PreserveSingleQuotes(session.search)# 
				</cfif>
				
				<cfif session.fbarcode neq "">				
				AND     ItemNo IN (SELECT ItemNo FROM ItemUoM WHERE ItemNo = I.ItemNo AND ItemBarCode LIKE '#session.fbarcode#%')
				</cfif>
				
				<!--- managed / used by this entity --->
				<cfif url.fmission neq "">
				AND		( I.Mission = '#url.fmission#' 
				          OR
						  EXISTS (SELECT 'X' 
							      FROM   ItemUoMMission 
								  WHERE  ItemNo  = I.ItemNo
								  AND    Operational = 1
								  AND    Mission = '#url.fmission#')	
					    )
				</cfif>
				
				<cfif url.used eq "1">
				AND EXISTS (SELECT 'X'
					    	FROM   ItemTransaction 						 
						    WHERE  ItemNo = I.ItemNo
						    <cfif url.fmission neq "">
						    AND    Mission = '#url.fmission#' 
						    </cfif>)							
				</cfif>
				
				<cfif url.programcode neq "">
					AND I.ProgramCode = '#url.ProgramCode#'
				</cfif>	
				
			) SubQ
		WHERE 1=1
		-- condition
		
	
</cfsavecontent>
</cfoutput>

<!---
<cfoutput>#cfquery.executiontime#</cfoutput>
<cfabort>
--->

<!--- show person, status processing color and filter on raise by me --->

<cfparam name="client.header" default="">

<cfset fields=ArrayNew(1)>

<cfset itm = 0>

<!---
<cfif url.fmission neq "">		
	<cf_tl id="Entity" var="1">
	<cfset itm = itm+1>
	<cfset fields[itm] = {label           = "#lt_text#",                   
						field             = "Mission",		
						functionscript    = "item",
						functionfield     = "ItemNo",			
						functioncondition = "#url.fmission#"}>				
</cfif>
--->

<cfset itm = itm+1>
<cf_tl id="ItemNo" var="1">
<cfset fields[itm] = {label           = "#lt_text#", 
                    width             = "0", 
					field             = "ItemNoExternal",		
					functionscript    = "itemclassification",
					functionfield     = "itemno",			
					functioncondition = "#url.systemfunctionid#",			
					search            = "text"}>	

<cfset itm = itm+1>
<cf_tl id="Description" var="1">
<cfset fields[itm] = {label           = "#lt_text#", 
                    width             = "0", 
					field             = "ItemDescription",					
					search            = "text"}>	

<cfset itm = itm+1>			
<cf_tl id="Make" var="1">						
<cfset fields[itm] = {label           = "#lt_text#",                   
					field             = "Make",
					search            = "text"}>	
					
<cfset itm = itm+1>		
<cf_tl id="Category" var="1">
<cfset fields[itm] = {label           = "#lt_text#", 
                    width             = "0", 
					filtermode        = "3",
					field             = "CategoryItemName",					
					search            = "text"}>						

<!---					
<cfset itm = itm+1>		
<cf_tl id="Classification" var="1">
<cfset fields[itm] = {label           = "#lt_text#", 
                    width             = "0", 
					field             = "Classification",					
					search            = "text"}>
--->					
											
<cfset itm = itm+1>		
<cf_tl id="Project" var="1">
<cfset fields[itm] = {label           = "#lt_text#", 
                    width             = "0", 
					field             = "ProgramName",
					filtermode        = "3",
					search            = "text"}>
					
<cfset itm = itm+1>						
<cf_tl id="Created" var="1">
<cfset fields[itm] = {label           = "#lt_text#",    
					width             = "0", 
					field             = "Created",		
					labelfilter       = "Recorded",			
					formatted         = "dateformat(Created,CLIENT.DateFormatShow)",
					search            = "date"}>							
					
<cfset itm = itm+1>							
<cf_tl id="Destination" var="1">
<cfset fields[itm] = {label           = "D", 					
					field             = "DestinationCode",		
					LabelFilter       = "#lt_text#",					
					filtermode        = "3",    
					search            = "text"}>							
					
<cfset itm = itm+1>		
<cf_tl id="Valuation" var="1">
<cfset fields[itm] = {label           = "Value",                    
					filtermode        = "2",    
					LabelFilter       = "#lt_text#",	
					search            = "text",					
					field             = "ValuationCode"}>		
						
<cfset itm = itm+1>		
<cf_tl id="UoM" var="1">
<cfset fields[itm] = {label           = "U",                    
					filtermode        = "0", 
					width             = "6",   
					LabelFilter       = "#lt_text#", 
					search            = "number",					
					field             = "UoMs"}>	
					
<cfset itm = itm+1>		
<cf_tl id="Child" var="1">
<cfset fields[itm] = {label           = "C",                    					  
					search            = "number",	
					width             = "6", 
					LabelFilter       = "#lt_text#", 				
					field             = "Children"}>	
					
<cfset itm = itm+1>		
<cf_tl id="Transactions" var="1">
								
<cfif url.fmission neq "">

	<cfset fields[itm] = {label      = "##",                    					
				LabelFilter          = "#lt_text#",	
				width                = "6", 
				functionscript       = "item",
				functionfield        = "ItemNo",							
				functioncondition    = "#url.fmission#",
				align                = "right",	
				search               = "number",				
				field                = "InUse"}>	
					
<cfelse>

<cfset fields[itm] = {label          = "##",                    					
					LabelFilter      = "#lt_text#",						
					align            = "right",		
					width            = "6", 
					search           = "number",			
					field            = "InUse"}>	

</cfif>					
											
<cfset itm = itm+1>				
<cf_tl id="On Hand" var="1">
<cfset fields[itm] = {label          = "#lt_text#",    
					width            = "0", 
					field            = "OnHand",	
					align            = "right",			
					formatted        = "lsNumberFormat(OnHand,'[precision]')",
					precision        = "ItemPrecision",
					search           = "amount"}>	
					
<cfset itm = itm+1>		
<cf_tl id="Operational" var="1">				
<cfset fields[itm] = {label          = "S", 	
                    LabelFilter      = "#lt_text#",				
					field            = "Operational",					
					filtermode       = "3",    
					search           = "text",
					align            = "center",
					formatted        = "Rating",
					ratinglist       = "1=Green,0=Red"}>												
	
	<cfset str = "mission=#url.fmission#">
										
	<cf_listing
    	header        = "lsItem"
    	box           = "lsItem"
		link          = "#SESSION.root#/Warehouse/Maintenance/Item/ItemSearchResultListing.cfm?systemfunctionid=#url.systemfunctionid#&used=#url.used#&fmission=#url.fmission#&programcode=#url.programcode#"		
    	html          = "No"
		show	      = "100"
		datasource    = "AppsMaterials"
		listquery     = "#myquery#"
		listkey       = "ItemNo"
		listgroup     = ""	
		listorder     = "ItemDescription"		
		listorderdir  = "ASC"
		headercolor   = "ffffff"
		listlayout    = "#fields#"		
		filterShow    = "Hide"
		excelShow     = "Yes"
		drillmode     = "tab"	
		drillstring   = "#str#"
		drilltemplate = "Warehouse/Maintenance/ItemMaster/ItemView.cfm?id="
		drillkey      = "ItemNo">

