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

<cfparam name="url.object"       default="">
<cfparam name="url.entryclass"   default="">

<cfparam name="Form.Usage"       default="">
<cfparam name="Form.ObjectCode"  default="#url.object#">
<cfparam name="Form.EntryClass"  default="#url.entryclass#">
<cfparam name="Form.Crit1_Value" default="">
<cfparam name="Form.Crit4_Value" default="">

<CFSET Criteria = ''>

<cfif Form.Crit1_Value neq "">
<CF_Search_AppendCriteria
    FieldName="#Form.Crit1_FieldName#"
    FieldType="#Form.Crit1_FieldType#"
    Operator="#Form.Crit1_Operator#"
    Value="#Form.Crit1_Value#">
</cfif>	

<cfif Form.Crit4_Value neq "">
<CF_Search_AppendCriteria
    FieldName="#Form.Crit4_FieldName#"
    FieldType="#Form.Crit4_FieldType#"
    Operator="#Form.Crit4_Operator#"
    Value="#Form.Crit4_Value#">		
</cfif>	

<cfquery name="SearchResult" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT TOP 450 I.*, 
              IO.ObjectCode AS ObjectCode, 
		      R.ObjectUsage AS ObjectUsage, 
              R.Description AS ObjectDescription,
			  C.Description as EntryClassName,
			  C.CustomDialog,
			  I.CustomDialogOverwrite,
			  <cfif getAdministrator("*") eq "0">
				  (SELECT count(*)
				   FROM   Organization.dbo.OrganizationAuthorization
				   WHERE  UserAccount = '#SESSION.acc#'
				   AND    Role        = 'AdminProcurement'
				   AND    Mission = I.Mission) as Access
			  <cfelse>
			   	   1 as Access 
			  </cfif> 
			  
	FROM      Program.dbo.Ref_Object R INNER JOIN
              ItemMasterObject IO ON R.Code = IO.ObjectCode RIGHT OUTER JOIN
              ItemMaster I ON IO.ItemMaster = I.Code INNER JOIN 
			  Ref_EntryClass C ON I.EntryClass = C.Code 
	WHERE     1=1
	<cfif Form.Usage neq "">
	AND   I.Code IN (SELECT ItemMaster 
	                 FROM   ItemMasterMission 
					 WHERE  ItemMaster = I.Code
					 AND    Mission = '#Form.usage#') 
	</cfif>
	
	<cfif Form.Mission neq "">
	AND Mission = '#Form.Mission#'
	</cfif>
	
	<cfif Criteria neq "">
    AND #PreserveSingleQuotes(Criteria)# 
	</cfif>
	<cfif form.isServiceItem neq "">
	AND isServiceItem = '#Form.isServiceItem#'
	</cfif>
	<cfif Form.EntryClass neq "">
	AND EntryClass = '#Form.EntryClass#'
	</cfif>
	<cfif Form.ObjectCode neq "">
	AND I.Code IN (SELECT ItemMaster
	             FROM   ItemMasterObject 
				 WHERE  ObjectCode = '#Form.ObjectCode#') 
	</cfif>
	ORDER BY I.EntryClass, I.Code ASC, I.Description ASC
</cfquery>


<table width="98%" height="100%"  align="center" class="navigation_table">

<tr>
<td width="100%">
	
	<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
	
	<cfif searchresult.recordcount eq 350>
		<tr bgcolor="red"><td colspan="8" align="center" class="labelit">
		>> Attention: <b><font color="white"> Only the first 350 records are shown </b> </font><<
		</td></tr>
	</cfif>
	
	</table>

</td>
</tr>

