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
<!--- Prosis template framework --->
<cfsilent>
	<proUsr>dev</proUsr>
	<proOwn>dev dev</proOwn>
	<proDes>Translated</proDes>
	<proCom></proCom>
</cfsilent>
 
<cfparam name="url.mission"    default="">
<cfparam name="url.period"     default="">
<cfparam name="url.entryclass" default="">
<cfparam name="url.itemmaster" default="">
<cfparam name="url.mode"       default="select">

<cfparam name="Form.mission"    default="#url.mission#">
<cfparam name="Form.period"     default="#url.period#">
<cfparam name="Form.entryClass" default="#url.entryclass#">
<cfparam name="Form.itemmaster" default="#url.itemmaster#">

<cfparam name="Form.Crit1_FieldName" default="">
<cfparam name="Form.Crit2_FieldName" default="">
<cfparam name="Form.Crit4_FieldName" default="">

<CFSET Criteria = "">

<cfif form.Crit1_FieldName neq "">

<CF_Search_AppendCriteria
    FieldName="#Form.Crit1_FieldName#"
    FieldType="#Form.Crit1_FieldType#"
    Operator="#Form.Crit1_Operator#"
    Value="#Form.Crit1_Value#">
</cfif>

<cfif form.Crit2_FieldName neq "">

<CF_Search_AppendCriteria
    FieldName="#Form.Crit2_FieldName#"
    FieldType="#Form.Crit2_FieldType#"
    Operator="#Form.Crit2_Operator#"
    Value="#Form.Crit2_Value#">
</cfif>

<cfset criteria1 = criteria>

<CFSET Criteria = "">

<cfif form.Crit4_FieldName neq "">

<CF_Search_AppendCriteria
    FieldName="#Form.Crit4_FieldName#"
    FieldType="#Form.Crit4_FieldType#"
    Operator="#Form.Crit4_Operator#"
    Value="#Form.Crit4_Value#">	
</cfif>	

<cfset criteria4 = criteria>
	
<!--- check roles --->

<cfquery name="CheckRole" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT TOP 1 * 
	FROM   OrganizationAuthorization
	WHERE  UserAccount = '#SESSION.acc#'
	AND    Role IN ('ProcReqEntry','ProcReqReview')
</cfquery>

<cfquery name="Param" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT * 
	FROM   Ref_ParameterMission
	WHERE  Mission  = '#url.Mission#'		
</cfquery>

<cfquery name="per" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT TOP 1 * 
	FROM   Ref_MissionPeriod
	WHERE  Mission   = '#url.Mission#'
	AND    Period    = '#url.period#' 
</cfquery>

