
<table width="100%" height="100%">
<tr><td style="height:100%">

<cfparam name="url.mid" default="">
<cf_divscroll overflowy="hidden">
<cfoutput>
<iframe src="#SESSION.root#/Tools/Mail/Mail.cfm?ID1=#url.id1#&ID2=#url.id2#&Source=#url.source#&Sourceid=#URL.SourceID#&Mode=#url.mode#&GUI=#url.gui#&mid=#url.mid#" 
 width="100%" height="100%" marginwidth="0" marginheight="0" frameborder="0"></iframe>
</cfoutput>

</cf_divscroll>

</td></tr></table>