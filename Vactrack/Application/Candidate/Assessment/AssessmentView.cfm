
<cfparam name="url.documentNo"   default="">
<cfparam name="url.actioncode"    default="">
<cfparam name="url.mode"         default="">

<cfoutput>
<iframe src="#session.root#/Vactrack/Application/Candidate/Assessment/AssessmentViewBase.cfm?documentno=#url.documentno#&actioncode=#url.actioncode#&mode=#url.mode#&mid=#url.mid#" width="100%" height="100%" marginwidth="5" marginheight="5" frameborder="0"></iframe>
</cfoutput>



