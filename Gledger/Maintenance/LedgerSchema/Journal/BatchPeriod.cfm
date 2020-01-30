
<cf_screentop height="100%" close="parent.ColdFusion.Window.destroy('mydialog',true)" scroll="Yes" label="Maintain Journal Batch" html="yes" layout="webapp">

<cfajaximport tags="cfform">

<table width="95%" height="100%" cellspacing="0" cellpadding="0" align="center" class="formpadding">

<tr><td height="4"></td></tr>
<tr><td valign="top">

<cfdiv id="list">

<cfinclude template="BatchPeriodList.cfm">

</cfdiv>

<!---
<cfoutput>
<iframe src="BatchPeriodList.cfm?journal=#url.journal#" width="100%" height="100%" scrolling="no" frameborder="0">
</iframe>
</cfoutput>
--->

</td></tr></table>

<!---
<cf_screenbottom layout="innerbox">
--->