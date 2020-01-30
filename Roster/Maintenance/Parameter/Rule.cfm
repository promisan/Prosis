<cfparam name="url.owner" default="">
<cfparam name="url.rule" default="">
<cfparam name="url.level" default="">
<cfparam name="url.from" default="">
<cfparam name="url.to" default="">

<cfoutput>
	<img src="#client.root#/images/link.gif" alt="Define a conditioning rule for this transition." 
		 style="cursor:pointer" onclick="selectRule('#url.owner#','#url.rule#','#url.level#','#url.from#','#url.to#')">
</cfoutput>