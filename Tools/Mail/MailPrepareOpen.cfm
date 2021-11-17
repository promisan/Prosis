
<cfparam name="URL.id0"         default="">
<cfparam name="URL.id1"         default="">
<cfparam name="URL.id2"         default="">
<cfparam name="URL.id3"         default="">
<cfparam name="URL.mid"         default="">
<cfparam name="URL.orientation" default="portrait">

<cfoutput>

<cfset id0 = replaceNoCase(url.id0,'\','\\','ALL')> 

<cfif URL.ID eq "Print">

	<script language="JavaScript">
	  
	  w = #CLIENT.width# - 100;
	  h = #CLIENT.height# - 140;
	  
	  window.moveTo(20,20)
	  window.resizeTo(w,h)
	  window.location = "MailPrepare.cfm?Id=#URL.ID#&ID1=#URL.ID1#&ID2=#URL.ID2#&ID3=#URL.ID3#&ID0=#ID0#&orientation=#URL.orientation#&mid=#url.mid#"
	 	  
	 </script> 
  		
<cfelse>

	<script language="JavaScript">
		
	  window.location = "MailPrepare.cfm?Id=#URL.ID#&ID1=#URL.ID1#&ID2=#URL.ID2#&ID3=#URL.ID3#&ID0=#ID0#&orientation=#URL.orientation#&mid=#url.mid#"

	</script>

</cfif>
</cfoutput>