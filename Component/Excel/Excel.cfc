<!--
    Copyright © 2025 Promisan

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

<!--- 
   Name : /Component/Process/Program.cfc
   Description : Execution procedures
   
   1.1.  Generate Excel header 
   1.2.  Generate Excel Section      
---> 

<cfcomponent>

    <cfproperty name="name" type="string">
    <cfset this.name = "Execution Queries">
		
	   <cffunction name ="getCleanHtml">
			 <cfparam name="val"    default="">		
			 
			 <cfset valStr = REReplaceNoCase(val,"<[^>]*>","","ALL")>
			 <cfset valStr = ReplaceNoCase(valStr,"&nbsp;"," ","ALL")>
			 <cfset valStr = ReplaceNoCase(valStr,"<br>","#CHR(10)##CHR(13)#","ALL")>
			 <cfset valStr = ReplaceNoCase(valStr,"</br>","#CHR(10)##CHR(13)#","ALL")>
			 <cfset valStr = ReplaceNoCase(valStr,"<p>"," ","ALL")>
				 <cfset valStr = ReplaceNoCase(valStr,"</p>"," ","ALL")>
			 <cfset valStr = ReplaceNoCase(valStr,"&amp;"," ","ALL")>
	   		<cfreturn valStr>
	   
	   </cffunction>
	
		<cffunction name="getstatus" 
		 access="remote" 
		 returntype="any" 
		 displayname="Progress" 
		 verifyClient = "yes"
		 output="false">
		 	 
			 <cfset str = structNew()>	
			 			
			 <cfparam name="Session.Status"    default="0">		
			 <cfparam name="Session.StatusStr" default="Initialize">	 	 
			 <cfset str.status  = "#Session.Status#">	
			 <cfset str.message = "Preparing: #Session.StatusStr#">	
			 
			 <cfif session.status eq "1">
			 
			 	<cfset session.status = "0">			 
			 	<cfset str.message = "Done">
								
			 </cfif>
			 		 
			 <cfreturn str>
		 		 
		</cffunction> 


		<cffunction name="DumpExcelTable" 
		 access="public" 
		 returntype="any" 
		 verifyClient = "yes"
		 displayname="Dump Excel Table" 
		 output="yes">
				
			<cfargument name="datasource"  type="string" required="true"   default="">
			<cfargument name="dataquery"   type="string" required="true"   default="">				
							
			<cfargument name="filename"    type="string" required="true"   default="">
			<cfargument name="sheetname"   type="string" required="true"   default="My sheet">
			
			<cfargument name="cols"        type="array"  required="yes">				

			<cfloop index="x" from="1" to="#ArrayLen(cols)#">
			
			    <cfif x eq "1">
				    <cfset sel = "[#cols[x][1]#] as ['#cols[x][3]#']">
				<cfelse>
					<cfset sel = "#sel#,[#cols[x][1]#] as ['#cols[x][3]#']">
				</cfif>	
			
			</cfloop>

			<cfquery name="data" 
				datasource="#datasource#">
					SELECT 	#sel#
					#dataquery# 
			</cfquery>							
			
			<!---
			
			<cfset xlObj = spreadsheetNew("testsheet", true)>
			<cfset spreadsheetAddRows(xlObj, "#data#")>
			<cfset spreadsheetwrite(xlObj, "#session.rootpath#//cfrstage//testing.xlsx", "", true, false)>
			
			--->
			
		    <cfspreadsheet action="write"
			      autosize="false" 
				  filename="#filename#" 
				  query="data" 
				  sheetname="#sheetName#" 
				  overwrite="true">
				 			
		</cffunction>
	
		<cffunction name="ExcelTable" 
			 access="public" 
			 returntype="any" 
			 verifyClient = "yes"
			 displayname="Excel Table" 
			 output="yes">
				
		<cfargument name="datasource"  type="string" required="true"   default="">
		<cfargument name="dataquery"   type="string" required="true"   default="">		
		<cfargument name="format"      type="string" required="true"   default="xlsx">			
		<cfargument name="cols"        type="array"  required="yes">				
						
		<cfargument name="filename"    type="string" required="true"   default="">
		<cfargument name="sheetname"   type="string" required="true"   default="My sheet">	
		<cfargument name="rowstart"    type="numeric"                  default="2">		
				
		<cfoutput>
		
		<cfset session.status = 0.0>
				
		<cfloop index="x" from="1" to="#ArrayLen(cols)#">
		
		    <cfif x eq "1">
			    <cfset lbl = "#cols[x][3]#">
			    <cfset sel = "[#cols[x][1]#]">
			<cfelse>
				<cfset lbl = "#lbl#,#cols[x][3]#">
				<cfset sel = "#sel#,[#cols[x][1]#]">
			</cfif>	
		
		</cfloop>		
		
		<cfif format eq "xls">
			<cfset thesheet    = SpreadsheetNew("my extract","no")>				
		<cfelse>
			<cfset thesheet    = SpreadsheetNew("my extract","yes")>		 
		</cfif>		
		
		<!--- Set the speadsheet meta info --->
		<cfset info                 = StructNew()> 
		<cfset info.title           = "#SESSION.welcome# Excel Engine"> 
		<cfset info.category        = "Financials"> 
		<cfset info.author          = "#SESSION.welcome# Excel Engine"> 
		<cfset info.comments        = "Revised by Hanno van Pelt October 2022"> 
		<cfset spreadsheetaddInfo(thesheet,info)> 
		
		<!--- set the default formatting content --->
		
		<cfset formatCel   = structNew()>
		
		<cfset formatCel.textwrap          = "false"> 
		<cfset formatCel.alignment         = "left,vertical_top"> 
		<cfset formatCel.font              = "Calibri"> 
		<cfset formatCel.fontsize          = "12"> 
		<cfset formatCel.color             = "black"> 
		<cfset formatCel.italic            = "false"> 
		<cfset formatCel.bold              = "false">    
		<cfset formatCel.textwrap          = "false">    
		<cfset formatCel.bottomborder      = "thin"> 
		<cfset formatCel.bottombordercolor = "blue_grey"> 
		<cfset formatCel.topbordercolor    = "blue_grey"> 
		<cfset formatCel.topborder         = "thin"> 
		<cfset formatCel.leftborder        = "dotted"> 
		<cfset formatCel.leftbordercolor   = "blue_grey"> 
		<cfset formatCel.rightborder       = "dotted"> 
		<cfset formatCel.rightbordercolor  = "blue_grey"> 		
		
		<!--- ----------------------------------- --->
		<!--- set the freezing of the header line --->
		<!--- ----------------------------------- --->
		
		<cfset SpreadsheetAddFreezePane(thesheet,1,1)>			
		<cfset SpreadsheetAddRow(theSheet,"No,#lbl#",1,1)> 	
		
		<cfset formatCel.font              = "Calibri"> 
		<cfset formatCel.fgcolor           = "silver"> 		
		<cfset formatCel.alignment         = "center"> 
		<cfset formatCel.textwrap          = "true">   
		
		<cfset SpreadsheetFormatRow(theSheet,formatCel,1)>
		<cfset SpreadsheetSetRowHeight(theSheet,1,40)>
		
		<cftry>
				
			<cfquery name="total" 
				 datasource="#datasource#"
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#"> 
			     SELECT #sel#
				 #preservesinglequotes(dataquery)#					     			   
		    </cfquery> 
		
			<cfcatch>
					
					<cfquery name="total" 
						 datasource="#datasource#"> 
					     SELECT #sel#
						 #preservesinglequotes(dataquery)#					     			   
				    </cfquery> 
			
			</cfcatch>	
			
		</cftry>
		
		<!--- ----------------------------------- --->
		<!--- --------Body of the sheet---------- --->
		<!--- ----------------------------------- --->			
		
		<cfset sumlist = "">		
						
		<cfif GroupByOne eq "">  	
		
			<cfset session.status = 0.5>
									
			<cfinvoke component="Service.Excel.Excel"
             method          = "ExcelSection"    
			  total          = "#total.recordcount#"
			  records        = "#total.recordcount#"           
			  sectiondata    = "#total#"	        
			  thesheet       = "#thesheet#"
	          cols           = "#cols#"
	          rowstart       = "2"
			  returnvariable = "sheetend"/>	
			  
			 <cfset session.status = 0.5> 
			  			  
			 <cfset sumlist = "#sheetend#">
					   		   
		<cfelse> 
		
			<cfset rowstart = "2">
			
			<cfset session.status    = "0">				
			
			<cfquery name="group1" dbtype="query"> 
			     SELECT DISTINCT #groupbyone#
				 FROM   Total	 			   
		    </cfquery> 			
						
			<cfloop query="group1">	
			
				<cfset perc = currentrow/recordcount>
				<cfset perc = "#perc-0.05#">	
																		
				<cftry>		
				
					<cfset val = replace(evaluate(groupbyone),"'","''","ALL")>
							
				   	<cfquery name="sectiondata" dbtype="query">
					        SELECT #sel#				    			
							FROM   Total
							WHERE  #groupbyone# = '#val#'						
					</cfquery> 		

					<cfcatch>
					
						<!--- Note : remove the strings around it as query does not accept this --->					
					 	<cfquery name="sectiondata" dbtype="query">
					        SELECT #sel#				    			
							FROM   Total
							WHERE  #groupbyone# = #val#						
					     </cfquery> 		
					
					</cfcatch>
				
				</cftry>
												
				<cfset session.status    = "#perc#">
				<cfset session.statusStr = "#val#">
				
				<!--- add a group header line --->																	
					
				<cfset SpreadsheetAddRow(theSheet,"#evaluate(groupbyone)# [#sectiondata.recordcount# records]","#rowstart#",1)> 	
								
				<cfset formatCel.fgcolor          = "lemon_chiffon">  
				<cfset formatCel.alignment        = "center"> 	
				<cfset formatCel.color            = "black"> 
				<cfset formatCel.fontsize         = "14"> 
				<cfset formatCel.topbordercolor   = "blue_grey"> 
				<cfset formatCel.topborder        = "thin"> 			
										
				<cfset SpreadsheetSetRowHeight(theSheet,rowstart,30)>
																			
				<cfset SpreadsheetMergeCells(theSheet, rowstart, rowstart, 1, "#ArrayLen(cols)+1#")>	
								
				<cfset SpreadsheetFormatRow(theSheet,formatCel,rowstart)> 	
									
																				
				<!--- now check for the second grouping --->
				
				<cfif groupbyTwo neq "">
				
					<cfset grouplist = "">
				
					<cfquery name="group2" dbtype="query"> 
				     SELECT DISTINCT #groupbytwo#
					 FROM   SectionData		 						 	   
				    </cfquery> 
					
					<cfloop query="group2">	
					
						<cfset val = replace(evaluate(groupbytwo),"'","''","ALL")>												
										
						<cftry>		
								
						   	<cfquery name="section2data" dbtype="query">
							    SELECT #sel#				    			
								FROM   SectionData
								WHERE  #groupbytwo# = '#val#'											
							</cfquery> 		
		
								<cfcatch>
								
									<!--- Note : remove the strings around it as query does not accept this --->					
								 	<cfquery name="section2data" dbtype="query">
								        SELECT #sel#				    			
										FROM   SectionData
										WHERE  #groupbytwo# = #val#						
								     </cfquery> 		
								
								</cfcatch>
					
						</cftry>
						
						<cfset rowstart = rowstart+1>
						
						<!--- add a sub group header line --->										
														
						<cfset SpreadsheetAddRow(theSheet,"#evaluate(groupbytwo)# [#section2data.recordcount# records]",rowstart,1)> 	
												
						<cfset formatCel.fgcolor    = "light_turquoise"> 
						<cfset formatCel.color      = "black">  
						<cfset formatCel.alignment  = "center"> 
						<cfset formatCel.fontsize   = "14"> 	
						<cfset formatCel.topbordercolor    = "blue_grey"> 
						<cfset formatCel.topborder         = "thin"> 		
						
						<cfset SpreadsheetSetRowHeight(theSheet,rowstart,28)>																	
											
						<cfset SpreadsheetMergeCells(theSheet, rowstart, rowstart, 1, "#ArrayLen(cols)+1#")>	
						
						<cfset SpreadsheetFormatRow(theSheet,formatCel,rowstart)> 														
						<!--- <cfset SpreadsheetFormatCell(theSheet,formatCel,rowstart,"1")> --->
												
						<cfset rowstart = rowstart+1>
				
						<!--- generate the body of the group --->
			
						<cfinvoke component   = "Service.Excel.Excel"
		            	  method              = "ExcelSection"  
						  total               = "#total.recordcount#"     						  
						  records             = "#sectiondata.recordcount#"		        
						  sectiondata         = "#section2data#"		         
						  thesheet            = "#thesheet#"
			        	  cols                = "#cols#"				  
				          rowstart            = "#rowstart#"
						  returnvariable      = "sheetend"/>	
						  
						 <!--- capture the total for final summary ---> 
				
						 <cfif grouplist eq "">
						  	  <cfset grouplist = "#sheetend#">
						 <cfelse>
							  <cfset grouplist = "#grouplist#,#sheetend#">
						 </cfif> 
						 
						 <!--- next line --->
				  
					     <cfset rowstart = sheetend+1>		
						 
					</cfloop>
					
					<!--- create a final line for all the groups on level 2 --->
					
					 <cfinvoke component = "Service.Excel.Excel"
	            	  method             = "ExcelSummary"  
					  total              = "#total.recordcount#"             
					  records            = "#sectiondata.recordcount#"		         
					  Sumformula         = "#grouplist#"
					  thesheet           = "#thesheet#"
					  color              = "lemon_chiffon" 
		        	  cols               = "#cols#"				  
			          rowstart           = "#rowstart#"/>		
					  
					 <cfif sumlist eq "">
					  	  <cfset sumlist = "#rowstart#">
					 <cfelse>
						  <cfset sumlist = "#sumlist#,#rowstart#">
					 </cfif>
					  
					 <cfset rowstart = rowstart+1>	
														
				<cfelse>
													
					<cfset rowstart = rowstart+1>
					
					<!--- generate the body of the group --->
				
					<cfinvoke component = "Service.Excel.Excel"
	            	  method            = "ExcelSection"  
					  total             = "#total.recordcount#"
					  records           = "#total.recordcount#"		           
					  sectiondata       = "#sectiondata#"		         
					  thesheet          = "#thesheet#"
		        	  cols              = "#cols#"				  
			          rowstart          = "#rowstart#"
					  returnvariable    = "sheetend"/>	
					 
					 <!--- capture the total for final summary ---> 
					
					 <cfif sumlist eq "">
					  	  <cfset sumlist = "#sheetend#">
					 <cfelse>
						  <cfset sumlist = "#sumlist#,#sheetend#">
					 </cfif>
					  
					 <!--- next line --->
					  
					 <cfset rowstart = sheetend+1>	
					 
				</cfif>	 
			
			<!--- end grouping 1 --->
						
			</cfloop>
						
			<!--- create a final line for all the groups on level 1  --->
			
			<cfinvoke component    = "Service.Excel.Excel"
	            	  method       = "ExcelSummary"   
					  total        = "#total.recordcount#" 					             
					  records      = "#total.recordcount#"		         
					  Sumformula   = "#sumlist#"
					  thesheet     = "#thesheet#"
					  color        = "pale_blue" 
		        	  cols         = "#cols#"				  
			          rowstart     = "#rowstart#"/>	
		 
		</cfif>  		
								
		<!--- ---------------------------------- --->
		<!--- ----Generate final spreadhseet---- --->
		<!--- ---------------------------------- --->
		
		<!--- opening sheet --->

		<cfspreadsheet action    = "write" 
		               filename  = "#filename#" 
					   autosize  = "false"
					   name      = "theSheet"  
         		       sheet     = 1 
					   sheetname = "Data" 
					   overwrite = "true">
		
		<!--- preview sheet, to prevent error message in Excel --->
								   
		<cfspreadsheet action    = "write" 
		               filename  = "#filenamepreview#" 
					   name      = "theSheet"  
					   autosize  = "false"
         		       sheet     = 1 
					   sheetname = "Data" 
					   overwrite = "true">		
					   
		<cfset session.status = "1.0">			   	   
					
		</cfoutput>
		
		</cffunction>				
		
		<cffunction name="ExcelSection"
		        access       = "public"
		        returntype   = "any"				 
				output       = "yes"
				verifyClient = "yes"
		        displayname  = "Excel Table">
				
				<cfargument name="total"         type="numeric"      required="true"   default="1">						
				<cfargument name="sectiondata"   type="query"        required="true"   default="">		
				<cfargument name="thesheet"      required="yes">			
				<cfargument name="cols"          type="array"        required="yes">		
				<cfargument name="rowstart"      type="numeric"      required="yes">	
				
				<cfif total lte 11000>
					<cfset format = "1">
				<cfelse>
				    <cfset format = "0">
				</cfif>
				
				<!--- cell formatting defaults --->
				
				<cfset letterList = "B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD,AE,AF,AG,AH,AI,AJ,AK,AL,AM,AN,AO,AP,AQ,AR,AS,AT,AU,AV,AW,AX,AY,AZ,BA,BB,BC,BD,BE,BF,BG,BH,BI,BJ,BK,BL,BM,BN,BO,BP,BQ,BR,BS,BT,BU,BV,BW,BX,BY,BZ">
				
				<cfset letter = ArrayNew(1)>

				<cfset no = 0>
				
				<cfloop index="x" list="#letterlist#">

					<cfset no = no+1>
					<cfset letter[no] = "#x#">
				
				</cfloop> 
				
				<cfloop index="cell" from="1" to="#ArrayLen(cols)#">
		
				    <cfif cell eq "1">
					    <cfset sel = "#cols[cell][1]#">
					<cfelse>
						<cfset sel = "#sel#,#cols[cell][1]#">
					</cfif>	
				
				</cfloop>										
											
				<!--- --------------------------- --->
				<!--- add the section rows------  --->
				<!--- --------------------------- --->
				
				<cfset row = "#rowstart-1#">
				<cfparam name="rowend" default="#rowstart+sectiondata.recordcount-1#">				

				<cfset aWrap = ArrayNew(1)> 								
				<cfloop query="sectiondata">
												
					<cfset SpreadsheetSetCellValue(theSheet, "#currentrow#", "#row+currentrow#", 1)>	
					
					<!--- content cell --->
					
				    <cfloop index="fld" from="1" to="#ArrayLen(cols)#">
					
				    		<cfset vError = 0>
							<cftry>
									<cfset val = evaluate("sectionData."&cols[fld][1])>
							<cfcatch>
									<cfset vError = 1>
									<!----
									<cfoutput>
										#fld#
									</cfoutput>
									
									<cfdump var="#cols[fld][1]#">
									<cfdump var ="#sectiondata#">
									<cfabort>
									---->	
									
							</cfcatch>		
							</cftry>	
							
							<cfif vError eq 0>
							
							<cfif cols[fld][2] eq "date" 
							       or cols[fld][2] eq "datetime" 
								   or findNoCase("date",fld)> 
														 													
								 <cftry>
							     	<cfset val = dateformat(val,CLIENT.DateFormatShow)>	
								 <cfcatch></cfcatch>
								 </cftry>
								 
								 <cfif len(val) gt 10>

									 <cfset valStr = getCleanHTML(val)>
									 
									 <cfset SpreadsheetSetCellValue(theSheet, "#valStr#", "#row+currentrow#", "#fld+1#")>	
									 <cfif len(val) gt 50>
									 	<cfif ArrayFind(aWrap, "#fld+1#") eq 0>
										 	<cfset ArrayAppend(aWrap, "#fld+1#")> 
										 </cfif>	 
									 </cfif>		
									 
								<cfelse>
									 <cfset SpreadsheetSetCellValue(theSheet, "#val#", "#row+currentrow#", "#fld+1#")>	 
								</cfif>							 								
								 
							<cfelseif cols[fld][2] eq "integer">															 
								 <cfset SpreadsheetSetCellValue(theSheet, "#val#", "#row+currentrow#", "#fld+1#")>									 
							<cfelseif cols[fld][2] eq "float">																						 
								 <cfset SpreadsheetSetCellValue(theSheet, "#val#", "#row+currentrow#", "#fld+1#")>		 								 
							<cfelseif cols[fld][2] eq "numeric">																																					 
								 <cfset SpreadsheetSetCellValue(theSheet, "#val#", "#row+currentrow#", "#fld+1#")>	
							<cfelse>
							
								 <cfset valStr = getCleanHTML(val)>								 
								 <cfset SpreadsheetSetCellValue(theSheet, "#valStr#", "#row+currentrow#", "#fld+1#")>	
								 
								 <cfif len(val) gt 50>
								 	
								 	<cfif ArrayFind(aWrap, "#fld+1#") eq 0>
									 	<cfset ArrayAppend(aWrap, "#fld+1#")> 
									 </cfif>	 
								 </cfif>
								
							</cfif>
						
						</cfif> <!--- end of error --->
						
					</cfloop>
								
				</cfloop>
				
				<!--- apply colun based formatting for this row --->
								
				<cfif format eq "1">	
				 
				 	<!--- pre-format the columns ---> 				
				 				 
				    <cfloop index="fld" from="1" to="#ArrayLen(cols)#">

							<cfset formatCel   = structNew()>
						    <cfset formatCel.fgcolor="white">
					
							<cfif cols[fld][2] eq "date" or cols[fld][2] eq "datetime" or findNoCase("date",fld)> 

									<cfif ArrayFind(aWrap, "#fld+1#") neq 0>
									    <cfset formatCel.textwrap        = "false"> 
										<cfset formatCel.alignment       = "left,vertical_top"> 
										<cfset SpreadSheetSetColumnWidth(theSheet,"#fld+1#",16)> 										
					 			    	<cfset SpreadsheetFormatColumn(theSheet,formatCel,"#fld+1#")>				
									<cfelse>
									    <cfset formatCel.alignment         = "center"> 									 
									    <cfset formatCel.verticalalignment = "vertical_top">
										<cfset SpreadSheetSetColumnWidth(theSheet,"#fld+1#",16)> 		
							 			<cfset SpreadsheetFormatColumn(theSheet,formatCel,"#fld+1#")>				
									</cfif>	

							<cfelseif cols[fld][2] eq "integer">
									 
								      <cfset formatCel.alignment         = "right"> 
									  <cfset formatCel.verticalalignment = "vertical_top">
							  	      <cfset formatCel.fgcolor           = "light_yellow"> 
								      <cfset formatCel.dataformat        = "0"> 	
						 			  <cfset SpreadsheetFormatColumn(theSheet,formatCel,"#fld+1#")>	
									  <cfset SpreadSheetSetColumnWidth(theSheet,"#fld+1#",10)> 			
				
								 				
							<cfelseif cols[fld][2] eq "numeric" or cols[fld][2] eq "float">
																	 	
								    <cfset formatCel.alignment           = "right"> 									
									<cfset formatCel.verticalalignment   = "vertical_top">
							  	    <cfset formatCel.fgcolor             = "light_green"> 									
								    <cfset formatCel.dataformat          = "##,####0.00"> 
									<cfset SpreadSheetSetColumnWidth(theSheet,"#fld+1#",18)> 
					 			    <cfset SpreadsheetFormatColumn(theSheet,formatCel,"#fld+1#")>				
								
							<cfelse>
							
									<cfif ArrayFind(aWrap, "#fld+1#") neq 0>
									
									    <cfset formatCel.textwrap   = "false"> 
										<cfset formatCel.alignment  = "left">
										<cfset formatCel.verticalalignment = "vertical_top"> 
										<cfset SpreadSheetSetColumnWidth(theSheet,fld+1,25)> 
					 			    	<cfset SpreadsheetFormatColumn(theSheet,formatCel,"#fld+1#")>	
													
									<cfelse>
									
										<cfset formatCel.alignment = "left">
										<cfset formatCel.textwrap   = "false"> 
										<cfset formatCel.verticalalignment = "vertical_top"> 
					 			    	<cfset SpreadsheetFormatColumn(theSheet,formatCel,"#fld+1#")>	
										<cfset SpreadSheetSetColumnWidth(theSheet,"#fld+1#",25)> 			
										
									</cfif>	
								
							</cfif>
					</cfloop>
					
					<!--- format header row (1) --->					
															
		  	        <cfset formatCel.fgcolor           = "royal_blue">
					<cfset formatCel.alignment         = "center">
					<cfset formatCel.color             = "white"> 
					<cfset formatCel.italic            = "false"> 
					<cfset formatCel.bold              = "false">    
				    <cfset formatCel.fontsize          = "12"> 
					<cfset formatCel.textwrap          = "false">    
					<cfset formatCel.bottomborder      = "thin"> 
					<cfset formatCel.bottombordercolor = "blue_grey"> 
					<cfset formatCel.topbordercolor    = "blue_grey"> 
					<cfset formatCel.topborder         = "thin"> 
					<cfset formatCel.leftborder        = "dotted"> 
					<cfset formatCel.leftbordercolor   = "blue_grey"> 
					<cfset formatCel.rightborder       = "dotted"> 
					<cfset formatCel.rightbordercolor  = "blue_grey"> 		
										
					<cfset SpreadsheetFormatRow(theSheet,formatCel,1)>					
					
				</cfif>												
								
				<!--- --------------------------- --->
				<!--- add the section summary row --->
				<!--- --------------------------- --->
				
				<script>
					ColdFusion.ProgressBar.updateStatus('pBar',1.0,'100%')
				</script> 
				
				<cfset f = RepeatString(" ,",ArrayLen(cols))>								
				
				<cfset SpreadsheetAddRow(theSheet,",#f#","#rowend+1#",1)> 
				
				<cfif format eq "1">	
				
					<cfset formatCel.font     = "Calibri"> 
					<cfset formatCel.color    = "black"> 
					<cfset formatCel.fontsize = "14"> 
					<cfset formatCel.fgcolor  = "light_turquoise">   
					<cfset formatCel.bold     = "false">  	
					<cfset SpreadsheetFormatRow(theSheet,formatCel,"#rowend+1#")> 
					
				</cfif>
				
				<cfloop index="x" from="1" to="#ArrayLen(cols)#">
				
					<cfset s = "#cols[x][4]#">
					<cfset f = "#cols[x][2]#">
										
					<cfif s eq "sum">
					
						<cfset let = letter[x]>
											
						<cfset SpreadsheetSetCellFormula(theSheet,"SUM(#let##row+1#:#let##rowend#)","#rowend+1#","#x+1#")> 
										
						<cfif format eq "1">	
												
						  <cfif f eq "integer">
							<cfset formatCel.dataformat  = "0"> 
						  <cfelse>
							 <cfset formatCel.dataformat = "##,####0.00"> 
						  </cfif>
						  <cfset formatCel.alignment     = "right"> 
						  <cfset SpreadsheetFormatCell(theSheet,formatCel,"#rowend+1#","#x+1#")> 					
						  
						</cfif>
					
					</cfif>		
					
				</cfloop>		
				
				<cfreturn rowend+1>
								
		</cffunction>		
				
		<cffunction name="ExcelSummary" hint="Create a summary line">
		
			<cfargument name="records"     type="string"       required="true"   default="1">		
			<cfargument name="SumFormula"  type="string"       required="false"   default="">		
			<cfargument name="thesheet"    required="yes">			
			<cfargument name="cols"        type="array"        required="yes">		
			<cfargument name="rowstart"    type="numeric"      required="yes">	
			<cfargument name="color"       type="string"       default="pale_blue">
				
			<!--- -------------------------------------- --->
			<!--- add the overall total row------------- --->
			<!--- -------------------------------------- --->
			
			<cfset formatCel   = structNew()>
		
			<cfset formatCel.font              = "Calibri"> 	
			<cfset formatCel.fontsize          = "14"> 	
			<cfset formatCel.color             = "black"> 
			<cfset formatCel.italic            = "false"> 
			<cfset formatCel.bold              = "false">    
			<cfset formatCel.textwrap          = "false">    
			<cfset formatCel.bottomborder      = "thin"> 
			<cfset formatCel.bottombordercolor = "blue_grey"> 
			<cfset formatCel.topbordercolor    = "blue_grey"> 
			<cfset formatCel.topborder         = "thin"> 
			<cfset formatCel.leftborder        = "dotted"> 
			<cfset formatCel.leftbordercolor   = "blue_grey"> 
			<cfset formatCel.rightborder       = "dotted"> 
			<cfset formatCel.rightbordercolor  = "blue_grey"> 		
			
			<cfset letterList = "B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD,AE,AF,AG,AH,AI,AJ,AK,AL,AM,AN,AO,AP,AQ,AR,AS,AT,AU,AV,AW,AX,AY,AZ,BA,BB,BC,BD,BE,BF,BG,BH,BI,BJ,BK,BL,BM,BN,BO,BP,BQ,BR,BS,BT,BU,BV,BW,BX,BY,BZ">
		
			<cfset letter = ArrayNew(1)>
	
			<cfset no = 0>
					
			<cfloop index="x" list="#letterlist#">
	
				<cfset no = no+1>
				<cfset letter[no] = "#x#">
			
			</cfloop> 
			
			<cfset formatCel.fgcolor="#color#">   
											
			<cfset f = RepeatString(" ,",ArrayLen(cols))>								
					
			<cfset SpreadsheetAddRow(theSheet,",#f#","#rowstart#",1)> 
			<cfset SpreadsheetSetCellValue(theSheet, "#records#", "#rowstart#", 1)>	
			
			<cfset formatCel.alignment= "center">
			<cfset formatCel.fontsize = "14"> 
			<cfset formatCel.color    = "black">	
			<cfset SpreadsheetFormatRow(theSheet,formatCel,"#rowstart#")> 
							
			<cfloop index="x" from="1" to="#ArrayLen(cols)#">
			
				<cfset s = "#cols[x][4]#">
									
				<cfif s eq "sum">
				
					<cfset let = letter[x]>
					<cfset for = "">
					
					<cfloop index="itm" list="#sumFormula#">
					 
					 <cfif for eq "">
					   <cfset for = "+#let##itm#">
					 <cfelse>
					   <cfset for = "#for#+#let##itm#">
					 </cfif>
					 
					</cfloop>
				
					<cfset f = "#cols[x][2]#">
					
					<cfif f eq "integer">
						<cfset formatCel.dataformat = "0"> 
					<cfelse>
						<cfset formatCel.dataformat = "##,####0.00"> 
					</cfif>
					
					<cfset formatCel.alignment   = "right"> 		
					<cfset SpreadsheetSetCellFormula(theSheet,"#for#","#rowstart#","#x+1#")> 														
					<cfset SpreadsheetFormatCell(theSheet,formatCel,"#rowstart#","#x+1#")> 					
				
				</cfif>		
				
			</cfloop>		 
				
		</cffunction>

</cfcomponent>
