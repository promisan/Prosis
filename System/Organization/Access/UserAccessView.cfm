
<cfparam name="URL.RequestId"  default="">
<cfparam name="URL.ID"         default="">
<cfparam name="URL.ID1"        default="">
<cfparam name="URL.ID2"        default="">
<cfparam name="URL.ID3"        default="">
<cfparam name="URL.ID4"        default="">
<cfparam name="URL.Mission"    default="">
<cfparam name="URL.Mission"    default="">
<cfparam name="URL.Box"        default="">

<cfoutput>
<table width="100%" height="100%">
<tr><td style="height:100%;width:100%;overflow:hidden">
<iframe src="#session.root#/System/Organization/Access/UserAccess.cfm?box=#url.box#&requestid=#url.requestid#&ID1=#url.id1#&ID=#URL.ID#&ID2=#url.id2#&ID4=#url.id4#&Mission=#URL.Mission#&ACC=#url.acc#" width="100%" height="100%" frameborder="0"></iframe>
</td></tr>
</table>
</cfoutput>
