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

<cfparam name="url.idmenu" default="">

<cf_screentop height="100%" 
			  scroll="Yes" 
			  html="No" 
			  menuAccess="Yes" 
			  jQuery="Yes"
			  systemfunctionid="#url.idmenu#">

<cf_dialogPosition>

<cfparam name="URL.view"      default="title">
<cfparam name="URL.mode"      default="regular">
<cfparam name="CLIENT.Filter" default="">
<cfparam name="URL.ID"        default="">
<cfparam name="URL.page"      default="1">

<cfset currrow = 1>
<cfinclude template="RecordListingScript.cfm">

<cfoutput>

<cfquery name="Parameter"
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT     *
	FROM        Parameter
</cfquery>

<cfif URL.view eq "grade">
			
	<cfquery name="SearchResult"
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
		SELECT R.GradeDeployment, 
			   R.Description as GradeDeploymentdescription,  
			   R.ListingOrder, 
			   F.*, 		    
			   O.Description, 
			   (SELECT count(*) 
						 FROM   FunctionOrganization FO, Ref_SubmissionEdition S  
						 WHERE  FO.SubmissionEdition = S.SubmissionEdition 
						 AND    S.EnableAsRoster = 1 AND F.FunctionNo = FO.FunctionNo AND G.GradeDeployment = FO.GradeDeployment) as Bucket			
			   
		FROM   #CLIENT.LanPrefix#FunctionTitle F INNER JOIN
               #CLIENT.LanPrefix#OccGroup O ON F.OccupationalGroup = O.OccupationalGroup INNER JOIN
               FunctionTitleGrade G ON F.FunctionNo = G.FunctionNo INNER JOIN Ref_GradeDeployment R ON G.GradeDeployment = R.GradeDeployment
		
		WHERE 1=1 
		
		<cfif url.mode eq "regular">
		
			#preserveSingleQuotes(Client.condition)#
			<cfif SESSION.isAdministrator eq "No">
			AND EXISTS  (SELECT 'X'
			             FROM   Organization.dbo.OrganizationAuthorization A, Ref_FunctionClass R
						 WHERE  R.Owner          = A.ClassParameter
						 AND    A.Role           = 'FunctionAdmin' 
						 AND    R.FunctionClass  = F.FunctionClass
						 AND    A.GroupParameter = F.OccupationalGroup
						 AND    A.UserAccount    = '#SESSION.acc#')
			</cfif>	
		<cfelse>
		    AND F.OfficerUserId = '#SESSION.acc#'
			AND F.Created > getdate()-1			
		</cfif>		
		
		ORDER BY O.OccupationalGroup, 
		         R.ListingOrder, 
				 R.GradeDeployment, 
				 F.FunctionDescription
				 
	</cfquery>

<cfelse>
		
	<cfquery name="SearchResult"
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT O.Description,
		       F.*,  
			     (SELECT count(*) 
						 FROM   FunctionOrganization FO, Ref_SubmissionEdition S  
						 WHERE  FO.SubmissionEdition = S.SubmissionEdition 
						 AND    S.EnableAsRoster = 1 AND F.FunctionNo = FO.FunctionNo) as Bucket				  
		FROM   #CLIENT.LanPrefix#OccGroup O, 
			   #CLIENT.LanPrefix#FunctionTitle F
		WHERE  O.OccupationalGroup = F.OccupationalGroup
		
		<cfif url.mode eq "regular">
		
			#PreserveSingleQuotes(Client.condition)#
			
			<cfif SESSION.isAdministrator eq "No">
			AND EXISTS  (SELECT 'X'
			             FROM   Organization.dbo.OrganizationAuthorization A, Ref_FunctionClass R
						 WHERE  R.Owner          = A.ClassParameter
						 AND    A.Role           = 'FunctionAdmin' 
						 AND    R.FunctionClass  = F.FunctionClass
						 AND    A.GroupParameter = F.OccupationalGroup
						 AND    A.UserAccount    = '#SESSION.acc#')
			</cfif>	
		
		<cfelse>
		
		    AND F.OfficerUserId = '#SESSION.acc#'
			AND F.Created > getdate()-1			
			
		</cfif>			
						
		ORDER BY O.OccupationalGroup, F.FunctionDescription
	</cfquery>

</cfif>

<cfset counted = Searchresult.recordcount>

</cfoutput>

<table width="94%" height="100%" align="center">

<tr><td height="24">

<input type="hidden" id="myrow">
</td></tr>

