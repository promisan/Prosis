<cfparam name="url.missionName" default="">
<cfparam name="url.label" 		default="">

<cfoutput>
	<div style="background-color:##005B9A; color:##FAFAFA; border-bottom:3px solid ##606060; padding:15px; margin-bottom:10px;">
		<div class="pull-left" style="padding-right:15px;">
			<img src="logo.png" style="height:50px">
		</div>
		<div>
			<span style="font-size:140%;">#url.missionName#</span>
			<br>
			<span class="clsPrintHeaderSubtitle">#url.label#</span>
		</div>
		<div style="float:right; margin-top:-42px; padding-right:10px;">
			<i class="fa fa-users" style="font-size:45px;"></i>
		</div>
	</div>
</cfoutput>