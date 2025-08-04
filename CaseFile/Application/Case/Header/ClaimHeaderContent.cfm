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


<cfoutput>

<script>

	function validate(id) {
	   
		document.caseform.onsubmit() 
	
		if( _CF_error_messages.length == 0 ) {
			if (document.caseform.claimtypeclass.value == '')	{
				alert('CaseFile entry class should be defined');
			}
			else {
				ptoken.navigate('../Header/ClaimHeaderSubmit.cfm?mid=#mid#&claimid='+id,'detailsubmit','','','POST','caseform')		
			}	
		 }  
	}

	function del(id) {
			
		var ans	=	confirm("this Case file will be removed, please confirm?");
		if(ans == true){
			ptoken.navigate('../Header/ClaimHeaderSubmit.cfm?mid=#mid#&claimid='+id+'&curraction=del','detailsubmit','','','POST','caseform')		
		}
		 
	}

	function selectclaimant(tpe,tree) {   		
   		  ptoken.navigate('../Header/ClaimantSelect.cfm?mid=#mid#&tree='+tree+'&claimid=#URL.ClaimId#&claimtype='+tpe,'claimant')		  
	}

	function applyunit(org)	{
		ptoken.navigate('#SESSION.root#/CaseFile/Application/Case/Header/getOrganization.cfm?orgunit='+org,'detailsubmit')
	}

</script>

</cfoutput>

<!---
<cf_screentop height="100%"  scroll="Yes" html="No" jQuery="Yes">
--->

<cfquery name="Parameter" 
    datasource="AppsCaseFile" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
        SELECT TOP 1 * 
        FROM  Ref_ParameterMission
</cfquery>

<cfparam name="URL.Mission" default="#Parameter.Mission#"> 

<cfif URL.Mission eq "">
	<cfset URL.Mission = Parameter.Mission>
</cfif>

<cfquery name="Get" 
	datasource="AppsCaseFile" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   C.*, 
	         R.Description as StatusDescription,
			 R.SystemStatus,
			 O.OrgUnitName as CustomerName,
			 T.Description as TypeDescription
	FROM     Claim C INNER JOIN
             Ref_Status R ON C.ActionStatus = R.Status INNER JOIN
             Ref_ClaimType T ON C.ClaimType = T.Code LEFT OUTER JOIN
             Organization.dbo.Organization O ON C.OrgUnitClaimant = O.OrgUnit
	WHERE    R.StatusClass = 'clm'		
	AND      C.ClaimId = '#URL.claimId#' 
</cfquery>	
		
<cfoutput>	
 
<cfform style="height:100%" method="POST" name="caseform" onsubmit="return false">

<cfif init eq "1">

	<table width="98%" border="0" align="center" cellspacing="0" cellpadding="0" class="formpadding">
		
	<cfinvoke component="Service.Access"  
	     method="CaseFileManager" 
	     mission="#URL.Mission#" 
	     returnvariable="access">
	
<cfelse>

	<cfinvoke component="Service.Access"  
     method="CaseFileManager" 
     mission="#URL.Mission#" 
	 claimtype="#get.claimtype#"
     returnvariable="access">

	<table width="98%" align="center" class="formpadding">
	<tr><td colspan="2" height="10"></td></tr>
	
</cfif>

