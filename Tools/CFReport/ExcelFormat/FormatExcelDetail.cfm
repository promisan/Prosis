
<cfquery name="Parameter" 
	datasource="appsSystem">
	SELECT   *
    FROM     Parameter 
</cfquery>

<cfquery name="Site" 
	datasource="AppsInit">
		SELECT * 
		FROM   Parameter
		WHERE  HostName = '#CGI.HTTP_HOST#'
</cfquery>

<cfquery name="Output" 
	datasource="appsSystem">
	SELECT   *
    FROM     Ref_ReportControlOutput
	WHERE    OutputId = '#URL.ID#'
</cfquery>

<cfparam name="URL.reportid" default="">

<cfset outputName = Output.OutputName>
<cfset ds         = Output.DataSource>

<cfif ds eq "">

	<cf_message message="The datasource for your extract could not be defined. Please contract your administrator">
	<cfabort>

</cfif>

<!--- usertype = 8 : number --->

<cfset w = "4">

<table width="98%" align="right" border="0" style="height:100%">

<tr><td style="height:100%">

	<cf_divscroll>

	<table width="98%" class="formpadding">
	
	<tr class="hide"><td colspan="4" align="center" id="processpreview"></td></tr>
	
	<tr><td height="8"></td></tr>
	
	<!--- grouping 1 --->
	
	<tr class="line fixlengthlist">
	    <td class="labelmedium" style="height:30px;font-size:20px;padding-left:5px">
		 <cf_tl id="Output Grouping and subtotals">	
		</td>	
	
	   <td colspan="1">
	
	   <table class="formpadding">
	   
	   <cfoutput>
	   
	   <cfset gr = "''">  
	       
	   <cfset disable = "0">
	   
	   <tr>
	   
	   <cfif site.applicationserver eq Parameter.databaseServer>		
		  <cfset svr = "">
	   <cfelse>
		   <cfset svr = "[#Parameter.databaseServer#].">
	   </cfif>
		   
	   <cfloop index="grp" list="1,2" delimiters=","> 
	   
	   		<!--- check location --->					
	   
		    <cfquery name="Grouping" 
			datasource="#ds#">
				SELECT   C.name, C.userType 
			    FROM     SysObjects S, SysColumns C 
				WHERE    S.id = C.id
				AND      S.name = '#URL.table#'	
				AND      C.UserType != '8' 
				AND      C.Name not IN (#preserveSingleQuotes(gr)#)		
				AND      C.Name IN (SELECT  FieldName
				                    FROM    #svr#System.dbo.UserReportOutput
									WHERE   UserAccount = '#SESSION.acc#'
									AND     OutputId    = '#id#'
									AND     OutputShow = 1
									AND     OutputClass IN ('Detail') 	
									)
				ORDER BY C.ColId			
			</cfquery>
		   
		    <cfquery name="Select" 
			datasource="appsSystem">
				SELECT   *
			    FROM     UserReportOutput
				WHERE    UserAccount = '#SESSION.acc#'
				AND      OutputId    = '#id#'
				AND      OutputClass = 'Group#Grp#'
			</cfquery>
			
		   <td width="20"></td>
			        
	       <td width="30" height="24">&nbsp;&nbsp;&nbsp;#grp#:</td>
					
	        <td>
			    <select <cfif disable eq "1">disabled</cfif> class="regularxxl" style="font-size:15px" name="Grouping#Grp#" id="Grouping#Grp#" 
				 onChange="javascript:fieldadd(this.value,'Group#Grp#','#url.id#','#url.table#')">
				 <option value="None">None</option>
			     <cfloop query="Grouping">
				  <option value="#Name#" <cfif Select.FieldName eq "#Name#">selected</cfif>>#Name#</option>
				 </cfloop>
			    </select>
			</td>
			<cfif Select.FieldName eq "">
			  <cfset disable = "1">
			</cfif>
			
			<cfset gr = "#gr#,'#Select.FieldName#'">
	      
	   </cfloop>
	   </tr>
	   
	   </cfoutput>
	  
	   </table>
	      
	</td></tr>
	
	<tr><td height="4"></td></tr>
	
	<tr><td colspan="2">
	
	   <table width="100%" class="formpadding">
	   
	   <cfoutput>
	   
	   <cfset gr = "''">  
	      
	   <tr class="line">
	   <td class="labelmedium" style="height:30px;font-size:20px;padding-left:5px">
		   
			<cf_tl id="Field Selection">
			</td>
	     
		    <cfquery name="Agg" 
			datasource="appsSystem">
				SELECT   *
			    FROM     UserReportOutput
				WHERE    UserAccount = '#SESSION.acc#'
				AND      OutputId    = '#id#'
				AND      OutputClass = 'Aggregate'
			</cfquery>
			        				
	        <td align="right">
			   <table>
			   <tr>
				   <td><input type="radio" style="width:16;height:16" name="Aggregate" id="Aggregate" value="0" onClick="javascript:pointeradd(0,'Aggregate','#url.id#','#url.table#')" <cfif Agg.recordcount eq "0">checked</cfif>></td>
				   <td style="padding-left:3px;padding-right:9px" class="labelmedium"><cf_tl id="Show all records"></td>
				   <td><input type="radio" style="width:16;height:16" name="Aggregate" id="Aggregate" value="1" onClick="javascript:pointeradd(1,'Aggregate','#url.id#','#url.table#')" <cfif Agg.recordcount eq "1">checked</cfif>></td>
				   <td style="padding-left:3px" class="labelmedium"><cf_tl id="Aggregate"></td>
			   </tr>
			   </table>
			</td>
			<td id="aggregate"></td>
			
	   </tr>
	   
	   </cfoutput>
	  
	   </table>
	      
	</td></tr>
	
	</tr>
	
	<!--- fields --->
	
	<tr><td colspan="2">
		
		<cfquery name="FieldNo" 
			datasource="#ds#">
			SELECT   count(*) as Total
		    FROM     SysObjects S, SysColumns C 
			WHERE    S.id = C.id
			AND      S.name = '#URL.table#'		
		</cfquery>
		
		<table width="98%" align="right" class="formpadding">
		
		<tr>
		<td width="50%" valign="top" bgcolor="FFFFFF">
		
		<cfset url.ds = ds>
			
		<cfquery name="Fields" 
		datasource="#ds#">
			SELECT   C.name, 
			         C.userType,
					 (SELECT   count(*) 
			          FROM     #svr#System.dbo.UserReportOutput
			          WHERE    UserAccount = '#SESSION.acc#'
						AND    OutputId = '#id#'
						AND    FieldName = c.name
						AND    OutputClass IN ('Detail')
						AND    OutputShow = 1 
					 ) as Selected
					 
		    FROM     SysObjects S, SysColumns C 
			WHERE    S.id = C.id
			AND      S.name = '#URL.table#'			
			ORDER BY c.name,C.colorder
		</cfquery>	
				
			<table width="100%" align="center" cellspacing="0" cellpadding="0" class="formpadding">
			<tr>
			   <td height="20" colspan="<cfoutput>#w-1#</cfoutput>" class="labelmedium2" style="padding-left:4px">
			   <font color="gray"><cf_tl id="Click on a field name to select">
			   </td>
			   <td align="right" class="cellcontent">
			   
				   <table>
				    <tr class="labelmedium2">
				     <cfoutput>				 
					 <td  style="padding-left:4px;font-size:15px">
				        <a href="javascript:fieldadd('','Detail','#url.id#','#url.table#')"><cf_tl id="Select all fields"></a>
				     </td>		 
				     </cfoutput>
					</tr>
				   </table>
				   
			   </td>
			</tr>
				
			<cfif Fields.recordcount eq "0">
				<tr><td colspan="4" align="center" class="cellcontent"><font color="408080"><cf_tl id="All fields have been selected"></font></td></tr>
			</cfif>
				
			<tr>
			
			  <td colspan="5">		  
			  	<table width="100%">
					<tr>					
				    <cfset cnt=0>
					
					<cfset m = round(fields.recordcount/5)+1>
								
					<cfoutput query="fields">
					
						<cfset cnt = cnt + 1>
								
						<cfif cnt eq "1">
						<td valign="top">
						
						<table width="100%">
						</cfif>
							
							<tr class="labelmedium fixlengthlist" style="height:16px">							
							<td width="30" style="font-size:11px" align="center">#CurrentRow#.</td>
							
							<cfif userType eq "8">
							   <cfset format = "numeric">
							<cfelseif userType eq "12">
							   <cfset format = "date"> 
							<!---   
							<cfelseif userType eq "0">
							   <cfset format = "date">   
							   --->
							<cfelse>
							   <cfset format = "default">   	
							</cfif>
							
							 <!--- check for a label --->
																							
									<cfquery name="get" 
									 datasource="appsSystem">
									 SELECT   *
									 FROM     UserReportOutput
									 WHERE    UserAccount = '#SESSION.acc#'
									 AND      OutputId    = '#url.id#'
									 AND      OutputClass = 'Detail' 
									 AND      FieldName   = '#Name#' 
									</cfquery> 
									
									<cfif get.recordcount eq "0">
									
									    <!-- the label from the administrator --->
									
										<cfquery name="get" 
										 datasource="appsSystem">
										 SELECT   TOP 1 *
										 FROM     UserReportOutput
										 WHERE    UserAccount = 'Admninistrator'
										 AND      OutputId    = '#url.id#'
										 AND      OutputClass = 'Detail' 
										 AND      FieldName = '#Name#'								 
										</cfquery> 							
									
									</cfif>							
							
							<cfif selected eq "0">
							
								<td style="height:15px;cursor:pointer;padding-left:5px;background-color=f3f3f3" 
								  onmouseout="this.className='regular'" 
								  onmouseover="this.className='highlight'" 
								  onclick="fieldadd('#name#','Detail','#url.id#','#url.table#','#format#')">
								    																			
									<a style="font-size:12px;color:black" title="Select field: #name#"><cfif get.Outputheader neq "">#get.OutputHeader#<cfelse>#Name#</cfif>
									  <span style="color:800080"> 
									  <cfif userType eq "8">
									      &nbsp;(<cf_tl id="Numeric">)
									  <cfelseif userType eq "12">
									      &nbsp;(<cf_tl id="Date">)
									  </cfif>
									  </span>
									</a>
									
								</td>
							
							<cfelse>
							
								<td bgcolor="ffffef"  style="padding-left:5px;font-size:12px">														
									<a href="javascript:fielddelete('#name#','#url.id#','#url.table#')"><u><cf_tl id="revoke"></u></a>&nbsp;|&nbsp	
									<i><font color="gray"><cfif get.Outputheader neq "">#get.OutputHeader#<cfelse>#Name#</cfif></font></i>							 														
								</td>
							
							</cfif>
							
							</tr>						
							
						<cfif cnt eq m>
							 </table>						
						     </td>				     
						     <cfset cnt="0">
						</cfif>
					
					</cfoutput>
					
					</tr>
					
				</table>
					
			   </td>
				
		</tr>
		
		
		<tr><td colspan="5" valign="top" id="selectedfields">	
				<cfinclude template="formatExcelDetailSelected.cfm">			
			 </td>
		</tr>
		
		
		<cfoutput>
		
		<cfif Selected.recordcount gte "1">
		
		<tr><td height="5"></td></tr>
		<tr class="line">
		<td colspan="1" class="cellcontent" style="height:30px;font-size:16px"><cf_tl id="Filter Excel Output"></td>	
		</tr>
		<tr>
			<td colspan="5">
			
				<form name="filterform" id="filterform" method="post">
				
					<table border="0" class="formpadding">
					
						 <cfquery name="Fields" 
							datasource="#ds#">
								SELECT   C.name, C.userType 
							    FROM     SysObjects S, SysColumns C 
								WHERE    S.id = C.id
								AND      S.name = '#URL.table#'	
								<!---	AND      C.UserType != '8' --->
								<!---
								AND      C.Name not IN (#preserveSingleQuotes(gr)#)
								--->
								ORDER BY C.name
						</cfquery>
						
					<cfset cnt="1">
					
					<cfoutput>
					
						<cfloop index="itm" from="1" to="4">
						
							<cfquery name="Select" 
								 datasource="appsSystem">
									SELECT * 
									FROM   UserReportOutput 
									WHERE  UserAccount      = '#SESSION.acc#'
							        AND    OutputId         = '#URL.ID#'
									AND    OutputClass      = 'filter#itm#'		
									AND    FieldNameOrder   = '#itm#'	      		
							</cfquery>
							
							<cfif select.recordcount eq "0">	
									
								<cftry>
						
								<cfquery name="Insert" 
									 datasource="appsSystem">
									 INSERT INTO UserReportOutput 
									   (UserAccount, 
									    OutputId, 
										OutputClass, 
										FieldName, 
										FieldNameOrder)
									 VALUES
									   ('#SESSION.acc#',
									    '#URL.ID#',
										'filter#itm#',
										'#itm#',
										'#itm#')							
								</cfquery>	
											
								<cfcatch></cfcatch> 
								
								</cftry>
							
							</cfif>
											
							<cfif cnt eq "1"> 
								<tr class="labelmedium">			
							</cfif>
							
						    <td style="padding-left:22px" width="20" align="center">#itm#.</td>
							<td>
							
							 <select name="Crit#itm#_FieldName" class="regularxl" id="Crit#itm#_FieldName" onchange="savefilter('#url.id#','#url.table#')">
								 <option value="None">None</option>
							     <cfloop query="Fields">
								      <option value="#Name#" <cfif Select.FieldName eq "#Name#">selected</cfif> >#Name#</option>
								 </cfloop>
						    </select>
							</td>
										
							<INPUT type="hidden" name="Crit#itm#_FieldType" id="Crit#itm#_FieldType" value="CHAR">
							
							<TD style="padding-left:4px">
							
							     <SELECT name="Crit#itm#_Operator" class="regularxl" id="Crit#itm#_Operator" onchange="savefilter('#url.id#','#url.table#')">
								
									<OPTION value="CONTAINS"     <cfif Select.filterOperator eq "Contain">selected</cfif>>contains
									<OPTION value="BEGINS_WITH"  <cfif Select.filterOperator eq "BEGINS_WITH">selected</cfif>>begins with
									<OPTION value="ENDS_WITH"    <cfif Select.filterOperator eq "ENDS_WITH">selected</cfif>>ends with
									<OPTION value="EQUAL"        <cfif Select.filterOperator eq "EQUAL">selected</cfif>>is
									<OPTION value="NOT_EQUAL"    <cfif Select.filterOperator eq "NOT_EQUAL">selected</cfif>>is not
									<OPTION value="SMALLER_THAN" <cfif Select.filterOperator eq "SMALLER_THAN">selected</cfif>>before
									<OPTION value="GREATER_THAN" <cfif Select.filterOperator eq "GREATER_THAN">selected</cfif>>after
								
								</SELECT>
							</td>
							
							<td style="padding-left:4px">	
							<input type="text" name="Crit#itm#_Value" class="regularxl" style="font-weight:200;height:25" id="Crit#itm#_Value" value="#Select.FilterValue#" size="20"
							  onchange="savefilter('#url.id#','#url.table#')">
							</TD>
							
							<cfif cnt eq "2">
								</tr>
								<cfset cnt = "1">
							<cfelse>
							    <cfset cnt = cnt+1>	
								
							</cfif>
										
						</cfloop>
					
					</cfoutput>
					
					</table>
				
				</form>
			
			</td></tr>
			
		</cfif>	
				
		<tr><td colspan="5" id="filterbox"></td></tr>
		
		</cfoutput>
				
		</table>	
		
		</td>
		</tr>
		
		</table>	
		
		</td>
		</tr>
				
		</table>	
	
	</cf_divscroll>
		
	</td></tr>
	
	<cfoutput>
	
	<cfif Selected.recordcount gt "0">
		   
		<tr><td colspan="5" align="center" style="padding:5px">
		
			<table cellspacing="0" cellpadding="0" class="formspacing">
			<tr>
				<td>				
				<input type="button" name="mail" id="mail" value="Prepare and Send" class="button10g clsBtnPrepareExcel" style="font-size:15px;width:240px;height:31px" onclick="prepare('mail','#url.id#','#url.table#')">
				</td>				
				<td>	
				<input type="button" name="view" id="view" value="Download" class="button10g clsBtnPrepareExcel" style="font-size:15px;width:240px;height:31px" onclick="prepare('view','#url.id#','#url.table#')">
				</td>				
			</tr>
			</table>
		</td></tr>	
			
	<cfelse>
		<!--- hide --->
	</cfif>	
	
	</cfoutput>	
	
</table>
	
<script>
	Prosis.busy('no')
</script>