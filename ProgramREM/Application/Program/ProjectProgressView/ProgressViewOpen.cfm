
<!--- passtru template --->

<cfparam name="URL.ID1" default="0">

<script language="JavaScript">

<cfoutput>

   window.location="ProgressViewGeneral.cfm?ID=ORG&ID1=#URL.ID1#&ID2=#URL.ID2#&ID3=#URL.ID3#&Period=" + 
   parent.left.document.getElementById("PeriodSelect").value
   
</cfoutput>

</script>

