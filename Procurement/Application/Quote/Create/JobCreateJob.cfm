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
<cfparam name="url.mode" default="job">
<cfparam name="SESSION.reqNo" default="">
<cfset url.selected = SESSION.reqNo>

<cfif url.selected eq "">
	<cfabort>
</cfif>

<cfquery name="Parameter" 
  datasource="AppsPurchase" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
      SELECT *
      FROM   Ref_ParameterMission
	  WHERE  Mission = '#URL.Mission#'
</cfquery>

<cfquery name="Active" 
  datasource="AppsPurchase" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
  SELECT DISTINCT J.JobNo, J.OrderClass, J.Description, J.CaseName, J.CaseNo, J.Created, 'Closed' AS JobStatus, MIN(L.Period) as Period
  FROM       Job J INNER JOIN
             JobActor A ON J.JobNo = A.JobNo INNER JOIN
             RequisitionLine L ON J.JobNo = L.JobNo
  WHERE      A.ActorUserId         = '#SESSION.acc#'		
  AND        J.Mission = '#URL.Mission#'	
  AND        J.OrderClass IN (SELECT Code FROM Ref_OrderClass WHERE PreparationMode = '#url.mode#') 
  GROUP BY   J.JobNo, J.OrderClass, J.Description, J.CaseName, J.CaseNo, J.Created
  HAVING     MIN(L.ActionStatus) < '2z' 
      AND    MIN(L.Period) = '#URL.Period#'
  UNION
  SELECT DISTINCT J.JobNo, J.OrderClass, J.Description, J.CaseName, J.CaseNo, J.Created, 'Closed' AS JobStatus, J.Period
  FROM       Job J INNER JOIN
             JobActor A ON J.JobNo = A.JobNo 
  WHERE      A.ActorUserId         = '#SESSION.acc#'		
  AND        J.Mission = '#URL.Mission#'		
   AND       J.OrderClass IN (SELECT Code FROM Ref_OrderClass WHERE PreparationMode = '#url.mode#') 
  AND        J.JobNo NOT IN (SELECT JobNo FROM RequisitionLine WHERE Mission='#URL.Mission#' AND JobNo is NOT NULL) 
  <!--- added condition 17/7/2009 for job additions 
  AND        J.ActionStatus = '0'
  --->
  ORDER BY 	 J.OrderClass, J.CaseNo 
</cfquery>

<cfform method="POST" name="jobform">  

