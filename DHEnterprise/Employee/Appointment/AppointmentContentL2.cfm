
<!--- control list data content --->

<!---

SELECT   IndexNo,
		          PADocument as ActionDocumentNo,
				  Year(PAEffective) as ActionYear,
		          PAEffective as DateProcessed,
				  AppointmentType,
				  Series as ContractStatus,
				  '' as ContractTerm,
				  EffectiveDate as DateEffective,
				  ExpirationDate as DateExpiration,
				  PensionNo,
				  'IMIS' as Source
	     FROM     WarehousePMSS.dbo.StaffPALineAppointment
		 WHERE    IndexNo = '#URL.IndexIMIS#' 
		 AND      Source = 'IMIS'
		 
		 --->

<cfparam name="url.UmojaIndexNo" default="">				 
<cfparam name="url.indexNo" default="#url.umojaindexno#">		

<cfif len(url.indexno) eq "8">
	<cfset indeximis = right(url.indexno,6)>
</cfif> 
		 
<cfsavecontent variable="myquery">

	<cfoutput>	  	
		
		SELECT *
		FROM (
		
		 		
		 SELECT   IndexNo,
		          ActionDocumentNo,
				  Year(ChangeEffective) as ActionYear,
		          ChangeEffective as DateProcessed,
				  AppointmentType,
				  AppointmentTypeName,
				  AppointmentStatusName as ContractTerm,
				  '' as ContractStatus,
				  AppointmentEffective  as DateEffective,
				  AppointmentExpiration as DateExpiration,
				  PensionFundNo as PensionNo,
				  'IMIS' as Source
	     FROM     IMIS_UNC.dbo.IMP_PersonAppointment
		 WHERE    IndexNo = '#URL.IndexNo#' 
						
		UNION ALL
				
		SELECT   IndexNo,
		         '49999999' as ActionDocumentNo,
				 Year(ContractEffective) as ActionYear,
				 P.ContractEffective as DateProcessed,  <!--- has to come from the action PersonAppointmentAction --->
				 R.AppointmentType,
				 R.AppointmentTypeName,				
				 (SELECT ContractTermDescription   FROM Ref_ContractTerm   WHERE ContractTerm = P.ContractTerm) as ContractTerm,			
				  (SELECT ContractStatusDescription FROM Ref_ContractStatus WHERE ContractStatus = P.ContractStatus) as ContractStatus,
				 DateEffective,
				 DateExpiration,
				 '' as PensionNo,
				 Source as Source				 	
	      
	    FROM     PersonAppointment P INNER JOIN Ref_ContractType R ON P.AppointmentType = R.AppointmentType	
		AND      IndexNo = '#url.IndexNo#' 	
		AND      TransactionStatus = '1'
		AND      TransactionLevel  = '2'
						
		) as L
		
		WHERE 1=1
			
		--Condition
						
	</cfoutput>	
	
</cfsavecontent>

<script>
	Prosis.busy('no')
</script>

<cfset itm = 0>

