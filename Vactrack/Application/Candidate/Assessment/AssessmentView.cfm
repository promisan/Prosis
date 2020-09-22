
<cfparam name="url.documentNo"   default="">
<cfparam name="url.actioncode"   default="">
<cfparam name="url.personno"     default="">
<cfparam name="url.mode"         default="View">
<cfparam name="url.modality"     default="Test">

<cfoutput>

<cfif url.mode eq "edit">

<iframe src="#session.root#/Vactrack/Application/Candidate/Assessment/AssessmentViewEdit.cfm?documentno=#url.documentno#&personno=#url.personno#&actioncode=#url.actioncode#&mode=#url.mode#&modality=#url.modality#&mid=#url.mid#" width="100%" height="100%" marginwidth="5" marginheight="5" frameborder="0"></iframe>

<cfelse>

<iframe src="#session.root#/Vactrack/Application/Candidate/Assessment/AssessmentViewContent.cfm?documentno=#url.documentno#&personno=#url.personno#&actioncode=#url.actioncode#&mode=#url.mode#&modality=#url.modality#&mid=#url.mid#" width="100%" height="100%" marginwidth="5" marginheight="5" frameborder="0"></iframe>


</cfif>

</cfoutput>



