
<cfoutput>
<cfset show = 1>

<table cellspacing="0" width="600" cellpadding="0" class="formpadding"><tr>

<cfform name="fCriteria_#url.class#" id="fCriteria_#url.class#" onsubmit="return false">
	
	<cfif url.layout eq 0>
	
		<cfquery name ="qFields" 
		         datasource ="#URL.DS#" 
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">
			SELECT  Column_Name, Data_Type
			FROM    INFORMATION_SCHEMA.COLUMNS 
			WHERE   Table_Name     = '#URL.Table#'
			AND     Column_Name    = '#URL.Field#'
			AND     Table_Catalog  = '#URL.DB#'
			ORDER BY Ordinal_position
		</cfquery>
				
		<cfset found = 0>	
		
		<cfquery name ="qFKs" 
		         datasource ="#URL.DS#" 
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">
			SELECT  DISTINCT Column_Name
			FROM    information_schema.table_constraints pk INNER JOIN information_schema.key_column_usage c on c.table_name = pk.table_name 
			        AND  c.constraint_name = pk.constraint_name
			WHERE   constraint_type in ('foreign key')
			AND     pk.table_name = '#URL.Table#'		
			AND     Column_Name   = '#URL.Field#'
		</cfquery>
		
		<cfif qFKs.recordcount neq 0>
		
			<cfquery name ="Details" 
		     datasource ="#URL.DS#" 
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
					SELECT *
					FROM   #URL.DB#.dbo.Ref_#qFKs.Column_Name#
			</cfquery>
			
			<cfif Details.recordcount neq 0>
				<cfset found = 1>
			</cfif>
			
		</cfif>
		
	<cfelse>
		
		<cfquery name ="qFields" 
		        datasource ="AppsCaseFile" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT T.Code as 'Column_Name', T.ValueClass as 'Data_Type'
				FROM   Ref_TopicElementClass TC INNER JOIN Ref_Topic T ON T.Code = TC.Code
				WHERE  ElementClass = '#URL.Class#'
				AND    T.Code       = '#URL.Field#'
		</cfquery>
		
		<cfset found = 0>			
		
	</cfif>		
	
	<input type="hidden" name="searchid" id="searchId" value = "#url.searchid#">	
	<input type="hidden" name="mode"     id="mode"     value = "#url.mode#">		
	<input type="hidden" name="layout"   id="layout"   value = "#url.layout#">	
	<input type="hidden" name="type"     id="type"     value = "#qFields.Data_Type#">		
	
	<cfif qFields.Data_Type eq "ZIP">
		<input type="hidden" name="ds" id="ds" value = "AppsEmployee">		
		<input type="hidden" name="db" id="db" value = "Ref_PostalCode">		
	<cfelse>
		<input type="hidden" name="ds" id="ds" 		   value = "#URL.ds#">		
		<input type="hidden" name="db" id="db" 		   value = "#URL.db#">	
	</cfif>	
	
	<input type="hidden" name="class" id="class"   value = "#URL.Class#">	
	<input type="hidden" name="field" id="field"   value = "#URL.Field#">
	<input type="hidden" name="table" id="table"   value = "#URL.Table#	">
	<input type="hidden" name="where" id="where"   value = "#URL.WHERE#	">
	
	<td width="10%" align="center"><cf_space spaces="40">
	
		<select name = "operator" 
		    style = "font:11px;width=90%"" 
			id    = "operator" 
			onchange = "list_operators('#url.mode#','#URL.searchid#','#url.ds#','#url.db#','#url.table#','#URL.Field#', '#url.layout#','#url.Class#',this.options[this.selectedIndex].value,'#url.where#')">
 			<cfswitch expression = "#qFields.Data_Type#">
			<cfcase value = "varchar">
				<option value="=" <cfif url.operator eq "=">selected</cfif>>=</option>
				<option value="Like" <cfif url.operator eq "Like">selected</cfif>><cf_tl id="Like"></option>
			</cfcase>
			<cfcase value = "datetime,date">
				<option value="Range"><cf_tl id="Range"></option>
			</cfcase>
			<cfcase value = "int">
				<option value="=" <cfif url.operator eq "=">selected</cfif>>=</option>
				<option value=">" <cfif url.operator eq ">">selected</cfif>>></option>
				<option value=">=" <cfif url.operator eq ">=">selected</cfif>>>=</option>
				<option value="<" <cfif url.operator eq "<">selected</cfif>><</option>
				<option value="<=" <cfif url.operator eq "<=">selected</cfif>><=</option>
				<option value="Like" <cfif url.operator eq "Like">selected</cfif>><cf_tl id="Like"></option>				
			</cfcase>
			<cfcase value = "List,Zip,Lookup">
				<option value="=" <cfif url.operator eq "=">selected</cfif>>=</option>
			</cfcase>			
			<cfcase value = "Text,Memo">
				<option value="Like" <cfif url.operator eq "Like">selected</cfif>><cf_tl id="Like"></option>
			</cfcase>		
			<cfcase value = "Boolean">
				<option value="=" <cfif url.operator eq "=">selected</cfif>>=</option>
			</cfcase>	
			<cfcase value = "Map">
				<option value="=" <cfif url.operator eq "=">selected</cfif>>=</option>
			</cfcase>	
			</cfswitch>

		</select>	
		</td>
				
		<cfif found eq 0>
		
		<td width="100" style="padding-left:4px"><cf_space spaces="70">
				
				<cfswitch expression = "#qFields.Data_Type#">
				<cfcase value = "varchar">
				
					<cfif url.operator neq "Like">
						<cfquery name ="Details" datasource ="#URL.DS#">
						SELECT DISTINCT #URL.Field# as Code, #URL.Field# as Description
						FROM   #URL.DB#.dbo.#URL.Table#
						<cfif url.class eq "Person">
						WHERE  ApplicantClass = '3'
						</cfif>
						</cfquery>
						<select name = "lValues" id = "lValues" style="font:11px;width:190">
							<cfloop query = "Details">
								<option value="#Details.Code#">#Details.Description#</option>
							</cfloop>		
						</select>
						
						<input type="hidden" name="ListDataSource" 	id="ListDataSource" 	 value = "#URL.DS#">	
						<input type="hidden" name="ListCondition"   id="ListCondition"       value = "">	
						<input type="hidden" name="ListTable"       id="ListTable"           value = "#URL.Table#">	
						<input type="hidden" name="ListPk" 		    id="ListPk" 	         value = "#URL.Field#">	
						<input type="hidden" name="ListDisplay"     id="ListDisplay"         value = "#URL.Field#">
					<cfelse>
						<cfinput type="Text" name="condition1" id="condition1" required="yes" maxlength="100">
					</cfif>	
										
				</cfcase>
				
				<cfcase value = "datetime,date">
				
						<cfset st = Dateformat(now(), CLIENT.DateFormatShow)>
						
						<table cellspacing="0" cellpadding="0">
						<tr><td>
						
						<cf_intelliCalendarDate8
							FieldName="Condition1" 
							Manual="True"					
							Default="#st#"
							style="font:17px;height:22"
							AllowBlank="False">	
							
							</td>
							<td>&nbsp;</td>
							<td>
											
						<cf_intelliCalendarDate8
							FieldName="Condition2" 
							Manual="True"					
							Default="#st#"
							style="font:17px;height:22"
							AllowBlank="True">		
							
							</td></tr></table>
							
											
						
				</cfcase>
				
				<cfcase value = "int">
					<cfinput type="Text" name="condition1" id="condition1" required="yes">	
				</cfcase>	
				
				<cfcase value = "Lookup">
				
					<cfquery name ="Meta_Details" datasource ="AppsCaseFile" username="#SESSION.login#" password="#SESSION.dbpw#">
						SELECT   T.ListDataSource, T.ListTable, T.ListCondition, T.ListPk, T.ListDisplay, T.ListOrder, T.TopicClass
						FROM     Ref_TopicElementClass TC INNER JOIN Ref_Topic T ON T.Code = TC.Code
						WHERE    ElementClass = '#URL.Class#'
						AND      T.Code = '#URL.Field#'
						AND  
						(EXISTS
						(
							SELECT 'X'
							FROM ElementTopic
							WHERE Topic = T.Code
						)
						OR
						T.TopicClass = 'Person'
						)
					</cfquery>
					
					<cfif Meta_Details.recordcount neq 0>
					
							<cfquery name ="Details" datasource ="#Meta_Details.ListDataSource#" username="#SESSION.login#" password="#SESSION.dbpw#">
								SELECT #Meta_Details.ListPk# as 'Code',  #Meta_Details.ListDisplay# as 'Description'
								FROM   #Meta_Details.ListTable# L
								WHERE 1=1
								<cfif Meta_Details.ListCondition neq "">
									AND  #PreserveSingleQuotes(Meta_Details.ListCondition)# 
								</cfif>	
								<cfif Meta_Details.TopicClass neq "Person">
									AND  EXISTS
									(
										SELECT 'X'
										FROM CaseFile.dbo.ElementTopic
										WHERE Topic = '#URL.Field#'
										AND ListCode = L.#Meta_Details.ListPk#
									)				
								</cfif>
								<cfif Meta_Details.ListOrder neq "">
									ORDER BY #Meta_Details.ListOrder#
								</cfif>
							</cfquery>		
											
							<cfif Details.recordcount neq 0>
									<select name= "lValues" id="lValues" style="font:11px;width:190">
									<cfloop query = "Details">
										<option value="#Details.Code#">#Details.Description#</option>
									</cfloop>		
									</select>				
							</cfif>	
							<input type="hidden" name="ListDataSource" id="ListDataSource"  value = "#Meta_Details.ListDataSource#">	
							<input type="hidden" name="ListCondition"  id="ListCondition"   value = "#Meta_Details.ListCondition#">	
							<input type="hidden" name="ListTable"      id="ListTable"       value = "#Meta_Details.ListTable#">	
							<input type="hidden" name="ListPk" 		   id="ListPk" 	        value = "#Meta_Details.ListPk#">	
							<input type="hidden" name="ListDisplay"    id="ListDisplay"     value = "#Meta_Details.ListDisplay#">	
														
					</cfif>
				
				</cfcase>
				
				<cfcase value = "List">
				
						<cfquery name ="Details" 
						         datasource ="#URL.DS#" 
								 username="#SESSION.login#" 
								 password="#SESSION.dbpw#">
								SELECT  ListCode as 'Code', 
								         ListValue as 'Description'
								FROM     Ref_TopicList TL INNER JOIN Ref_Topic T
								ON TL.Code = T.Code 
								WHERE    TL.Code  = '#URL.Field#'
								AND      TL.Operational = '1'
								AND  
								(EXISTS
								(
									SELECT 'X'
									FROM ElementTopic
									WHERE Topic = TL.Code
								)
								OR
								T.TopicClass = 'Person'
								)
								ORDER BY TL.ListOrder 
						</cfquery>		
						
						
						<cfif Details.recordcount neq 0>
							<select name = "lValues" id = "lValues" style="font:11px;width:190">
							<cfloop query = "Details">
								<option value="#Details.Code#">#Details.Description#</option>
							</cfloop>		
							</select>		
						<cfelse>
							<i><cf_tl id="There are no values for this variable"></i>			
							<cfset show = 0>
						</cfif>	
						
						<input type="hidden" name="ListCode"  id="ListCode" 	 value = "ListCode">	
						<input type="hidden" name="ListValue" id="ListValue" value = "ListValue">	
						
				</cfcase>
				
				<cfcase value = "Text,Memo">
					<cf_tl id="Please enter a valid condition" var="1" class="message">
					<cfinput type="Text" name="condition1" id="condition1" required="yes" style="font:11px" message="#lt_text#">	
				</cfcase>				
				
				<cfcase value = "Zip">
					
					<cfquery name="Details" datasource="AppsEmployee">
					SELECT   Code, PostalName as Description
					FROM     Ref_PostalCode
					ORDER BY PostalAreaName
					</cfquery>	
					
				
					<cfif Details.recordcount neq 0>
						<select name = "lValues" id = "lValues" style="font:11px;width:190">
						<cfloop query = "Details">
							<option value="#Details.Code#">#Details.Description#</option>
						</cfloop>		
						</select>				
					</cfif>		
				</cfcase>
				
				<cfcase value = "Boolean">
				
					<select name = "lValues" id = "lValues" style="font:11px;width:190">
						<option value="1">True</option>
						<option value="0">False</option>						
					</select>
					
				</cfcase>

				<cfcase value = "Map">
					<cf_tl id="Please enter a valid condition" var="1" class="message">
					<cfinput type="Text" name="condition1" id="condition1" required="yes" message="#lt_text#">						
				</cfcase>
				
				</cfswitch>
				
			</td>	
				
		<cfelse>
		
		    <td width="100">
			<select name = "lValues" id = "lValues" style="font:11px;width:190">
				<cfloop query = "Details">
					<option value="#Details.Code#">#Details.Description#</option>
				</cfloop>		
			</select>
			 </td>
			
			<input type="hidden" name="ListDataSource" 	id="ListDataSource"   value = "#URL.DS#">	
			<input type="hidden" name="ListCondition"   id="ListCondition"    value = "">	
			<input type="hidden" name="ListTable"       id="ListTable"        value = "Ref_#qFKs.Column_Name#">	
			<input type="hidden" name="ListPk" 		    id="ListPk" 	      value = "Code">	
			<input type="hidden" name="ListDisplay"     id="ListDisplay"      value = "Description">			
			
		</cfif>
		
		<cfif show eq 1> 
		    <td align="left" style="padding-left:5px">			   
			   				
				<img src="#SESSION.root#/images/addline.png"
				 style="cursor:pointer" 
				 onclick="do_insert('#url.class#')" 
				 align="absmiddle" 
				 height="13" 
				 width="13" 
				 alt="Add" 
				 border="0">
			</td>
		</cfif>	
		
</tr>

</table>		
				
</cfform>	
	
</cfoutput>