<table width="100%" class="formpadding">
	
	<tr><td height="8" id="result"></td></tr>
	<tr>
	   <td width="95%" colspan="2" style="padding-left:20px">
	       
		   <input type="hidden" name="selectjob" id="selectjob" value="add">
		   <table><tr><td class="labelmedium" style="padding-left:5px;cursor: pointer;" onclick="selectme[0].click()">
		   <input type="radio" class="radiol" name="selectme" id="selectme" value="add" checked onClick="show('add');selectjob.value='add'"><cf_tl id="New Job">
		   </td>
		   
		   <cfif Active.recordcount neq "0">
		   
		   <td style="padding-left:5px;cursor: pointer;" class="labelmedium" onclick="selectme[1].click()">
		   <input type="radio" class="radiol" name="selectme" id="selectme" value="exist" onClick="show('exist');selectjob.value='exist'"><cf_tl id="Add to Existing Job">
		   </td>
		   <td>&nbsp;</td>
		   <td id="exist" class="hide">
		   		   
		    <select name="JobNo" id="JobNo" class="regularxxl">
			  <cfoutput query="Active">
			     <option value="#JobNo#">#JobNo# : #CaseNo# </option>
			  </cfoutput>
		    </select>
					   
		   </td> 		   
		   
		   </cfif>
		   
		   </td></tr></table>
	   </td>
	</tr>
			
	<tr><td height="3"></td></tr>
		
	<tr id="add" class="regular">
	
	  <td colspan="2">
	  
		<table width="93%" align="center" class="formpadding">
		
		<tr><td height="1" colspan="2" class="linedotted"></td></tr>
				
		<cfquery name="OrderClass" 
		  datasource="AppsPurchase" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
	    	  SELECT *
		      FROM   Ref_OrderClass R
			  WHERE  ( Mission = '#URL.Mission#' 
			          or  Mission is NULL 
					  or  Code IN (SELECT Code 
			                   FROM   Ref_OrderClassMission 
						       WHERE  Mission = '#url.mission#'
						       AND    Code = R.Code)
							   )
			  AND     PreparationMode = '#URL.Mode#'
			  <!---	this is handled differently by the template itself						   
			  AND    EXISTS (
			                 SELECT 'X'
							 FROM   Organization.dbo.Ref_EntityClassPublish
							 WHERE  EntityClass = R.Code AND EntityCode = 'ProcJob'
							 )				   
							 --->
			  ORDER BY ListingOrder
		</cfquery>
		
		<tr>
		   <td class="labelmedium"><cf_tl id="Workflow Track">:<font color="FF0000">*</font></b></td>
		   
		   <td class="labelmedium" style="height:26">
		   
		   <cfif OrderClass.recordcount eq "0">
		   <cfoutput><font color="FF0000">There is no Job workflow configured for #ucase(url.mode)# </font></cfoutput>
		   </cfif>
		   
	       <table>
		   <cfoutput query="OrderClass">
		   
			   	<!--- check if the class has a published instance --->
		   					
			   <tr>
			   <td><input type="radio" name="OrderClass" class="radiol" id="OrderClass" value="#Code#" <cfif currentrow eq "1">checked</cfif>></td>
			   <td style="padding-left:5px" class="labelmedium">
			   <a href="javascript:workflow('ProcJob','#code#')" title="Preview workflow"><font color="gray">#Description#</font></a>	   
			   </td>
			   </tr>
			   
		   </cfoutput>
		   </table>
			 
		   </td>
		</tr>
				
		<cfquery name="Mission" 
		  datasource="AppsOrganization" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
	    	  SELECT   *
		      FROM     Ref_Mission
			  WHERE    Mission = '#URL.Mission#'			 
		</cfquery>
		
		<cfquery name="JobGroup" 
		  datasource="AppsPurchase" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
	    	  SELECT *
		      FROM Ref_JobCategory
			  WHERE Code IN (SELECT EntityGroup 
			                 FROM   Organization.dbo.Ref_EntityGroup 
							 WHERE  EntityCode = 'ProcJob'
							 AND   (Owner is NULL or Owner = '#Mission.MissionOwner#')
							)
		</cfquery>
	
		<tr>
		   <td class="labelmedium"><cf_tl id="Authorization Group">:<font color="FF0000">*</font>&nbsp;</b></td>
		   <td class="labelmedium">
		   <select name="JobCategory" id="JobCategory" class="regularxxl">
			   <cfoutput query="JobGroup">
			   <option value="#Code#">#Description#</option>
			   </cfoutput>
		   </select>
			 
		   </td>
		</tr>
				
		<tr>
		   <td class="labelmedium"><cf_tl id="<cfoutput>#Parameter.JobReferenceName#</cfoutput>">:<font color="FF0000">*</font></td>
		   <td class="labelmedium">
		       <input class="regularxxl" type="text" name="CaseNo" id="CaseNo" size="20" maxlength="20">
		   </td>
		</tr>
				
		<tr>
		   <td class="labelmedium"><cf_tl id="Description">:&nbsp;<font color="FF0000">*</font></b></td>
		   <td>
		       <input class="regularxxl" type="text" name="Description" id="Description" size="80" maxlength="100">
		   </td>
		</tr>
		
		<tr>
		   <td class="labelmedium"><cf_tl id="Unit">:</td>
		   <td class="labelmedium">
		       <input class="regularxxl" type="text" id="CaseName" name="CaseName" size="80" maxlength="100">
		   </td>
		</tr>
		
		<cfif url.mode eq "ssa">
				
			<cfquery name="Person" 
			  datasource="AppsPurchase" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">
				SELECT  DISTINCT P.FirstName, P.LastName, P.Personno
				FROM    RequisitionLine R INNER JOIN
			            Employee.dbo.Person P ON R.Personno = P.PersonNo 
				WHERE   RequisitionNo IN (#preservesingleQuotes(URL.selected)#)
			</cfquery>				
		
			<cfif Person.recordcount gte "1">
			<tr>
			<td class="labelmedium"><cf_tl id="Proposed Individual">:</td>
			<td class="labelmedium">
			<table cellspacing="0" cellpadding="0">
			
			    <cfif Person.recordcount eq "1">
				
					<tr>
						<td class="labelmedium"><cf_tl id="Undefined"></td>					
					</tr>
								
				<cfelse>
				 
					<cfoutput query="Person">
					<tr>
						<td class="labelmedium"><a href="javascript:EditPerson('#PersonNo#')"><font color="0080C0">#FirstName# #LastName#</a></td>					
					</tr>
					</cfoutput>
				
				</cfif>
				
			</table>
			</td>
			
			</tr>
					
			</cfif>
		
		<cfelse>
					
			<cfquery name="Vendor" 
			  datasource="AppsPurchase" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">
				SELECT  DISTINCT O.OrgUnit, O.OrgUnitCode, O.OrgUnitName
				FROM    RequisitionLine R INNER JOIN
			            ItemMasterVendor I ON R.ItemMaster = I.Code INNER JOIN
			            Organization.dbo.Organization O ON I.OrgUnitVendor = O.OrgUnit
				WHERE   RequisitionNo IN (#preservesingleQuotes(URL.selected)#)
				AND     I.Operational = 1				
				
			</cfquery>				
		
			<cfif vendor.recordcount gte "1">
			<tr>
			<td class="labelmedium"><cf_tl id="Shortlisted Providers">:</td>
			<td class="labelmedium">
			<table cellspacing="0" cellpadding="0" class="formpadding">
			
				<cfoutput query="Vendor">
				<tr>
					<td class="labelmedium"><a href="javascript:viewOrgUnit('#OrgUnit#')">#OrgUnitCode#</a></td>
					<td class="labelmedium">&nbsp;</td>
					<td class="labelmedium">#OrgUnitName#</td>
				</tr>
				</cfoutput>
				
			</table>
			</td>
			
			</tr>
					
			</cfif>
			
		</cfif>	
						
		<tr>
		   <td valign="top" style="padding-top:4px" class="labelmedium"><cf_tl id="Justification">:</td>
		   <td>
		      <textarea style="border-radius:3px;width:99%;height:50;padding:3px;font-size:14px" class="regular" name="QuotationRemarks"></textarea>		  
		   </td>
		</tr>
			
		</table>	
				
	</td></tr>
		
	<tr><td height="4"></td></tr>
	<tr><td height="1" colspan="2" class="linedotted"></td></tr>
	<tr><td height="4"></td></tr>
		
	<cfoutput>
	<cf_tl id="Submit Job" var="1">
	<cfset vCJ=#lt_text#>
		
	</cfoutput>
		
	<tr><td height="4" colspan="2">
	
		<cf_securediv bind="url:SelectLines.cfm?mode=#url.mode#&mission=#url.mission#&period={period}">	
	
	</td></tr>
	
	<cfoutput>
	
	<cfif OrderClass.recordcount gte "1">
	
		<tr><td colspan="2" style="padding-top:4px" align="center">
		
		   <cfset sel = replace(url.selected,"'","","all")> 
		   	   
		    <input type="button" 
			     name="Close" 
	             id="Close"
				 value="Close" 		
				 class="button10g" style="height:30px;width:140;font-size:13px"
				 onclick="window.close()">
								 
		    <input type="button" 
			     name="Submit" 
	             id="Submit"
				 value="#vCJ#" 		
				 class="button10g" style="height:30px;width:140;font-size;13px"
				 onclick="Prosis.busy('yes');ptoken.navigate('JobCreateSubmit.cfm?mode=#url.mode#&Mission=#URL.Mission#&period=#URL.Period#','result','','','POST','jobform')">
			 
		</td></tr>
	
	</cfif>
	
	</cfoutput>
	
</td></tr>

</table>

</cfform>
