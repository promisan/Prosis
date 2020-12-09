
<!--- copy inquiry --->

<cfparam name="url.mid" default="">

<cfoutput>
<table width="100%" height="100%"><tr><td>
<iframe src="#session.root#/System/Modules/InquiryBuilder/CopyInquiryQuery.cfm?id=#url.id#&mid=#url.mid#" width="100%" height="100%" frameborder="0"></iframe>
</td></tr></table>
</cfoutput>