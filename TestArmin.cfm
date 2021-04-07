
<cfinclude template="Tools/ConvertNumber/NumbersToLetters.cfm">

300.1 => 
<cfset amt = "300.1">
<cfoutput>
#numberToLetters(amt)#
</cfoutput>

285 -> 
<cfset amt = "285">
<cfoutput>
#numberToLetters(amt)#
</cfoutput>