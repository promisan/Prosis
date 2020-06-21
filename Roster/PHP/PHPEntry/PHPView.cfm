
<cfparam name="CLIENT.ApplicantNo" default="">
<cfparam name="URL.ApplicantNo"    default="#CLIENT.ApplicantNo#">

<cfparam name="URL.Scope"          default="portal">
<cfparam name="URL.menu"           default="profile">
<cfparam name="URL.Source"         default="">
<cfparam name="URL.Owner"          default="">

<cfparam name="URL.Code"           default="0">
<cfparam name="URL.ID"             default="PHP">
<cfparam name="URL.Alias"          default="appsSelection">
<cfparam name="URL.Object"         default="Applicant">
<cfparam name="URL.ID1"            default="{00000000-0000-0000-0000-000000000000}">

<cfparam name="URL.Group"          default="PHP">
<cfparam name="URL.TriggerGroup"   default="#URL.Group#">

<cfparam name="URL.Mission" 	   default="">
<cfparam name="URL.Source" 	   	   default="">

<cfquery name="submission" 
	datasource="appsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   *,
		         (SELECT EntityClass FROM Ref_SubmissionEdition WHERE SubmissionEdition = A.SubmissionEdition) as EntityClass
		FROM     ApplicantSubmission A, Ref_Source R
    	WHERE    ApplicantNo = '#url.applicantNo#'
    	AND      A.Source = R.Source		
</cfquery>

<cfset validation = submission.PHPValidation>

<cfif url.mission neq "">
	
	<cfquery name="hasValidations" 
			datasource="appsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT   *
			FROM     Ref_ModuleControlValidationMission
			WHERE    SystemFunctionId = '#url.systemfunctionid#'
			AND      Mission = '#url.mission#'		
	</cfquery>
	
	<cfif hasValidations.recordcount eq "0">
	
	  <cfset validation = "0">
	
	</cfif>

</cfif>

<cfquery name="getCandidate" 
		datasource="appsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT   *
		FROM     Applicant A, Ref_Source R
		WHERE    A.Source = R.Source	
		AND      PersonNo = '#submission.PersonNo#' 	
</cfquery>
	
<cfset url.source = submission.source>	

<cfif (getCandidate.CandidateStatus eq "0" and Submission.EntityClass neq "" and url.scope eq "portal")>
	
	<table align="center">
		<tr><td class="labellarge" align="center" style="font-size:29px;padding-top:80px">
		<font color="FF0000"><cf_tl id="Your account is not cleared yet"></font>
		</td></tr>
	</table>
	
	<cfabort>

</cfif>

<cfoutput>
	<script>
		function reload(src) {	  	   
		   ptoken.open('#session.root#/Roster/PHP/PHPEntry/PHPView.cfm?source='+src,'_top')	
		}
	</script>
</cfoutput>

<cfif getCandidate.recordcount eq "1">
	<cfset url.PersonNo = getCandidate.PersonNo>	
</cfif>

<cfquery name="Parameter" 
	datasource="appsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   *
	FROM     Parameter
</cfquery>

<cfset CLIENT.submission  = Parameter.PHPEntry>

<cfquery name="qCheckOwnerSection" 
datasource="appsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   *
	FROM     Ref_ApplicantSectionOwner
	WHERE    Owner = '#URL.Owner#' 
</cfquery>

<cfquery name="Section" 
datasource="appsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   *
	FROM     #CLIENT.LanPrefix#Ref_ApplicantSection R LEFT OUTER JOIN
             ApplicantSection C ON R.Code = C.ApplicantSection 
			 AND C.ApplicantNo = '#url.ApplicantNo#'
	WHERE    R.TriggerGroup = '#url.triggergroup#' 
	AND      R.Operational = 1
	<cfif qCheckOwnerSection.recordcount neq 0>
		AND EXISTS
		(
			SELECT 'X'
			FROM Ref_ApplicantSectionOwner 
			WHERE Code = R.Code
			AND   Owner = '#URL.Owner#'
			AND Operational = '1' 
		)
	</cfif>	
	ORDER BY R.ListingOrder
</cfquery>