<tr>
<td width="100%" height="100%" valign="top">

	<cf_divscroll>
		
		<table width="100%" align="center">
		
			<tr class="line fixrow labelmedium2">
			<TD  style="min-width:20"></TD>			
		    <TD  style="min-width:30"></TD>   
			<TD  style="width:15%"><cf_tl id="Class"></TD> 
			<TD  width="width:50%"><cf_tl id="Description"></TD>
			<TD  style="min-width:80"><cf_tl id="Code"></TD>
			<TD  style="min-width:30">Op</TD>			
			
			<TD  style="min-width:120"><cf_tl id="Interface"></TD>			
			<td  style="min-width:80"><cf_tl id="Usage"></td>
			<TD  style="min-width:60"><cf_tl id="Object"></TD>			
			<td  style="min-width:200">Name</td>
		  </TR>
							
			<cfset row = 0>
			
			<cfoutput query="SearchResult" group="Description">
			
				<cfset row = row+1>
			    	
				<TR style="height:21px" class="labelmedium2 navigation_row line"> 
				
					<td style="min-width:20" height="18" style="padding-left:3px">#row#.</td>
					
					<TD style="min-width:30" align="center" style="padding-top:1px;">
					
					     <cfif access eq "0">
						 
						 <cfelse>
					
						 	<cf_img icon="open" navigation="Yes" onclick="recordedit('#Code#');">
							  
						 </cfif>	  
								  
					</TD>		
					<TD style="min-width:80" id="#code#_clss">#EntryClassName#</TD>				
					<TD style="width:50%" id="#code#_desc">#Description#</TD>
					<TD style="min-width:80;padding-left:4px" id="#code#_code">#Code#</TD>
					<td style="min-width:30" id="#code#_oper"><cfif operational eq "1">Yes<cfelse><font color="FF0000">No</cfif></td>
					 
					<TD style="min-width:80" id="#code#_inte">
					<cfif CustomDialogOverwrite neq "">
					    <cfif customDialogOverwrite eq "Contract">Position<cfelse>#CustomDialogOverwrite#</cfif>
				    <cfelseif CustomDialog neq "">
					    <cfif customDialog eq "Contract">Position<cfelse>#CustomDialog#</cfif>
					<cfelse>Common</cfif>					
					<cfif customdialog eq "Materials">
					<cfif enforceWarehouse eq "0">:&nbsp;No<cfelseif enforceWarehouse eq "1">:&nbsp;Req<cfelse>:&nbsp;Rct</cfif>
					</cfif>					
					<cfif EmployeeLookup eq "1">
					:&nbsp;Per
					</cfif>
					
					</TD>	 					
					
					<td style="min-width:80"><font color="808080">#ObjectUsage#</td> 
					<td style="min-width:60" id="#code#_objc"><font color="808080">#ObjectCode#</td>		
					<td style="min-width:200"><font color="808080">
					<cfif len(ObjectDescription) lte 30>#ObjectDescription#<cfelse>#left(ObjectDescription,30)#...</cfif>
					</td>
				</tr>
				
				<cfoutput group="Code">
			
				<cfset r = 0>
				
				<cfoutput group="ObjectCode">
				
					<cfset r = r+1>
					
					<cfif r gt "1">
							
					<tr style="height:15px" class="labelit navigation_row">
					<td colspan="7" height="16"></td>
					<td style="border-bottom:1px solid silver"><font color="808080">#ObjectUsage#</td>
					<td style="border-bottom:1px solid silver"><font color="808080">#ObjectCode#</td>		
					<td style="border-bottom:1px solid silver"><font color="808080">
					<cfif len(ObjectDescription) lte 30>#ObjectDescription#<cfelse>#left(ObjectDescription,30)#...</cfif>
					</td>
					</tr>
					
					</cfif>			
					
				</cfoutput>	
				</cfoutput>
						
				<tr class="#URL.view#">
					
					<td colspan="3"></td>
					<td id="#Code#" colspan="6">
					
						<table width="100%" border="0" class="show" cellspacing="0" cellpadding="0">
					
							<cfquery name="vendors"
							datasource="AppsPurchase"
							username="#SESSION.login#"
							password="#SESSION.dbpw#">
								SELECT  *
								FROM    ItemMasterVendor      
								WHERE   Code = '#SearchResult.Code#'					  
							</cfquery>				
							
							<cfloop query="vendors">
							
									<cfquery name="ORG"
									datasource="AppsOrganization"
									username="#SESSION.login#"
									password="#SESSION.dbpw#">
										SELECT     *
										FROM  Organization      
										WHERE  OrgUnit = '#OrgUnitVendor#'					  
									</cfquery>				
									
							    <tr style="border-bottom:1px solid silver">
									<TD width="60">#OrgUnitVendor#</a></TD>
									<TD width="200">#ORG.OrgUnitName#</TD>
									<TD width="120">#OfficerFirstName# #OfficerLastName#</TD>
									<TD width="80">#Dateformat(Created, "#CLIENT.DateFormatShow#")#</TD>
							   </tr>
							   
							</cfloop>
						
						</table>
					</td></tr>	
											 
			</cfoutput>
			
			</table>
		
	</cf_divscroll>	

</tr>

</TABLE>

<cfset AjaxOnLoad("doHighlight")>	

<script>
	Prosis.busy('no')
</script>

