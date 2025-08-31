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
<cfquery name="Site" 
	datasource="AppsInit">
		SELECT * 
		FROM Parameter
		WHERE HostName = '#CGI.HTTP_HOST#'
</cfquery>

<cfquery name="Parameter" 
	datasource="appsSystem">
	SELECT   *
    FROM     Parameter
</cfquery>

<cfif site.applicationserver eq Parameter.databaseServer>		
	  <cfset svr = "">
<cfelse>
      
      <cfset svr = "[#Parameter.databaseServer#].">
	  
</cfif>

  <cfquery name="Delete" 
	datasource="#url.ds#">
		DELETE FROM #svr#System.dbo.UserReportOutput 
		WHERE  UserAccount = '#SESSION.acc#'
		AND    OutputId    = '#url.id#'
		AND    OutputClass != 'Aggregate'
		AND    FieldName NOT IN (SELECT C.Name 
		                         FROM SysObjects S, SysColumns C 
								 WHERE    S.id = C.id
								 AND      S.name = '#URL.table#')	
	</cfquery>
			
	<cfquery name="Selected" 
	datasource="#url.ds#">
		SELECT   FieldName, GroupFormula, C.UserType, OutputSorting, OutputHeader
	    FROM     #svr#System.dbo.UserReportOutput P,
		         SysObjects S, 
				 SysColumns C 
		WHERE    S.id         = C.id
		AND      C.Name       = P.FieldName
		AND      S.name       = '#URL.table#'
		AND      UserAccount  = '#SESSION.acc#'
		AND      OutputId     = '#url.id#'
		AND      OutputClass  = 'Detail' 
		AND      OutputShow   = 1
		ORDER BY FieldNameOrder
	</cfquery>
	
	<cfif Selected.recordcount gte "1">
	
	    <form name="formselectedfields" id="formselectedfields">
		
			<table width="100%">
			
			<cfoutput>		
			<tr class="line  fixlengthlist">
			   <td colspan="7" style="font-size:16px;height:26px;padding-left:1px;" class="labelmedium2"><cf_tl id="Selected">
			   <a href="javascript:fielddelete('','#url.id#','#url.table#')">[<cf_tl id="remove all fields">]</a>	
			   	   
			   </td>
			</tr>
			</cfoutput>
				
			<!--- container saving label --->
			<tr class="hide"><td id="label"></td></tr>
			
			<tr class="labelmedium2 line fixlengthlist">
			<td></td>
			<td style="width:30px"><cf_tl id="Sort"></td>
			<td><cf_tl id="Field name"></td>	
			<td align="center"></td>	
			<td><cf_tl id="Label"></td>		
			<td><cf_tl id="Sort"></td>
			<td><cf_tl id="Sum"></td>	
			</tr>		
					
			<cfoutput query="Selected">
			
			<tr style="height:15px" class="line labelmedium2 fixlengthlist">
			
			<td align="center">
				
				<cfquery name="Check" 
				datasource="appsSystem">
					SELECT   FieldName 
				    FROM     UserReportOutput
					WHERE    UserAccount = '#SESSION.acc#'
					AND      OutputId    = '#id#'
					AND      OutputClass LIKE 'Group%' 
					AND      FieldName = '#FieldName#'
				</cfquery>
				
				<cfif Check.recordcount gte "1">	
					*		
				<cfelse>	
					<cf_img icon="delete" onClick="javascript:fielddelete('#Fieldname#','#url.id#','#url.table#')">				
				</cfif>
			
			</td>
			
			<td align="center">
			
			<input type="text" name="Order_#fieldname#" onchange="document.getElementById('applysort').className='regular'" class="regular" style="background-color:e1e1e1;border:1px;text-align:center;width:40px" value="#currentrow#">
			
			</td>
			
			<td onmouseout="this.className='regular'" 
				onmouseover="this.className='highlight1'" style="font-size:12px;padding-left:4px">#FieldName#
			</td>
				
			<td align="right">
				
				<table><tr>
				<td align="center" style="width:20px">
				<cfif currentrow neq 1>			
								
				    <button type="button" style="border:1px;height:20px;width:20px" class="button10g" 
					   onclick="update('up','#fieldName#','','#url.id#','selectedfields','#url.table#','#url.ds#')">
					
					<img src="#SESSION.root#/images/up6.png" 							 
								 width="8" 
								 height="10" 
								 alt="" 
								 border="0">
				
					</button>
									
				</cfif>
				
				</td>
	
			    <td align="center" style="width:20px">
													
				<cfif currentrow neq recordcount>				
				
					 <button type="button" style="border:1px;height:20px;width:20px" class="button10g" onclick="update('down','#fieldName#','','#url.id#','selectedfields','#url.table#','#url.ds#')">
					 
					 <img src="#SESSION.root#/images/down6.png" 							 
								 width="8" 
								 height="10" 
								 alt="" 
								 border="0">
				
					</button>
									
				</cfif>
				
				</td>
				
				</tr>
				</table>
			</td>
												
			<td>
				<input type="text" 
				   name="label" 
				   id="label"
				   value="#OutputHeader#" 
				   style="height:20px;width:100%;font-size:12px;padding:0px;padding-left:3px;padding-right:3px;background-color:ffffbf;border:0px;border-left:1px solid silver;border-right:1px solid silver"
				   class="regularh" 
				   onchange="update('label','#fieldName#',this.value,'#url.id#','label','#url.table#')">		
			</td>	
			
			<td id="sorting#currentrow#">
			
				<cfif OutputSorting eq "">
					   <a href="javascript:update('sorting','#fieldName#','ASC','#url.id#','sorting#currentrow#','#url.table#')">ASC</a>&nbsp;|
					   <a href="javascript:update('sorting','#fieldName#','DESC','#url.id#','sorting#currentrow#','#url.table#')">DESC</a>&nbsp;|
					   <font color="800000">NONE</font>
				<cfelseif OutputSorting eq "ASC">
					   <font color="800000">ASC</font>&nbsp;|			   
					   <a href="javascript:update('sorting','#fieldName#','DESC','#url.id#','sorting#currentrow#','#url.table#')">DESC</a>&nbsp;|
					   <a href="javascript:update('sorting','#fieldName#','','#url.id#','sorting#currentrow#','#url.table#')">NONE</a>		  
				<cfelse>
					   <a href="javascript:update('sorting','#fieldName#','ASC','#url.id#','sorting#currentrow#','#url.table#')">ASC</a>&nbsp;|
					   <font color="800000">DESC</font>&nbsp;|			   
					   <a href="javascript:update('sorting','#fieldName#','','#url.id#','sorting#currentrow#','#url.table#')">NONE</a>	  
				</cfif>
			
			</td>	
			
			<td id="formula#currentrow#">
					
				<cfif userType eq "8" or userType eq "7">
				
					<cfif GroupFormula eq "None" or GroupFormula eq "">
					   <a href="javascript:update('formula','#fieldName#','SUM','#url.id#','formula#currentrow#','#url.table#')"><cf_tl id="Yes"></a>&nbsp;|&nbsp;<cf_tl id="No">
					<cfelseif GroupFormula eq "SUM">
					   <cf_tl id="Yes">&nbsp;|&nbsp;</font><a href="javascript:update('formula','#fieldName#','None','#url.id#','formula#currentrow#','#url.table#')"><cf_tl id="No"></a>
					</cfif>
					
				</cfif>
				
			</td>
				
			</tr>
			
			</cfoutput>
			
			<cfoutput>
			
			<tr id="applysort" class="hide"><td colspan="7" style="padding:2px;height:20px">
			 <input type="button" value="Apply sort" style="height:23px" class="button10g" onclick="javascript:update('ap','','','#url.id#','selectedfields','#url.table#','#url.ds#')">			  
			</td></tr>
			
			</cfoutput>
			
			
			</table>
		
		</form>
	
	</cfif>