<!--- Query returning search results :  dev dev: Added a LEFT outer join with Ref_Object as per Kristina's request from CMP--->
<cfquery name="SearchResult" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT TOP 400 I.*, 
	       C.CustomDialog
    FROM #CLIENT.LanPrefix#ItemMaster I INNER JOIN Ref_EntryClass C	ON C.Code = I.EntryClass 
		
	WHERE 1=1

	AND   I.Operational = 1
	AND   I.isServiceitem = 0
	
	<!--- only enabled codes --->
	
	<cfif form.mission neq "" and url.mode neq "maintain">
	AND   I.Code IN (SELECT ItemMaster 
	                 FROM   ItemMasterMission 
					 WHERE  ItemMaster = I.Code 
					 AND    Mission = '#Form.Mission#') 
	</cfif>
	
	<cfif form.EntryClass neq "">
	AND   EntryClass = '#Form.EntryClass#'	
	<cfelseif url.entryClass neq "">
	AND   EntryClass = '#url.EntryClass#'	
	</cfif>
	
	<cfif form.mission neq "" and form.period neq "">
	AND   EntryClass IN (SELECT EntryClass 
	                     FROM   Ref_ParameterMissionEntryClass 
			 			 WHERE  Mission     = '#FORM.Mission#'
						 AND    Operational = 1 
						 AND    Period      = '#FORM.period#') 
	</cfif>
		
	<cfif getAdministrator("#Form.Mission#") eq "0" and url.mode neq "maintain">
	
	AND EntryClass IN (SELECT DISTINCT ClassParameter 
					   FROM   Organization.dbo.OrganizationAuthorization
					   WHERE  UserAccount = '#SESSION.acc#'
					   AND    Role IN ('ProcReqEntry','ProcReqReview')
					  ) 
	</cfif>		
	
	<!--- only allow item masters for procurement enabled OE --->
	
	<cfif Param.FilterItemMaster eq "1" and url.mode eq "regular">  <!--- if mode is maintain for association of warehouse items we all this to be shown --->
					
			    AND  I.Code IN (SELECT ItemMaster 
				                FROM   ItemMasterObject 
								WHERE  ObjectCode IN (SELECT Code 
								                      FROM   Program.dbo.Ref_Object 
													  WHERE  Procurement = 1))
	
				
				AND  ( 
				      I.Code IN (SELECT ItemMaster 
				                   FROM   Program.dbo.ProgramAllotmentDetail A, ItemMasterObject O
								   WHERE  A.ObjectCode = O.ObjectCode
								   AND    A.Period = '#URL.Period#'
								   AND    A.ProgramCode IN (SELECT ProgramCode 
								                            FROM   Program.dbo.Program
														    WHERE  Mission = '#url.Mission#') 
								 <cfif per.editionid neq "">					  
								  AND     A.EditionId = '#per.editionid#'		
								 </cfif>	
								 )
								 
						OR 
						
						EnforceListing = 1
						
						)		 
								 
	</cfif>	
		   				  
			  
	<cfif Criteria1 neq "">
        AND (
		    #PreserveSingleQuotes(Criteria1)# 
		    OR I.Code IN (SELECT ItemMaster 
			              FROM   ItemMasterStandard I, Ref_Standard R 
						  WHERE  I.StandardCode = R.Code 
						  AND    R.Description LIKE '%#Form.Crit1_Value#%')
  			    )
	</cfif>
			
	<cfif Criteria4 neq "">
	AND I.Code IN (SELECT ItemMaster FROM ItemMasterObject WHERE #PreserveSingleQuotes(Criteria4)# )
	</cfif>
	
	ORDER BY I.EntryClass, I.Description
		
</cfquery>

	
<table width="97%" border="0" cellspacing="0" cellpadding="0" class="navigation_table">
  <tr>
   
   <td>
    
		<table width="100%">   
							
				<TR class="labelmedium line fixrow">				
				<td width="20"></td>			    				
				<td width="60"><cf_tl id="Code"></td>				
			    <TD><cf_tl id="Description"></TD>				
				<td width="20"></td>
				<TD width="80"><cf_tl id="Class"></TD>
				<td width="60" align="right"><cf_tl id="Cost"></td>						
			
		</TR>
								
		<CFOUTPUT query="SearchResult">		
		
			<cfif CustomDialogOverwrite neq "">
			
				<cfset dlg = CustomDialogOverwrite>
				
			<cfelse>
				
				<cfset dlg = CustomDialog>
			
			</cfif>
		
		    <!---
			<cfset des = replaceNoCase("#description#",","," ","ALL")>
			<cfset des = replaceNoCase("#des#","'","","ALL")>
			<cfset des = replaceNoCase("#des#",'"',"","ALL")>
			--->
								
		    <tr style="height:20px" class="navigation_row line labelmedium">							
				<td width="20" style="padding-top:3px;padding-left:3px"><cf_img icon="select" navigation="Yes" onclick="setvalue('#Code#')"></td>
				<td>#Code#</td>								
				<td width="50%"><a href="javascript:recordedit('#code#')">#Description#</a></td>
				<TD style="padding-top:8px" align="center"><cf_img icon="expand" toggle="yes" onclick="GetObjects('#currentrow#','#Code#','#url.Mission#','#url.Period#')"></TD>					
				<td width="140">#EntryClass#<cfif customDialogOverwrite neq "">:#CustomDialogOverwrite#<cfelseif customdialog neq "">:#CustomDialog#</cfif></td>
				<td width="60" align="right" style="padding-right:4px">#numberformat(CostPrice,".__")#</td>			
			</TR>				
			<TR><td colspan="6" id="d#currentrow#"></td></TR>
				
		</CFOUTPUT>
		
		</table>
		
		</td>
		
		</tr>

</TABLE>

<cfset AjaxOnLoad("doHighlight")>	

<script>
	Prosis.busy('no')
</script>	


