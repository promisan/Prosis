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
<cfparam name="url.mission" default=""> 

<cfoutput>
    
	 <cfsavecontent variable="myquery">	
	 
		SELECT   newid() as Id, 
		         Fund, 
		         Service, 
				 Class, 
				 Object, 
				 objc_descr,
				 f_glan_seq_num,
				 f_dorf_id_code+'-'+STR(part1_doc_id) as Document1, 
				 f_dorf_id_code_2+'-'+STR(part1_doc_id_2) as Document2,
				 primary_dorf_doc_descr,
				 postd_date,
				 postd_acct_prd,
				 
				 CASE WHEN f_glan_seq_num = '4510' THEN ROUND(SUM(ExpenditureAmount), 2) END AS Preencumbered,
				 CASE WHEN f_glan_seq_num = '6210' THEN ROUND(SUM(ExpenditureAmount), 2) END AS Obligated, 
				 CASE WHEN f_glan_seq_num = '6310' THEN ROUND(SUM(ExpenditureAmount), 2) END AS Disbursed
				 
		FROM     Userquery.dbo.#SESSION.acc#IMIS		 
		
		GROUP BY postd_acct_prd,
		         Fund, 
		         Service, 
				 Class, 
				 Object, 
				 objc_descr, 
				 f_glan_seq_num, 
				 f_dorf_id_code, 
				 part1_doc_id, 
				 postd_date, 
	             f_dorf_id_code_2, 
				 part1_doc_id_2,
				 primary_dorf_doc_descr,
				 postd_date		
		
	</cfsavecontent>	

</cfoutput>
	  
<cfset fields=ArrayNew(1)>
	
	<cfset fields[1] = {label   = "Posted",                  
						field   = "postd_date",
						filtermode = "1",
						search  = "date",
						formatted  = "dateformat(postd_date,'#CLIENT.DateFormatShow#')"}>		
	
	<cfset fields[2] = {label      = "Period",                  
						field      = "postd_acct_prd",
						fieldsort  = "postd_acct_prd",
						filtermode = "1",
						search     = "number"}>							
			
						
	<cfset fields[3] = {label   = "Document 1",                  
						field   = "Document1",
						filtermode = "0",
						align = "center",
						searchfield = "part1_doc_id",
						search  = "text"}>	
						
	<cfset fields[4] = {label       = "Document 2",                  
						field       = "Document2",
						filtermode  = "0",
						align       = "center",
						searchfield = "part1_doc_id_2",
						search      = "text"}>														
								
	<cfset fields[5] = {label       = "Fund", 					
						field       = "Fund",					
						filtermode  = "2",    
						align       = "center",
						search      = "text"}>		
						
	<cfset fields[6] = {label       = "Service",  					
						field       = "Service",
						filtermode  = "2",		
						align       = "center",				
						search      = "text"}>								
						
	<cfset fields[7] = {label       = "Class",  					
						field       = "Class",
						filtermode  = "2",	
						align       = "center",					
						search      = "text"}>
						
	<cfset fields[8] = {label       = "Object",  					
						field       = "Object",
						filtermode  = "2",	
						align       = "center",					
						search      = "text"}>					
						
	<cfset fields[9] = {label       = "Preenc",  					
						field       = "Preencumbered",
						align       = "right",
						formatted   = "numberformat(preencumbered,'__,__')",			
						filtermode  = "0"}>	
						
	<cfset fields[10] = {label      = "Obligated",  					
						field       = "Obligated",
						align       = "right",
						formatted   = "numberformat(obligated,'__,__')",			
						filtermode  = "0"}>		
						
	<cfset fields[11] = {label      = "Disbursed",  					
						field       = "Disbursed",
						align       = "right",
						filtermode  = "0",	
						formatted   = "numberformat(disbursed,'__,__')"}>		
													
	<cfset fields[12] = {label      = "id",  					
						field       = "id",
						display     = "0",
						filtermode  = "0",						
						search      = "text"}>		
						
<cfset fields[13] = {label          = "Memo",  					
						field       = "primary_dorf_doc_descr",
						filtermode  = "0",	
						colspan     = "7",
						rowlevel    = "2",										
						search      = "text"}>													
	
<cf_listing  header        = "imis"
			 box           = "imis"
			 link          = "#SESSION.root#/Procurement/Application/Funding/Detail/IMISContent.cfm?mission=#url.mission#"
			 html          = "No"
			 show          = "500"
			 datasource    = "appsQuery"
			 listquery     = "#myquery#"
			 listkey       = "id"
			 listgroup     = "postd_acct_prd"
			 listorder     = "postd_date"
			 listorderdir  = "ASC"		
			 headercolor   = "ffffff"
			 listlayout    = "#fields#"
			 filterShow    = "Hide"
			 excelShow     = "Yes">
					  
 	