<cfset fields=ArrayNew(1)>

	<cfset itm = itm+1>	
	<cf_tl id="Appointment" var = "1">		
	<cfset fields[itm] = {label       = "#lt_text#",                    
	     				field         = "AppointmentTypeName",																																																		
						displayfilter = "yes",																																									
						search        = "text",
						filtermode    = "2"}>		
						
							
						
	<cfset itm = itm+1>
	<cf_tl id="Approx. Eff" var = "1">		
	<cfset fields[itm] = {label       = "#lt_text#",                    
	     				field         = "DateProcessed",	
						displayfilter = "no",	
						search        = "date",
						formatted     = "dateformat(DateProcessed,client.dateformatshow)"}>						
						
				
							
	<cfset itm = itm+1>
	<cf_tl id="Year" var = "1">		
	<cfset fields[itm] = {label       = "#lt_text#",                    	                   
	     				field         = "ActionYear",																																												
						search        = "text",													
						filtermode    = "2"}>			
						
								
						
	<cfset itm = itm+1>
	<cf_tl id="Start" var = "1">		
	<cfset fields[itm] = {label       = "#lt_text#",                    	                   
	     				field         = "DateEffective",	
						displayfilter = "no",																																												
						search        = "date",													
						formatted     = "dateformat(DateEffective,client.dateformatshow)"}>					
				
	<cfset itm = itm+1>
	<cf_tl id="End" var = "1">		
	<cfset fields[itm] = {label       = "#lt_text#",                    
	     				field         = "DateExpiration",	
						displayfilter = "no",	
						search        = "date",
						formatted     = "dateformat(DateExpiration,client.dateformatshow)"}>													
						
	<cfset itm = itm+1>	
	<cf_tl id="Term" var = "1">		
	<cfset fields[itm] = {label       = "#lt_text#",                    
	     				field         = "ContractTerm",								
						display       = "1",																																					
						displayfilter = "yes",
						search        = "text",
						filtermode    = "3"}>		
											
	
							
	<cfset itm = itm+1>	
	<cf_tl id="Status" var = "1">		
	<cfset fields[itm] = {label       = "#lt_text#",                    
	     				field         = "ContractStatus",								
						display       = "1",																																					
						displayfilter = "yes",
						search        = "text",
						filtermode    = "3"}>		
					
	<cfset itm = itm+1>	
	<cf_tl id="Pension" var = "1">		
	<cfset fields[itm] = {label       = "#lt_text#",                    
	     				field         = "PensionNo",								
						display       = "1",																																					
						displayfilter = "yes"}>		
						
	<cfset itm = itm+1>
	<cf_tl id="PANo" var = "1">			
	<cfset fields[itm] = {label       = "#lt_text#",                    
	     				field         = "ActionDocumentNo",					
						alias         = "",							
						width         = "20",																	
						search        = "text"}>						
						
	<cfset itm = itm+1>	
	<cf_tl id="Source" var = "1">		
	<cfset fields[itm] = {label       = "#lt_text#",                    
	     				field         = "Source",								
						display       = "1",																																					
						displayfilter = "yes",
						search        = "text",
						filtermode    = "3"}>																		
						
	<!---															
	
	<cfset itm = itm+1>	
	<cf_tl id="Officer" var = "1">		
	<cfset fields[itm] = {label       = "#lt_text#",                    
	     				field         = "Officer",								
						display       = "1",																																					
						displayfilter = "yes",
						search        = "text",
						filtermode    = "2"}>	
						
						
						
	<cfset itm = itm+1>
	<cf_tl id="Processed" var = "1">		
	<cfset fields[itm] = {label       = "#lt_text#",                    
	     				field         = "DateProcessed",	
						search        = "date",
						formatted     = "dateformat(DateProcessed,client.dateformatshow)"}>		
						
						--->							
																							
<cfset menu=ArrayNew(1)>	

<!---
	listgroupfield      = "AppointmentTypeName"
	listgrouporder      = "DateProcessed"
	listgroupdir        = "DESC"		
	
	--->
	
		
	
<cf_listing
	    header              = "action"
	    box                 = "actionlisting"
		link                = "#SESSION.root#/DHEnterprise/Employee/Appointment/AppointmentContentL2.cfm?indexno=#url.indexno#&systemfunctionid=#url.systemfunctionid#"
	    html                = "No"		
		tableheight         = "100%"
		tablewidth          = "100%"
		calendar            = "9" 
		font                = "Calibri"
		datasource          = "hubEnterprise"
		listquery           = "#myquery#"				
		listorderfield      = "DateProcessed"
		listorder           = "DateProcessed"
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
		drilltemplate       = "../../DWarehouse/InquiryEmployee/PA_Detail.cfm?id2=#indexIMIS#&id1="
		drillkey            = "ActionDocumentNo">	
		
	