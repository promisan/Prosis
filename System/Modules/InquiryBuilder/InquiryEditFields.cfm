
<cfquery name="List" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   Ref_ModuleControlDetail
	WHERE  SystemFunctionId = '#URL.SystemFunctionId#'
	AND    FunctionSerialNo = '#URL.FunctionSerialNo#'
</cfquery>

<cfparam name="URL.SystemFunctionId" default="">
<cfparam name="URL.FunctionSerialno" default="1">
<cfparam name="Form.querydatasource" default="#List.queryDataSource#">
<cfparam name="Form.QueryScript"     default="#List.queryScript#">
<cfparam name="URL.ID2"              default="new">

<cfset client.queryscript = urldecode(Form.QueryScript)>

<cfset myscript = urldecode(Form.QueryScript)>

<cfif findNoCase("UPDATE",myscript) or findNoCase("DELETE",myscript)>
	 <script>
	 alert("Problem, you may not process an UPDATE/DELETE query")
	 </script>
	 <cfabort>
</cfif> 

<cfif FindNoCase("ORDER BY",myscript)>

	<script>
	alert("ORDER BY may not be used in the query")
	</script>
	<cfabort>

</cfif>

<cfif myscript eq "">
	 <cfabort>
</cfif>

<cftry>

    <cfset sc = replaceNocase(myscript, "SELECT",  "SELECT TOP 1")> 
		
	<!--- -------------------------- --->
	<!--- preparation of the listing --->
	<!--- -------------------------- --->
		
	<cfset fileNo = "#List.DetailSerialNo#">							
	<cfinclude template="QueryPreparationVars.cfm">
	<cfinclude template="QueryValidateReserved.cfm">
	
	<!--- -------------------------- --->
	<!--- ----- end of preparation   --->
	<!--- -------------------------- --->
	
	<cfquery name="SelectQuery" 
	datasource="#Form.querydatasource#" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	   #preservesinglequotes(sc)#	   
	</cfquery>
						
	<cfcatch>
			
		<cfif len(sc) gte 10>
					
		<script>
		alert("Invalid query script.")
		</script>		
		
		<cfabort>
		
		</cfif>
		
	</cfcatch>

</cftry>

<cfquery name="Header" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   Ref_ModuleControlDetail
	WHERE  SystemFunctionId = '#URL.SystemFunctionId#'
	AND    FunctionSerialNo = #url.FunctionSerialNo#	
</cfquery>

<cfquery name="Detail" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   Ref_ModuleControlDetailField
	WHERE  SystemFunctionId = '#URL.SystemFunctionId#'
	AND    FunctionSerialNo = #url.FunctionSerialNo#
	ORDER  BY ListingOrder
</cfquery>

<cfset myscript = replaceNoCase(myscript, "FROM"," FROM","ALL")>
<cfset myscript = replaceNoCase(myscript, "WHERE"," WHERE","ALL")>
<cfset myscript = replace(myscript, "ON"," ON","ALL")>   <!--- otherwise AddressZone would be incorrectly split --->
<cfset myscript = replaceNoCase(myscript, "INNER JOIN"," INNER JOIN","ALL")>
<cfset myscript = replaceNoCase(myscript, "LEFT OUTER JOIN"," LEFT OUTER JOIN","ALL")>

<cfset s = FindNoCase("FROM", myscript)>
 
<cfif Find("WHERE", myscript)>
   <cfset e = FindNoCase("WHERE", myscript)>
<cfelse>
   <cfset e = len(myscript)>
</cfif>

<cfset fr = mid(myscript,s+4,e-(s+3))>

<!--- make a list of clumns that are not found --->
		
<cfset col = SelectQuery.columnList>
<cfset colfields = "">

<cfloop index="fld" list="#col#">

	<cfif not findNoCase(fld,valueList(Detail.fieldName))>
	
	     <cfif colfields eq "">
		    <cfset colfields = "#fld#">
		 <cfelse>
		    <cfset colfields = "#colfields#,#fld#">	
		 </cfif> 
	
	</cfif> 

</cfloop>
	
