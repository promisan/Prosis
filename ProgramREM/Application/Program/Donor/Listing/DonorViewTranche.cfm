

<cfparam name="url.mode"    default="Detail">
<cfparam name="url.mission" default="#url.id2#">
<cfparam name="url.filter" default="all">
<cfinclude template="DonorViewTranchePrepare.cfm">
<cfinclude template="DonorViewTrancheContent.cfm">