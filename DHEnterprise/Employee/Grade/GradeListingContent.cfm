

<!--- control list data content, 
      later this record will be removed or set as historica record --->

<cfquery name="Exclude" 
datasource="hubEnterprise" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM      PersonGrade P
	WHERE     IndexNo = '#url.IndexUmoja#'	
	AND       Source  = 'IMIS'
	AND       DateEffective >= (SELECT MIN(DateEffective) 
	                            FROM   PersonGrade X
								WHERE  X.IndexNo    = P.IndexNo
								AND    X.Source     = 'UMOJA'
								AND    X.GradeClass = 'Regular')
</cfquery>


<cfsavecontent variable="myquery">

	<cfoutput>	  
		
		SELECT DISTINCT GradeClass,
		                IndexNo, 
						ActionDocumentNo, 
						ActionYear, 
						DateProcessed, 
						GradeEffective, 
						Grade, 
						StepEffective, 
						Step, 
						DateExpiration,
						Pas,
						Source
		
		FROM (		   
		   		
			SELECT    GradeClass,
			          IndexNo,
			          '49999999' as ActionDocumentNo,		
					  YEAR(DateEffective) as ActionYear,	  				  
					  DateEffective as DateProcessed,
					  GradeEffective,
					  Grade,
					  DateEffective as StepEffective,
					  Step,
					  DateExpiration,		
					  1 as PAs,			 
					  Source		 
			FROM      PersonGrade P
			WHERE     IndexNo = '#url.IndexUmoja#'	
			AND       TransactionStatus != '9'
			<cfif Exclude.recordcount gte "1">							   
			AND        Transactionid NOT IN (#QuotedValueList(Exclude.TransactionId)#)								
			</cfif>
			
			AND       HistoricAction = '0'									   
				
		) as L
		
		WHERE 1=1
			
		--Condition
						
	</cfoutput>	
	
</cfsavecontent>

<cfset itm = 0>

<cfset fields=ArrayNew(1)>
							
	<cfset itm = itm+1>
	<cf_tl id="Class" var = "1">		
	<cfset fields[itm] = {label       = "#lt_text#",                    	                   
	     				field         = "GradeClass",
						search        = "text",													
						filtermode    = "3"}>								
						
	<cfset itm = itm+1>
	<cf_tl id="Year" var = "1">		
	<cfset fields[itm] = {label       = "#lt_text#",                    	                   
	     				field         = "ActionYear",																																												
						search        = "text",													
						filtermode    = "2"}>							
						
	
	<cfset itm = itm+1>
	<cf_tl id="Grade" var = "1">		
	<cfset fields[itm] = {label       = "#lt_text#",                    	                   
	     				field         = "Grade",	
						search        = "text",													
						filtermode    = "2"}>	
						
				
						
						
	<cfset itm = itm+1>
	<cf_tl id="Step" var = "1">		
	<cfset fields[itm] = {label       = "#lt_text#",                    	                   
	     				field         = "Step"}>	
						
	<cfset itm = itm+1>
	<cf_tl id="Effective" var = "1">		
	<cfset fields[itm] = {label       = "#lt_text#",                    	                   
	     				field         = "StepEffective",	
						displayfilter = "no",																																												
						search        = "date",													
						formatted     = "dateformat(StepEffective,client.dateformatshow)"}>					
					
						
	<cfset itm = itm+1>
	<cf_tl id="Expiry" var = "1">		
	<cfset fields[itm] = {label       = "#lt_text#",                    	                   
	     				field         = "DateExpiration",	
						displayfilter = "no",																																												
						search        = "date",													
						formatted     = "dateformat(DateExpiration,client.dateformatshow)"}>		
						
	
	<cfset itm = itm+1>
	<cf_tl id="PANo" var = "1">			
	<cfset fields[itm] = {label       = "#lt_text#",                    
	     				field         = "ActionDocumentNo",					
						alias         = "",							
						width         = "20",																	
						search        = "text"}>	
						
	<cfset itm = itm+1>			
	<cfset fields[itm] = {label       = "Cnt",                    
	     				field         = "PAs",					
						alias         = "",							
						width         = "5",																	
						search        = "text"}>																			
					
	
	<cfset itm = itm+1>
	<cf_tl id="Grade Eff" var = "1">		
	<cfset fields[itm] = {label       = "#lt_text#",                    	                   
	     				field         = "GradeEffective",	
						displayfilter = "no",																																												
						search        = "date",													
						formatted     = "dateformat(GradeEffective,client.dateformatshow)"}>																
							
	<cfset itm = itm+1>	
	<cf_tl id="Source" var = "1">		
	<cfset fields[itm] = {label       = "#lt_text#",                    
	     				field         = "Source",								
						display       = "1",																																					
						displayfilter = "yes",
						search        = "text",
						filtermode    = "3"}>		
						
	<cfset itm = itm+1>
	<cf_tl id="Last Processed" var = "1">		
	<cfset fields[itm] = {label       = "#lt_text#",                    
	     				field         = "DateProcessed",	
						search        = "date",
						formatted     = "dateformat(DateProcessed,client.dateformatshow)"}>		
															
	
	<!---
	<cfset itm = itm+1>	
	<cf_tl id="Officer" var = "1">		
	<cfset fields[itm] = {label       = "#lt_text#",                    
	     				field         = "Officer",								
						display       = "1",																																					
						displayfilter = "yes",
						search        = "text",
						filtermode    = "2"}>	
						--->
						
								
														
		
	<!--- ----- --->					
	<!--- row 2 --->
	<!--- ----- 
	
	<cfset itm = itm+1>	
	<cf_tl id="Reason" var = "1">		
	<cfset fields[itm] = {label       = "#lt_text#",                    
	     				labelfilter   = "#lt_text#",
						field         = "ActionReason",	
						display       = "1",								
						rowlevel      = "2",
						Colspan       = "7",																																													
						search        = "text"}>		
						
	--->							
							
																
<cfset menu=ArrayNew(1)>	

<cf_listing
	    header              = "grade"
	    box                 = "gradelisting"
		link                = "#SESSION.root#/DWarehouse/InquiryEmployee/Search_ResultGRContent.cfm?indexUmoja=#url.indexUmoja#&indexIMIS=#url.indexIMIS#&systemfunctionid=#url.systemfunctionid#"
	    html                = "No"		
		tableheight         = "100%"
		tablewidth          = "100%"
		calendar            = "9" 
		font                = "Calibri"
		datasource          = "hubEnterprise"
		listquery           = "#myquery#"				
		listorderfield      = "StepEffective"
		listorder           = "StepEffective"
		listorderdir        = "DESC"		
		headercolor         = "ffffff"		
		menu                = "#menu#"
		showrows            = "2"
		show                = "60"
		printshow           = "Yes"
		printshowtitle      = "#client.printtitle#"
		printshowrows       = "500"
		filtershow          = "Hide"
		excelshow           = "Yes" 					
		listlayout          = "#fields#"
		drillmode           = "tab" 
		drillargument       = "#client.height-90#;#client.width-90#;false;false"	
		drilltemplate       = "../../DWarehouse/InquiryEmployee/PA_Detail.cfm?id2=#url.indexIMIS#&id1="
		drillkey            = "ActionDocumentNo">		
		
		