<cfif (get.recordcount eq "0" or (get.SystemStatus neq "End"))
     and (Access eq "EDIT" or Access eq "ALL")>	 
	
	<!--- entry mode --->
	
	<cfquery name="parameter" 
		datasource="AppsCaseFile" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT *
		    FROM   Ref_ParameterMission
			WHERE  Mission = '#URL.Mission#'	
	</cfquery>
	
	<input type="hidden" name="fMission" id="fMission" value="#URL.Mission#">
	
	<!--- <a href="javascript:toggleheader()"> --->	
	<cfif get.recordcount neq "0">
	<tr>
		<td height="25" class="labelmedium2" width="100"><cf_space spaces="33"><cf_tl id="Case No">:</td>
		<td width="50%" class="labelmedium2">
			#get.caseNo#				 
		</td>
		<td width="100"><cf_space spaces="33"></td>	
		
		
	</tr>
	</cfif>
		
	<tr class="regular">
		<td height="25" class="labelmedium2" width="100"><cf_tl id="Organization">:</td>
		<td>
				
		     <cfoutput>	
			 				
					<cfif get.OrgUnit eq "">
					
						<cfquery name="Mandate" 
							datasource="appsOrganization" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
							SELECT   *
							FROM     Ref_Mandate
							WHERE    Mission = '#url.mission#'												      
							ORDER BY MandateDefault DESC
						</cfquery>	
						
						<cfset man = Mandate.MandateNo>		
						
					<cfelse>
					
						<cfquery name="getOrg" 
							datasource="appsOrganization" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
							SELECT   *
							FROM     Organization
							WHERE    OrgUnit = '#get.OrgUnit#'												      
						</cfquery>	
					
						<cfset man = getOrg.MandateNo>					
					
					</cfif>
					
					<!--- select valid units for the defined mandate --->
					
					<cfquery name="Org" 
						datasource="appsOrganization" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						SELECT   *
						FROM     Organization
						WHERE    Mission = '#url.mission#'	
						AND      MandateNo = '#man#'	
						ORDER    BY OrgUnitName												      
					</cfquery>	
					
				    <cfif Org.recordcount lte "90">
					
						<cfif SESSION.isAdministrator eq "No">
					
							<!--- check which units to show for the user --->
												
							<cfquery name="All" 
								datasource="appsOrganization" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">						
								SELECT   Mission
								FROM     OrganizationAuthorization
								WHERE    Role        = 'CaseFileManager'
								AND      UserAccount = '#SESSION.acc#'						
								AND      Mission     = '#url.mission#' 
								AND      OrgUnit is NULL						
							</cfquery>	
							
							<cfif All.recordcount eq "0">
							
								<!--- show only valid units to which the user was granted access --->
												
								<cfquery name="Org" 
								datasource="appsOrganization" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">
							
							    SELECT   *
								FROM     Organization
								WHERE    Mission = '#url.mission#'		
								AND      MandateNo = '#man#'
								AND      OrgUnit IN (
									
											SELECT   OrgUnit
											FROM     OrganizationAuthorization
											WHERE    Role        = 'CaseFileManager'
											AND      UserAccount = '#SESSION.acc#'						
											AND      Mission     = '#url.mission#' 
											AND      AccessLevel IN ('1','2')
											AND      OrgUnit is not NULL						
										)
								ORDER By OrgUnitName		
								</cfquery>					
							
							</cfif>
						
						</cfif>
						
						<select name="orgunit" class="regularxxl">
						
							<cfif get.orgunit neq "">
								<!--- always show the current value to prevent a reset if a user does not have access to selected others --->
								<option value="#getOrg.orgunit#" selected>#getOrg.OrgUnitName#</option>	
							</cfif>
				
							<cfloop query="org">								
							    
								<cfif get.OrgUnit neq orgunit>
								<option value="#orgunit#" <cfif get.orgunit eq orgunit>selected</cfif>>#OrgUnitName#</option>													
								</cfif>
								
							</cfloop>
						
						</select>						
											
					<cfelse>
					
						<table cellspacing="0" cellpadding="0"><tr><td>
						 
					   <img src="#Client.VirtualDir#/Images/contract.gif" alt="Select item master" name="img4" 
							  onMouseOver="document.img4.src='#Client.VirtualDir#/Images/button.jpg'" 
							  onMouseOut="document.img4.src='#Client.VirtualDir#/Images/contract.gif'"
							  style="cursor: pointer;" alt="" width="24" height="25" border="0" align="absmiddle" 
							  onClick="selectorgmis('webdialog','orgunit','orgunitcode','mission','orgunitname','orgunitclass','#URL.Mission#','','')">
						
						</td>
													  
						<cfquery name="Org" 
							datasource="appsOrganization" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
							SELECT   *
							FROM     Organization
							WHERE    OrgUnit = '#get.OrgUnit#'							
						</cfquery>	
					    
					  <cf_tl id="Please select an owner" var="1">
					  
					  <td style="padding-left:4px">
						
					  <cfinput type="Text"
					       name="orgunitname"
						   id="orgunitname"
					       message="#lt_text#"
					       required="Yes"
					       visible="Yes"
						   value="#Org.OrgUnitName#"
					       enabled="Yes"					     
					       size="50"
					       maxlength="60"
					       class="regularxxl" readonly>
						   
						</td></tr>
					   </table>   
						   
					  <input type="hidden" name="mission" id="mission">
				   	  <input type="hidden" name="orgunit" id="orgunit" value="#get.OrgUnit#">
					  <input type="hidden" name="orgunitcode" id="orgunitcode">
				  	  <input type="hidden" name="orgunitclass" id="orgunitclass">
					  					  
					  <!--- PENDING validation at the moment of saving that the unit can indeed be selected
					   in this mode --->
					  
				  </cfif>	  
				  
			</cfoutput>	
					   
	    </td>		
		
	</tr>
		
	<tr>
		<td class="labelmedium2" style="width:100px" height="25"><cf_tl id="File Reference">:
		<cf_space spaces="39">
		</td>
		<td>
		
			<cfinput type="Text"
		       name="DocumentNo"
		       required="No"
			   message="Please enter a document reference"
			   class="regularxxl"
			   maxlength="20"
			   value="#get.DocumentNo#"
	    	   visible="Yes"
		       enabled="Yes">
			   
	    </td>
		<td class="labelmedium2" width="100"><cf_tl id="File Date">:</td>
		<td>
		    <cf_calendarscript>
			
			<cfif get.recordcount eq "0">
			
				<cf_intelliCalendarDate9
					FieldName="DocumentDate" 
					required="Yes"
					default="#dateformat(now(),CLIENT.DateFormatShow)#"
					class="regularxxl"
	 			    message="Please enter a Document Date"
					AllowBlank="False">	
					
			<cfelse>
			
				<cf_intelliCalendarDate9
					FieldName="DocumentDate" 
					Default="#dateformat(get.DocumentDate,CLIENT.DateFormatShow)#"
					required="Yes"
					class="regularxxl"
	 			    message="Please enter a Document Date"
					AllowBlank="False">	
					
			</cfif>
			
		</td>
		
	</tr>
	
	<tr>
		    <td class="labelmedium2" height="25" width="100"><cf_tl id="Name">:</td>		
		    <td colspan="5">
		
				<cfinput type="Text"
			       name="DocumentDescription"
			       required="No"
				   message="Please enter a CaseFile description"
				   class="regularxxl"
				   maxlength="40"
				   size = "55"
				   value="#get.DocumentDescription#"
		    	   visible="Yes"
			       enabled="Yes">
				
			</td>
									
	</tr>
	
	<tr>
		<td class="labelmedium2" style="min-width:175px;max-width:175px" height="25"><cf_tl id="File Type">:</td>		
				
			<cfif get.recordcount eq "0">
			
				<td style="width:40%">
			
				<cfquery name="check" 
				datasource="AppsCaseFile" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT ClaimType 
	                FROM   Ref_ClaimTypeMission 
					WHERE  Mission = '#url.mission#'
				</cfquery>
			
				<cfquery name="Type" 
				datasource="AppsCaseFile" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				    SELECT *
				    FROM  Ref_ClaimType		
					WHERE Operational = '1'	
					<cfif check.recordcount gte "1">
					AND   Code IN (SELECT ClaimType 
					               FROM   Ref_ClaimTypeMission 
								   WHERE  Mission = '#url.mission#')
					</cfif>		
					ORDER BY ListingOrder			
				</cfquery>								
		
				<select name="claimtype" id="claimtype" class="regularxxl" onChange="selectclaimant(this.value,'#parameter.customertree#')">
				
				<cfloop query="type">
				
					<cfinvoke component="Service.Access"  
				     method="CaseFileManager" 
				     mission="#URL.Mission#" 
					 claimtype="#code#"
				     returnvariable="accessselect">
					
					<cfif accessselect eq "EDIT" or accessselect eq "ALL">
						<option value="#Code#" <cfif get.claimtype eq code>selected</cfif>>#Description#</option>
					</cfif>
				
				</cfloop>
				
				</select>
				
			</td>
			
			<td style="min-width:120px" class="labelmedium2"><cf_tl id="File Class">:</td>			
			<td style="width:40%">	
				
				<cfselect name="claimtypeclass"
				   class="regularxxl" 
				   bindonload="Yes"			
			       bind="cfc:service.Input.Input.DropdownSelect('AppsCaseFile','Ref_ClaimTypeClass','Code','Description','ClaimType',{claimtype},'','','')"/>				
										
			</td>	
			
			<cfelse>
			
				<td class="labelmedium2" style="width:40%">
			
			    <input type="hidden" name="claimtype" value="#get.claimtype#">
			
				<cfquery name="type" 
				datasource="AppsCaseFile" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				    SELECT *
				    FROM  Ref_ClaimType
					WHERE Code = '#get.claimtype#'			
				</cfquery>	
				
				#Type.description# 
				
				</td>
				
				<td class="labelmedium2"><cf_tl id="File Class">:</td>			
				<td style="width:40%">
				
				<cfselect name="claimtypeclass" class="regularxxl" bindOnLoad="yes" selected="#get.claimtypeclass#"
    			    bind = "cfc:service.Input.Input.DropdownSelect('AppsCaseFile','Ref_ClaimTypeClass','Code','Description','ClaimType','#get.claimtype#','','','#get.claimtypeclass#')">				
			    </cfselect>
				
				</td>
			
			</cfif>
			
	</tr>
	
	<tr>
			
		<td height="25" class="labelmedium2"><cf_tl id="Person">:</td>			
		<td>
				                       			
			<cf_securediv bind="url:../Header/ClaimantSelect.cfm?tree=#parameter.customertree#&claimid=#URL.ClaimId#&claimtype={claimtype}" id="claimant">
								
		  </td>
		  
		  <td class="labelmedium2" height="25" width="100"><cf_tl id="Contact Mail">:</td>
		  
		  <td width="40%">
		
			<cf_tl id="You must submit a correctly formatted eMail address" var="1" class="message">
			
			<cfinput type = "Text"
		       name       = "ClaimantEMail"
		       value      = "#get.ClaimantEMail#"
		       size       = "40"
		       validate   = "email"
			   message    = "#lt_text#"
		       required   = "No"
		       visible    = "Yes"
		       enabled    = "Yes"
		       typeahead  = "Yes"
		       maxlength  = "50"
		       class="regularxxl">
			   
		  </td>
	</tr>
	
	<tr><td height="10"></td></tr>
		
	<cfif init eq "1">
				
		<tr>
		<td valign="top" height="99%" style="border: 0px solid Silver;" colspan="4">
				
		    <cf_textarea name="ClaimMemo"                 		          
		           bindonload     = "No" 	      			 			 				          		            
				   init           = "yes"  
				   resize         = "No" 
				   height         = "80%"    
				   color          = "ffffff" 
		           toolbar        = "mini">#get.ClaimMemo#</cf_textarea>
				 
		</td>
		</tr>
		
	<cfelse>
	
		<tr>
		<td valign="top" style="border: 0px solid Silver;" colspan="4">
		    <cf_textarea name="ClaimMemo"                 		          
		           bindonload     = "No" 	      			 			 				          
		           resize         = "No"             				
				   height         = "220"
				   init           = "yes"  
		           toolbar        = "mini"
				   color          = "ffffff">#get.ClaimMemo#</cf_textarea>
		
		</td>
		</tr>
		
		<tr><td height="10"></td></tr>
	
		
	</cfif>		
		
	<cfif init eq "1">
	
	<tr><td id="detailsubmit"></td></tr>
	
	<tr><td height="1" colspan="4" class="linedotted"></td></tr>
	<tr>
		<td colspan="4" height="30" align="center">
			<cf_tl id="Close" var="1">
			<input type="button" name="Close" class="button10g" style="width:180" value="#lt_text#" onclick="parent.window.close()">
			<cf_tl id="Reset" var="1">
			<input type="reset" name="Reset" class="button10g" style="width:180" value="#lt_text#">
			<cf_tl id="Create File" var="1">
			<input type="button" name="Save" class="button10g" style="width:180" value="#lt_text#" onclick="Prosis.busy('yes');validate('#url.claimid#')">
	    </td>
	</tr>
	
	<cfelse>
	
	<tr><td height="1" colspan="4" class="linedotted"></td></tr>
	<tr>
	<cfset thisColsPan="4">
	
	<!---checking on the access and status to remove this record ---->
	<cfif Get.ActionStatus neq "1" and (Access eq "EDIT" or Access eq "ALL")>
		<cfset thisColsPan="2">
		<td align="center" colspan="#thisColsPan#">
			<cfoutput>
			    <cf_tl id="Remove" var="1">
					<input type="button" name="Save" style="font-size:13px;height:28;width:250" class="button10g" value="#lt_text#" onclick="Prosis.busy('yes');del('#url.claimid#'); parent.window.close()">				
			</cfoutput>	
		</td>	
			
	</cfif>
	
		<td align="center" colspan="#thisColsPan#">
			<cfoutput>
			    <cf_tl id="Update" var="1">
					<input type="button" name="Save" style="font-size:13px;height:28;width:250" class="button10g" value="#lt_text#" onclick="Prosis.busy('yes');updateTextArea();validate('#url.claimid#')">				
			</cfoutput>	
		</td>	
	</tr>	
	
	
	</cfif>		
	
