
<!--- passtru template --->

<cfparam name="URL.UNIT" default="-">

<script language="JavaScript">

<cfif #URL.ID# eq 'ORG'>

<cfoutput>

   window.location="ProgressViewGeneral.cfm?ID=ORG&UNIT=#URL.UNIT#&ID1=#URL.ID1#&ID2=#URL.ID2#&ID3=#URL.ID3#&Period=" + 
   parent.window.left.PeriodSelect.value + "&Sub=" + parent.window.left.SubSelect.value
   

</cfoutput>

<cfelse>

   window.location="ProgressViewGeneral.cfm?ID=PRG&UNIT=#URL.UNIT#&ID1=#Level01.ProgramCode#&Period=" + 
   parent.window.left.PeriodSelect.value + "&Sub=" + parent.window.left.SubSelect.value
   
</cfif>

</script>