<cfloop query="Section">
			 	
	<cfset vCheckAccess = true> 

	<cfif isDefined("AllowedGroups")>
		<cfif AllowedGroups neq "">
			<cfquery name="CheckAccess" 
			datasource="#Alias#" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT	*
				FROM	System.dbo.UserNamesGroup
				WHERE	Account = '#session.acc#'
				AND		AccountGroup IN (#preserveSingleQuotes(AllowedGroups)#)
			</cfquery>

			<cfif CheckAccess.recordCount eq 0>
				<cfset vCheckAccess = false>
			</cfif>
		</cfif>
	</cfif>
	
	<cfif vCheckAccess>
			 	
		<cftry>

			<cfquery name="Insert" 
			datasource="appsSelection">
				INSERT INTO ApplicantSection 
				     (ApplicantNo,ApplicantSection)
				VALUES ('#url.ApplicantNo#','#Code#')
			</cfquery> 
				
			<cfcatch></cfcatch>

		</cftry>

	</cfif>
		
</cfloop>		

<cfquery name="Check" 
datasource="appsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT    TOP 1 *
	FROM      #CLIENT.LanPrefix#Ref_ApplicantSection R INNER JOIN
	          ApplicantSection C ON R.Code = C.ApplicantSection
	WHERE     R.TriggerGroup = '#URL.TriggerGroup#' 
	AND       C.ApplicantNo = '#url.ApplicantNo#' 
	AND       C.ProcessStatus = '0'
	AND       C.Operational = 1
		<cfif qCheckOwnerSection.recordcount neq 0>
			AND EXISTS
			(
				SELECT 'X'
				FROM Ref_ApplicantSectionOwner 
				WHERE Code = R.Code
				AND   Owner = '#URL.Owner#'
				AND Operational = '1' 
			)
		</cfif>	
	ORDER BY  R.ListingOrder 
</cfquery>

<cfif Check.recordcount eq "0">

	<cfquery name="Check" 
	datasource="appsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   TOP 1 *
	FROM     #CLIENT.LanPrefix#Ref_ApplicantSection R
	WHERE    TriggerGroup = '#URL.TriggerGroup#'
	 	<cfif qCheckOwnerSection.recordcount neq 0>
		AND EXISTS
		(
			SELECT 'X'
			FROM   Ref_ApplicantSectionOwner 
			WHERE  Code = R.Code
			AND    Owner = '#URL.Owner#'
			AND    Operational = '1' 
		)
		</cfif>	

	ORDER BY ListingOrder 
	</cfquery>

</cfif>

<cfif url.scope eq "BackOffice">
		
	<cf_screentop height="100%" 
	    scroll="Yes" 
		label="Personal History Profile" 
		line="no" 
		banner="blue" 
		bannerforce="yes"
		layout="webapp" 
		SystemFunctionId=""
		SystemModule="Roster"
		FunctionClass="Window"
		FunctionName="PHP Profile"
		html="yes" 
		jquery="Yes">

<cfelse>

 <!--- we generate it --->
 <cf_ModuleInsertSubmit
		   SystemModule   = "Roster" 
		   FunctionClass  = "Window"
		   FunctionName   = "PHP Profile" 
		   MenuClass      = "Dialog"
		   MenuOrder      = "1"
		   MainMenuItem   = "0"
		   FunctionMemo   = "PHP Profile"
		   ScriptName     = ""> 
		   
<cfset url.systemfunctionid = rowguid>

</cfif>

<!---	
<cfajaximport tags="cfwindow">			
--->

<cf_panescript>	 
<cf_LayoutScript>
	
<cfset attrib = {type="Border",name="mybox",fitToWindow="Yes"}>
	 
<cfoutput>

<cf_layout attributeCollection="#attrib#">
    
	<cf_layoutarea 
	   	position  = "top"
	   	name      = "phptop"
	   	minsize	  = "10px"
		maxsize	  = "10px"
		style     = "border-bottom:1px solid 6688aa"
		size 	  = "10px">	
									  
		<cfinclude template="PHPIdentity.cfm">	
				
			 			  
	</cf_layoutarea>			
	
	<cfparam name="url.owner" default="">
	 	
	<cf_layoutarea position="center" name="box" style = "border-right:1px solid 6688aa">
						
		 <iframe src="#SESSION.root#/Roster/PHP/#Check.TemplateURL#?#check.templatecondition#&Code=#URL.Code#&PersonNo=#url.PersonNo#&mission=#URL.mission#&Section=#Check.Code#&Alias=#URL.Alias#&Object=#URL.Object#&Topic=#Check.TemplateTopicId#&ApplicantNo=#url.ApplicantNo#&id1=#Check.TemplateCondition#&owner=#url.owner#&triggerGroup=#url.triggerGroup#&source=#URL.source#" 
		            name="right" id="right" width="100%" height="100%" scrolling="no" frameborder="0"></iframe>		
					
	</cf_layoutarea>	
				
	<!--- validation is enabled for this source and enabled for the mission which is passed --->
		
	<cfif Validation eq "1">
	
		<cf_layoutarea size="370" minsize="370" position="right" name="rightbox" collapsible="true">
		
			<cf_divscroll style="height:100%">
																		
				<cfinvoke component = "Service.Validation.Controller"  
				   method           = "Control" 
				   systemFunctionId = "#url.systemfunctionid#"
				   mission          = "" 
				   owner            = ""
				   object           = "Applicant"
				   objectKeyValue1  = "#URL.ApplicantNo#"
				   objectKeyValue2  = "#URL.PersonNo#"
				   objectKeyValue3  = "#URL.owner#"
				   target           = "">	  
			
			</cf_divscroll>	
						
		</cf_layoutarea>
				
    </cfif>
	
		<cf_layoutarea 
		    position    = "left" 
			name        = "treebox" 
			maxsize     = "159" 		
			size        = "150" 
			minsize     = "150"			
			collapsible = "true" 
			splitter    = "true"
			overflow    = "scroll">
					
			<iframe src="#SESSION.root#/Roster/PHP/PHPEntry/PHPMenu.cfm?Section=#Check.code#&PersonNo=#url.PersonNo#&Id=#url.ApplicantNo#&owner=#url.owner#&mission=#URL.mission#&triggergroup=#url.triggergroup#"
			        	name="left" id="left" width="100%" height="99%" scrolling="no" frameborder="0"></iframe>				
				
	    </cf_layoutarea>		
	
					
</cf_layout>

</cfoutput>

<cf_screenbottom layout="webapp" html="no">
