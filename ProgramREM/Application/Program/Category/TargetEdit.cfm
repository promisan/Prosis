
<cfparam name="url.programcode"   default="">
<cfparam name="url.period"        default="">
<cfparam name="url.targetid"      default="">
<cfparam name="url.category"      default="View">
<cfparam name="url.programaccess" default="Test">

<cfoutput>
<iframe src="#session.root#/ProgramREM/Application/Program/Category/TargetEditContent.cfm?programcode=#url.programcode#&period=#url.period#&targetid=#url.targetid#&category=#url.category#&programaccess=#url.programaccess#" 
width="100%" height="100%" marginwidth="5" marginheight="5" frameborder="0"></iframe>
</cfoutput>