<cfset submitlink = "#SESSION.root#/System/Modules/InquiryBuilder/InquiryEditFieldsSubmit.cfm?Datasource=#Form.querydatasource#&SystemFunctionId=#URL.SystemFunctionId#&functionSerialNo=#url.functionSerialNo#">

<table width="100%" align="center" cellspacing="0" cellpadding="0" class="formpadding">

<tr><td>
			
	    <table width="100%" class="navigation_table formpadding">
		
		<cfset alias = 0>	
						 
	 	<cfloop index="itm" list="#fr#" delimiters=", ">
			
			<cfif len(itm) lte 5>
				<cfset alias = 1>
			</cfif>
				
		</cfloop>
			
	    <TR class="labelmedium line fixrow">
		   <td align="center" style="text-align:center;border:1px solid silver;padding-left:1px">
		   
	 	   <cfoutput>
		   
		   	 <cfif colfields eq "" or URL.ID2 eq "new">
			 
			 <cfelse>
			
			 <div onClick="_cf_loadingtexthtml='';ptoken.navigate('#SESSION.root#/System/Modules/InquiryBuilder/InquiryEditFields.cfm?SystemFunctionId=#URL.SystemFunctionId#&functionSerialNo=#url.functionSerialNo#&ID2=new','fields')">			 
			     <A style="font-size:13px" href="##"><cf_tl id="Add"></a>
			 </div>
			 
			 </cfif>
			
		   </cfoutput>
							 
		   </td>
		   <td height="22" style="text-align:center;border:1px solid silver;padding-left:1px"><cf_tl id="sort"></td>
		   <td style="text-align:center;border:1px solid silver;padding-left:1px"><cfif alias eq "1">Alias</cfif></td>
	   	   <td style="text-align:center;border:1px solid silver;padding-left:1px"><cf_tl id="Field"></td>
		   <td style="text-align:center;border:1px solid silver;padding-left:1px">isKey</td>
		   <td style="text-align:center;border:1px solid silver;padding-left:1px"><cf_tl id="Show"></td>
		   <td style="text-align:center;border:1px solid silver;padding-left:1px"><cf_tl id="Align"></td>
		   <td style="text-align:center;border:1px solid silver;padding-left:1px"><cf_tl id="Label"></td>
		   <td style="text-align:center;border:1px solid silver;padding-left:1px"><cf_tl id="Format"></td>
		   <td style="text-align:center;border:1px solid silver;max-width:40px;cursor:pointer;padding-right:3px"><cf_UIToolTip tooltip="Enforce With, leave as 0 to let system define the presentation">Width</cf_UIToolTip></td>
		   <td style="text-align:center;border:1px solid silver;cursor:pointer"><cf_UIToolTip tooltip="Initial Grouping/Sorting of the listing">Mode</cf_UIToolTip></td>
		   <td style="text-align:center;border:1px solid silver;"><cf_tl id="Filter"></td>
		   <td style="text-align:center;cursor:pointer;border:1px solid silver;"><cf_UIToolTip tooltip="Filter selection mode">Select mode</cf_UIToolTip></td>
		   <td style="text-align:center;border:1px solid silver;"><cf_UIToolTip tooltip="Show option in the tree">Tree</cf_UIToolTip></td>
		   <td></td>
		   
	    </TR>	
			
		<cfoutput>
		
				
		<cfloop query="Detail">
															
			<cfif URL.ID2 eq fieldid>
			
				<cfif colfields eq "">
				    <cfset colfields = "#fieldname#">
				 <cfelse>
				    <cfset colfields = "#fieldname#,#colfields#">	
				 </cfif> 
																					
				<TR class="line" style="background-color:f1f1f1">
				
				     <td></td>
				     <td align="center" style="border-left:1px solid silver;padding-left:2px;padding-right:2px">
					 
					  <input type="Text" 
							  name="listingorder" 
	                          id="listingorder"
							  value="#ListingOrder#" 
							  style="width:23;text-align: center;border:0px;background-color:transparent" 
							  class="regularxl"
							  maxlength="2">
														 
					 </td>
					 
					 <td align="center" style="border-left:1px solid silver;padding-left:2px;padding-right:2px">
					 					 					 							
						<cfif alias eq "0">
												
						 <input type="hidden" name="fieldqueryalias" id="fieldqueryalias" value="">
						
						<cfelse>			
												
						<select name="fieldqueryalias" id="fieldqueryalias" class="regularxl" style="border:0px;width:100%;background-color:transparent">
						
							<cfloop index="itm" list="#fr#" delimiters=", ">							
						
								<cfif len(trim(itm)) lte 3 and trim(itm) neq "=" and trim(itm) neq "ON" and trim(itm) neq "AS" and trim(itm) neq "AND" and trim(itm) neq "BY">
									<option value="#itm#" <cfif fieldAliasquery eq itm>selected</cfif>>#itm#</option>
								</cfif>
								
							</cfloop>
						
						</select>	
						
						</cfif> 
					 													 
					 </td>
					 
					 <td style="border-left:1px solid silver;padding-left:2px;padding-right:2px">
					 
					 <select name="fieldname" id="fieldname" class="regularxl" style="border:0px;width:100%;background-color:transparent">
									 
					  <cfloop index="col" list="#colfields#" delimiters=",">
					  	  <option value="#col#"  <cfif col eq fieldname>selected</cfif>>#col#</option> 
					  </cfloop>
									
					 </select>
					 
					 </td>
					 
					 <td style="border-left:1px solid silver;padding-left:2px;padding-right:2px">
					 
					  <select name="fieldiskey" id="fieldiskey" class="regularxl" style="border:0px;width:100%;background-color:transparent">
							
					  	 <option value="1" <cfif fieldiskey eq "1">selected</cfif>>Yes</option> 
						 <option value="0" <cfif fieldiskey eq "0">selected</cfif>>No</option> 
												
				 	  </select>
					 
					 </td>		
					 
					 <td style="border-left:1px solid silver;padding-left:2px;padding-right:2px">
					 
					  <select name="fieldingrid" id="fieldingrid" class="regularxl" style="border:0px;width:100%;background-color:transparent">
							
					  	 <option value="1" <cfif fieldingrid eq "1">selected</cfif>>Yes</option> 
						  <option value="0" <cfif fieldingrid eq "0">selected</cfif>>No</option> 
												
				 	  </select>
					 
					 </td>		
					 
					 <td style="border-left:1px solid silver;padding-left:2px;padding-right:2px">
					 
					  <select name="fieldalignment" id="fieldalignment" class="regularxl" style="border:0px;width:100%;background-color:transparent">
							
					  	 <option value="Left" <cfif fieldalignment eq "Left">selected</cfif>>Left</option> 
						 <option value="Center" <cfif fieldalignment eq "Center">selected</cfif>>Center</option> 
						 <option value="Right" <cfif fieldalignment eq "Right">selected</cfif>>Right</option>
												
				 	  </select>
					 
					 </td>					
										 
					 <td style="border-left:1px solid silver;padding-left:2px;padding-right:2px">
					 
					  <input type="Text" 
						  name="fieldheaderlabel" 
                          id="fieldheaderlabel"
						  value="#fieldheaderlabel#" 
						  style="width:100%;border:0px;background-color:transparent" 
						  class="regularxl"
						  maxlength="30">
														 
					 </td>
					 
					 <td style="border-left:1px solid silver;padding-left:2px;padding-right:2px">
					 
					 <select name="fieldoutputformat" id="fieldoutputformat" style="width:100%;border:0px;background-color:transparent" class="regularxl">
											 
					 	  <option value=""  <cfif fieldoutputformat eq "">selected</cfif>>Default</option> 
					 	  <option value="Date"  <cfif fieldoutputformat eq "Date">selected</cfif>>Date</option> 
						  <option value="DateTime"  <cfif fieldoutputformat eq "DateTime">selected</cfif>>Date/Time</option> 
					   	  <option value="Time"  <cfif fieldoutputformat eq "Time">selected</cfif>>Time</option> 
					   	  <option value="Amount" <cfif fieldoutputformat eq "Amount">selected</cfif>>Amount</option> 
						  <option value="eMail" <cfif fieldoutputformat eq "eMail">selected</cfif>>eMail</option> 											
					 </select>
					 
					 </td>
					 					
					 
					<td style="width:40px;border-left:1px solid silver;padding-left:2px;padding-right:2px">
					 
					  <input type="Text" 
						  name="fieldwidth" 
                          id="fieldwidth"
						  value="#fieldwidth#" 
						  class="regularxl"
						  style="width:100%;padding-top:2px;text-align:center;border:0px;background-color:transparent" 
						  maxlength="3">
														 
					 </td>
					 
					 <td style="border-left:1px solid silver;padding-left:2px;padding-right:2px">
					 
					   <select name="fieldsort" id="fieldsort" class="regularxl" style="width:100%;border:0px;background-color:transparent">
							
					  	 <option value="1" <cfif fieldsort eq "1">selected</cfif>>Sort</option> 
						 <option value="2" <cfif fieldsort eq "2">selected</cfif>>Group</option> 
						 <option value="3" <cfif fieldsort eq "3">selected</cfif>>Sum</option> 
						 <option value="0" <cfif fieldsort eq "0">selected</cfif>>No</option> 
																		
				 	   </select>
					  
					 </td>
					 
					 <td style="border-left:1px solid silver;padding-left:2px;padding-right:2px">
					 
						 <select name="fieldfilterclass" id="fieldfilterclass" style="width:100%;border:0px;background-color:transparent" class="regularxl" onchange="toggle('FieldFilterClassMode',this.value)">
								
							  <option value=""       <cfif FieldFilterClass eq "">selected</cfif>>N/A</option>					 
						 	  <option value="Text"   <cfif FieldFilterClass eq "Text">selected</cfif>>Text</option> 
							  <option value="Amount" <cfif FieldFilterClass eq "Amount">selected</cfif>>Amount</option> 
						 	  <option value="Date"   <cfif FieldFilterClass eq "Date">selected</cfif>>Date</option> 
						  											
						 </select>
														 
					 </td>
					 
					 <td style="border-left:1px solid silver;padding-left:2px;padding-right:2px">
					 
						 <select name="FieldFilterClassMode" id="FieldFilterClassMode" style="border:0px;width:100%;background-color:transparent" class="regularxl" <cfif fieldfilterclass eq "">disabled</cfif>>	
						 							
							  <option value="0"  <cfif FieldFilterClassMode eq "0">selected</cfif>>Default</option> 
						 	  <option value="1"  <cfif FieldFilterClassMode eq "1">selected</cfif>>Combo</option> 
						  	  <option value="2"  <cfif FieldFilterClassMode eq "2">selected</cfif>>List</option> 										
							  <option value="3"  <cfif FieldFilterClassMode eq "3">selected</cfif>>Checkbox</option> 	
							  <option value="4"  <cfif FieldFilterClassMode eq "4">selected</cfif>>Like</option> 	
							  
						 </select>
														 
					 </td>			
					 
					 <td style="border-left:1px solid silver;padding-left:2px;padding-right:2px">
					 
					  <select name="fieldtree" id="fieldtree" class="regularxl" style="border:0px;width:100%;background-color:transparent">
							
					  	  <option value="1" <cfif fieldtree eq "1">selected</cfif>>Yes</option> 
						  <option value="0" <cfif fieldtree eq "0">selected</cfif>>No</option> 
												
				 	  </select>
					 
					</td>		
										 		
					<td style="border-left:1px solid silver;padding-left:2px;padding-right:2px">			   
				   
						   <input type="button" 
							   value="Save" 
							   style="width:50px;height:23px"
					   		   onclick="ptoken.navigate('#submitlink#&fieldiskey='+fieldiskey.value+'&fieldingrid='+fieldingrid.value+'&fieldalignment='+fieldalignment.value+'&fieldid=#fieldid#&listingorder='+listingorder.value+'&fieldname='+fieldname.value+'&fieldqueryalias='+fieldqueryalias.value+'&fieldheaderlabel='+fieldheaderlabel.value+'&fieldoutputformat='+fieldoutputformat.value+'&fieldwidth='+fieldwidth.value+'&fieldsort='+fieldsort.value+'&fieldfilterclass='+fieldfilterclass.value+'&fieldtree='+fieldtree.value+'&FieldFilterClassMode='+FieldFilterClassMode.value,'fields')">
							   	
					</td>
									
				   
			    </TR>	
														
			<cfelse>
			
				<cfoutput>
				<cfsavecontent variable="edit">
				_cf_loadingtexthtml='';
				ptoken.navigate('#SESSION.root#/System/Modules/InquiryBuilder/InquiryEditFields.cfm?Datasource=#Form.querydatasource#&SystemFunctionId=#URL.SystemFunctionId#&FunctionSerialNo=#URL.FunctionSerialNo#&ID2=#FieldId#','fields');				
				</cfsavecontent>
				</cfoutput>
		
				<cfif FieldisKey eq "1">
					<cfset color = "ffffaf">
				<cfelse>
					<cfset color = "ffffff">
				</cfif>			
														
				<TR class="navigation_row labelmedium line" bgcolor="#color#" style="height:18px" onDblClick="#edit#">
				
				  <td align="right" style="padding-right:4px;padding-top:3px;border-left:1px solid silver;">		
				   
					   <table>
						   <tr>		
						   <td>
						   <cf_img icon="select" tooltip="Editing this field settings" onclick="#edit#">						  						   
						   </td>		   
						   <td><cf_img icon="edit" tooltip="Editing this field settings" onclick="fieldedit('#fieldid#','#systemfunctionid#','#FunctionSerialNo#')"></td>						  
						   </tr>
					   </table>		 
					
				  </td>
				
				   <td align="center" class="navigation_action" style="border-left:1px solid silver;padding;3px">#ListingOrder#.</td>
				   <td style="border-left:1px solid silver;padding;3px">
				    <cfif not find(" #FieldAliasQuery#", fr)>
					     <font color="FF0000">
					  </cfif> #FieldAliasQuery#
				   </td>
				   <td style="border-left:1px solid silver;padding-left:2px;padding-right:2px">				     					  
					  <cfif not find(fieldname,SelectQuery.columnList)><font color="FF0000"></cfif> 
					  #FieldName#									
				   </td>
				   <td style="border-left:1px solid silver;padding-left:2px;padding-right:2px"><cfif FieldisKey eq "1">*<cfelse></cfif></td>
				   <td style="border-left:1px solid silver;padding-left:2px;padding-right:2px"><cfif FieldInGrid eq "1">Yes<cfelse>No</cfif></td>
				   <td style="border-left:1px solid silver;padding-left:2px;padding-right:2px">#FieldAlignment#</td>
				   <td style="border-left:1px solid silver;padding-left:2px;padding-right:2px"><cfif FieldHeaderLabel neq "">#FieldHeaderLabel#<cfelse>Default</cfif></td>
				   <td style="border-left:1px solid silver;padding-left:2px;padding-right:2px"><cfif FieldOutputFormat neq "">#FieldOutputFormat#<cfelse>As in table</cfif></td>
				   <td style="border-left:1px solid silver;padding-left:2px;padding-right:2px"><cfif FieldInGrid eq "0">--<cfelse><cfif fieldwidth eq "0">Fit<cfelse>#FieldWidth#</cfif></cfif></td>
				   <td style="border-left:1px solid silver;padding-left:2px;padding-right:2px"><cfif FieldSort eq "1">Sort<cfelseif FieldSort eq "2">Group<cfelseif FieldSort eq "3">Sum<cfelse></cfif></td>
				   <td style="border-left:1px solid silver;padding-left:2px;padding-right:2px"><cfif FieldFilterClass eq "">--<cfelse>#FieldFilterClass#</cfif></td>
				   <td style="border-left:1px solid silver;padding-left:2px;padding-right:2px"><cfif FieldFilterClass eq "">--
				                        <cfelseif FieldFilterClassMode eq "1">Combo  <!--- ajax combo --->
										<cfelseif FieldFilterClassMode eq "2">List1  <!--- select --->
										<cfelseif FieldFilterClassMode eq "3">ListNN  <!--- checkbox or select multi --->
										<cfelseif FieldFilterClassMode eq "4">Like
										</cfif></td>	
				   <td style="border-left:1px solid silver;padding-left:2px;padding-right:2px"><cfif FieldTree eq "0">No<cfelse>Yes</cfif></td>		
				   
				   				   
				    <td style="border-left:1px solid silver;padding-top:3px;padding-left:2px;padding-right:2px">	   
						   
							   	<cf_img icon="delete"
								     onclick="_cf_loadingtexthtml='';ptoken.navigate('#SESSION.root#/System/Modules/InquiryBuilder/InquiryEditFieldsPurge.cfm?Datasource=#Form.querydatasource#&SystemFunctionId=#URL.SystemFunctionId#&FunctionSerialNo=#URL.FunctionSerialNo#&fieldid=#fieldid#','fields')">										
									 
					  </td>
				   
				   </td>		  				   		   
				   
			    </TR>	
																			
			</cfif>
												
		</cfloop>		
										
		<cfif URL.ID2 eq "new" and colfields neq "">		
		
			<cfquery name="Last" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT *
			    FROM     Ref_ModuleControlDetailField
				WHERE    SystemFunctionId = '#URL.SystemFunctionId#'
				AND      FunctionSerialNo = 1
				ORDER BY ListingOrder DESC
			</cfquery>
			
			<cfif Last.ListingOrder eq "">
			 <cfset ord = "1">
			<cfelse>
			 <cfset ord = Last.ListingOrder+1>
			</cfif>
							
			<cf_assignId>
		
			<TR class="line">
			
			     <td align="right" style="border-right:1px solid silver;padding-left:2px;padding-right:2px">			   		   		  
											   	
				</td>
				
			     <td align="center" style="width:30px;border-left:1px solid silver;padding-left:2px;padding-right:2px">
				 
				  <input type="Text" 
					  name="listingorder"
                      id="listingorder" 
					  value="#ord#" 
					  class="regularxl"
					  style="width:95%;text-align:center;border:0px" 
					  maxlength="2">
													 
				 </td>
				 
				 <td align="center" style="border-left:1px solid silver;padding-left:2px;padding-right:2px">
												 					
					<cfif alias eq "0">
					
					 <input type="hidden" name="fieldqueryalias" id="fieldqueryalias" value="">
					
					<cfelse>
						
						<select name="fieldqueryalias" id="fieldqueryalias" class="regularxl" style="border:0px;width:100%">
							
							<cfloop index="itm" list="#fr#" delimiters=", ">
		
							<cfif len(trim(itm)) lte 3 and trim(itm) neq "=" and trim(itm) neq "ON" and trim(itm) neq "AS" and trim(itm) neq "AND" and trim(itm) neq "BY">
								<option value="#itm#">#itm#</option>
							</cfif>
								
							</cfloop>
							
						</select>	 
					
					</cfif>
				
													 
				</td>
				 
				<td style="border-left:1px solid silver;padding-left:2px;padding-right:2px">
				 
				 <select name="fieldname" id="fieldname" style="width:100%;border:0px" class="regularxl">								 
					  <cfloop index="col" list="#colfields#" delimiters=",">
					  	  <option value="#col#" >#col#</option> 
					  </cfloop>								
				 </select>
				 
				</td>
				
				<td style="border-left:1px solid silver;padding-left:2px;padding-right:2px">
				
				 <select name="fieldiskey" id="fieldiskey" class="regularxl" style="border:0px;width:100%">							
					<option value="1">Yes</option> 
					<option value="0" selected>No</option> 												
				 </select>
				 
				</td> 
				 
				<td style="border-left:1px solid silver;padding-left:2px;padding-right:2px">
				 
				 <select name="fieldingrid" id="fieldingrid" class="regularxl" style="border:0px;width:100%">							
				  	  <option value="1" selected>Yes</option> 
					  <option value="0">No</option> 												
				 </select>
				 
				</td>
				
				<td style="border-left:1px solid silver;padding-left:2px;padding-right:2px">
				
				  <select name="fieldalignment" id="fieldalignment" class="regularxl" style="border:0px;width:100%">							
					  	 <option value="Left" selected>Left</option> 
						 <option value="Center">Center</option> 
						 <option value="Right">Right</option>												
				  </select>
				  
				 </td> 
				 
				<td style="border-left:1px solid silver;padding-left:2px;padding-right:2px;">
				 
				  <input type   = "Text" 
					  name      = "fieldheaderlabel" 
                      id        = "fieldheaderlabel"
					  value     = "" 
					  class     = "regularxl"
					  style     = "width:100%;text-align:center;border:0px;background-color:transparent" 
					  maxlength = "30">
													 
				</td>
				 
				<td style="border-left:1px solid silver;padding-left:2px;padding-right:2px">
				 
					 <select name="fieldoutputformat" id="fieldoutputformat" class="regularxl" style="border:0px;width:100%">											 
					 	  <option value="" selected>Default</option> 
					 	  <option value="Date">Date</option> 
						  <option value="DateTime">DateTime</option> 
					   	  <option value="Time">Time</option> 
					   	  <option value="Amount">Amount</option> 
						  <option value="eMail">eMail</option> 																	
					 </select>
				 
				</td>
				
				<td align="center" style="max-width:40px;border-left:1px solid silver;padding-left:2px;padding-right:2px">
				 
				  <input type="Text" 
					  name="fieldwidth" 
                      id="fieldwidth"
					  value="0" 
					  class="regularxl"
					  style="width:100%;text-align:center;border:0px;background-color:transparent" 
					  maxlength="2">
													 
				</td>
				
				<td style="border-left:1px solid silver;padding-left:2px;padding-right:2px;">
					 
					   <select name="fieldsort" id="fieldsort" class="regularxl" style="border:0px;width:100%">							
					   
					     <option value="1">Sort</option> 
						 <option value="2">Group</option> 
						 <option value="3">Sum</option> 
						 <option value="0" selected>No</option> 
					   											
				 	   </select>
					  
				 </td>
								 
				<td align="center" style="border-left:1px solid silver;padding-left:2px;padding-right:2px">
				 
					 <select name="fieldfilterclass" id="fieldfilterclass" style=";width:100%;border:0px" class="regularxl" onchange="toggle('FieldFilterClassMode',this.value)">
							
						  <option value="" selected>No</option>					 
					 	  <option value="Text">Text</option> 
					 	  <option value="Date">Date</option> 
					  											
					 </select>
													 
				</td>
				
				<td align="center" style="border-left:1px solid silver;padding-left:2px;padding-right:2px">
				 
					 <select name="FieldFilterClassMode" id="FieldFilterClassMode" style=";width:100%;border:0px"  class="regularxl"disabled>							
						  <option value="0" selected>Default</option> 
					 	  <option value="1">Combo</option> 
						  <option value="2">List</option> 		
						  <option value="3">Checkbox</option> 				  											
						  <option value="4">Like</option> 	
					 </select>
													 
				</td>		
				
				<td style="border-left:1px solid silver;padding-left:2px;padding-right:2px">
					 
					  <select name="fieldtree" id="fieldtree" class="regularxl" style="border:0px;width:100%">							
					  	 <option value="1">Yes</option> 
						 <option value="0" selected>No</option> 												
				 	  </select>
					 
				</td>	
				
				  <td align="right" style="border-left:1px solid silver;border-right:1px solid silver;padding-left:2px;padding-right:2px">			   
			   			  
				   <input type="button" 
					   value="Add" 
					   style="width:100%;height:23px"
			   		   onclick="ptoken.navigate('#submitlink#&fieldiskey='+fieldiskey.value+'&fieldingrid='+fieldingrid.value+'&fieldid=#rowguid#&listingorder='+listingorder.value+'&fieldname='+fieldname.value+'&fieldqueryalias='+fieldqueryalias.value+'&fieldheaderlabel='+fieldheaderlabel.value+'&fieldoutputformat='+fieldoutputformat.value+'&fieldwidth='+fieldwidth.value+'&fieldalignment='+fieldalignment.value+'&fieldsort='+fieldsort.value+'&fieldfilterclass='+fieldfilterclass.value+'&fieldtree='+fieldtree.value+'&FieldFilterClassMode='+FieldFilterClassMode.value,'fields')">
											   	
				</td>	
				   
			</TR>	
		
		</cfif>
		
		</cfoutput>
			
		</table>
			
</td>
</tr>
											
</table>		

<cfset AjaxOnLoad("doHighlight")>
	