<cfelse>
	
	<tr class="labelmedium2">
		<td height="25" width="150"><cf_tl id="Mission">:</td>
		<td>#URL.Mission#</td>
	</tr>

	<tr class="labelmedium2">
		<td height="25" width="100"><cf_tl id="Case No">:</td>
		<td>
			#get.CaseNo#
		</td>
	</tr>
	
	<tr class="labelmedium2">
		<td height="25" width="100"><cf_tl id="Description">:</td>
		<td>
			#get.DocumentDescription#
		</td>
	</tr>

	<tr class="labelmedium2">
		<td height="25" width="100"><cf_tl id="Reference">:</td>
		<td>#get.DocumentNo#</td>
	</tr>
	
	<tr class="labelmedium2">
		<td height="25" width="100"><cf_tl id="Type">:</td>
		<td>#get.TypeDescription#</td>
	</tr>
	
	<tr class="labelmedium2">
		<td height="25" width="100"><cf_tl id="Classification">:</td>
		<td></td>
	</tr>
			
		<cfquery name="type" 
		datasource="AppsCaseFile" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT *
		    FROM  Ref_ClaimType
			WHERE Code = '#get.claimtype#'			
		</cfquery>			

		<cfif Type.Claimant eq "Employee">
		
			<cfquery name="Person" 
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT *
			    FROM  Person
				WHERE PersonNo = '#get.PersonNo#'			
			</cfquery>							

			<tr>
				<td height="25" width="100">Claimant/Beneficiary:</td>
				<td>#Person.fullName#
				</td>
			</tr>
			
		<cfelse>
		
			<tr class="labelmedium2">
				<td height="25" width="100"><cf_tl id="Customer">:</td>
				<td>#get.CustomerName#</td>
			</tr>
		
		</cfif>			
			
	<tr class="labelmedium2">
		<td height="25" width="100"><cf_tl id="Contact eMail">:</td>
		<td>#get.ClaimantEMail#</td>
	</tr>
	<tr class="labelmedium2">
		<td height="100%" width="100"><cf_tl id="Memo">:</td>
		<td>#get.ClaimMemo#</td>
	</tr>

</cfif>

</table>

</cfform>

</cfoutput>

<cfdiv id="detailsubmit" class="hide">