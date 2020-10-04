
<!--- instruction view --->

<cfparam name="url.mid" default="">

<cfoutput>
<iframe src="#session.root#/Staffing/Maintenance/PersonEvent/Instruction.cfm?code=#url.code#&mission=#url.mission#&mid=#url.mid#" width="100%" height="100%" marginwidth="5" marginheight="5" frameborder="0"></iframe>
</cfoutput>