<tr class="noprint linedotted">
    <td style="padding-left:2px;height:46;font-size:32px;" class="labellarge"><cf_tl id="Functional Titles and Buckets"></b></td>
	<td align="right">
	
	<cfif URL.View eq "grade">
	
		<cf_PageCountN count="#counted#">
		<select name="page" id="page" class="regularxl" size="1" style="background: #ffffff;" onChange="javascript:reloadForm(this.value,'<cfoutput>#URL.View#','#url.mode#'</cfoutput>)">
		    <cfloop index="Item" from="1" to="#pages#" step="1">
			        <cfoutput><option value="#Item#"<cfif URL.page eq "#Item#">selected</cfif>><cf_tl id="Page"> #Item# <cf_tl id="of"> #pages#</option></cfoutput>
		    </cfloop>	 
		</SELECT> 	
	
	<cfelse>
	
		<cf_PageCountN count="#counted#">
		<select name="page" id="page" class="regularxl" size="1" style="background: #ffffff;" onChange="javascript:reloadForm(this.value,'<cfoutput>#URL.View#','#url.mode#'</cfoutput>)">
		    <cfloop index="Item" from="1" to="#pages#" step="1">
			        <cfoutput><option value="#Item#"<cfif URL.page eq "#Item#">selected</cfif>><cf_tl id="Page"> #Item# <cf_tl id="of"> #pages#</option></cfoutput>
		    </cfloop>	 
		</SELECT>
	
	</cfif>
	
	</td>
</tr> 	

<tr>
     <td colspan="12" height="40" style="padding-left:6px">
	 
	 <table class="formspacing">
	 <tr class="fixlengthlist">
	  		 	 
		 <cfoutput>
	 
		 <td align="right"> 
		 	<button class="button10g" style="width:100" onClick="javascript:locate('#url.idmenu#')"><cf_tl id="Search"></button>
		 </td>
		 	 
		 <cfinvoke component="Service.AccessGlobal"  
		      method="global" 
			  role="FunctionAdmin" 
			  returnvariable="Access">
			  
		 <cfif Access eq "EDIT" or Access eq "ALL">   		 
	  	 	<td><button class="button10g" style="width:100" onClick="javascript:recordadd()"><cf_tl id="Add Title"></button></td>	 
		 </cfif>
		 
		 <td> 
		     
			 <cfif url.mode eq "new">
			 <input type="button" name="mode" id="mode" class="button10g" value="All Functions" <cfif URL.mode eq "new">checked</cfif> onClick="reloadForm(page.value,'#url.view#','regular')">
			 <cfelse>
			 <input type="button" name="mode" id="mode" class="button10g" value="Newly added" <cfif URL.mode eq "new">checked</cfif> onClick="reloadForm(page.value,'#url.view#','new')">	
			 </cfif>	 
		 </td>
		 
		 <td>
		 
		 		<cfset condition = replace(client.condition,"'","|","ALL")>
				   		    
			    <cfinvoke component="Service.Analysis.CrossTab"  
					  method      = "ShowInquiry"
					  buttonClass = "button10g"			
					  buttonstyle = "width:120"		  						 
					  buttonText  = "Export Excel"						 
					  reportPath  = "Roster\Maintenance\FunctionalTitles\"
					  SQLtemplate = "RecordListingExcel.cfm"
					  filter      = "#condition#"
					  dataSource  = "appsQuery" 
					  module      = "Roster"						  
					  reportName  = "Execution Report"
					  table1Name  = "Titles"
					  table2Name  = "Titles and Grades"				
					  data        = "1"
					  ajax        = "0"				 
					  olap        = "0" 
					  excel       = "1"> 	
		 
		 </td>		 
		 
		 <td style="padding-left:8px"><input type="radio" class="radiol" name="view" id="view" value="title" <cfif URL.view eq "title">checked</cfif> onClick="reloadForm(page.value,'title','#url.mode#')"></td>
		 <td style="padding-left:3px" class="labelmedium" onClick="reloadForm(page.value,'title','#url.mode#')"><cf_tl id="Title"></td>
		 <td style="padding-left:8px"><input type="radio" class="radiol" ame="view" id="view" value="grade" <cfif URL.view eq "grade">checked</cfif> onClick="reloadForm(page.value,'grade','#url.mode#')"></td>
	     <td style="padding-left:3px; padding-right:20px" class="labelmedium" onClick="reloadForm(page.value,'grade','#url.mode#')">Grade&nbsp;<b>(bucket)</b></td>
				 
		 </cfoutput>
	 		 
	 </tr>
	 </table>
	 </td>
</tr>

<tr><td colspan="10"><cfinclude template="Navigation.cfm"></td></tr>

