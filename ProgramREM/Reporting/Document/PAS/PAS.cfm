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
<cfset vFilename = 'PASDocument'>
<cfset FileNo = round(Rand()*100)>
<cfset vDirectory = "#SESSION.rootPath#\CFRStage\User\#SESSION.acc#">
<cfset vDirectory = replace(vDirectory,"\\","\","ALL")>
<cfset vVirtualDirectory = "#SESSION.root#/CFRStage/User/#SESSION.acc#">

<cfif not DirectoryExists(vDirectory)>
	<cfdirectory action="CREATE" directory="#vDirectory#">
</cfif>

<cfquery name="getPerson" 
	datasource="appsEPas" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	P.*
		FROM 	Contract C
				INNER JOIN Employee.dbo.Person P
					ON C.PersonNo = P.PersonNo
		WHERE	C.ContractId = '#URL.ID#'
</cfquery>

<!--- base report --->
<cfset attachBase = "#vFileName#_#FileNo#_Base.pdf">
<cfset vpathBase ="#vDirectory#\#attachBase#">
<cfset vTemplatepath = 'ProgramREM/Reporting/Document/PAS/PAS.cfr'>	
<cfreport 
   template     = "#SESSION.rootPath##vTemplatepath#" 
   format       = "PDF" 
   overwrite    = "yes" 
   encryption   = "none"
   filename     = "#vpathBase#">
		<cfreportparam name="ID" value="#URL.ID#"> 
</cfreport>	

<!--- 1st portion base --->
<cfset attachBase1 = "#vFileName#_#FileNo#_Base1.pdf">
<cfset vpathBase1 ="#vDirectory#\#attachBase1#">
<cfpdf action="merge" source="#vpathBase#" pages="1" destination="#vpathBase1#" overwrite="yes">

<!--- 2nd portion base --->
<cfset attachBase2 = "#vFileName#_#FileNo#_Base2.pdf">
<cfset vpathBase2 ="#vDirectory#\#attachBase2#">
<cfpdf action="merge" source="#vpathBase#" pages="2" destination="#vpathBase2#" overwrite="yes">

<!--- 3rd portion base --->
<cfset attachBase3 = "#vFileName#_#FileNo#_Base3.pdf">
<cfset vpathBase3 ="#vDirectory#\#attachBase3#">
<cfpdf action="merge" source="#vpathBase#" pages="3" destination="#vpathBase3#" overwrite="yes">

<!--- 4th portion base --->
<cfset attachBase4 = "#vFileName#_#FileNo#_Base4.pdf">
<cfset vpathBase4 ="#vDirectory#\#attachBase4#">
<cfpdf action="merge" source="#vpathBase#" pages="4-*" destination="#vpathBase4#" overwrite="yes">

<!--- complement info 1 --->
<cfquery name="getComplement" 
	datasource="appsEPas" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		select *
		from contractActivity CA
		WHERE   CA.ContractId = '#url.id#'
		<!--- AND CA.ActivityIdParent IS NULL --->
		AND CA.RecordStatus = '1'
		AND CA.Operational = '1'
		ORDER BY ActivityOrder ASC
</cfquery>

<cfset attachComplement1 = "#vFileName#_#FileNo#_C1.pdf">
<cfset vpathComplement1="#vDirectory#\#attachComplement1#">
<cfdocument 
	format="pdf" 
	filename="#vpathComplement1#" 
	overwrite="true" 
	pagewidth="8.2639" 
	pageheight="11.6944" 
	orientation="portrait" 
	marginleft="0.0972"
	marginright="0.0972"
	unit="in" 
	pagetype="a4"> 
		<cfoutput>
			<table width="100%">
				<tr>
					<td style="font-size:16pt; font-face:Verdana; font-family:Verdana; padding-bottom:15px; font-weight:bold; text-decoration:underline;" align="center">
						<cf_tl id="Workplan" var="1"> 
						#ucase(lt_text)#
					</td>
				</tr>
				<tr>
					<td style="font-size:12pt; padding-bottom:15px; font-face:Verdana; font-family:Verdana;"><b><cf_tl id="Staff member's description of major assignments and personal objectives"> :</b></td>
				</tr>
				<tr>
					<td style="color:##666666; font-face:Verdana; font-family:Verdana; font-size:10pt; padding-left:10px;">
						<table width="100%">
							<cfset vCntComplement1 = 0>
							<cfloop query="getComplement">
								<cfif vCntComplement1 eq 0>
									<tr><td>
								<cfelse>
									<tr><td style="padding-top:5px; border-top:1px solid ##DDDDDD;">
								</cfif>
								#ActivityDescription#
								</td></tr>
								<cfset vCntComplement1 = vCntComplement1 + 1>
							</cfloop>
						</table>
					</td>
				</tr>
			</table>
		</cfoutput>
		<cfdocumentitem type="header"> 
		   	<cf_PASHeader StaffName="#getPerson.FirstName# #getPerson.LastName#">
		</cfdocumentitem> 
		<cfdocumentitem type="footer"> 
		   	<cf_PASFooter pageNum="1a">
		</cfdocumentitem> 
</cfdocument>

<!--- complement info 2 --->
<cfquery name="getComplement2" 
	datasource="appsEPas" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		select *
		from contractActivity CA
		WHERE   CA.ContractId = '#url.id#'
		AND CA.ActivityIdParent IS NULL
		AND CA.RecordStatus = '2'
		AND CA.Operational = '1'
</cfquery>

<cfset attachComplement2 = "#vFileName#_#FileNo#_C2.pdf">
<cfset vpathComplement2="#vDirectory#\#attachComplement2#">
<cfdocument 
	format="pdf" 
	filename="#vpathComplement2#" 
	overwrite="true" 
	pagewidth="8.2639" 
	pageheight="11.6944" 
	orientation="portrait" 
	marginleft="0.0972"
	marginright="0.0972"
	unit="in" 
	pagetype="a4"> 
		<cfoutput>
			<table width="100%" cellpadding="0" cellspacing="0">
				<tr>
					<td>
						<cf_PASTitle Title1="Part II" Title2="MIDTERM REVIEW">
					</td>
				</tr>
				<tr>
					<td style="font-size:16pt; font-face:Verdana; font-family:Verdana; padding-bottom:15px; font-weight:bold; text-decoration:underline;" align="center">
						<cf_tl id="Revised Workplan" var="1"> 
						#ucase(lt_text)#
					</td>
				</tr>
				<tr>
					<td style="font-size:12pt; padding-bottom:15px; font-face:Verdana; font-family:Verdana;"><b><cf_tl id="Specific assignments and objectives"> :</b></td>
				</tr>
				<tr>
					<td style="color:##666666; font-face:Verdana; font-family:Verdana; font-size:10pt; padding-left:10px;">#getComplement2.ActivityDescription#</td>
				</tr>
			</table>
		</cfoutput>
		<cfdocumentitem type="header"> 
		   	<cf_PASHeader StaffName="#getPerson.FirstName# #getPerson.LastName#">
		</cfdocumentitem> 
		<cfdocumentitem type="footer"> 
		   	<cf_PASFooter pageNum="2a">
		</cfdocumentitem> 
</cfdocument>

<!--- complement info 3 --->
<cfquery name="getComplement3" 
	datasource="appsEPas" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		select 	* 
		from 	ContractEvaluation 
		WHERE  	EvaluationType = 'final' 
		and  	ContractId = '#url.id#'
		and 	ActionStatus != '9'
</cfquery>

<cfset attachComplement3 = "#vFileName#_#FileNo#_C3.pdf">
<cfset vpathComplement3 = "#vDirectory#\#attachComplement3#">
<cfdocument 
	format="pdf" 
	filename="#vpathComplement3#" 
	overwrite="true" 
	pagewidth="8.2639" 
	pageheight="11.6944" 
	orientation="portrait" 
	marginleft="0.0972"
	marginright="0.0972"
	unit="in" 
	pagetype="a4"> 
		<cfoutput>
			<table width="100%" cellpadding="0" cellspacing="0">
				<tr>
					<td>
						<cf_PASTitle Title1="Part III" Title2="PERFORMANCE APPRAISAL AND RECOMMENDATIONS">
					</td>
				</tr>
				<tr>
					<td style="font-size:16pt; font-face:Verdana; font-family:Verdana; padding-bottom:15px; font-weight:bold; text-decoration:underline;" align="center">
						<cf_tl id="Self Appraisal" var="1"> 
						#ucase(lt_text)#
					</td>
				</tr>
				<tr>
					<td style="color:##666666; font-face:Verdana; font-family:Verdana; font-size:10pt; padding-left:10px;">#getComplement3.Evaluation#</td>
				</tr>
			</table>
		</cfoutput>
		<cfdocumentitem type="header"> 
		   	<cf_PASHeader StaffName="#getPerson.FirstName# #getPerson.LastName#">
		</cfdocumentitem> 
		<cfdocumentitem type="footer"> 
		   	<cf_PASFooter pageNum="3a">
		</cfdocumentitem> 
</cfdocument>

<!--- Define if workplan will be included --->
<cfquery name="isClear" 
	datasource="appsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT  *
		FROM 	OrganizationObjectInformation
		WHERE   ObjectId = (SELECT ObjectId FROM OrganizationObject WHERE ObjectKeyValue4 = '#url.id#' AND EntityCode = 'EntPAS' AND EntityClass = 'Standard' AND Operational = '1')
		AND	   	DocumentId = 
			   	(
					SELECT 	DocumentId
					FROM	Ref_EntityDocument
					WHERE	EntityCode = 'EntPAS' 
					AND		DocumentType = 'field'
					AND		DocumentDescription LIKE '%clearly%defined%explained%'
			   	)
		AND	   	DocumentItemValue LIKE '%Yes%'
</cfquery>

<cfset vSourceFiles = "#vpathBase1#,#vpathComplement1#,#vpathBase2#,#vpathBase3#,#vpathComplement2#,#vpathComplement3#,#vpathBase4#">
<!--- <cfif isClear.recordCount eq 0>
	<cfset vSourceFiles = "#vpathBase1#, #vpathBase2#, #vpathBase3#, #vpathComplement3#, #vpathBase4#">
</cfif> --->

<!--- no midterm yet --->
<cfif getComplement2.recordCount eq 0>
	<cfset vSourceFiles = "#vpathBase1#,#vpathComplement1#,#vpathBase2#">
	<!--- <cfif isClear.recordCount eq 0>
		<cfset vSourceFiles = "#vpathBase1#, #vpathBase2#">
	</cfif> --->
</cfif>

<!--- midterm review --->
<cfquery name="CheckSection" 
	datasource="appsEPas" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	*
		FROM 	ContractSection
		WHERE 	ContractId = '#url.id#'
		AND 	ContractSection = 'P08'
</cfquery>
<cfif checkSection.recordCount eq 0 OR (checkSection.recordCount eq 1 AND (checkSection.Operational eq "0" OR checkSection.ProcessStatus eq "0"))>
	<!--- remove Midterm review section --->
	<cfset vSourceFiles = replace(vSourceFiles, "#vpathBase3#,","","ALL")>
	<cfset vSourceFiles = replace(vSourceFiles, "#vpathComplement2#,","","ALL")>
</cfif>

<!--- self appraisal --->
<cfquery name="CheckSection" 
	datasource="appsEPas" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	*
		FROM 	ContractSection
		WHERE 	ContractId = '#url.id#'
		AND 	ContractSection = 'P10'
</cfquery>
<cfif checkSection.recordCount eq 0 OR (checkSection.recordCount eq 1 AND (checkSection.Operational eq "0" OR checkSection.ProcessStatus eq "0"))>
	<!--- remove self appraisal section --->
	<cfset vSourceFiles = replace(vSourceFiles, "#vpathComplement3#,","","ALL")>
</cfif>

<!--- individual and overall appraisals --->
<cfquery name="CheckSection" 
	datasource="appsEPas" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	*
		FROM 	ContractSection
		WHERE 	ContractId = '#url.id#'
		AND 	ContractSection = 'P12'
</cfquery>
<cfif checkSection.recordCount eq 0 OR (checkSection.recordCount eq 1 AND (checkSection.Operational eq "0"))>
	<!--- remove individual and overall appraisals section --->
	<cfset vSourceFiles = replace(vSourceFiles, ",#vpathBase4#","","ALL")>
</cfif>

<!--- check if workplan and revised workplan are the same --->
<cfif getComplement.ActivityDescription eq getComplement2.ActivityDescription>
	<!--- remove revised workplan --->
	<cfset vSourceFiles = replace(vSourceFiles, ",#vpathComplement2#","","ALL")>
</cfif>

<!--- Create final document --->
<cfset attachFinal = "#vFileName#_#FileNo#.pdf">
<cfset vpathFinal ="#vDirectory#\#attachFinal#">
<cfpdf action="merge" source="#vSourceFiles#" destination="#vpathFinal#" overwrite="yes">

<!--- Output final to screen --->
<cfoutput>
	<script>
		window.location = "#vVirtualDirectory#/#attachFinal#?ts=#getTickCount()#";
	</script>
</cfoutput>