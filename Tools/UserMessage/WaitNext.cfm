
<cfparam name="attributes.frm" default="">
<cfparam name="attributes.increment" default="1">

<cfoutput>

<script language="JavaScript">

<cfif attributes.frm neq "">

   prg = #attributes.frm#.progress.value - 0
   prg = prg + 1
   #attributes.frm#.progress.value = prg 

<cfelse>

  prg = progress.value - 0
  prg = prg + 1
  progress.value = prg 

</cfif>
 	   
</script>

</cfoutput>

<cfflush>