<tr>
<td colspan="10" height="100%">

	<cf_divscroll>
	
		<table width="100%" class="navigation_table">
			
		<tr class="labelmedium line fixrow fixlengthlist">
		    <td colspan="2" style="padding-left:4px"><cf_tl id="No"></td>		
			<td><cf_tl id="Class"></td>
			<td width="2%">R.</td>
			<!---
			<td><cf_tl id="Parent"></td>
			--->
			<td width="40%"><cf_tl id="Description"></td>
			<td width="70"><cf_tl id="Code"></td>		
			<td><cfif URL.View eq "grade"><cf_tl id="Owner"><cfelse><cf_tl id="Grade deployment"></cfif></td>
			<td><cf_tl id="Entered"></td>
			<td></td>
		</tr>
			
		<cfif URL.View eq "grade">
		
			<cfoutput query="SearchResult" group="Description">
			
			    <cfif currrow gte first and currrow lte last> 
				    <tr class="linedotted"><td colspan="9" height="20" class="labellarge">#Description#</td></tr>
				</cfif>
				
				<cfoutput group="ListingOrder">
				<cfoutput group="GradeDeployment">
				
				<cfif currrow gte first and currrow lte last>
				<tr class="linedotted">
			      <td class="labelmedium" colspan="9" style="font-size:18px;padding-left:4px"><b>			  
				  <cfif GradeDeployment eq "">		  
				  <cf_tl id="Not defined"><cfelse>#GradeDeployment#</cfif></b>
				  </td>	
				</tr>
				</cfif>
					
				<cfoutput>
				
				<cfset currrow = currrow + 1>
				
				<cfif currrow gte first and currrow lte last>
						
					    <!--- <tr bgcolor="#IIf(Currentrow Mod 2, DE('FFFFFF'), DE('ffffcf'))#"> --->
						<cfif FunctionOperational eq "0">
						<tr bgcolor="FBB5AA" style="height:20px" class="navigation_row labelmedium linedotted fixlengthlist">
						<cfelseif Bucket eq "0">
						<tr bgcolor="ffffff" style="height:20px" class="navigation_row labelmedium linedotted fixlengthlist">
						<cfelse>
						<tr style="height:20px" class="navigation_row labelmedium linedotted fixlengthlist">
						</cfif>
						
						<td width="50" style="font-size:12px;padding-left:5px;height:20px" class="navigation_action">
						  <a href="javascript:recordedit('#FunctionNo#','#currentrow#')">#FunctionNo#</a>
						</td>	
																
						<cfif Bucket neq "0">
						
							<td width="50" style="padding-left:4px">								
							<cf_img icon="expand" toggle="Yes" onclick="listing('#Currentrow#','#FunctionNo#','#GradeDeployment#')">																
							</td>	
							
						<cfelse>
							
							<td >
								 <!--- <cf_img icon="edit" onclick="recordedit('#FunctionNo#','#currentrow#');"> --->
							</td>							
							
						</cfif>			
									
						<td>#FunctionClass#</td>
						<td><cfif FunctionRoster eq "1"><img src="#SESSION.root#/Images/check.png" height="11" alt="= Roster function" border="0"></cfif></td>
						
						<!---
						<td>#ParentFunctionNo#</td>
						--->
						<td id="desc_#currentrow#">				
						<font color="0080C0">
						<cfif URL.ID neq "">
							#ReplaceNoCase(Searchresult.FunctionDescription, URL.ID, "<b><u>#URL.ID#</u></b>")#
						<cfelse>
							#FunctionDescription#
						</cfif>				
						</td>
						<td id="code_#currentrow#"><cfif FunctionClassification eq "">#Reference#<cfelse>#FunctionClassification#</cfif></td>
						<td>#OfficerFirstName# #OfficerLastName#</td>
						<td>#Dateformat(Created, "#CLIENT.DateFormatShow#")#</td>
						<td align="left" id="grde_#currentrow#" class="hide"></td>					
					    </tr>
												
						<tr id="d#currentrow#" class="hide"><td></td>
						    <td colspan="8" id="i#currentrow#"></td>
					    </tr>
					
				</cfif>
				
				<cfif currrow gt last>			  
					<cfabort>
				</cfif>
					
				</cfoutput>
				</cfoutput>
			   	</cfoutput>
					
			</tr>
			</CFOUTPUT>
		
		<cfelse>
		
			<cfoutput query="SearchResult" group="Description">
			
				<cfif currrow gte first and currrow lte last> 	
			    	<tr class="line fixrow2"><td colspan="9" height="24" style="font-size:22px;height:40px;padding-left:5px">#Description#</td></tr>
				</cfif>
						
				<cfoutput>
				
				<cfset currrow = currrow + 1>
						
				<cfif currrow gte first and currrow lte last> 
								
				    <cfif Bucket neq "0">
					<tr style="height:18px" class="navigation_row labelmedium line">
					<cfelse>
					<tr style="height:18px" class="navigation_row labelmedium line">				
					</cfif>
					
					<td style="font-size:12px;padding-left:5px;padding-right:5px">					
					    <a href="javascript:recordedit('#FunctionNo#','#currentrow#')">#FunctionNo#</a></td>	
					
						<cfif Bucket neq "0">
						
						   <td align="center" style="padding-top:5px;;padding-right:5px">					   					   
						    <cf_img icon="expand" toggle="Yes" onclick="listing('#Currentrow#','#FunctionNo#','')">										   							
						   </td>	
								
						<cfelse>						
							<td style="padding-right:5px"></td>							 		
						</cfif>			
										
					<td style="padding-right:5px">#FunctionClass#</td>
					<td><cfif FunctionRoster eq "1"><img src="#SESSION.root#/Images/check.png" height="11" alt="= Roster function" border="0"></cfif></td>
						
					<!---
					<td style="padding-right:5px">#ParentFunctionNo#</td>
					--->
					<td id="desc_#currentrow#">
						<table cellspacing="0" cellpadding="0">				
						<cfif URL.ID neq "">
						    <tr style="height:18px" class="labelmedium"><td><font color="0080C0">#ReplaceNoCase(Searchresult.FunctionDescription, URL.ID, "<b><u>#URL.ID#</u></b>")#</td></tr>
						<cfelse>
						    <tr style="height:18px" class="labelmedium"><td>#FunctionDescription#</td></tr>
							<cfif FunctionPrefix neq "">
							<tr style="height:18px" class="labelmedium"><td>#FunctionPrefix#.#FunctionKeyWord#.#FunctionSuffix#</td></tr>
							</cfif>
						</cfif>
						</table>
					</td>
					<td style="padding-right:5px" id="code_#currentrow#">#FunctionClassification#</td>				
					<td style="padding-right:5px" width="25%" id="grde_#currentrow#">
					
						<cfquery name="Grade"
						datasource="AppsSelection" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							SELECT   DISTINCT 
							         FG.FunctionNo,
									 FG.Reference,
							         FG.GradeDeployment, 
									 FP.FunctionNo as Profile
							FROM     FunctionTitleGrade FG LEFT OUTER JOIN FunctionTitleGradeProfile FP
							  ON     FG.FunctionNo = FP.FunctionNo AND FG.GradeDeployment = FP.GradeDeployment
							WHERE    FG.FunctionNo = '#FunctionNo#'		
							AND      FG.Operational = 1			
							GROUP BY FG.FunctionNo,
							         FG.GradeDeployment,
									 FP.FunctionNo,
									 FG.Reference
						</cfquery>
					
						<table width="100%" cellspacing="0" cellpadding="0"><tr><td class="labelit">
						
							<cfloop query="Grade">
							<a title="Maintain job profile" href="javascript:maintain('#FunctionNo#','#GradeDeployment#')">
							
							<cfif Profile neq ""><font color="0080C0"><b><cfelse><font color="0080C0"></cfif>
							#Grade.GradeDeployment#<cfif grade.reference neq "">/#reference#</cfif>
							<cfif Profile neq ""></b></cfif>
							</font>
							</a>						
							<cfif Currentrow neq Recordcount>;</cfif>
							</cfloop>
						</td>	
						</tr>
						</table>
						
					</td>
					<td style="font-size:13px;padding-right:5px">#Dateformat(Created, "#CLIENT.DateFormatShow#")#</td>
					<td align="left" style="padding-left:4px;padding-top:1px;">
					<!---
						 <cf_img icon="open" onclick="EditFunction('#FunctionNo#')">		
						 --->						 
					</td>
					</tr>
					
					<tr id="d#currentrow#" class="hide">
					   <td colspan="9" id="i#currentrow#"></td>
					</tr>								
									
				</cfif>
					
				</cfoutput>
					
			</tr>
			</CFOUTPUT>
		
		</cfif>
		
		</table>
	
	</cf_divscroll>

</td></tr>

<cfif currrow gt last>
					
	<tr style="border-top:1px solid silver"><td colspan="10">
	<cfinclude template="Navigation.cfm">
	</td></tr>		  	
	
</cfif>

</table>

<cf_droptable dbname="appsQuery" tblname="#SESSION.acc#Bucket">
