
<cfparam name="url.documentNo"   default="">
<cfparam name="url.personNo"     default="">
<cfparam name="url.actoncode"    default="">
<cfparam name="url.mode"         default="">
<cfparam name="url.competenceid" default="">

<cfquery name="getSubmission" 
	datasource="AppsVacancy" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT        *
	FROM          DocumentCandidateReviewCompetence
	WHERE 		  DocumentNo = '#url.documentno#' 
	AND           ActionCode = '#url.actioncode#'
	AND           PersonNo   = '#url.personno#'
	AND           CompetenceId = '#url.competenceid#'	
</cfquery>

<cfif getSubmission.CompetenceContent neq "">

	<cfoutput>
	
	#getSubmission.CompetenceContent#
	</cfoutput>

<cfelse>

<table width="100%" height="100%" align="center"><tr><td align="center" style="background-color:f1f1f1;color:gray;font-size:20px">Not available</td></tr>

<!---
Regarding the Two-Phase Strategy on Protected Areas, Target 11 of the Strategic Plan, the first phase (2015-2016) focused on collecting information on the status of each element of Target 11, and focused actions, as a country driven process. The second phase (2017-2020) is focusing on facilitating the implementation of identified actions to achieve Target 11, especially through the provision of support from regional implementation support networks. The end of the second phase is what the CBD Secretariat, and the Individual Contractor soon to be hired, will now focus on, in preparation for COP 15.
There is very little time left to meet the target by the end of 2020. Gaps in information need to be identified and filled. There is a need to assess where countries currently stand regarding their commitments to the sub-targets under Target 11. This includes the quantifiable % of protected areas (i.e. 17% and 10%), as well as progress in fulfilling the important quality-related “elements” under the target, including representativity, connectivity and management effectiveness of protected areas, as well as equity and the inclusion of key biodiversity areas (KBAs).
In addition, countries have been actively creating Other Effective Area-Based Conservation Measures (OEABCMs). However, the related guidance for these measures is relatively new, countries may follow their own guidance, or they may be unaware of existing guidance. It is imperative that such OEABCMs represent true conservation measures. For example, in Canada, the government has created many “marine refuges” where the conservation of one species may be the objective, while potentially ignoring the conservation of other species and habitats and other quality-related elements.
--->

</cfif>
