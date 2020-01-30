
<cfquery name="Text" 
	datasource="AppsInit">
		  UPDATE InterfaceText
		  SET    TextENG = '#url.eng#',
		         TextFRA = '#url.fra#', 
			     TextESP = '#url.esp#',
			     TextGER = '#url.ger#',
			     TextNED = '#url.ned#',
			     TextPOR = '#url.por#',
				 TextCHI = N'#url.chi#',
				 TextITA = '#url.ita#' 
		  WHERE  TextClass = '#url.cls#'
		  AND    TextId    = '#url.clsid#'
</cfquery>

<cfloop index="itm" list="ENG,FRA,ESP,GER,NED,POR,ITA,CHI">
	<cftry>
       <cfset StructDelete(Application["#itm#"], "#url.clsid#", "True")>
	   <cfcatch></cfcatch>
	</cftry>  	  
</cfloop>

<cfoutput>

<cfif url.box neq "">

	<script language="JavaScript">
	  opener._cf_loadingtexthtml=''; 
	  opener.ColdFusion.navigate('#SESSION.root#/tools/language/TL_update.cfm?cls=#url.cls#&clsid=#url.clsid#','#url.box#')	 
	  window.close()
	</script>
	
<cfelse>
	<script language="JavaScript">
	 window.close()
	</script> 

</cfif>	

</cfoutput>
