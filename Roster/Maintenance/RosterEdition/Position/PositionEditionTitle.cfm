
<!--- ability to change the label of the title --->

<cfquery name="qExercise"
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT  E.*, 
	        S.ActionStatus, S.Owner
	FROM    Ref_ExerciseClass E INNER JOIN Ref_SubmissionEdition S
	ON      E.ExcerciseClass    = S.ExerciseClass
	WHERE   S.SubmissionEdition = '#url.submissionedition#' 
</cfquery> 


<cfif qExercise.ActionStatus eq "0">
    <cfset mode = "edit">
<cfelse>
	<cfset mode = "view">
</cfif>

<cfquery name="get"
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT  *
	FROM    Ref_ExerciseClass E INNER JOIN Ref_SubmissionEdition S
	ON      E.ExcerciseClass    = S.ExerciseClass
	WHERE   S.SubmissionEdition = '#url.submissionedition#' 
</cfquery>



<cfquery name="getPosition"
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT  *
	FROM    Ref_SubmissionEditionPosition
	WHERE   SubmissionEdition = '#url.submissionedition#' 
	AND     PositionNo        = '#url.PositionNo#'
</cfquery> 

<!--- ------------------------------ --->
<!--- -----initially populate------- --->
<!--- ------------------------------ --->

<cfquery name="getLanguage" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM   System.dbo.Ref_SystemLanguage
	WHERE  SystemDefault = '1'	
</cfquery>

<cfquery name="TitleNames" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	<cfif getLanguage.recordcount eq "1">
		SELECT FunctionDescription, '#getLanguage.code#' as Code
		FROM   FunctionTitle
		WHERE  FunctionNo = '#getPosition.FunctionNo#'
		UNION
		</cfif>
		SELECT FunctionDescription, LanguageCode as Code
		FROM   FunctionTitle_Language
		WHERE  FunctionNo = '#getPosition.FunctionNo#'
</cfquery>

<cfloop query="TitleNames">

	<cftry>

	<cfquery name="addline" 
		datasource="AppsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			INSERT INTO Ref_SubmissionEditionPosition_Language(
					SubmissionEdition, 
					PositionNo,
					FunctionDescription,			
					LanguageCode,
					OfficerUserId,
					Created
					)
			VALUES (
				'#url.submissionedition#',
				'#url.PositionNo#',
				'#FunctionDescription#',	
				'#Code#',		
				'#SESSION.acc#',
				getdate()
				)			
	</cfquery>
	
	<cfcatch></cfcatch>
	
	</cftry>

</cfloop>

<!--- ------------------------------ --->
<!--- ------------------------------ --->
<!--- ------------------------------ --->

<cfform name="formentry" style="height:100%">		
	
	<table width="95%" align="center" class="formpadding">
	
		
		<tr><td></td></tr>
		<tr><td class="labelmedium"><b>Functional&nbsp;title</td></tr>
		
		<tr><td></td>
			
		    <TD style="padding-left:14px">
					
				<cf_LanguageInput
						TableCode       = "EditionFunctionTitle" 
						Mode            = "#mode#"
						Name            = "FunctionDescription"
						Operational     = "1"
						Label           = "Yes"
						Key1Value       = "#url.SubmissionEdition#"
						Key2Value       = "#url.Positionno#"
						Type            = "Input"
						Required        = "Yes"
						Message         = "Please enter a functional title"
						MaxLength       = "80"
						Size            = "60"
						Class           = "regularxl">	
					  
		   	</TD>
		
		</TR>
		
		<tr><td></td></tr>
	   
		<tr><td valign="top" style="padding-top:4px" class="labelmedium"><b>Competencies</td>
	
		<tr><td colspan="2" style="padding-left:20px">
		
							
			<table width="99%" cellspacing="0" cellpadding="0" align="center" class="formpadding">
					 
				 <cfquery name="GetCompetencies" 
					 datasource="AppsSelection" 
					 username="#SESSION.Login#" 
					 password="#SESSION.dbpw#">
						  
						SELECT CC.Description AS Category,C.*, FOC.PositionNo
					    FROM   Ref_Competence C
						INNER  JOIN Ref_CompetenceCategory CC
								ON   C.CompetenceCategory = CC.Code
						LEFT   JOIN  Ref_SubmissionEditionPositionCompetence FOC
								ON   FOC.CompetenceId = C.CompetenceId 
								AND FOC.PositionNo = '#url.Positionno#' and FOC.SubmissionEdition = '#url.submissionedition#' AND FOC.Operational = 1
						WHERE  C.Operational = 1 
						ORDER  BY CC.Code, ListingOrder
						  
				</cfquery>
					
				<cfset columns= 3>
						
				<tr>
					<td>
								
						<table width="95%" align="center">
				
						<cfoutput query="GetCompetencies" group="Category">
						 
						 	<cfset cont   = 0>
						 
							 <tr>
							 	<td class="labelmedium" colspan="#columns#">
									<i>#Category#</i>
								</td>
							 </tr>
							 
							 <tr><td class="linedotted" colspan="#columns#"></td></tr>
			
							 <cfoutput>
							 	
								<cfif cont eq 0> <tr> </cfif>
								
								<cfif PositionNo neq "">
								   <cfset cl = "ffffcf">
								<cfelse>
								   <cfset cl = "ffffff">
								</cfif>
								
						 		<td style="background-color:###cl#" onclick="document.getElementById('#CompetenceId#').click()" style="cursor:pointer" class="labelmedium">
									<input type="checkbox" class="radiol" value="#CompetenceId#" name="CompetenceId" id="CompetenceId_#CompetenceId#" <cfif PositionNo neq "">checked</cfif> <cfif mode eq "view">disabled</cfif>>
									</td>
									<td  style="background-color:###cl#" class="labelmedium" style="height:20px;padding-left;4px">#Description#</td>
									<cfset cont = cont + 1>
								</td>
								<cfif cont eq columns> </tr> <cfset cont = 0> </cfif>
								
					 		  </cfoutput>
							  
							  <tr><td colspan="#columns#" height="10px"></td></tr>
						
						</cfoutput>
						
						</table>
						
			
					</td>
				</tr>	
				
				<tr><td id="submitid" align="center"></td></tr>
			
			</table>	
		
		</td></tr>
	
		<tr><td class="linedotted" height="1" colspan="2"></td></tr>	
		
		<cfif mode eq "edit">	
		<tr><td height="2" colspan="2"></td></tr>
				  		
		<tr><td colspan="2" height="30" align="center">	
		   <table style="formspacing">
		   <tr>
		   <cfoutput>			
		    <td><input class="button10s" style="width:130;height:24" type="button" name="UpdateC" value="Remove" onclick="if (confirm('Do you want to remove this position ?')) {ColdFusion.navigate('PositionEditionTitleSubmit.cfm?action=delete&submissionedition=#url.submissionedition#&positionno=#url.positionno#','result')}"></td>									 
			<td><input class="button10s" style="width:130;height:24" type="button" name="UpdateC" value="Save"   onclick="ColdFusion.navigate('PositionEditionTitleSubmit.cfm?action=update&submissionedition=#url.submissionedition#&positionno=#url.positionno#','result','','','POST','formentry')"></td>
		   </cfoutput>			   
		   </tr>
		   </table>
		</td></tr>
		
		</cfif>
		
		<tr><td id="result" colspan="2" align="center"></td></tr>
	
	</table>
	
	</cfform>

